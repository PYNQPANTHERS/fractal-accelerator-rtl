// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_multiply_manager_wide.h for the primary calling header

#include "Vtb_multiply_manager_wide__pch.h"

void Vtb_multiply_manager_wide___024root___timing_ready(Vtb_multiply_manager_wide___024root* vlSelf);

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root___eval_static(Vtb_multiply_manager_wide___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root___eval_static\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_multiply_manager_wide__DOT__errors = 0U;
    vlSelfRef.tb_multiply_manager_wide__DOT__checks = 0U;
    vlSelfRef.tb_multiply_manager_wide__DOT__unnamedblk1__DOT__idx = 0U;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_multiply_manager_wide__DOT__clk__0 
        = vlSelfRef.tb_multiply_manager_wide__DOT__clk;
    Vtb_multiply_manager_wide___024root___timing_ready(vlSelf);
    do {
        vlSelfRef.__VactTriggeredAcc[vlSelfRef.__Vi] 
            = vlSelfRef.__VactTriggered[vlSelfRef.__Vi];
        vlSelfRef.__Vi = ((IData)(1U) + vlSelfRef.__Vi);
    } while ((0U >= vlSelfRef.__Vi));
}

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root___eval_static__TOP(Vtb_multiply_manager_wide___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root___eval_static__TOP\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_multiply_manager_wide__DOT__errors = 0U;
    vlSelfRef.tb_multiply_manager_wide__DOT__checks = 0U;
    vlSelfRef.tb_multiply_manager_wide__DOT__unnamedblk1__DOT__idx = 0U;
}

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root___eval_initial__TOP(Vtb_multiply_manager_wide___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root___eval_initial__TOP\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_multiply_manager_wide__DOT__clk = 0U;
    VL_READMEM_N(true, 32, 256, 0, "wide_expected.hex"s
                 ,  &(vlSelfRef.tb_multiply_manager_wide__DOT__expected_count)
                 , 0, ~0ULL);
    VL_WRITEF_NX("Loaded expected counts from wide_expected.hex  [0]=%0d [1]=%0d\n",2
                 , '#',32,vlSelfRef.tb_multiply_manager_wide__DOT__expected_count[0U]
                 , '#',32,vlSelfRef.tb_multiply_manager_wide__DOT__expected_count[1U]);
}

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root___eval_final(Vtb_multiply_manager_wide___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root___eval_final\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_multiply_manager_wide___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vtb_multiply_manager_wide___024root___eval_phase__stl(Vtb_multiply_manager_wide___024root* vlSelf);

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root___eval_settle(Vtb_multiply_manager_wide___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root___eval_settle\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VstlIterCount;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vtb_multiply_manager_wide___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
#endif
            VL_FATAL_MT("tb_multiply_manager_wide_python_reference.sv", 16, "", "DIDNOTCONVERGE: Settle region did not converge after '--converge-limit' of 10000 tries");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        vlSelfRef.__VstlPhaseResult = Vtb_multiply_manager_wide___024root___eval_phase__stl(vlSelf);
        vlSelfRef.__VstlFirstIteration = 0U;
    } while (vlSelfRef.__VstlPhaseResult);
}

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root___eval_triggers_vec__stl(Vtb_multiply_manager_wide___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root___eval_triggers_vec__stl\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VstlTriggered[0U] = ((0xfffffffffffffffeULL 
                                      & vlSelfRef.__VstlTriggered[0U]) 
                                     | (IData)((IData)(vlSelfRef.__VstlFirstIteration)));
}

VL_ATTR_COLD bool Vtb_multiply_manager_wide___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_multiply_manager_wide___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(Vtb_multiply_manager_wide___024root___trigger_anySet__stl(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD bool Vtb_multiply_manager_wide___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root___trigger_anySet__stl\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root___stl_sequent__TOP__0(Vtb_multiply_manager_wide___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root___stl_sequent__TOP__0\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    VlWide<3>/*71:0*/ tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x;
    VL_ZERO_W(72, tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x);
    VlWide<3>/*71:0*/ tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y;
    VL_ZERO_W(72, tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y);
    VlWide<3>/*71:0*/ tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x;
    VL_ZERO_W(72, tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x);
    VlWide<3>/*71:0*/ tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y;
    VL_ZERO_W(72, tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y);
    VlWide<3>/*95:0*/ __Vtemp_2;
    VlWide<3>/*95:0*/ __Vtemp_7;
    VlWide<3>/*95:0*/ __Vtemp_9;
    VlWide<3>/*95:0*/ __Vtemp_14;
    // Body
    vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1_overflow_flag 
        = ((0U != (7U & (IData)((vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1 
                                 >> 0x00000021U)))) 
           & (7U != (7U & (IData)((vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1 
                                   >> 0x00000021U)))));
    vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1_overflow_flag 
        = ((0U != (7U & (IData)((vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1 
                                 >> 0x00000021U)))) 
           & (7U != (7U & (IData)((vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1 
                                   >> 0x00000021U)))));
    vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_max_iteration_flag 
        = (1U & ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__iteration_reg_1) 
                 >> (0x0000000fU & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__max_iteration))));
    vlSelfRef.__VdfgRegularize_h6e95ff9d_0_4 = (0x0000000fffffffffULL 
                                                & VL_MULS_QQQ(36, 
                                                              (0x0000000fffffffffULL 
                                                               & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__spare_x_reg_1)), 
                                                              (0x0000000fffffffffULL 
                                                               & VL_EXTENDS_QI(36,18, 
                                                                               (0x0003ffffU 
                                                                                & (IData)(
                                                                                (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1 
                                                                                >> 0x00000010U)))))));
    vlSelfRef.__VdfgRegularize_h6e95ff9d_0_5 = (0x0000000fffffffffULL 
                                                & VL_MULS_QQQ(36, 
                                                              (0x0000000fffffffffULL 
                                                               & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__spare_x_reg_2)), 
                                                              (0x0000000fffffffffULL 
                                                               & VL_EXTENDS_QI(36,18, 
                                                                               (0x0003ffffU 
                                                                                & (IData)(
                                                                                (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2 
                                                                                >> 0x00000010U)))))));
    if ((1U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__grouping_status)) {
        vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_mode 
            = ((2U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_cycle)
                ? 0U : ((3U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_cycle)
                         ? 1U : ((4U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_cycle)
                                  ? 2U : 0U)));
        vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_mode 
            = ((2U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_cycle)
                ? 0U : ((3U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_cycle)
                         ? 1U : ((4U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_cycle)
                                  ? 2U : 0U)));
    } else if ((2U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__grouping_status)) {
        if ((2U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__joint_cycle)) {
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_mode = 0U;
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_mode = 0U;
        } else if ((3U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__joint_cycle)) {
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_mode = 2U;
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_mode = 2U;
        } else if ((4U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__joint_cycle)) {
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_mode = 1U;
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_mode = 1U;
        } else if ((5U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__joint_cycle)) {
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_mode = 0U;
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_mode = 0U;
        } else if ((6U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__joint_cycle)) {
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_mode = 3U;
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_mode = 3U;
        } else if ((7U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__joint_cycle)) {
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_mode = 3U;
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_mode = 3U;
        } else {
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_mode = 0U;
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_mode = 0U;
        }
    } else {
        vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_mode = 0U;
        vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_mode = 0U;
    }
    vlSelfRef.tb_multiply_manager_wide__DOT__done = 0U;
    vlSelfRef.tb_multiply_manager_wide__DOT__done_side = 0U;
    if ((1U & (~ ((2U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__grouping_status) 
                  & (0x0000000aU == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__joint_cycle))))) {
        if ((1U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__grouping_status)) {
            if ((7U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_cycle)) {
                vlSelfRef.tb_multiply_manager_wide__DOT__done_side = 0U;
            }
            if ((7U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_cycle)) {
                vlSelfRef.tb_multiply_manager_wide__DOT__done_side = 1U;
            }
        }
    }
    vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out 
        = vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__iteration_reg_1;
    if (((2U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__grouping_status) 
         & (0x0000000aU == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__joint_cycle))) {
        vlSelfRef.tb_multiply_manager_wide__DOT__done = 1U;
        vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out 
            = vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__iteration_reg_1;
    } else if ((1U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__grouping_status)) {
        if ((7U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__left_cycle)) {
            vlSelfRef.tb_multiply_manager_wide__DOT__done = 1U;
            vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out 
                = vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__iteration_reg_1;
        }
        if ((7U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__right_cycle)) {
            vlSelfRef.tb_multiply_manager_wide__DOT__done = 1U;
            vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out 
                = vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__iteration_reg_2;
        }
    }
    vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__is_wide 
        = ((1U != vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__grouping_status) 
           && (2U == vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__grouping_status));
    vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_1 
        = vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1;
    vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_2 
        = vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_2;
    tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[0U] 
        = (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_2);
    tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[1U] 
        = (((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1) 
            << 4U) | (IData)((vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_2 
                              >> 0x00000020U)));
    tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[2U] 
        = (((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1) 
            >> 0x0000001cU) | ((IData)((vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1 
                                        >> 0x00000020U)) 
                               << 4U));
    tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[0U] 
        = tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[0U];
    tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[1U] 
        = tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[1U];
    tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[2U] 
        = tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[2U];
    vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_1 
        = vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1;
    vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_2 
        = vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2;
    tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[0U] 
        = (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2);
    tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[1U] 
        = (((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1) 
            << 4U) | (IData)((vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2 
                              >> 0x00000020U)));
    tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[2U] 
        = (((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1) 
            >> 0x0000001cU) | ((IData)((vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1 
                                        >> 0x00000020U)) 
                               << 4U));
    tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[0U] 
        = tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[0U];
    tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[1U] 
        = tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[1U];
    tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[2U] 
        = tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[2U];
    if (vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__is_wide) {
        if ((8U & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding))) {
            VL_NEGATE_W(3, __Vtemp_2, tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x);
            if ((0x00000080U & tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[2U])) {
                tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[0U] 
                    = __Vtemp_2[0U];
                tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[1U] 
                    = __Vtemp_2[1U];
                tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[2U] 
                    = (0x000000ffU & __Vtemp_2[2U]);
            } else {
                tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[0U] 
                    = tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[0U];
                tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[1U] 
                    = tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[1U];
                tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[2U] 
                    = (0x000000ffU & tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[2U]);
            }
        }
        if ((2U & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding))) {
            VL_NEGATE_W(3, __Vtemp_7, tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x);
            tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[0U] 
                = __Vtemp_7[0U];
            tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[1U] 
                = __Vtemp_7[1U];
            tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[2U] 
                = (0x000000ffU & __Vtemp_7[2U]);
        }
        vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_1 
            = (0x0000000fffffffffULL & (((QData)((IData)(tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[2U])) 
                                         << 0x0000001cU) 
                                        | ((QData)((IData)(tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[1U])) 
                                           >> 4U)));
        vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_2 
            = (0x0000000fffffffffULL & (((QData)((IData)(tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[1U])) 
                                         << 0x00000020U) 
                                        | (QData)((IData)(tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[0U]))));
        if ((4U & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding))) {
            VL_NEGATE_W(3, __Vtemp_9, tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y);
            if ((0x00000080U & tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[2U])) {
                tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[0U] 
                    = __Vtemp_9[0U];
                tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[1U] 
                    = __Vtemp_9[1U];
                tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[2U] 
                    = (0x000000ffU & __Vtemp_9[2U]);
            } else {
                tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[0U] 
                    = tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[0U];
                tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[1U] 
                    = tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[1U];
                tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[2U] 
                    = (0x000000ffU & tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[2U]);
            }
        }
        if ((1U & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding))) {
            VL_NEGATE_W(3, __Vtemp_14, tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y);
            tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[0U] 
                = __Vtemp_14[0U];
            tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[1U] 
                = __Vtemp_14[1U];
            tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[2U] 
                = (0x000000ffU & __Vtemp_14[2U]);
        }
        vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_1 
            = (0x0000000fffffffffULL & (((QData)((IData)(tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[2U])) 
                                         << 0x0000001cU) 
                                        | ((QData)((IData)(tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[1U])) 
                                           >> 4U)));
        vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_2 
            = (0x0000000fffffffffULL & (((QData)((IData)(tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[1U])) 
                                         << 0x00000020U) 
                                        | (QData)((IData)(tb_multiply_manager_wide__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[0U]))));
    } else {
        if ((8U & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding))) {
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_1 
                = (0x0000000fffffffffULL & (VL_GTS_IQQ(36, 0ULL, vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1)
                                             ? (- vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1)
                                             : vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1));
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_2 
                = (0x0000000fffffffffULL & (VL_GTS_IQQ(36, 0ULL, vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_2)
                                             ? (- vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_2)
                                             : vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_2));
        }
        if ((2U & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding))) {
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_1 
                = (0x0000000fffffffffULL & (- vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_1));
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_2 
                = (0x0000000fffffffffULL & (- vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_2));
        }
        if ((4U & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding))) {
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_1 
                = (0x0000000fffffffffULL & (VL_GTS_IQQ(36, 0ULL, vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1)
                                             ? (- vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1)
                                             : vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1));
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_2 
                = (0x0000000fffffffffULL & (VL_GTS_IQQ(36, 0ULL, vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2)
                                             ? (- vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2)
                                             : vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2));
        }
        if ((1U & (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding))) {
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_1 
                = (0x0000000fffffffffULL & (- vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_1));
            vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_2 
                = (0x0000000fffffffffULL & (- vlSelfRef.tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_2));
        }
    }
}

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root___eval_stl(Vtb_multiply_manager_wide___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root___eval_stl\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered[0U])) {
        Vtb_multiply_manager_wide___024root___stl_sequent__TOP__0(vlSelf);
    }
}

VL_ATTR_COLD bool Vtb_multiply_manager_wide___024root___eval_phase__stl(Vtb_multiply_manager_wide___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root___eval_phase__stl\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VstlExecute;
    // Body
    Vtb_multiply_manager_wide___024root___eval_triggers_vec__stl(vlSelf);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtb_multiply_manager_wide___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
    }
#endif
    __VstlExecute = Vtb_multiply_manager_wide___024root___trigger_anySet__stl(vlSelfRef.__VstlTriggered);
    if (__VstlExecute) {
        Vtb_multiply_manager_wide___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

bool Vtb_multiply_manager_wide___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_multiply_manager_wide___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(Vtb_multiply_manager_wide___024root___trigger_anySet__act(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @(posedge tb_multiply_manager_wide.clk)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 1U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 1 is active: @(negedge tb_multiply_manager_wide.clk)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 2U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 2 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root___ctor_var_reset(Vtb_multiply_manager_wide___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root___ctor_var_reset\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->tb_multiply_manager_wide__DOT__clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12322405290025202206ull);
    vlSelf->tb_multiply_manager_wide__DOT__rst = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 8846766618201741225ull);
    vlSelf->tb_multiply_manager_wide__DOT__kill = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 17923359363074997101ull);
    vlSelf->tb_multiply_manager_wide__DOT__received = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 9859239034650184017ull);
    vlSelf->tb_multiply_manager_wide__DOT__start_left = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 6916899996635801504ull);
    vlSelf->tb_multiply_manager_wide__DOT__start_right = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 11967135177994564745ull);
    vlSelf->tb_multiply_manager_wide__DOT__start_wide = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 730078425628686423ull);
    vlSelf->tb_multiply_manager_wide__DOT__julia_type = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 637014805229320649ull);
    vlSelf->tb_multiply_manager_wide__DOT__magnitude_negation_encoding = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 12508247068506760436ull);
    vlSelf->tb_multiply_manager_wide__DOT__max_iteration = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 5242380762614854018ull);
    vlSelf->tb_multiply_manager_wide__DOT__julia_c_x = VL_SCOPED_RAND_RESET_I(18, __VscopeHash, 933336201749930949ull);
    vlSelf->tb_multiply_manager_wide__DOT__julia_c_y = VL_SCOPED_RAND_RESET_I(18, __VscopeHash, 17720228246907553682ull);
    vlSelf->tb_multiply_manager_wide__DOT__starting_x_reg_1 = VL_SCOPED_RAND_RESET_I(18, __VscopeHash, 1688845358321128426ull);
    vlSelf->tb_multiply_manager_wide__DOT__starting_x_reg_2 = VL_SCOPED_RAND_RESET_I(18, __VscopeHash, 17249910901065506285ull);
    vlSelf->tb_multiply_manager_wide__DOT__starting_y_reg_1 = VL_SCOPED_RAND_RESET_I(18, __VscopeHash, 12320324140695328001ull);
    vlSelf->tb_multiply_manager_wide__DOT__starting_y_reg_2 = VL_SCOPED_RAND_RESET_I(18, __VscopeHash, 10746338745168943821ull);
    vlSelf->tb_multiply_manager_wide__DOT__done = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 4673615022332204545ull);
    vlSelf->tb_multiply_manager_wide__DOT__done_side = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 18226313085037270217ull);
    vlSelf->tb_multiply_manager_wide__DOT__iteration_out = VL_SCOPED_RAND_RESET_I(16, __VscopeHash, 7108808361881823087ull);
    for (int __Vi0 = 0; __Vi0 < 256; ++__Vi0) {
        vlSelf->tb_multiply_manager_wide__DOT__expected_count[__Vi0] = 0;
    }
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1 = VL_SCOPED_RAND_RESET_Q(36, __VscopeHash, 17393317835805519976ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_2 = VL_SCOPED_RAND_RESET_Q(36, __VscopeHash, 3131998521918413261ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1 = VL_SCOPED_RAND_RESET_Q(36, __VscopeHash, 2171415581263475401ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2 = VL_SCOPED_RAND_RESET_Q(36, __VscopeHash, 15954010379248077751ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__wide_partial_1 = VL_SCOPED_RAND_RESET_Q(36, __VscopeHash, 12332441206653148105ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__wide_partial_2 = VL_SCOPED_RAND_RESET_Q(36, __VscopeHash, 14386975572238367690ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1_overflow_flag = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 8388873599183767916ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1_overflow_flag = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 14057723655602822270ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__is_wide = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12748308235146855475ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__spare_x_reg_1 = VL_SCOPED_RAND_RESET_I(18, __VscopeHash, 1423805936895946453ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__spare_x_reg_2 = VL_SCOPED_RAND_RESET_I(18, __VscopeHash, 12301693739978417724ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__magnitude_reg_1 = VL_SCOPED_RAND_RESET_Q(36, __VscopeHash, 8974062557934255190ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__magnitude_reg_2 = VL_SCOPED_RAND_RESET_Q(36, __VscopeHash, 13608967900980873782ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__iteration_reg_1 = VL_SCOPED_RAND_RESET_I(16, __VscopeHash, 2391436036112318968ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__iteration_reg_2 = VL_SCOPED_RAND_RESET_I(16, __VscopeHash, 15651271192396839453ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__grouping_status = 0;
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__left_thread = 0;
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__left_cycle = 0;
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__right_thread = 0;
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__right_cycle = 0;
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__joint_cycle = 0;
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_1 = VL_SCOPED_RAND_RESET_Q(36, __VscopeHash, 3419176547672024663ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_2 = VL_SCOPED_RAND_RESET_Q(36, __VscopeHash, 3746649880645366708ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_1 = VL_SCOPED_RAND_RESET_Q(36, __VscopeHash, 15791245162782173456ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_2 = VL_SCOPED_RAND_RESET_Q(36, __VscopeHash, 13463023007456358383ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_result = VL_SCOPED_RAND_RESET_Q(36, __VscopeHash, 1756313828941345390ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_mode = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 16892096984866454632ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_result = VL_SCOPED_RAND_RESET_Q(36, __VscopeHash, 1492935557886598294ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_mode = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 975105002411650135ull);
    vlSelf->tb_multiply_manager_wide__DOT__dut__DOT__left_max_iteration_flag = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 9122055450889177277ull);
    vlSelf->__VdfgRegularize_h6e95ff9d_0_4 = 0;
    vlSelf->__VdfgRegularize_h6e95ff9d_0_5 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VstlTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggeredAcc[__Vi0] = 0;
    }
    vlSelf->__Vtrigprevexpr___TOP__tb_multiply_manager_wide__DOT__clk__0 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VnbaTriggered[__Vi0] = 0;
    }
    vlSelf->__Vi = 0;
}
