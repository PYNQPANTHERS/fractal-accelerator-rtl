// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vtb_multiply_manager_wide__Syms.h"


void Vtb_multiply_manager_wide___024root__trace_chg_0_sub_0(Vtb_multiply_manager_wide___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vtb_multiply_manager_wide___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root__trace_chg_0\n"); );
    // Body
    Vtb_multiply_manager_wide___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_multiply_manager_wide___024root*>(voidSelf);
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    Vtb_multiply_manager_wide___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vtb_multiply_manager_wide___024root__trace_chg_0_sub_0(Vtb_multiply_manager_wide___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root__trace_chg_0_sub_0\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 0);
    if (VL_UNLIKELY((((vlSelfRef.__Vm_traceActivity[1U] 
                       | vlSelfRef.__Vm_traceActivity[2U]) 
                      | vlSelfRef.__Vm_traceActivity[3U])))) {
        bufp->chgBit(oldp+0,(vlSelfRef.tb_multiply_manager_wide__DOT__received));
        bufp->chgBit(oldp+1,(vlSelfRef.tb_multiply_manager_wide__DOT__start_wide));
        bufp->chgBit(oldp+2,(vlSelfRef.tb_multiply_manager_wide__DOT__julia_type));
        bufp->chgCData(oldp+3,(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding),4);
        bufp->chgCData(oldp+4,(vlSelfRef.tb_multiply_manager_wide__DOT__max_iteration),5);
        bufp->chgIData(oldp+5,(vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_x),18);
        bufp->chgIData(oldp+6,(vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_y),18);
        bufp->chgIData(oldp+7,(vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_1),18);
        bufp->chgIData(oldp+8,(vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_2),18);
        bufp->chgIData(oldp+9,(vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_1),18);
        bufp->chgIData(oldp+10,(vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_2),18);
        bufp->chgBit(oldp+11,((1U & ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding) 
                                     >> 3U))));
        bufp->chgBit(oldp+12,((1U & ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding) 
                                     >> 1U))));
        bufp->chgBit(oldp+13,((1U & ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding) 
                                     >> 2U))));
        bufp->chgBit(oldp+14,((1U & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding))));
    }
    if (VL_UNLIKELY(((vlSelfRef.__Vm_traceActivity[4U] 
                      | vlSelfRef.__Vm_traceActivity[6U])))) {
        bufp->chgQData(oldp+15,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_1),36);
        bufp->chgQData(oldp+17,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_2),36);
        bufp->chgQData(oldp+19,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_1),36);
        bufp->chgQData(oldp+21,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_2),36);
        bufp->chgBit(oldp+23,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_max_iteration_flag));
        bufp->chgWData(oldp+24,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x),72);
        bufp->chgWData(oldp+27,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y),72);
        bufp->chgWData(oldp+30,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x),72);
        bufp->chgWData(oldp+33,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y),72);
    }
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[5U]))) {
        bufp->chgBit(oldp+36,(vlSelfRef.tb_multiply_manager_wide__DOT__done));
        bufp->chgBit(oldp+37,(vlSelfRef.tb_multiply_manager_wide__DOT__done_side));
        bufp->chgSData(oldp+38,(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out),16);
        bufp->chgQData(oldp+39,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1),36);
        bufp->chgQData(oldp+41,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_2),36);
        bufp->chgQData(oldp+43,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1),36);
        bufp->chgQData(oldp+45,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2),36);
        bufp->chgQData(oldp+47,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__wide_partial_1),36);
        bufp->chgQData(oldp+49,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__wide_partial_2),36);
        bufp->chgBit(oldp+51,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1_overflow_flag));
        bufp->chgBit(oldp+52,(((0U != (7U & (IData)(
                                                    (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_2 
                                                     >> 0x00000021U)))) 
                               & (7U != (7U & (IData)(
                                                      (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_2 
                                                       >> 0x00000021U)))))));
        bufp->chgBit(oldp+53,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1_overflow_flag));
        bufp->chgBit(oldp+54,(((0U != (7U & (IData)(
                                                    (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2 
                                                     >> 0x00000021U)))) 
                               & (7U != (7U & (IData)(
                                                      (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2 
                                                       >> 0x00000021U)))))));
        bufp->chgBit(oldp+55,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__is_wide));
        bufp->chgIData(oldp+56,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__spare_x_reg_1),18);
        bufp->chgIData(oldp+57,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__spare_x_reg_2),18);
        bufp->chgQData(oldp+58,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__magnitude_reg_1),36);
        bufp->chgQData(oldp+60,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__magnitude_reg_2),36);
        bufp->chgSData(oldp+62,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__iteration_reg_1),16);
        bufp->chgSData(oldp+63,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__iteration_reg_2),16);
        bufp->chgIData(oldp+64,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__grouping_status),32);
        bufp->chgIData(oldp+65,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_thread),32);
        bufp->chgIData(oldp+66,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_cycle),32);
        bufp->chgIData(oldp+67,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_thread),32);
        bufp->chgIData(oldp+68,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_cycle),32);
        bufp->chgIData(oldp+69,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__joint_cycle),32);
        bufp->chgQData(oldp+70,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_result),36);
        bufp->chgCData(oldp+72,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_mode),2);
        bufp->chgQData(oldp+73,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_result),36);
        bufp->chgCData(oldp+75,(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_mode),2);
        bufp->chgBit(oldp+76,((0U != (3U & (IData)(
                                                   (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__magnitude_reg_1 
                                                    >> 0x00000022U))))));
        bufp->chgBit(oldp+77,((0U != (3U & (IData)(
                                                   (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__magnitude_reg_2 
                                                    >> 0x00000022U))))));
        bufp->chgIData(oldp+78,((0x0003ffffU & (IData)(
                                                       (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1 
                                                        >> 0x00000010U)))),18);
        bufp->chgQData(oldp+79,((0x0000000fffffffffULL 
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
        bufp->chgIData(oldp+81,((0x0003ffffU & (IData)(
                                                       (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2 
                                                        >> 0x00000010U)))),18);
        bufp->chgQData(oldp+82,((0x0000000fffffffffULL 
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
    }
    bufp->chgBit(oldp+84,(vlSelfRef.tb_multiply_manager_wide__DOT__clk));
    bufp->chgBit(oldp+85,(vlSelfRef.tb_multiply_manager_wide__DOT__rst));
    bufp->chgBit(oldp+86,(vlSelfRef.tb_multiply_manager_wide__DOT__kill));
    bufp->chgBit(oldp+87,(vlSelfRef.tb_multiply_manager_wide__DOT__start_left));
    bufp->chgBit(oldp+88,(vlSelfRef.tb_multiply_manager_wide__DOT__start_right));
    bufp->chgIData(oldp+89,(vlSelfRef.tb_multiply_manager_wide__DOT__errors),32);
    bufp->chgIData(oldp+90,(vlSelfRef.tb_multiply_manager_wide__DOT__checks),32);
    bufp->chgBit(oldp+91,((1U & ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__iteration_reg_2) 
                                 >> (0x0000000fU & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__max_iteration))))));
    bufp->chgDouble(oldp+92,(vlSelfRef.tb_multiply_manager_wide__DOT__unnamedblk3__DOT__unnamedblk4__DOT__eps));
}

void Vtb_multiply_manager_wide___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root__trace_cleanup\n"); );
    // Body
    Vtb_multiply_manager_wide___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_multiply_manager_wide___024root*>(voidSelf);
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[2U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[3U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[4U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[5U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[6U] = 0U;
}
