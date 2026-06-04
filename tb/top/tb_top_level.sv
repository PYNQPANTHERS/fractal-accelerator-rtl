// Integration testbench for top_level (sixteenth_controller + per_sixteenth_engine)

// ps_start and cfg_* are internal signals pending AXI Lite wiring
// We use inline `force`/`release` (Icarus only allows this in initial blocks)


`timescale 1ns/1ps

module tb_top_level;

    int tests_run    = 0;
    int tests_passed = 0;
    int tests_failed = 0;
    string current_suite = "";

    task automatic suite(input string name);
        current_suite = name;
        $display("\n%0s", {72{"="}});
        $display("  SUITE: %s", name);
        $display("%0s", {72{"="}});
    endtask

    task automatic check(input logic cond, input string desc);
        tests_run++;
        if (cond) begin
            tests_passed++;
            $display("  [PASS] %s", desc);
        end else begin
            tests_failed++;
            $display("  [FAIL] %s  (suite: %s)", desc, current_suite);
        end
    endtask

    task automatic summary();
        $display("\n%0s", {72{"="}});
        $display("  RESULTS: %0d / %0d passed", tests_passed, tests_run);
        if (tests_failed == 0)
            $display("  ALL TESTS PASSED");
        else
            $display("  %0d TEST(S) FAILED", tests_failed);
        $display("%0s\n", {72{"="}});
    endtask

    logic clk = 0;
    always #5 clk = ~clk;
    task automatic tick(input int n = 1); repeat(n) @(posedge clk); #1; endtask

    // DUT ports
    logic        rst;
    logic [31:0] hp_axi_wr_addr;
    logic [63:0] hp_axi_wr_data;
    logic        hp_axi_wr_en;
    logic        hp_axi_wr_ready;
    logic        irq_all_done;

    top_level dut (
        .clk            (clk),
        .rst            (rst),
        .hp_axi_wr_addr (hp_axi_wr_addr),
        .hp_axi_wr_data (hp_axi_wr_data),
        .hp_axi_wr_en   (hp_axi_wr_en),
        .hp_axi_wr_ready(hp_axi_wr_ready),
        .irq_all_done   (irq_all_done)
    );

    // module-level variables
    int ok, elapsed;

    initial begin
        $dumpfile("sim/waves/tb_top_level.vcd");
        $dumpvars(0, tb_top_level);

        hp_axi_wr_ready = 1'b1;

        suite("RESET STATE");
        rst = 1; tick(3); rst = 0; tick(1);
        check(!irq_all_done,        "irq_all_done low after reset");
        check(!hp_axi_wr_en,        "hp_axi_wr_en low after reset");
        check(dut.ctrl_engine_rst,  "engine_rst high after reset (controller in IDLE)");
        check(!dut.ctrl_start,      "start low after reset");

        // FSM timing (all outputs are registered):
        //   tick 1  ps_start=1 -> IDLE evaluates -> next: state=LOAD,  engine_rst=1
        //   tick 2              -> LOAD evaluates -> next: state=RENDER, engine_rst=1
        //   tick 3              -> RENDER evaluates -> next: engine_rst=0, start=1
        suite("CONTROLLER - starts engine after ps_start");
        rst = 1; tick(3); rst = 0; tick(1);
        force dut.ps_start = 1'b1;
        tick(1);                    // tick 1: IDLE -> LOAD
        release dut.ps_start;
        check(dut.ctrl_engine_rst,  "tick 1 (LOAD): engine_rst high");
        check(!dut.ctrl_start,      "tick 1 (LOAD): start still low");
        tick(1);                    // tick 2: LOAD -> RENDER (engine_rst still 1)
        check(dut.ctrl_engine_rst,  "tick 2 (RENDER registered): engine_rst still high");
        tick(1);                    // tick 3: RENDER executes -> engine_rst=0, start=1
        check(!dut.ctrl_engine_rst, "tick 3: engine_rst deasserted (engine released)");
        check(dut.ctrl_start,       "tick 3: start asserted to engine");

        suite("OFFSETS - sixteenth 0 x/y offsets and base address");
        // sixteenth_base_addr is set in LOAD from cfg_image_base_addr.
        // x_offset/y_offset are set in LOAD from the sixteenth_index.
        rst = 1; tick(3); rst = 0; tick(1);
        force dut.cfg_image_base_addr = 32'hA000_0000;
        force dut.ps_start = 1'b1;
        tick(1); release dut.ps_start; // tick 1: IDLE->LOAD (offsets computed)
        tick(1);                        // tick 2: LOAD->RENDER (values registered)
        check(dut.ctrl_x_offset == 10'd0,   "sixteenth 0: x_offset = 0");
        check(dut.ctrl_y_offset == 10'd0,   "sixteenth 0: y_offset = 0");
        // sixteenth_base_addr = 0xA000_0000 + 0 * 66048
        check(dut.ctrl_sixteenth_base_addr == 32'hA000_0000,
              "sixteenth 0: sixteenth_base_addr = image_base");
        release dut.cfg_image_base_addr;

        suite("RENDER HOLD - start stays high while engine is running");
        // In RENDER state, start is held high until quarter_complete.
        // Engine stub never asserts quarter_complete (not connected to finish
        // all 256 tiles), so the controller stays in RENDER with start=1.
        rst = 1; tick(3); rst = 0; tick(1);
        force dut.ps_start = 1'b1;
        tick(1); release dut.ps_start; // IDLE->LOAD
        tick(2);                        // LOAD->RENDER, RENDER executes
        check(dut.ctrl_start,           "start high in RENDER");
        tick(10);                       // stay in RENDER for 10 more cycles
        check(dut.ctrl_start,           "start still high 10 cycles later");
        check(!dut.ctrl_engine_rst,     "engine_rst stays low during render");

        suite("ENGINE DONE - full pipeline fires engine_done");
        rst = 1; tick(3); rst = 0; tick(1);
        force dut.cfg_image_base_addr = 32'h0;
        force dut.ps_start = 1'b1;
        tick(1); release dut.ps_start;
        tick(2); // -> RENDER (engine_rst=0, start=1)
        ok = 0; elapsed = 0;
        while (elapsed < 300 && !dut.u_engine.engine_done) begin
            tick(1); elapsed++;
        end
        ok = dut.u_engine.engine_done ? 1 : 0;
        check(ok, "engine_done fires within 300 cycles");
        $display("    (fired after ~%0d cycles)", elapsed);
        release dut.cfg_image_base_addr;

        suite("AXI OUTPUT - writes appear at hp_axi port");
        begin
            int w, t;
            logic [31:0] first_addr;
            w = 0; t = 0;
            first_addr = 32'hFFFF_FFFF;
            while (w < 32 && t < 500) begin
                @(posedge clk); #1; t++;
                if (hp_axi_wr_en) begin
                    if (w == 0) first_addr = hp_axi_wr_addr;
                    w++;
                end
            end
            check(w >= 32,
                  $sformatf("hp_axi: at least 32 writes visible (got %0d)", w));
            check(first_addr == 32'h0,
                  $sformatf("first write addr = 0 (got 0x%08X)", first_addr));
        end

        suite("RESET CLEARS STATE");
        rst = 1; tick(3); rst = 0; tick(1);
        check(dut.ctrl_engine_rst,  "engine_rst high after reset");
        check(!dut.ctrl_start,      "start low after reset");
        check(!irq_all_done,        "irq_all_done low after reset");

        summary();
        $finish;
    end

    initial begin
        #5_000_000;
        $display("\n[TIMEOUT] simulation exceeded 5 ms wall — possible hang");
        $finish;
    end

endmodule
