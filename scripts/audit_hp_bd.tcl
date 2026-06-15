# =============================================================================
# audit_hp_bd.tcl
#
# Audits the S_AXI_HP0 write path in the open block design to find why WREADY
# never asserts (symptom: AW handshakes once, W never handshakes, wrapper FIFO
# fills, b2d stalls in GENERATE_FILL).
#
# Run from the Vivado Tcl console with the BD OPEN:
#     source scripts/audit_hp_bd.tcl
#
# It prints, for the HP write path:
#   1. what drives S_AXI_HP0_ACLK and whether it matches the wrapper's clk
#   2. the HP0 data width (must be 64 to match AWSIZE=3 / 64-bit WDATA)
#   3. the reset net on the HP path and its polarity source
#   4. every aclk/aresetn on any interconnect between wrapper and PS
# =============================================================================

puts "=================================================================="
puts " S_AXI_HP0 WRITE-PATH AUDIT"
puts "=================================================================="

# ---- locate the Zynq PS cell -------------------------------------------------
set ps_cells [get_bd_cells -quiet -filter {VLNV =~ *processing_system7*}]
if {[llength $ps_cells] == 0} {
    puts "ERROR: no processing_system7 cell found in the open BD."
    return
}
set ps [lindex $ps_cells 0]
puts "PS cell: $ps"

# ---- 1. HP0 ACLK source ------------------------------------------------------
puts "\n--- 1. S_AXI_HP0_ACLK ---"
set hpclk_pin [get_bd_pins -quiet $ps/S_AXI_HP0_ACLK]
if {[llength $hpclk_pin] == 0} {
    puts "  NOTE: no S_AXI_HP0_ACLK pin -> is S_AXI_HP0 even enabled in PS config?"
} else {
    set net [get_bd_nets -quiet -of_objects $hpclk_pin]
    if {[llength $net] == 0} {
        puts "  >>> S_AXI_HP0_ACLK is UNCONNECTED.  <<<  (this alone kills WREADY)"
    } else {
        puts "  S_AXI_HP0_ACLK net    : $net"
        set drv [get_bd_pins -quiet -of_objects $net -filter {DIR == O}]
        puts "  driven by             : $drv"
    }
}

# ---- locate the wrapper cell and its clk ------------------------------------
set wrap [get_bd_cells -quiet -filter {VLNV =~ *axi_hp_master_wrap*}]
if {[llength $wrap] == 0} {
    set wrap [get_bd_cells -quiet -filter {VLNV =~ *top_level*}]
}
puts "\n--- wrapper / top cell: $wrap ---"
foreach clkname {clk aclk m_axi_aclk ap_clk} {
    set p [get_bd_pins -quiet $wrap/$clkname]
    if {[llength $p]} {
        set n [get_bd_nets -quiet -of_objects $p]
        puts "  $wrap/$clkname net: $n"
    }
}
puts "  ^ compare this net to the S_AXI_HP0_ACLK net above -- they must MATCH."

# ---- 2. HP0 data width -------------------------------------------------------
puts "\n--- 2. S_AXI_HP0 data width (must be 64) ---"
foreach prop {CONFIG.PCW_USE_S_AXI_HP0 \
              CONFIG.PCW_S_AXI_HP0_DATA_WIDTH} {
    set v [get_property -quiet $prop $ps]
    puts "  $prop = $v"
}

# ---- 3. reset on the HP path -------------------------------------------------
puts "\n--- 3. reset nets near the HP path ---"
foreach rstpin [get_bd_pins -quiet $ps/S_AXI_HP0_ARESETN] {
    set n [get_bd_nets -quiet -of_objects $rstpin]
    puts "  S_AXI_HP0_ARESETN net : $n  (note: HP wants ACTIVE-LOW)"
    set drv [get_bd_pins -quiet -of_objects $n -filter {DIR == O}]
    puts "    driven by           : $drv"
}

# ---- 4. interconnects between wrapper and PS --------------------------------
puts "\n--- 4. interconnect/converters on the HP path (check their aclk/aresetn) ---"
set ics [get_bd_cells -quiet -filter {VLNV =~ *axi_interconnect* || VLNV =~ *smartconnect* || VLNV =~ *protocol_convert*}]
foreach ic $ics {
    puts "  cell: $ic  ([get_property VLNV $ic])"
    foreach p [get_bd_pins -quiet -of_objects $ic -filter {TYPE == clk || TYPE == rst}] {
        set n [get_bd_nets -quiet -of_objects $p]
        puts "      [get_property NAME $p]  <- $n"
    }
}

puts "\n=================================================================="
puts " AUDIT DONE. Paste the output back."
puts " Most common culprit: S_AXI_HP0_ACLK net != wrapper clk net (unclocked"
puts " HP W-FIFO -> WREADY never rises)."
puts "=================================================================="
