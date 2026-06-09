// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vtb_multiply_manager_wide__Syms.h"


VL_ATTR_COLD void Vtb_multiply_manager_wide___024root__trace_init_sub__TOP__0(Vtb_multiply_manager_wide___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root__trace_init_sub__TOP__0\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    VL_TRACE_PUSH_PREFIX(tracep, "tb_multiply_manager_wide", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+94,0,"NARROW_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+95,0,"INTEGER_BITS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+96,0,"ITERATION_COUNT_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+97,0,"LOW",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+94,0,"WIDE_HIGH_W",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+98,0,"WIDE_LOW_W",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+99,0,"WIDE_TOTAL",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+100,0,"WIDE_REG_W",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+101,0,"WIDE_FRAC",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+102,0,"ACC_W",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+103,0,"RES_HI",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+104,0,"RES_LO",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+84,0,"clk",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+85,0,"rst",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+86,0,"kill",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+0,0,"received",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+87,0,"start_left",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+88,0,"start_right",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+1,0,"start_wide",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+2,0,"julia_type",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+3,0,"magnitude_negation_encoding",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+4,0,"max_iteration",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 4,0);
    VL_TRACE_DECL_BUS(tracep,c+5,0,"julia_c_x",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BUS(tracep,c+6,0,"julia_c_y",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BUS(tracep,c+7,0,"starting_x_reg_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BUS(tracep,c+8,0,"starting_x_reg_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BUS(tracep,c+9,0,"starting_y_reg_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BUS(tracep,c+10,0,"starting_y_reg_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BIT(tracep,c+36,0,"done",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+37,0,"done_side",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+38,0,"iteration_out",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BUS(tracep,c+89,0,"errors",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+90,0,"checks",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_PUSH_PREFIX(tracep, "dut", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+105,0,"NARROW_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+106,0,"INTEGER_BITS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+107,0,"ITERATION_COUNT_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+108,0,"LOWEST_MAX_ITERATION_POWER",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+84,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+85,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+86,0,"kill",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+0,0,"received",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+87,0,"start_left",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+88,0,"start_right",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+1,0,"start_wide",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+2,0,"julia_type",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+3,0,"magnitude_negation_encoding",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+4,0,"max_iteration",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 4,0);
    VL_TRACE_DECL_BUS(tracep,c+5,0,"julia_c_x",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BUS(tracep,c+6,0,"julia_c_y",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BUS(tracep,c+7,0,"starting_x_reg_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BUS(tracep,c+8,0,"starting_x_reg_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BUS(tracep,c+9,0,"starting_y_reg_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BUS(tracep,c+10,0,"starting_y_reg_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BIT(tracep,c+36,0,"done",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+37,0,"done_side",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+38,0,"iteration_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BUS(tracep,c+107,0,"NARROW_FRACTIONAL_BITS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_QUAD(tracep,c+39,0,"sum_x_reg_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+41,0,"sum_x_reg_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+43,0,"sum_y_reg_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+45,0,"sum_y_reg_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+47,0,"wide_partial_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+49,0,"wide_partial_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_BIT(tracep,c+51,0,"sum_x_reg_1_overflow_flag",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+52,0,"sum_x_reg_2_overflow_flag",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+53,0,"sum_y_reg_1_overflow_flag",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+54,0,"sum_y_reg_2_overflow_flag",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+55,0,"is_wide",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+56,0,"spare_x_reg_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BUS(tracep,c+57,0,"spare_x_reg_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_QUAD(tracep,c+58,0,"magnitude_reg_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+60,0,"magnitude_reg_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_BUS(tracep,c+62,0,"iteration_reg_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BUS(tracep,c+63,0,"iteration_reg_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BUS(tracep,c+64,0,"grouping_status",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+65,0,"left_thread",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+66,0,"left_cycle",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+67,0,"right_thread",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+68,0,"right_cycle",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+69,0,"joint_cycle",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_QUAD(tracep,c+15,0,"encoded_x_reg_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+17,0,"encoded_x_reg_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+19,0,"encoded_y_reg_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+21,0,"encoded_y_reg_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+70,0,"left_multiply_result",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_BUS(tracep,c+72,0,"left_multiply_mode",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 1,0);
    VL_TRACE_DECL_QUAD(tracep,c+73,0,"right_multiply_result",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_BUS(tracep,c+75,0,"right_multiply_mode",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 1,0);
    VL_TRACE_DECL_BIT(tracep,c+76,0,"left_magnitude_flag",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+77,0,"right_magnitude_flag",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+23,0,"left_max_iteration_flag",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+91,0,"right_max_iteration_flag",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_PUSH_PREFIX(tracep, "left_iteration_flagger", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+107,0,"ITERATION_COUNT_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+108,0,"LOWEST_MAX_ITERATION_POWER",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+62,0,"iteration_count",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BUS(tracep,c+4,0,"max_iteration",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 4,0);
    VL_TRACE_DECL_BIT(tracep,c+23,0,"flag",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "left_magnitude", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+105,0,"NARROW_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+106,0,"INTEGER_BITS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_QUAD(tracep,c+58,0,"magnitude",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_BIT(tracep,c+76,0,"mag_flag",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+109,0,"TOP",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+110,0,"BOTTOM",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "left_multiply", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+105,0,"NARROW_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+84,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+56,0,"x",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BUS(tracep,c+78,0,"y",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BUS(tracep,c+72,0,"mode",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 1,0);
    VL_TRACE_DECL_BIT(tracep,c+55,0,"is_wide",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_QUAD(tracep,c+70,0,"result",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+79,0,"combinational_result",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "mag_neg_encoder", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+105,0,"NARROW_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+106,0,"INTEGER_BITS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_QUAD(tracep,c+39,0,"sum_x_reg_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+41,0,"sum_x_reg_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+43,0,"sum_y_reg_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+45,0,"sum_y_reg_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_BUS(tracep,c+3,0,"magnitude_negation_encoding",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BIT(tracep,c+55,0,"is_wide",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_QUAD(tracep,c+15,0,"changed_sum_x_reg_1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+17,0,"changed_sum_x_reg_2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+19,0,"changed_sum_y_reg_1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+21,0,"changed_sum_y_reg_2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_BUS(tracep,c+111,0,"SUM_INT_BITS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+112,0,"SUM_FRACTIONAL_BITS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_WIDE(tracep,c+24,0,"wide_x",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 71,0);
    VL_TRACE_DECL_WIDE(tracep,c+27,0,"wide_y",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 71,0);
    VL_TRACE_DECL_WIDE(tracep,c+30,0,"changed_wide_x",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 71,0);
    VL_TRACE_DECL_WIDE(tracep,c+33,0,"changed_wide_y",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 71,0);
    VL_TRACE_DECL_BIT(tracep,c+11,0,"abs_x",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+12,0,"neg_x",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+13,0,"abs_y",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+14,0,"neg_y",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "right_iteration_flagger", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+107,0,"ITERATION_COUNT_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+108,0,"LOWEST_MAX_ITERATION_POWER",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+63,0,"iteration_count",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BUS(tracep,c+4,0,"max_iteration",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 4,0);
    VL_TRACE_DECL_BIT(tracep,c+91,0,"flag",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "right_magnitude", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+105,0,"NARROW_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+106,0,"INTEGER_BITS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_QUAD(tracep,c+60,0,"magnitude",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_BIT(tracep,c+77,0,"mag_flag",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+109,0,"TOP",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+110,0,"BOTTOM",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "right_multiply", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+105,0,"NARROW_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+84,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+57,0,"x",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BUS(tracep,c+81,0,"y",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 17,0);
    VL_TRACE_DECL_BUS(tracep,c+75,0,"mode",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 1,0);
    VL_TRACE_DECL_BIT(tracep,c+55,0,"is_wide",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_QUAD(tracep,c+73,0,"result",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_QUAD(tracep,c+82,0,"combinational_result",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "x_1", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+105,0,"NARROW_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+107,0,"NARROW_FRACTIONAL_BITS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+106,0,"INTEGER_BITS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_QUAD(tracep,c+39,0,"coordinate",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_BIT(tracep,c+55,0,"is_wide",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+51,0,"flag",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+109,0,"TOP",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+113,0,"BOTTOM",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "x_2", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+105,0,"NARROW_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+107,0,"NARROW_FRACTIONAL_BITS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+106,0,"INTEGER_BITS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_QUAD(tracep,c+41,0,"coordinate",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_BIT(tracep,c+55,0,"is_wide",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+52,0,"flag",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+109,0,"TOP",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+113,0,"BOTTOM",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "y_1", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+105,0,"NARROW_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+107,0,"NARROW_FRACTIONAL_BITS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+106,0,"INTEGER_BITS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_QUAD(tracep,c+43,0,"coordinate",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_BIT(tracep,c+55,0,"is_wide",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+53,0,"flag",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+109,0,"TOP",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+113,0,"BOTTOM",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "y_2", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+105,0,"NARROW_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+107,0,"NARROW_FRACTIONAL_BITS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+106,0,"INTEGER_BITS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_QUAD(tracep,c+45,0,"coordinate",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 35,0);
    VL_TRACE_DECL_BIT(tracep,c+55,0,"is_wide",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+54,0,"flag",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+109,0,"TOP",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+113,0,"BOTTOM",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "unnamedblk3", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_PUSH_PREFIX(tracep, "unnamedblk4", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_DOUBLE(tracep,c+92,0,"eps",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::DOUBLE);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "unnamedblk5", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+114,0,"cyc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_POP_PREFIX(tracep);
}

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root__trace_init_top(Vtb_multiply_manager_wide___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root__trace_init_top\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtb_multiply_manager_wide___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vtb_multiply_manager_wide___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtb_multiply_manager_wide___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtb_multiply_manager_wide___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root__trace_register(Vtb_multiply_manager_wide___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root__trace_register\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    tracep->addConstCb(&Vtb_multiply_manager_wide___024root__trace_const_0, 0, vlSelf);
    tracep->addFullCb(&Vtb_multiply_manager_wide___024root__trace_full_0, 0, vlSelf);
    tracep->addChgCb(&Vtb_multiply_manager_wide___024root__trace_chg_0, 0, vlSelf);
    tracep->addCleanupCb(&Vtb_multiply_manager_wide___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root__trace_const_0_sub_0(Vtb_multiply_manager_wide___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root__trace_const_0\n"); );
    // Body
    Vtb_multiply_manager_wide___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_multiply_manager_wide___024root*>(voidSelf);
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Vtb_multiply_manager_wide___024root__trace_const_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root__trace_const_0_sub_0(Vtb_multiply_manager_wide___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root__trace_const_0_sub_0\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullIData(oldp+94,(0x00000012U),32);
    bufp->fullIData(oldp+95,(2U),32);
    bufp->fullIData(oldp+96,(0x00000010U),32);
    bufp->fullIData(oldp+97,(0U),32);
    bufp->fullIData(oldp+98,(0x00000011U),32);
    bufp->fullIData(oldp+99,(0x00000023U),32);
    bufp->fullIData(oldp+100,(0x00000024U),32);
    bufp->fullIData(oldp+101,(0x00000021U),32);
    bufp->fullIData(oldp+102,(0x00000048U),32);
    bufp->fullIData(oldp+103,(0x00000044U),32);
    bufp->fullIData(oldp+104,(0x00000022U),32);
    bufp->fullIData(oldp+105,(0x00000012U),32);
    bufp->fullIData(oldp+106,(2U),32);
    bufp->fullIData(oldp+107,(0x00000010U),32);
    bufp->fullIData(oldp+108,(0U),32);
    bufp->fullIData(oldp+109,(0x00000023U),32);
    bufp->fullIData(oldp+110,(0x00000022U),32);
    bufp->fullIData(oldp+111,(4U),32);
    bufp->fullIData(oldp+112,(0x00000020U),32);
    bufp->fullIData(oldp+113,(0x00000021U),32);
    bufp->fullIData(oldp+114,(0U),32);
}

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root__trace_full_0_sub_0(Vtb_multiply_manager_wide___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root__trace_full_0\n"); );
    // Body
    Vtb_multiply_manager_wide___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_multiply_manager_wide___024root*>(voidSelf);
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Vtb_multiply_manager_wide___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root__trace_full_0_sub_0(Vtb_multiply_manager_wide___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root__trace_full_0_sub_0\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullBit(oldp+0,(vlSelfRef.tb_multiply_manager_wide__DOT__received));
    bufp->fullBit(oldp+1,(vlSelfRef.tb_multiply_manager_wide__DOT__start_wide));
    bufp->fullBit(oldp+2,(vlSelfRef.tb_multiply_manager_wide__DOT__julia_type));
    bufp->fullCData(oldp+3,(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding),4);
    bufp->fullCData(oldp+4,(vlSelfRef.tb_multiply_manager_wide__DOT__max_iteration),5);
    bufp->fullIData(oldp+5,(vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_x),18);
    bufp->fullIData(oldp+6,(vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_y),18);
    bufp->fullIData(oldp+7,(vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_1),18);
    bufp->fullIData(oldp+8,(vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_2),18);
    bufp->fullIData(oldp+9,(vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_1),18);
    bufp->fullIData(oldp+10,(vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_2),18);
    bufp->fullBit(oldp+11,((1U & ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding) 
                                  >> 3U))));
    bufp->fullBit(oldp+12,((1U & ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding) 
                                  >> 1U))));
    bufp->fullBit(oldp+13,((1U & ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding) 
                                  >> 2U))));
    bufp->fullBit(oldp+14,((1U & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding))));
    bufp->fullQData(oldp+15,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_1),36);
    bufp->fullQData(oldp+17,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_2),36);
    bufp->fullQData(oldp+19,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_1),36);
    bufp->fullQData(oldp+21,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_2),36);
    bufp->fullBit(oldp+23,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_max_iteration_flag));
    bufp->fullWData(oldp+24,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x),72);
    bufp->fullWData(oldp+27,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y),72);
    bufp->fullWData(oldp+30,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x),72);
    bufp->fullWData(oldp+33,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y),72);
    bufp->fullBit(oldp+36,(vlSelfRef.tb_multiply_manager_wide__DOT__done));
    bufp->fullBit(oldp+37,(vlSelfRef.tb_multiply_manager_wide__DOT__done_side));
    bufp->fullSData(oldp+38,(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out),16);
    bufp->fullQData(oldp+39,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1),36);
    bufp->fullQData(oldp+41,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_2),36);
    bufp->fullQData(oldp+43,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1),36);
    bufp->fullQData(oldp+45,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2),36);
    bufp->fullQData(oldp+47,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__wide_partial_1),36);
    bufp->fullQData(oldp+49,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__wide_partial_2),36);
    bufp->fullBit(oldp+51,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1_overflow_flag));
    bufp->fullBit(oldp+52,(((0U != (7U & (IData)((vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_2 
                                                  >> 0x00000021U)))) 
                            & (7U != (7U & (IData)(
                                                   (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_2 
                                                    >> 0x00000021U)))))));
    bufp->fullBit(oldp+53,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1_overflow_flag));
    bufp->fullBit(oldp+54,(((0U != (7U & (IData)((vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2 
                                                  >> 0x00000021U)))) 
                            & (7U != (7U & (IData)(
                                                   (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2 
                                                    >> 0x00000021U)))))));
    bufp->fullBit(oldp+55,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__is_wide));
    bufp->fullIData(oldp+56,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__spare_x_reg_1),18);
    bufp->fullIData(oldp+57,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__spare_x_reg_2),18);
    bufp->fullQData(oldp+58,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__magnitude_reg_1),36);
    bufp->fullQData(oldp+60,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__magnitude_reg_2),36);
    bufp->fullSData(oldp+62,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__iteration_reg_1),16);
    bufp->fullSData(oldp+63,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__iteration_reg_2),16);
    bufp->fullIData(oldp+64,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__grouping_status),32);
    bufp->fullIData(oldp+65,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_thread),32);
    bufp->fullIData(oldp+66,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_cycle),32);
    bufp->fullIData(oldp+67,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_thread),32);
    bufp->fullIData(oldp+68,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_cycle),32);
    bufp->fullIData(oldp+69,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__joint_cycle),32);
    bufp->fullQData(oldp+70,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_result),36);
    bufp->fullCData(oldp+72,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_mode),2);
    bufp->fullQData(oldp+73,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_result),36);
    bufp->fullCData(oldp+75,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_mode),2);
    bufp->fullBit(oldp+76,((0U != (3U & (IData)((vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__magnitude_reg_1 
                                                 >> 0x00000022U))))));
    bufp->fullBit(oldp+77,((0U != (3U & (IData)((vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__magnitude_reg_2 
                                                 >> 0x00000022U))))));
    bufp->fullIData(oldp+78,((0x0003ffffU & (IData)(
                                                    (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1 
                                                     >> 0x00000010U)))),18);
    bufp->fullQData(oldp+79,((0x0000000fffffffffULL 
                              & ((2U & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_mode))
                                  ? ((1U & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_mode))
                                      ? vlSelfRef.__VdfgRegularize_h6e95ff9d_0_4
                                      : VL_SHIFTL_QQI(36,36,32, vlSelfRef.__VdfgRegularize_h6e95ff9d_0_4, 1U))
                                  : ((1U & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_mode))
                                      ? VL_MULS_QQQ(36, 
                                                    (0x0000000fffffffffULL 
                                                     & VL_EXTENDS_QI(36,18, 
                                                                     (0x0003ffffU 
                                                                      & (IData)(
                                                                                (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1 
                                                                                >> 0x00000010U))))), 
                                                    (0x0000000fffffffffULL 
                                                     & VL_EXTENDS_QI(36,18, 
                                                                     (0x0003ffffU 
                                                                      & (IData)(
                                                                                (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1 
                                                                                >> 0x00000010U))))))
                                      : VL_MULS_QQQ(36, 
                                                    (0x0000000fffffffffULL 
                                                     & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__spare_x_reg_1)), 
                                                    (0x0000000fffffffffULL 
                                                     & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__spare_x_reg_1))))))),36);
    bufp->fullIData(oldp+81,((0x0003ffffU & (IData)(
                                                    (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2 
                                                     >> 0x00000010U)))),18);
    bufp->fullQData(oldp+82,((0x0000000fffffffffULL 
                              & ((2U & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_mode))
                                  ? ((1U & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_mode))
                                      ? vlSelfRef.__VdfgRegularize_h6e95ff9d_0_5
                                      : VL_SHIFTL_QQI(36,36,32, vlSelfRef.__VdfgRegularize_h6e95ff9d_0_5, 1U))
                                  : ((1U & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_mode))
                                      ? VL_MULS_QQQ(36, 
                                                    (0x0000000fffffffffULL 
                                                     & VL_EXTENDS_QI(36,18, 
                                                                     (0x0003ffffU 
                                                                      & (IData)(
                                                                                (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2 
                                                                                >> 0x00000010U))))), 
                                                    (0x0000000fffffffffULL 
                                                     & VL_EXTENDS_QI(36,18, 
                                                                     (0x0003ffffU 
                                                                      & (IData)(
                                                                                (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2 
                                                                                >> 0x00000010U))))))
                                      : VL_MULS_QQQ(36, 
                                                    (0x0000000fffffffffULL 
                                                     & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__spare_x_reg_2)), 
                                                    (0x0000000fffffffffULL 
                                                     & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__spare_x_reg_2))))))),36);
    bufp->fullBit(oldp+84,(vlSelfRef.tb_multiply_manager_wide__DOT__clk));
    bufp->fullBit(oldp+85,(vlSelfRef.tb_multiply_manager_wide__DOT__rst));
    bufp->fullBit(oldp+86,(vlSelfRef.tb_multiply_manager_wide__DOT__kill));
    bufp->fullBit(oldp+87,(vlSelfRef.tb_multiply_manager_wide__DOT__start_left));
    bufp->fullBit(oldp+88,(vlSelfRef.tb_multiply_manager_wide__DOT__start_right));
    bufp->fullIData(oldp+89,(vlSelfRef.tb_multiply_manager_wide__DOT__errors),32);
    bufp->fullIData(oldp+90,(vlSelfRef.tb_multiply_manager_wide__DOT__checks),32);
    bufp->fullBit(oldp+91,((1U & ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__iteration_reg_2) 
                                  >> (0x0000000fU & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__max_iteration))))));
    bufp->fullDouble(oldp+92,(vlSelfRef.tb_multiply_manager_wide__DOT__unnamedblk3__DOT__unnamedblk4__DOT__eps));
}
