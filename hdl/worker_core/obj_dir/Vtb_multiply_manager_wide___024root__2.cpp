// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_multiply_manager_wide.h for the primary calling header

#include "Vtb_multiply_manager_wide__pch.h"

void Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(Vtb_multiply_manager_wide___024root* vlSelf, const char* __VeventDescription);
void Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(Vtb_multiply_manager_wide___024root* vlSelf, const char* __VeventDescription);

VlCoroutine Vtb_multiply_manager_wide___024root___eval_initial__TOP__Vtiming__0__2(Vtb_multiply_manager_wide___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_wide___024root___eval_initial__TOP__Vtiming__0__2\n"); );
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_49__to_wide;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_48__to_wide;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_47__to_wide;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_46__to_wide;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_45__to_wide;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_44__to_wide;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_43__to_wide;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_42__to_wide;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_41__to_wide;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_40__to_wide;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_39__to_wide;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_38__to_wide;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_37__to_wide;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_36__to_wide;
    IData/*17:0*/ tb_multiply_manager_wide__DOT____VlemCall_35__to_narrow;
    IData/*17:0*/ tb_multiply_manager_wide__DOT____VlemCall_34__to_narrow;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_33__to_wide;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_32__to_wide;
    IData/*17:0*/ tb_multiply_manager_wide__DOT____VlemCall_31__to_narrow;
    IData/*17:0*/ tb_multiply_manager_wide__DOT____VlemCall_30__to_narrow;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_29__to_wide;
    QData/*35:0*/ tb_multiply_manager_wide__DOT____VlemCall_28__to_wide;
    IData/*17:0*/ tb_multiply_manager_wide__DOT____VlemCall_27__to_narrow;
    IData/*17:0*/ tb_multiply_manager_wide__DOT____VlemCall_26__to_narrow;
    IData/*31:0*/ tb_multiply_manager_wide__DOT__unnamedblk3__DOT__i;
    tb_multiply_manager_wide__DOT__unnamedblk3__DOT__i = 0;
    IData/*31:0*/ tb_multiply_manager_wide__DOT__unnamedblk5__DOT__unnamedblk1_3__DOT____Vrepeat2;
    tb_multiply_manager_wide__DOT__unnamedblk5__DOT__unnamedblk1_3__DOT____Vrepeat2 = 0;
    IData/*31:0*/ tb_multiply_manager_wide__DOT__unnamedblk5__DOT__unnamedblk1_4__DOT____Vrepeat3;
    tb_multiply_manager_wide__DOT__unnamedblk5__DOT__unnamedblk1_4__DOT____Vrepeat3 = 0;
    IData/*31:0*/ tb_multiply_manager_wide__DOT__unnamedblk1_5__DOT____Vrepeat4;
    tb_multiply_manager_wide__DOT__unnamedblk1_5__DOT____Vrepeat4 = 0;
    IData/*31:0*/ tb_multiply_manager_wide__DOT__unnamedblk1_6__DOT____Vrepeat5;
    tb_multiply_manager_wide__DOT__unnamedblk1_6__DOT____Vrepeat5 = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_9__mask35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_9__mask35 = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_8__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_8__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_7__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_7__wide_mul = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_6__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_6__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_5__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_5__wide_mul = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_4__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_4__wide_mul = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_3__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_3__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_2__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_2__wide_hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_1__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_1__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_0__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_0__wide_hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk1__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk1__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk1__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk1__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk2__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk2__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk2__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk2__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__cx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__cx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__cy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__cy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__ax;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__ax = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__ay;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__ay = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__x2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__x2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__y2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__y2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__xy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__xy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__xy2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__xy2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__mag;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__mag = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__iter;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__iter = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__limit_bit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__limit_bit = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_abs_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_abs_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_neg_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_neg_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_abs_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_abs_y = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_neg_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_neg_y = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__763__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__763__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__763__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__763__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__764__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__764__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__764__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__764__w = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__765__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__765__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__765__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__765__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__766__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__766__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__766__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__766__w = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__770__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__770__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__770__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__770__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__770__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__770__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__772__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__772__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__772__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__772__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__772__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__772__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__775__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__775__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__775__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__775__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__775__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__775__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__776__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__776__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__776__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__776__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__776__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__776__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__778__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__778__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__778__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__778__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__778__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__778__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__779__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__779__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__779__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__779__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__779__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__779__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__780__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__780__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__780__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__780__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__780__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__780__trunc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__py_wide = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__782__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__782__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__783__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__783__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__784__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__784__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__785__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__785__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__786__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__786__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__787__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__787__cond = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__result = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__result = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__enc;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__py_wide = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__timeout_cycles;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__timeout_cycles = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__expected;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__expected = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__cyc;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__cyc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__captured;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__captured = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__Vfuncout = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__jtype;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__jtype = 0;
    CData/*3:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__enc;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__enc = 0;
    CData/*4:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__maxit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__maxit = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__jcx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__jcx = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__jcy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__jcy = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__px_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__px_wide = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__py_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__py_wide = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_9__mask35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_9__mask35 = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_8__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_8__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_7__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_7__wide_mul = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_6__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_6__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_5__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_5__wide_mul = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_4__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_4__wide_mul = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_3__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_3__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_2__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_2__wide_hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_1__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_1__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_0__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_0__wide_hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk1__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk1__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk1__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk1__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk2__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk2__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk2__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk2__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__cx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__cx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__cy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__cy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__ax;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__ax = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__ay;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__ay = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__x2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__x2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__y2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__y2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__xy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__xy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__xy2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__xy2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__mag;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__mag = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__iter;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__iter = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__limit_bit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__limit_bit = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_abs_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_abs_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_neg_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_neg_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_abs_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_abs_y = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_neg_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_neg_y = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__792__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__792__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__792__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__792__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__793__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__793__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__793__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__793__w = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__794__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__794__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__794__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__794__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__795__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__795__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__795__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__795__w = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__799__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__799__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__799__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__799__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__799__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__799__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__801__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__801__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__801__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__801__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__801__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__801__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__804__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__804__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__804__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__804__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__804__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__804__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__805__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__805__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__805__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__805__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__805__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__805__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__807__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__807__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__807__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__807__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__807__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__807__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__808__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__808__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__808__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__808__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__808__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__808__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__809__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__809__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__809__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__809__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__809__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__809__trunc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__py_wide = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__811__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__811__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__812__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__812__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__813__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__813__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__814__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__814__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__815__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__815__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__816__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__816__cond = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__817__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__817__v = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__818__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__818__v = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__result = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__result = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__enc;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__py_wide = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__timeout_cycles;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__timeout_cycles = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__expected;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__expected = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__cyc;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__cyc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__captured;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__captured = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__Vfuncout = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__jtype;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__jtype = 0;
    CData/*3:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__enc;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__enc = 0;
    CData/*4:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__maxit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__maxit = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__jcx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__jcx = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__jcy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__jcy = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__px_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__px_wide = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__py_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__py_wide = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_9__mask35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_9__mask35 = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_8__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_8__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_7__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_7__wide_mul = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_6__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_6__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_5__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_5__wide_mul = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_4__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_4__wide_mul = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_3__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_3__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_2__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_2__wide_hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_1__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_1__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_0__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_0__wide_hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk1__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk1__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk1__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk1__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk2__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk2__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk2__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk2__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__cx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__cx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__cy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__cy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__ax;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__ax = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__ay;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__ay = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__x2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__x2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__y2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__y2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__xy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__xy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__xy2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__xy2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__mag;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__mag = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__iter;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__iter = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__limit_bit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__limit_bit = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_abs_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_abs_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_neg_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_neg_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_abs_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_abs_y = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_neg_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_neg_y = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__823__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__823__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__823__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__823__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__824__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__824__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__824__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__824__w = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__825__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__825__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__825__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__825__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__826__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__826__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__826__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__826__w = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__830__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__830__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__830__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__830__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__830__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__830__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__832__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__832__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__832__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__832__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__832__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__832__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__835__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__835__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__835__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__835__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__835__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__835__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__836__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__836__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__836__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__836__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__836__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__836__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__838__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__838__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__838__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__838__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__838__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__838__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__839__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__839__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__839__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__839__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__839__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__839__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__840__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__840__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__840__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__840__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__840__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__840__trunc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__py_wide = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__842__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__842__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__843__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__843__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__844__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__844__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__845__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__845__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__846__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__846__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__847__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__847__cond = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__848__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__848__v = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__849__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__849__v = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__result = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__result = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__enc;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__py_wide = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__timeout_cycles;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__timeout_cycles = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__expected;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__expected = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__cyc;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__cyc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__captured;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__captured = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__Vfuncout = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__jtype;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__jtype = 0;
    CData/*3:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__enc;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__enc = 0;
    CData/*4:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__maxit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__maxit = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__jcx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__jcx = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__jcy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__jcy = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__px_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__px_wide = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__py_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__py_wide = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_9__mask35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_9__mask35 = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_8__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_8__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_7__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_7__wide_mul = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_6__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_6__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_5__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_5__wide_mul = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_4__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_4__wide_mul = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_3__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_3__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_2__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_2__wide_hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_1__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_1__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_0__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_0__wide_hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk1__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk1__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk1__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk1__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk2__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk2__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk2__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk2__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__cx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__cx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__cy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__cy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__ax;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__ax = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__ay;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__ay = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__x2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__x2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__y2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__y2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__xy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__xy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__xy2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__xy2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__mag;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__mag = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__iter;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__iter = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__limit_bit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__limit_bit = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_abs_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_abs_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_neg_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_neg_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_abs_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_abs_y = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_neg_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_neg_y = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__854__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__854__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__854__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__854__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__855__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__855__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__855__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__855__w = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__856__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__856__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__856__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__856__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__857__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__857__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__857__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__857__w = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__861__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__861__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__861__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__861__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__861__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__861__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__863__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__863__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__863__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__863__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__863__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__863__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__866__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__866__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__866__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__866__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__866__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__866__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__867__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__867__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__867__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__867__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__867__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__867__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__869__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__869__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__869__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__869__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__869__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__869__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__870__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__870__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__870__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__870__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__870__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__870__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__871__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__871__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__871__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__871__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__871__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__871__trunc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__py_wide = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__873__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__873__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__874__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__874__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__875__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__875__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__876__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__876__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__877__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__877__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__878__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__878__cond = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__879__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__879__v = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__880__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__880__v = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__result = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__result = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__enc;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__py_wide = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__timeout_cycles;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__timeout_cycles = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__expected;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__expected = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__cyc;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__cyc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__captured;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__captured = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__Vfuncout = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__jtype;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__jtype = 0;
    CData/*3:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__enc;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__enc = 0;
    CData/*4:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__maxit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__maxit = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__jcx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__jcx = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__jcy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__jcy = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__px_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__px_wide = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__py_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__py_wide = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_9__mask35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_9__mask35 = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_8__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_8__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_7__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_7__wide_mul = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_6__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_6__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_5__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_5__wide_mul = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_4__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_4__wide_mul = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_3__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_3__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_2__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_2__wide_hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_1__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_1__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_0__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_0__wide_hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk1__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk1__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk1__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk1__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk2__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk2__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk2__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk2__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__cx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__cx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__cy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__cy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__ax;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__ax = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__ay;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__ay = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__x2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__x2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__y2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__y2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__xy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__xy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__xy2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__xy2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__mag;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__mag = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__iter;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__iter = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__limit_bit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__limit_bit = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_abs_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_abs_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_neg_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_neg_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_abs_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_abs_y = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_neg_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_neg_y = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__885__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__885__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__885__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__885__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__886__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__886__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__886__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__886__w = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__887__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__887__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__887__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__887__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__888__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__888__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__888__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__888__w = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__892__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__892__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__892__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__892__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__892__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__892__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__894__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__894__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__894__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__894__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__894__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__894__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__897__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__897__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__897__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__897__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__897__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__897__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__898__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__898__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__898__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__898__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__898__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__898__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__900__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__900__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__900__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__900__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__900__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__900__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__901__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__901__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__901__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__901__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__901__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__901__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__902__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__902__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__902__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__902__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__902__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__902__trunc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__py_wide = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__904__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__904__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__905__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__905__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__906__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__906__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__907__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__907__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__908__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__908__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__909__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__909__cond = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__result = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__result = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__enc;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__py_wide = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__timeout_cycles;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__timeout_cycles = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__expected;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__expected = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__cyc;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__cyc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__captured;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__captured = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__Vfuncout = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__jtype;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__jtype = 0;
    CData/*3:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__enc;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__enc = 0;
    CData/*4:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__maxit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__maxit = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__jcx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__jcx = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__jcy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__jcy = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__px_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__px_wide = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__py_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__py_wide = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_9__mask35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_9__mask35 = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_8__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_8__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_7__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_7__wide_mul = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_6__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_6__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_5__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_5__wide_mul = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_4__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_4__wide_mul = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_3__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_3__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_2__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_2__wide_hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_1__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_1__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_0__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_0__wide_hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk1__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk1__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk1__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk1__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk2__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk2__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk2__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk2__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__cx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__cx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__cy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__cy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__ax;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__ax = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__ay;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__ay = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__x2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__x2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__y2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__y2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__xy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__xy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__xy2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__xy2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__mag;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__mag = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__iter;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__iter = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__limit_bit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__limit_bit = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_abs_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_abs_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_neg_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_neg_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_abs_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_abs_y = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_neg_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_neg_y = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__914__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__914__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__914__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__914__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__915__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__915__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__915__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__915__w = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__916__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__916__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__916__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__916__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__917__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__917__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__917__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__917__w = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__921__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__921__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__921__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__921__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__921__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__921__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__923__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__923__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__923__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__923__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__923__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__923__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__926__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__926__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__926__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__926__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__926__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__926__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__927__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__927__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__927__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__927__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__927__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__927__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__929__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__929__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__929__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__929__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__929__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__929__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__930__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__930__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__930__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__930__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__930__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__930__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__931__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__931__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__931__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__931__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__931__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__931__trunc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__py_wide = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__933__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__933__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__934__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__934__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__935__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__935__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__936__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__936__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__937__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__937__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__938__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__938__cond = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__result = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__result = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__enc;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__py_wide = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__timeout_cycles;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__timeout_cycles = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__expected;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__expected = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__cyc;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__cyc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__captured;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__captured = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__Vfuncout = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__jtype;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__jtype = 0;
    CData/*3:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__enc;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__enc = 0;
    CData/*4:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__maxit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__maxit = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__jcx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__jcx = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__jcy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__jcy = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__px_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__px_wide = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__py_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__py_wide = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_9__mask35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_9__mask35 = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_8__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_8__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_7__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_7__wide_mul = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_6__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_6__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_5__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_5__wide_mul = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_4__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_4__wide_mul = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_3__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_3__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_2__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_2__wide_hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_1__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_1__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_0__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_0__wide_hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk1__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk1__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk1__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk1__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk2__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk2__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk2__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk2__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__cx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__cx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__cy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__cy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__ax;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__ax = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__ay;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__ay = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__x2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__x2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__y2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__y2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__xy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__xy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__xy2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__xy2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__mag;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__mag = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__iter;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__iter = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__limit_bit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__limit_bit = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_abs_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_abs_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_neg_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_neg_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_abs_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_abs_y = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_neg_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_neg_y = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__943__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__943__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__943__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__943__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__944__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__944__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__944__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__944__w = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__945__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__945__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__945__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__945__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__946__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__946__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__946__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__946__w = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__950__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__950__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__950__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__950__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__950__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__950__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__952__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__952__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__952__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__952__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__952__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__952__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__955__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__955__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__955__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__955__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__955__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__955__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__956__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__956__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__956__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__956__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__956__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__956__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__958__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__958__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__958__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__958__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__958__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__958__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__959__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__959__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__959__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__959__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__959__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__959__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__960__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__960__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__960__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__960__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__960__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__960__trunc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__py_wide = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__962__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__962__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__963__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__963__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__964__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__964__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__965__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__965__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__966__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__966__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__967__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__967__cond = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__result = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__result = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__enc;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__py_wide = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__timeout_cycles;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__timeout_cycles = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__expected;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__expected = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__cyc;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__cyc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__captured;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__captured = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__Vfuncout = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__jtype;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__jtype = 0;
    CData/*3:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__enc;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__enc = 0;
    CData/*4:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__maxit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__maxit = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__jcx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__jcx = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__jcy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__jcy = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__px_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__px_wide = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__py_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__py_wide = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_9__mask35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_9__mask35 = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_8__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_8__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_7__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_7__wide_mul = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_6__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_6__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_5__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_5__wide_mul = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_4__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_4__wide_mul = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_3__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_3__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_2__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_2__wide_hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_1__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_1__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_0__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_0__wide_hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk1__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk1__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk1__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk1__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk2__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk2__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk2__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk2__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__cx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__cx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__cy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__cy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__ax;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__ax = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__ay;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__ay = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__x2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__x2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__y2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__y2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__xy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__xy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__xy2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__xy2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__mag;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__mag = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__iter;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__iter = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__limit_bit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__limit_bit = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_abs_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_abs_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_neg_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_neg_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_abs_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_abs_y = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_neg_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_neg_y = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__972__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__972__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__972__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__972__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__973__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__973__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__973__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__973__w = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__974__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__974__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__974__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__974__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__975__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__975__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__975__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__975__w = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__979__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__979__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__979__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__979__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__979__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__979__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__981__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__981__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__981__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__981__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__981__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__981__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__984__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__984__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__984__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__984__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__984__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__984__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__985__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__985__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__985__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__985__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__985__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__985__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__987__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__987__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__987__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__987__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__987__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__987__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__988__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__988__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__988__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__988__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__988__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__988__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__989__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__989__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__989__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__989__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__989__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__989__trunc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__py_wide = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__991__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__991__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__992__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__992__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__993__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__993__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__994__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__994__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__995__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__995__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__996__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__996__cond = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__result = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__result = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__enc;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__py_wide = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__timeout_cycles;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__timeout_cycles = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__expected;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__expected = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__cyc;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__cyc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__captured;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__captured = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__Vfuncout = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__jtype;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__jtype = 0;
    CData/*3:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__enc;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__enc = 0;
    CData/*4:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__maxit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__maxit = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__jcx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__jcx = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__jcy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__jcy = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__px_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__px_wide = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__py_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__py_wide = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_9__mask35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_9__mask35 = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_8__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_8__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_7__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_7__wide_mul = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_6__wide_escaped;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_6__wide_escaped = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_5__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_5__wide_mul = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_4__wide_mul;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_4__wide_mul = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_3__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_3__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_2__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_2__wide_hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_1__wide_lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_1__wide_lo = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_0__wide_hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_0__wide_hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk1__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk1__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk1__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk1__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk2__DOT__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk2__DOT__hi = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk2__DOT__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk2__DOT__lo = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__cx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__cx = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__cy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__cy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__ax;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__ax = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__ay;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__ay = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__x2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__x2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__y2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__y2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__xy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__xy = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__xy2;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__xy2 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__mag;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__mag = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__iter;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__iter = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__limit_bit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__limit_bit = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_abs_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_abs_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_neg_x;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_neg_x = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_abs_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_abs_y = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_neg_y;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_neg_y = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1001__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1001__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1001__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1001__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1002__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1002__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1002__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1002__w = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1003__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1003__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1003__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1003__w = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1004__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1004__Vfuncout = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1004__w;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1004__w = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__v;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__v = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__do_abs;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__do_abs = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__do_neg;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__do_neg = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__t;
    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__t = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1008__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1008__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1008__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1008__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1008__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1008__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1010__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1010__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1010__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1010__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1010__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1010__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__a;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__a = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__b;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__b = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__AH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__AH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__BH;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__BH = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__AL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__AL = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__BL;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__BL = 0;
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__acc;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__acc);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__HH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__HH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__HL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__HL);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__LH;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__LH);
    VlWide<4>/*127:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__LL;
    VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__LL);
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1013__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1013__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1013__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1013__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1013__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1013__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1014__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1014__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1014__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1014__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1014__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1014__trunc = 0;
    CData/*0:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__mag_q2_33;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__mag_q2_33 = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__repacked;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__repacked = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__trunc35;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__trunc35 = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1016__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1016__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1016__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1016__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1016__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1016__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1017__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1017__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1017__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1017__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1017__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1017__trunc = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1018__Vfuncout;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1018__Vfuncout = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1018__v;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1018__v = 0;
    QData/*34:0*/ __Vfunc_tb_multiply_manager_wide__DOT__mask35__1018__trunc;
    __Vfunc_tb_multiply_manager_wide__DOT__mask35__1018__trunc = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__py_wide = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__1020__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__1020__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__1021__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__1021__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__1022__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__1022__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__1023__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__1023__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__1024__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__1024__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__1025__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__1025__cond = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__result = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__result = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__py_wide = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__1029__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__1029__cond = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__1030__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__1030__cond = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__result = 0;
    double __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__v;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__raw;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__raw = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__hi;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__hi = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__lo;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__lo = 0;
    QData/*35:0*/ __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__result = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__jtype;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__jtype = 0;
    CData/*3:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__enc = 0;
    CData/*4:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__maxit = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__jcx = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__jcy = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__px_wide = 0;
    QData/*35:0*/ __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__py_wide = 0;
    CData/*0:0*/ __Vtask_tb_multiply_manager_wide__DOT__check__1034__cond;
    __Vtask_tb_multiply_manager_wide__DOT__check__1034__cond = 0;
    VlWide<4>/*127:0*/ __Vtemp_1;
    VlWide<4>/*127:0*/ __Vtemp_2;
    VlWide<4>/*127:0*/ __Vtemp_3;
    VlWide<4>/*127:0*/ __Vtemp_4;
    VlWide<4>/*127:0*/ __Vtemp_5;
    VlWide<4>/*127:0*/ __Vtemp_6;
    VlWide<4>/*127:0*/ __Vtemp_7;
    VlWide<4>/*127:0*/ __Vtemp_8;
    VlWide<4>/*127:0*/ __Vtemp_9;
    VlWide<4>/*127:0*/ __Vtemp_10;
    VlWide<4>/*127:0*/ __Vtemp_11;
    VlWide<4>/*127:0*/ __Vtemp_12;
    VlWide<4>/*127:0*/ __Vtemp_13;
    VlWide<4>/*127:0*/ __Vtemp_14;
    VlWide<4>/*127:0*/ __Vtemp_15;
    VlWide<4>/*127:0*/ __Vtemp_16;
    VlWide<4>/*127:0*/ __Vtemp_17;
    VlWide<4>/*127:0*/ __Vtemp_18;
    VlWide<4>/*127:0*/ __Vtemp_19;
    VlWide<4>/*127:0*/ __Vtemp_20;
    VlWide<4>/*127:0*/ __Vtemp_21;
    VlWide<4>/*127:0*/ __Vtemp_22;
    VlWide<4>/*127:0*/ __Vtemp_23;
    VlWide<4>/*127:0*/ __Vtemp_24;
    VlWide<4>/*127:0*/ __Vtemp_25;
    VlWide<4>/*127:0*/ __Vtemp_26;
    VlWide<4>/*127:0*/ __Vtemp_27;
    VlWide<4>/*127:0*/ __Vtemp_28;
    VlWide<4>/*127:0*/ __Vtemp_29;
    VlWide<4>/*127:0*/ __Vtemp_30;
    VlWide<4>/*127:0*/ __Vtemp_31;
    VlWide<4>/*127:0*/ __Vtemp_32;
    VlWide<4>/*127:0*/ __Vtemp_33;
    VlWide<4>/*127:0*/ __Vtemp_34;
    VlWide<4>/*127:0*/ __Vtemp_35;
    VlWide<4>/*127:0*/ __Vtemp_36;
    VlWide<4>/*127:0*/ __Vtemp_37;
    VlWide<4>/*127:0*/ __Vtemp_38;
    VlWide<4>/*127:0*/ __Vtemp_39;
    VlWide<4>/*127:0*/ __Vtemp_40;
    VlWide<4>/*127:0*/ __Vtemp_41;
    VlWide<4>/*127:0*/ __Vtemp_42;
    VlWide<4>/*127:0*/ __Vtemp_43;
    VlWide<4>/*127:0*/ __Vtemp_44;
    VlWide<4>/*127:0*/ __Vtemp_45;
    VlWide<4>/*127:0*/ __Vtemp_46;
    VlWide<4>/*127:0*/ __Vtemp_47;
    VlWide<4>/*127:0*/ __Vtemp_48;
    VlWide<4>/*127:0*/ __Vtemp_49;
    VlWide<4>/*127:0*/ __Vtemp_50;
    VlWide<4>/*127:0*/ __Vtemp_51;
    VlWide<4>/*127:0*/ __Vtemp_52;
    VlWide<4>/*127:0*/ __Vtemp_53;
    VlWide<4>/*127:0*/ __Vtemp_54;
    VlWide<4>/*127:0*/ __Vtemp_55;
    VlWide<4>/*127:0*/ __Vtemp_56;
    VlWide<4>/*127:0*/ __Vtemp_57;
    VlWide<4>/*127:0*/ __Vtemp_58;
    VlWide<4>/*127:0*/ __Vtemp_59;
    VlWide<4>/*127:0*/ __Vtemp_60;
    VlWide<4>/*127:0*/ __Vtemp_61;
    VlWide<4>/*127:0*/ __Vtemp_62;
    VlWide<4>/*127:0*/ __Vtemp_63;
    VlWide<4>/*127:0*/ __Vtemp_64;
    VlWide<4>/*127:0*/ __Vtemp_65;
    VlWide<4>/*127:0*/ __Vtemp_66;
    VlWide<4>/*127:0*/ __Vtemp_67;
    VlWide<4>/*127:0*/ __Vtemp_68;
    VlWide<4>/*127:0*/ __Vtemp_69;
    VlWide<4>/*127:0*/ __Vtemp_70;
    VlWide<4>/*127:0*/ __Vtemp_71;
    VlWide<4>/*127:0*/ __Vtemp_72;
    VlWide<4>/*127:0*/ __Vtemp_73;
    VlWide<4>/*127:0*/ __Vtemp_74;
    VlWide<4>/*127:0*/ __Vtemp_75;
    VlWide<4>/*127:0*/ __Vtemp_76;
    VlWide<4>/*127:0*/ __Vtemp_77;
    VlWide<4>/*127:0*/ __Vtemp_78;
    VlWide<4>/*127:0*/ __Vtemp_79;
    VlWide<4>/*127:0*/ __Vtemp_80;
    VlWide<4>/*127:0*/ __Vtemp_81;
    VlWide<4>/*127:0*/ __Vtemp_82;
    VlWide<4>/*127:0*/ __Vtemp_83;
    VlWide<4>/*127:0*/ __Vtemp_84;
    VlWide<4>/*127:0*/ __Vtemp_85;
    VlWide<4>/*127:0*/ __Vtemp_86;
    VlWide<4>/*127:0*/ __Vtemp_87;
    VlWide<4>/*127:0*/ __Vtemp_88;
    VlWide<4>/*127:0*/ __Vtemp_89;
    VlWide<4>/*127:0*/ __Vtemp_90;
    VlWide<4>/*127:0*/ __Vtemp_91;
    VlWide<4>/*127:0*/ __Vtemp_92;
    VlWide<4>/*127:0*/ __Vtemp_93;
    VlWide<4>/*127:0*/ __Vtemp_94;
    VlWide<4>/*127:0*/ __Vtemp_95;
    VlWide<4>/*127:0*/ __Vtemp_96;
    VlWide<4>/*127:0*/ __Vtemp_97;
    VlWide<4>/*127:0*/ __Vtemp_98;
    VlWide<4>/*127:0*/ __Vtemp_99;
    VlWide<4>/*127:0*/ __Vtemp_100;
    VlWide<4>/*127:0*/ __Vtemp_101;
    VlWide<4>/*127:0*/ __Vtemp_102;
    VlWide<4>/*127:0*/ __Vtemp_103;
    VlWide<4>/*127:0*/ __Vtemp_104;
    VlWide<4>/*127:0*/ __Vtemp_105;
    VlWide<4>/*127:0*/ __Vtemp_106;
    VlWide<4>/*127:0*/ __Vtemp_107;
    VlWide<4>/*127:0*/ __Vtemp_108;
    VlWide<4>/*127:0*/ __Vtemp_109;
    VlWide<4>/*127:0*/ __Vtemp_110;
    VlWide<4>/*127:0*/ __Vtemp_111;
    VlWide<4>/*127:0*/ __Vtemp_112;
    VlWide<4>/*127:0*/ __Vtemp_113;
    VlWide<4>/*127:0*/ __Vtemp_114;
    VlWide<4>/*127:0*/ __Vtemp_115;
    VlWide<4>/*127:0*/ __Vtemp_116;
    VlWide<4>/*127:0*/ __Vtemp_117;
    VlWide<4>/*127:0*/ __Vtemp_118;
    VlWide<4>/*127:0*/ __Vtemp_119;
    VlWide<4>/*127:0*/ __Vtemp_120;
    VlWide<4>/*127:0*/ __Vtemp_121;
    VlWide<4>/*127:0*/ __Vtemp_122;
    VlWide<4>/*127:0*/ __Vtemp_123;
    VlWide<4>/*127:0*/ __Vtemp_124;
    VlWide<4>/*127:0*/ __Vtemp_125;
    VlWide<4>/*127:0*/ __Vtemp_126;
    VlWide<4>/*127:0*/ __Vtemp_127;
    VlWide<4>/*127:0*/ __Vtemp_128;
    VlWide<4>/*127:0*/ __Vtemp_129;
    VlWide<4>/*127:0*/ __Vtemp_130;
    VlWide<4>/*127:0*/ __Vtemp_131;
    VlWide<4>/*127:0*/ __Vtemp_132;
    VlWide<4>/*127:0*/ __Vtemp_133;
    VlWide<4>/*127:0*/ __Vtemp_134;
    VlWide<4>/*127:0*/ __Vtemp_135;
    VlWide<4>/*127:0*/ __Vtemp_136;
    VlWide<4>/*127:0*/ __Vtemp_137;
    VlWide<4>/*127:0*/ __Vtemp_138;
    VlWide<4>/*127:0*/ __Vtemp_139;
    VlWide<4>/*127:0*/ __Vtemp_140;
    VlWide<4>/*127:0*/ __Vtemp_141;
    VlWide<4>/*127:0*/ __Vtemp_142;
    VlWide<4>/*127:0*/ __Vtemp_143;
    VlWide<4>/*127:0*/ __Vtemp_144;
    VlWide<4>/*127:0*/ __Vtemp_145;
    VlWide<4>/*127:0*/ __Vtemp_146;
    VlWide<4>/*127:0*/ __Vtemp_147;
    VlWide<4>/*127:0*/ __Vtemp_148;
    VlWide<4>/*127:0*/ __Vtemp_149;
    VlWide<4>/*127:0*/ __Vtemp_150;
    VlWide<4>/*127:0*/ __Vtemp_151;
    VlWide<4>/*127:0*/ __Vtemp_152;
    VlWide<4>/*127:0*/ __Vtemp_153;
    VlWide<4>/*127:0*/ __Vtemp_154;
    VlWide<4>/*127:0*/ __Vtemp_155;
    VlWide<4>/*127:0*/ __Vtemp_156;
    VlWide<4>/*127:0*/ __Vtemp_157;
    VlWide<4>/*127:0*/ __Vtemp_158;
    VlWide<4>/*127:0*/ __Vtemp_159;
    VlWide<4>/*127:0*/ __Vtemp_160;
    VlWide<4>/*127:0*/ __Vtemp_161;
    VlWide<4>/*127:0*/ __Vtemp_162;
    VlWide<4>/*127:0*/ __Vtemp_163;
    VlWide<4>/*127:0*/ __Vtemp_164;
    VlWide<4>/*127:0*/ __Vtemp_165;
    VlWide<4>/*127:0*/ __Vtemp_166;
    VlWide<4>/*127:0*/ __Vtemp_167;
    VlWide<4>/*127:0*/ __Vtemp_168;
    VlWide<4>/*127:0*/ __Vtemp_169;
    VlWide<4>/*127:0*/ __Vtemp_170;
    VlWide<4>/*127:0*/ __Vtemp_171;
    VlWide<4>/*127:0*/ __Vtemp_172;
    VlWide<4>/*127:0*/ __Vtemp_173;
    VlWide<4>/*127:0*/ __Vtemp_174;
    VlWide<4>/*127:0*/ __Vtemp_175;
    VlWide<4>/*127:0*/ __Vtemp_176;
    VlWide<4>/*127:0*/ __Vtemp_177;
    VlWide<4>/*127:0*/ __Vtemp_178;
    VlWide<4>/*127:0*/ __Vtemp_179;
    VlWide<4>/*127:0*/ __Vtemp_180;
    VlWide<4>/*127:0*/ __Vtemp_181;
    VlWide<4>/*127:0*/ __Vtemp_182;
    VlWide<4>/*127:0*/ __Vtemp_183;
    VlWide<4>/*127:0*/ __Vtemp_184;
    VlWide<4>/*127:0*/ __Vtemp_185;
    VlWide<4>/*127:0*/ __Vtemp_186;
    VlWide<4>/*127:0*/ __Vtemp_187;
    VlWide<4>/*127:0*/ __Vtemp_188;
    VlWide<4>/*127:0*/ __Vtemp_189;
    VlWide<4>/*127:0*/ __Vtemp_190;
    VlWide<4>/*127:0*/ __Vtemp_191;
    VlWide<4>/*127:0*/ __Vtemp_192;
    VlWide<4>/*127:0*/ __Vtemp_193;
    VlWide<4>/*127:0*/ __Vtemp_194;
    VlWide<4>/*127:0*/ __Vtemp_195;
    VlWide<4>/*127:0*/ __Vtemp_196;
    VlWide<4>/*127:0*/ __Vtemp_197;
    VlWide<4>/*127:0*/ __Vtemp_198;
    VlWide<4>/*127:0*/ __Vtemp_199;
    VlWide<4>/*127:0*/ __Vtemp_200;
    VlWide<4>/*127:0*/ __Vtemp_201;
    VlWide<4>/*127:0*/ __Vtemp_202;
    VlWide<4>/*127:0*/ __Vtemp_203;
    VlWide<4>/*127:0*/ __Vtemp_204;
    VlWide<4>/*127:0*/ __Vtemp_205;
    VlWide<4>/*127:0*/ __Vtemp_206;
    VlWide<4>/*127:0*/ __Vtemp_207;
    VlWide<4>/*127:0*/ __Vtemp_208;
    VlWide<4>/*127:0*/ __Vtemp_209;
    VlWide<4>/*127:0*/ __Vtemp_210;
    VlWide<4>/*127:0*/ __Vtemp_211;
    VlWide<4>/*127:0*/ __Vtemp_212;
    VlWide<4>/*127:0*/ __Vtemp_213;
    VlWide<4>/*127:0*/ __Vtemp_214;
    VlWide<4>/*127:0*/ __Vtemp_215;
    VlWide<4>/*127:0*/ __Vtemp_216;
    VlWide<4>/*127:0*/ __Vtemp_217;
    VlWide<4>/*127:0*/ __Vtemp_218;
    VlWide<4>/*127:0*/ __Vtemp_219;
    VlWide<4>/*127:0*/ __Vtemp_220;
    VlWide<4>/*127:0*/ __Vtemp_221;
    VlWide<4>/*127:0*/ __Vtemp_222;
    VlWide<4>/*127:0*/ __Vtemp_223;
    VlWide<4>/*127:0*/ __Vtemp_224;
    VlWide<4>/*127:0*/ __Vtemp_225;
    VlWide<4>/*127:0*/ __Vtemp_226;
    VlWide<4>/*127:0*/ __Vtemp_227;
    VlWide<4>/*127:0*/ __Vtemp_228;
    VlWide<4>/*127:0*/ __Vtemp_229;
    VlWide<4>/*127:0*/ __Vtemp_230;
    VlWide<4>/*127:0*/ __Vtemp_231;
    VlWide<4>/*127:0*/ __Vtemp_232;
    VlWide<4>/*127:0*/ __Vtemp_233;
    VlWide<4>/*127:0*/ __Vtemp_234;
    VlWide<4>/*127:0*/ __Vtemp_235;
    VlWide<4>/*127:0*/ __Vtemp_236;
    VlWide<4>/*127:0*/ __Vtemp_237;
    VlWide<4>/*127:0*/ __Vtemp_238;
    VlWide<4>/*127:0*/ __Vtemp_239;
    VlWide<4>/*127:0*/ __Vtemp_240;
    VlWide<4>/*127:0*/ __Vtemp_241;
    VlWide<4>/*127:0*/ __Vtemp_242;
    VlWide<4>/*127:0*/ __Vtemp_243;
    VlWide<4>/*127:0*/ __Vtemp_244;
    VlWide<4>/*127:0*/ __Vtemp_245;
    VlWide<4>/*127:0*/ __Vtemp_246;
    VlWide<4>/*127:0*/ __Vtemp_247;
    VlWide<4>/*127:0*/ __Vtemp_248;
    VlWide<4>/*127:0*/ __Vtemp_249;
    VlWide<4>/*127:0*/ __Vtemp_250;
    VlWide<4>/*127:0*/ __Vtemp_251;
    VlWide<4>/*127:0*/ __Vtemp_252;
    VlWide<4>/*127:0*/ __Vtemp_253;
    VlWide<4>/*127:0*/ __Vtemp_254;
    VlWide<4>/*127:0*/ __Vtemp_255;
    VlWide<4>/*127:0*/ __Vtemp_256;
    VlWide<4>/*127:0*/ __Vtemp_257;
    VlWide<4>/*127:0*/ __Vtemp_258;
    VlWide<4>/*127:0*/ __Vtemp_259;
    VlWide<4>/*127:0*/ __Vtemp_260;
    VlWide<4>/*127:0*/ __Vtemp_261;
    VlWide<4>/*127:0*/ __Vtemp_262;
    VlWide<4>/*127:0*/ __Vtemp_263;
    VlWide<4>/*127:0*/ __Vtemp_264;
    VlWide<4>/*127:0*/ __Vtemp_265;
    VlWide<4>/*127:0*/ __Vtemp_266;
    VlWide<4>/*127:0*/ __Vtemp_267;
    VlWide<4>/*127:0*/ __Vtemp_268;
    VlWide<4>/*127:0*/ __Vtemp_269;
    VlWide<4>/*127:0*/ __Vtemp_270;
    VlWide<4>/*127:0*/ __Vtemp_271;
    VlWide<4>/*127:0*/ __Vtemp_272;
    VlWide<4>/*127:0*/ __Vtemp_273;
    VlWide<4>/*127:0*/ __Vtemp_274;
    VlWide<4>/*127:0*/ __Vtemp_275;
    VlWide<4>/*127:0*/ __Vtemp_276;
    VlWide<4>/*127:0*/ __Vtemp_277;
    VlWide<4>/*127:0*/ __Vtemp_278;
    VlWide<4>/*127:0*/ __Vtemp_279;
    VlWide<4>/*127:0*/ __Vtemp_280;
    VlWide<4>/*127:0*/ __Vtemp_281;
    VlWide<4>/*127:0*/ __Vtemp_282;
    VlWide<4>/*127:0*/ __Vtemp_283;
    VlWide<4>/*127:0*/ __Vtemp_284;
    VlWide<4>/*127:0*/ __Vtemp_285;
    VlWide<4>/*127:0*/ __Vtemp_286;
    VlWide<4>/*127:0*/ __Vtemp_287;
    VlWide<4>/*127:0*/ __Vtemp_288;
    VlWide<4>/*127:0*/ __Vtemp_289;
    VlWide<4>/*127:0*/ __Vtemp_290;
    VlWide<4>/*127:0*/ __Vtemp_291;
    VlWide<4>/*127:0*/ __Vtemp_292;
    VlWide<4>/*127:0*/ __Vtemp_293;
    VlWide<4>/*127:0*/ __Vtemp_294;
    VlWide<4>/*127:0*/ __Vtemp_295;
    VlWide<4>/*127:0*/ __Vtemp_296;
    VlWide<4>/*127:0*/ __Vtemp_297;
    VlWide<4>/*127:0*/ __Vtemp_298;
    VlWide<4>/*127:0*/ __Vtemp_299;
    VlWide<4>/*127:0*/ __Vtemp_300;
    VlWide<4>/*127:0*/ __Vtemp_301;
    VlWide<4>/*127:0*/ __Vtemp_302;
    VlWide<4>/*127:0*/ __Vtemp_303;
    VlWide<4>/*127:0*/ __Vtemp_304;
    VlWide<4>/*127:0*/ __Vtemp_305;
    VlWide<4>/*127:0*/ __Vtemp_306;
    VlWide<4>/*127:0*/ __Vtemp_307;
    VlWide<4>/*127:0*/ __Vtemp_308;
    VlWide<4>/*127:0*/ __Vtemp_309;
    VlWide<4>/*127:0*/ __Vtemp_310;
    VlWide<4>/*127:0*/ __Vtemp_311;
    VlWide<4>/*127:0*/ __Vtemp_312;
    VlWide<4>/*127:0*/ __Vtemp_313;
    VlWide<4>/*127:0*/ __Vtemp_314;
    VlWide<4>/*127:0*/ __Vtemp_315;
    VlWide<4>/*127:0*/ __Vtemp_316;
    VlWide<4>/*127:0*/ __Vtemp_317;
    VlWide<4>/*127:0*/ __Vtemp_318;
    VlWide<4>/*127:0*/ __Vtemp_319;
    VlWide<4>/*127:0*/ __Vtemp_320;
    VlWide<4>/*127:0*/ __Vtemp_321;
    VlWide<4>/*127:0*/ __Vtemp_322;
    VlWide<4>/*127:0*/ __Vtemp_323;
    VlWide<4>/*127:0*/ __Vtemp_324;
    VlWide<4>/*127:0*/ __Vtemp_325;
    VlWide<4>/*127:0*/ __Vtemp_326;
    VlWide<4>/*127:0*/ __Vtemp_327;
    VlWide<4>/*127:0*/ __Vtemp_328;
    VlWide<4>/*127:0*/ __Vtemp_329;
    VlWide<4>/*127:0*/ __Vtemp_330;
    VlWide<4>/*127:0*/ __Vtemp_331;
    VlWide<4>/*127:0*/ __Vtemp_332;
    VlWide<4>/*127:0*/ __Vtemp_333;
    VlWide<4>/*127:0*/ __Vtemp_334;
    VlWide<4>/*127:0*/ __Vtemp_335;
    VlWide<4>/*127:0*/ __Vtemp_336;
    VlWide<4>/*127:0*/ __Vtemp_337;
    VlWide<4>/*127:0*/ __Vtemp_338;
    VlWide<4>/*127:0*/ __Vtemp_339;
    VlWide<4>/*127:0*/ __Vtemp_340;
    VlWide<4>/*127:0*/ __Vtemp_341;
    VlWide<4>/*127:0*/ __Vtemp_342;
    VlWide<4>/*127:0*/ __Vtemp_343;
    VlWide<4>/*127:0*/ __Vtemp_344;
    VlWide<4>/*127:0*/ __Vtemp_345;
    VlWide<4>/*127:0*/ __Vtemp_346;
    VlWide<4>/*127:0*/ __Vtemp_347;
    VlWide<4>/*127:0*/ __Vtemp_348;
    VlWide<4>/*127:0*/ __Vtemp_349;
    VlWide<4>/*127:0*/ __Vtemp_350;
    VlWide<4>/*127:0*/ __Vtemp_351;
    VlWide<4>/*127:0*/ __Vtemp_352;
    VlWide<4>/*127:0*/ __Vtemp_353;
    VlWide<4>/*127:0*/ __Vtemp_354;
    VlWide<4>/*127:0*/ __Vtemp_355;
    VlWide<4>/*127:0*/ __Vtemp_356;
    VlWide<4>/*127:0*/ __Vtemp_357;
    VlWide<4>/*127:0*/ __Vtemp_358;
    VlWide<4>/*127:0*/ __Vtemp_359;
    VlWide<4>/*127:0*/ __Vtemp_360;
    VlWide<4>/*127:0*/ __Vtemp_361;
    VlWide<4>/*127:0*/ __Vtemp_362;
    VlWide<4>/*127:0*/ __Vtemp_363;
    VlWide<4>/*127:0*/ __Vtemp_364;
    VlWide<4>/*127:0*/ __Vtemp_365;
    VlWide<4>/*127:0*/ __Vtemp_366;
    VlWide<4>/*127:0*/ __Vtemp_367;
    VlWide<4>/*127:0*/ __Vtemp_368;
    VlWide<4>/*127:0*/ __Vtemp_369;
    VlWide<4>/*127:0*/ __Vtemp_370;
    VlWide<4>/*127:0*/ __Vtemp_371;
    VlWide<4>/*127:0*/ __Vtemp_372;
    VlWide<4>/*127:0*/ __Vtemp_373;
    VlWide<4>/*127:0*/ __Vtemp_374;
    VlWide<4>/*127:0*/ __Vtemp_375;
    VlWide<4>/*127:0*/ __Vtemp_376;
    VlWide<4>/*127:0*/ __Vtemp_377;
    VlWide<4>/*127:0*/ __Vtemp_378;
    // Body
    {
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__Vfuncout = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zx = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__cx = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__cy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__ax = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__ay = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__x2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__y2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__xy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__xy2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__mag = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__iter = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__limit_bit = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_abs_x = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_neg_x = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_abs_y = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_neg_y = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_abs_x 
            = (1U & ((IData)(vlSelfRef.__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__enc) 
                     >> 3U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_neg_x 
            = (1U & ((IData)(vlSelfRef.__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__enc) 
                     >> 1U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_abs_y 
            = (1U & ((IData)(vlSelfRef.__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__enc) 
                     >> 2U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_neg_y 
            = (1U & (IData)(vlSelfRef.__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__enc));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__limit_bit 
            = vlSelfRef.__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__maxit;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk1__DOT__hi = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk1__DOT__lo = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__763__w 
            = vlSelfRef.__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__763__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__763__Vfuncout 
            = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__763__w 
                                      >> 0x12U)));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_0__wide_hi 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__763__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk1__DOT__hi 
            = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_0__wide_hi);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__764__w 
            = vlSelfRef.__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__764__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__764__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__764__w));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_1__wide_lo 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__764__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk1__DOT__lo 
            = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_1__wide_lo));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zx 
            = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk1__DOT__hi, 0x00000011U) 
               | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk1__DOT__lo);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk2__DOT__hi = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk2__DOT__lo = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__765__w 
            = vlSelfRef.__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__765__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__765__Vfuncout 
            = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__765__w 
                                      >> 0x12U)));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_2__wide_hi 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__765__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk2__DOT__hi 
            = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_2__wide_hi);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__766__w 
            = vlSelfRef.__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__766__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__766__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__766__w));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_3__wide_lo 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__766__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk2__DOT__lo 
            = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_3__wide_lo));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zy 
            = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk2__DOT__hi, 0x00000011U) 
               | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__unnamedblk2__DOT__lo);
        if (vlSelfRef.__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__jtype) {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__cx 
                = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, vlSelfRef.__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__jcx), 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__cy 
                = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, vlSelfRef.__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__jcy), 0x00000011U);
        } else {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__cx 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__cy 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zx = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zy = 0ULL;
        }
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__iter = 0U;
        while (true) {
            if ((1U & (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__iter 
                       >> (0x0000001fU & __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__limit_bit)))) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__iter;
                goto __Vlabel0;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__do_neg 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_neg_x;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__do_abs 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_abs_x;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__t = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__t 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__v;
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__do_abs) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__t 
                    = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__t)
                        ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__t)
                        : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__t);
            }
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__do_neg) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__t 
                    = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__t);
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__Vfuncout 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__t;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__ax 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__767__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__do_neg 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_neg_y;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__do_abs 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__do_abs_y;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__t = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__t 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__v;
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__do_abs) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__t 
                    = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__t)
                        ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__t)
                        : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__t);
            }
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__do_neg) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__t 
                    = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__t);
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__Vfuncout 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__t;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__ay 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__768__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_1, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_2, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__HH, __Vtemp_1, __Vtemp_2);
            VL_EXTENDS_WQ(128,64, __Vtemp_3, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__HL, __Vtemp_3, __Vtemp_4);
            VL_EXTENDS_WQ(128,64, __Vtemp_5, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_6, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__LH, __Vtemp_5, __Vtemp_6);
            VL_EXTENDS_WQ(128,64, __Vtemp_7, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_8, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__LL, __Vtemp_7, __Vtemp_8);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_9, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_10, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_11, __Vtemp_9, __Vtemp_10);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_12, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_13, __Vtemp_11, __Vtemp_12);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__acc, __Vtemp_13, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_14, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__Vfuncout 
                = (((QData)((IData)(__Vtemp_14[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_14[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_4__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__769__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__770__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_4__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__770__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__770__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__770__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__770__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__770__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__770__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__x2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__770__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_15, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_16, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__HH, __Vtemp_15, __Vtemp_16);
            VL_EXTENDS_WQ(128,64, __Vtemp_17, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_18, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__HL, __Vtemp_17, __Vtemp_18);
            VL_EXTENDS_WQ(128,64, __Vtemp_19, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_20, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__LH, __Vtemp_19, __Vtemp_20);
            VL_EXTENDS_WQ(128,64, __Vtemp_21, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_22, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__LL, __Vtemp_21, __Vtemp_22);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_23, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_24, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_25, __Vtemp_23, __Vtemp_24);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_26, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_27, __Vtemp_25, __Vtemp_26);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__acc, __Vtemp_27, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_28, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__Vfuncout 
                = (((QData)((IData)(__Vtemp_28[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_28[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_5__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__771__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__772__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_5__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__772__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__772__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__772__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__772__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__772__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__772__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__y2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__772__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__mag 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__x2 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__y2);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__mag_q2_33 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__mag;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__repacked = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__trunc35 = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__trunc35 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__mag_q2_33);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__repacked 
                = (((QData)((IData)((1U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__mag_q2_33 
                                                   >> 0x23U))))) 
                    << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__trunc35);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__Vfuncout 
                = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__repacked 
                                        >> 0x22U))));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_6__wide_escaped 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__773__Vfuncout;
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_6__wide_escaped) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__iter;
                goto __Vlabel0;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_29, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_30, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__HH, __Vtemp_29, __Vtemp_30);
            VL_EXTENDS_WQ(128,64, __Vtemp_31, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__HL, __Vtemp_31, __Vtemp_32);
            VL_EXTENDS_WQ(128,64, __Vtemp_33, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_34, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__LH, __Vtemp_33, __Vtemp_34);
            VL_EXTENDS_WQ(128,64, __Vtemp_35, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_36, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__LL, __Vtemp_35, __Vtemp_36);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_37, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_38, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_39, __Vtemp_37, __Vtemp_38);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_40, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_41, __Vtemp_39, __Vtemp_40);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__acc, __Vtemp_41, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_42, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__Vfuncout 
                = (((QData)((IData)(__Vtemp_42[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_42[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_7__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__774__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__775__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_7__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__775__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__775__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__775__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__775__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__775__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__775__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__xy 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__775__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__776__v 
                = VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__xy, 1U);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__776__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__776__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__776__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__776__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__776__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__776__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__xy2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__776__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__mag_q2_33 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__mag;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__repacked = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__trunc35 = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__trunc35 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__mag_q2_33);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__repacked 
                = (((QData)((IData)((1U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__mag_q2_33 
                                                   >> 0x23U))))) 
                    << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__trunc35);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__Vfuncout 
                = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__repacked 
                                        >> 0x22U))));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_8__wide_escaped 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__777__Vfuncout;
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_8__wide_escaped) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__iter;
                goto __Vlabel0;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__778__v 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__x2 
                   - __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__y2);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__778__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__778__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__778__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__778__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__778__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__778__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_9__mask35 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__778__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zx 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762____VlefCall_9__mask35 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__cx);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zy 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__xy2 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__cy);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__779__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__779__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__779__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__779__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__779__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__779__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__779__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zx 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__779__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__780__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__780__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__780__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__780__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__780__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__780__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__780__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__zy 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__780__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__iter 
                = ((IData)(1U) + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__iter);
        }
        __Vlabel0: ;
    }
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__expected 
        = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__762__Vfuncout;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__py_wide 
        = vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__px_wide 
        = vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__jcy 
        = vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__jcx 
        = vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__maxit 
        = vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__enc 
        = vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__jtype 
        = vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_type 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__enc;
    vlSelfRef.tb_multiply_manager_wide__DOT__max_iteration 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__maxit;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_x 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__jcx;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_y 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__jcy;
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__px_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__px_wide));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__py_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__781__py_wide));
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         442);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         444);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 0U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__cyc = 0U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__captured = 0U;
    while ((1U & (~ (IData)(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__captured)))) {
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                        "@(posedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             450);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__cyc 
            = ((IData)(1U) + vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__cyc);
        if (vlSelfRef.tb_multiply_manager_wide__DOT__done) {
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__782__msg 
                = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__name, ": done_side should be 0 (wide uses left thread)"s));
            __Vtask_tb_multiply_manager_wide__DOT__check__782__cond 
                = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done_side)));
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__782__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__782__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__783__msg 
                = VL_SFORMATF_N_NX("%s: count mismatch  dut=%0d  expected=%0d",3
                                   , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__name)
                                   , '#',16,(IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out)
                                   , '#',32,vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__expected) ;
            __Vtask_tb_multiply_manager_wide__DOT__check__783__cond 
                = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                   == (0x0000ffffU & vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__expected));
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__783__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__783__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 3U;
            while (VL_LTS_III(32, 0U, vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1)) {
                Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                                "@(posedge tb_multiply_manager_wide.clk)");
                co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge tb_multiply_manager_wide.clk)", 
                                                                     "tb_multiply_manager_wide.sv", 
                                                                     460);
                vlSelfRef.__Vm_traceActivity[3U] = 1U;
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__784__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__name, ": done dropped before received"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__784__cond 
                    = vlSelfRef.tb_multiply_manager_wide__DOT__done;
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__784__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__784__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__785__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__name, ": iteration_out changed while holding"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__785__cond 
                    = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                       == (0x0000ffffU & vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__expected));
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__785__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__785__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                    = (vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                       - (IData)(1U));
            }
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__captured = 1U;
        }
        if ((vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__cyc 
             > vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__timeout_cycles)) {
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__786__msg 
                = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__name, ": TIMEOUT waiting for done"s));
            __Vtask_tb_multiply_manager_wide__DOT__check__786__cond = 0U;
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__786__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__786__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__captured = 1U;
        }
    }
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         474);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__received = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         476);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__received = 0U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                    "@(posedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         480);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__787__msg 
        = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__name, ": done did not drop after received"s));
    __Vtask_tb_multiply_manager_wide__DOT__check__787__cond 
        = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done)));
    vlSelfRef.tb_multiply_manager_wide__DOT__checks 
        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
    if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__787__cond)))))) {
        vlSelfRef.tb_multiply_manager_wide__DOT__errors 
            = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
        VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                     , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__787__msg)
                     , '#',64,VL_TIME_UNITED_Q(1000));
    }
    VL_WRITEF_NX("  [ OK ] %-40s  count=%0d  (%0d cycles)\n",3
                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__name)
                 , '#',32,vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__expected
                 , '#',32,vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__761__cyc);
    tb_multiply_manager_wide__DOT__unnamedblk3__DOT__i = 0U;
    while (VL_GTS_III(32, 8U, tb_multiply_manager_wide__DOT__unnamedblk3__DOT__i)) {
        vlSelfRef.tb_multiply_manager_wide__DOT__unnamedblk3__DOT__unnamedblk4__DOT__eps 
            = (std::numeric_limits<double>::infinity() 
               * VL_ISTOR_D_I(32, (tb_multiply_manager_wide__DOT__unnamedblk3__DOT__i 
                                   - (IData)(4U))));
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__v 
            = (-7.50000000000000000e-01 + vlSelfRef.tb_multiply_manager_wide__DOT__unnamedblk3__DOT__unnamedblk4__DOT__eps);
        vlSelf->tb_multiply_manager_wide__DOT____VlemCall_24__to_wide = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__raw = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__hi = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__lo = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__result = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__raw 
            = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 
                                                * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__v)));
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__hi 
            = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__raw, 0x00000011U)));
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__lo 
            = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__raw) 
                              - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                      VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__hi), 0x00000011U))));
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__result 
            = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__hi)) 
                << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__lo)));
        vlSelfRef.tb_multiply_manager_wide__DOT____VlemCall_24__to_wide 
            = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__788__result;
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__v 
            = (1.00000000000000006e-01 - vlSelfRef.tb_multiply_manager_wide__DOT__unnamedblk3__DOT__unnamedblk4__DOT__eps);
        vlSelf->tb_multiply_manager_wide__DOT____VlemCall_25__to_wide = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__raw = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__hi = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__lo = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__result = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__raw 
            = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 
                                                * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__v)));
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__hi 
            = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__raw, 0x00000011U)));
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__lo 
            = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__raw) 
                              - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                      VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__hi), 0x00000011U))));
        __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__result 
            = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__hi)) 
                << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__lo)));
        vlSelfRef.tb_multiply_manager_wide__DOT____VlemCall_25__to_wide 
            = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__789__result;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__timeout_cycles = 0x0007a120U;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__py_wide 
            = vlSelfRef.tb_multiply_manager_wide__DOT____VlemCall_25__to_wide;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__px_wide 
            = vlSelfRef.tb_multiply_manager_wide__DOT____VlemCall_24__to_wide;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__jcy = 0U;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__jcx = 0U;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__maxit = 8U;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__enc = 0U;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__jtype = 0U;
        vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__790__name 
            = VL_SFORMATF_N_NX("LSB jitter %0d",1, '~',32,tb_multiply_manager_wide__DOT__unnamedblk3__DOT__i) ;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__expected = 0U;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__cyc = 0U;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__captured = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__py_wide 
            = __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__px_wide 
            = __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__jcy 
            = __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__jcy;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__jcx 
            = __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__jcx;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__maxit 
            = __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__maxit;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__enc 
            = __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__enc;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__jtype 
            = __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__jtype;
        {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__Vfuncout = 0U;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zx = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zy = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__cx = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__cy = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__ax = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__ay = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__x2 = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__y2 = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__xy = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__xy2 = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__mag = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__iter = 0U;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__limit_bit = 0U;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_abs_x = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_neg_x = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_abs_y = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_neg_y = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_abs_x 
                = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__enc) 
                         >> 3U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_neg_x 
                = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__enc) 
                         >> 1U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_abs_y 
                = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__enc) 
                         >> 2U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_neg_y 
                = (1U & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__enc));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__limit_bit 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__maxit;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk1__DOT__hi = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk1__DOT__lo = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__792__w 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__px_wide;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__792__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__792__Vfuncout 
                = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__792__w 
                                          >> 0x12U)));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_0__wide_hi 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__792__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk1__DOT__hi 
                = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_0__wide_hi);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__793__w 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__px_wide;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__793__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__793__Vfuncout 
                = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__793__w));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_1__wide_lo 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__793__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk1__DOT__lo 
                = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_1__wide_lo));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zx 
                = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk1__DOT__hi, 0x00000011U) 
                   | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk1__DOT__lo);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk2__DOT__hi = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk2__DOT__lo = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__794__w 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__py_wide;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__794__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__794__Vfuncout 
                = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__794__w 
                                          >> 0x12U)));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_2__wide_hi 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__794__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk2__DOT__hi 
                = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_2__wide_hi);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__795__w 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__py_wide;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__795__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__795__Vfuncout 
                = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__795__w));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_3__wide_lo 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__795__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk2__DOT__lo 
                = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_3__wide_lo));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zy 
                = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk2__DOT__hi, 0x00000011U) 
                   | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__unnamedblk2__DOT__lo);
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__jtype) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__cx 
                    = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__jcx), 0x00000011U);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__cy 
                    = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__jcy), 0x00000011U);
            } else {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__cx 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zx;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__cy 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zy;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zx = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zy = 0ULL;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__iter = 0U;
            while (true) {
                if ((1U & (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__iter 
                           >> (0x0000001fU & __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__limit_bit)))) {
                    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__Vfuncout 
                        = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__iter;
                    goto __Vlabel1;
                }
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__do_neg 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_neg_x;
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__do_abs 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_abs_x;
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__v 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zx;
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__Vfuncout = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__t = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__t 
                    = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__v;
                if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__do_abs) {
                    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__t 
                        = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__t)
                            ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__t)
                            : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__t);
                }
                if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__do_neg) {
                    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__t 
                        = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__t);
                }
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__t;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__ax 
                    = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__796__Vfuncout;
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__do_neg 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_neg_y;
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__do_abs 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__do_abs_y;
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__v 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zy;
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__Vfuncout = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__t = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__t 
                    = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__v;
                if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__do_abs) {
                    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__t 
                        = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__t)
                            ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__t)
                            : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__t);
                }
                if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__do_neg) {
                    __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__t 
                        = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__t);
                }
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__t;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__ay 
                    = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__797__Vfuncout;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__b 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__ax;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__a 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__ax;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__Vfuncout = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__AH = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__BH = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__AL = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__BL = 0ULL;
                VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__acc);
                VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__HH);
                VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__HL);
                VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__LH);
                VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__LL);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__AH 
                    = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__a, 0x00000011U);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__AL 
                    = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__a 
                       - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__AH, 0x00000011U));
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__BH 
                    = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__b, 0x00000011U);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__BL 
                    = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__b 
                       - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__BH, 0x00000011U));
                VL_EXTENDS_WQ(128,64, __Vtemp_43, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__AH);
                VL_EXTENDS_WQ(128,64, __Vtemp_44, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__BH);
                VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__HH, __Vtemp_43, __Vtemp_44);
                VL_EXTENDS_WQ(128,64, __Vtemp_45, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__AH);
                VL_EXTENDS_WQ(128,64, __Vtemp_46, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__BL);
                VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__HL, __Vtemp_45, __Vtemp_46);
                VL_EXTENDS_WQ(128,64, __Vtemp_47, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__AL);
                VL_EXTENDS_WQ(128,64, __Vtemp_48, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__BH);
                VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__LH, __Vtemp_47, __Vtemp_48);
                VL_EXTENDS_WQ(128,64, __Vtemp_49, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__AL);
                VL_EXTENDS_WQ(128,64, __Vtemp_50, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__BL);
                VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__LL, __Vtemp_49, __Vtemp_50);
                VL_SHIFTL_WWI(128,128,32, __Vtemp_51, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__HH, 0x00000022U);
                VL_SHIFTL_WWI(128,128,32, __Vtemp_52, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__HL, 0x00000011U);
                VL_ADD_W(4, __Vtemp_53, __Vtemp_51, __Vtemp_52);
                VL_SHIFTL_WWI(128,128,32, __Vtemp_54, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__LH, 0x00000011U);
                VL_ADD_W(4, __Vtemp_55, __Vtemp_53, __Vtemp_54);
                VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__acc, __Vtemp_55, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__LL);
                VL_SHIFTRS_WWI(128,128,32, __Vtemp_56, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__acc, 0x00000022U);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__Vfuncout 
                    = (((QData)((IData)(__Vtemp_56[1U])) 
                        << 0x00000020U) | (QData)((IData)(__Vtemp_56[0U])));
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_4__wide_mul 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__798__Vfuncout;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__799__v 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_4__wide_mul;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__799__Vfuncout = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__799__trunc = 0;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__799__trunc 
                    = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__799__v);
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__799__Vfuncout 
                    = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__799__trunc);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__x2 
                    = __Vfunc_tb_multiply_manager_wide__DOT__mask35__799__Vfuncout;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__b 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__ay;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__a 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__ay;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__Vfuncout = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__AH = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__BH = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__AL = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__BL = 0ULL;
                VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__acc);
                VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__HH);
                VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__HL);
                VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__LH);
                VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__LL);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__AH 
                    = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__a, 0x00000011U);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__AL 
                    = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__a 
                       - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__AH, 0x00000011U));
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__BH 
                    = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__b, 0x00000011U);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__BL 
                    = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__b 
                       - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__BH, 0x00000011U));
                VL_EXTENDS_WQ(128,64, __Vtemp_57, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__AH);
                VL_EXTENDS_WQ(128,64, __Vtemp_58, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__BH);
                VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__HH, __Vtemp_57, __Vtemp_58);
                VL_EXTENDS_WQ(128,64, __Vtemp_59, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__AH);
                VL_EXTENDS_WQ(128,64, __Vtemp_60, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__BL);
                VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__HL, __Vtemp_59, __Vtemp_60);
                VL_EXTENDS_WQ(128,64, __Vtemp_61, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__AL);
                VL_EXTENDS_WQ(128,64, __Vtemp_62, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__BH);
                VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__LH, __Vtemp_61, __Vtemp_62);
                VL_EXTENDS_WQ(128,64, __Vtemp_63, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__AL);
                VL_EXTENDS_WQ(128,64, __Vtemp_64, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__BL);
                VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__LL, __Vtemp_63, __Vtemp_64);
                VL_SHIFTL_WWI(128,128,32, __Vtemp_65, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__HH, 0x00000022U);
                VL_SHIFTL_WWI(128,128,32, __Vtemp_66, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__HL, 0x00000011U);
                VL_ADD_W(4, __Vtemp_67, __Vtemp_65, __Vtemp_66);
                VL_SHIFTL_WWI(128,128,32, __Vtemp_68, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__LH, 0x00000011U);
                VL_ADD_W(4, __Vtemp_69, __Vtemp_67, __Vtemp_68);
                VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__acc, __Vtemp_69, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__LL);
                VL_SHIFTRS_WWI(128,128,32, __Vtemp_70, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__acc, 0x00000022U);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__Vfuncout 
                    = (((QData)((IData)(__Vtemp_70[1U])) 
                        << 0x00000020U) | (QData)((IData)(__Vtemp_70[0U])));
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_5__wide_mul 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__800__Vfuncout;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__801__v 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_5__wide_mul;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__801__Vfuncout = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__801__trunc = 0;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__801__trunc 
                    = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__801__v);
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__801__Vfuncout 
                    = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__801__trunc);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__y2 
                    = __Vfunc_tb_multiply_manager_wide__DOT__mask35__801__Vfuncout;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__mag 
                    = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__x2 
                       + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__y2);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__mag_q2_33 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__mag;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__Vfuncout = 0;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__repacked = 0;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__trunc35 = 0;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__trunc35 
                    = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__mag_q2_33);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__repacked 
                    = (((QData)((IData)((1U & (IData)(
                                                      (__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__mag_q2_33 
                                                       >> 0x23U))))) 
                        << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__trunc35);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__Vfuncout 
                    = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__repacked 
                                            >> 0x22U))));
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_6__wide_escaped 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__802__Vfuncout;
                if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_6__wide_escaped) {
                    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__Vfuncout 
                        = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__iter;
                    goto __Vlabel1;
                }
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__b 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__ay;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__a 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__ax;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__Vfuncout = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__AH = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__BH = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__AL = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__BL = 0ULL;
                VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__acc);
                VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__HH);
                VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__HL);
                VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__LH);
                VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__LL);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__AH 
                    = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__a, 0x00000011U);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__AL 
                    = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__a 
                       - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__AH, 0x00000011U));
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__BH 
                    = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__b, 0x00000011U);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__BL 
                    = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__b 
                       - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__BH, 0x00000011U));
                VL_EXTENDS_WQ(128,64, __Vtemp_71, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__AH);
                VL_EXTENDS_WQ(128,64, __Vtemp_72, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__BH);
                VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__HH, __Vtemp_71, __Vtemp_72);
                VL_EXTENDS_WQ(128,64, __Vtemp_73, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__AH);
                VL_EXTENDS_WQ(128,64, __Vtemp_74, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__BL);
                VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__HL, __Vtemp_73, __Vtemp_74);
                VL_EXTENDS_WQ(128,64, __Vtemp_75, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__AL);
                VL_EXTENDS_WQ(128,64, __Vtemp_76, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__BH);
                VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__LH, __Vtemp_75, __Vtemp_76);
                VL_EXTENDS_WQ(128,64, __Vtemp_77, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__AL);
                VL_EXTENDS_WQ(128,64, __Vtemp_78, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__BL);
                VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__LL, __Vtemp_77, __Vtemp_78);
                VL_SHIFTL_WWI(128,128,32, __Vtemp_79, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__HH, 0x00000022U);
                VL_SHIFTL_WWI(128,128,32, __Vtemp_80, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__HL, 0x00000011U);
                VL_ADD_W(4, __Vtemp_81, __Vtemp_79, __Vtemp_80);
                VL_SHIFTL_WWI(128,128,32, __Vtemp_82, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__LH, 0x00000011U);
                VL_ADD_W(4, __Vtemp_83, __Vtemp_81, __Vtemp_82);
                VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__acc, __Vtemp_83, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__LL);
                VL_SHIFTRS_WWI(128,128,32, __Vtemp_84, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__acc, 0x00000022U);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__Vfuncout 
                    = (((QData)((IData)(__Vtemp_84[1U])) 
                        << 0x00000020U) | (QData)((IData)(__Vtemp_84[0U])));
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_7__wide_mul 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__803__Vfuncout;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__804__v 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_7__wide_mul;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__804__Vfuncout = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__804__trunc = 0;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__804__trunc 
                    = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__804__v);
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__804__Vfuncout 
                    = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__804__trunc);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__xy 
                    = __Vfunc_tb_multiply_manager_wide__DOT__mask35__804__Vfuncout;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__805__v 
                    = VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__xy, 1U);
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__805__Vfuncout = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__805__trunc = 0;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__805__trunc 
                    = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__805__v);
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__805__Vfuncout 
                    = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__805__trunc);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__xy2 
                    = __Vfunc_tb_multiply_manager_wide__DOT__mask35__805__Vfuncout;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__mag_q2_33 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__mag;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__Vfuncout = 0;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__repacked = 0;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__trunc35 = 0;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__trunc35 
                    = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__mag_q2_33);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__repacked 
                    = (((QData)((IData)((1U & (IData)(
                                                      (__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__mag_q2_33 
                                                       >> 0x23U))))) 
                        << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__trunc35);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__Vfuncout 
                    = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__repacked 
                                            >> 0x22U))));
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_8__wide_escaped 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__806__Vfuncout;
                if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_8__wide_escaped) {
                    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__Vfuncout 
                        = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__iter;
                    goto __Vlabel1;
                }
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__807__v 
                    = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__x2 
                       - __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__y2);
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__807__Vfuncout = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__807__trunc = 0;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__807__trunc 
                    = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__807__v);
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__807__Vfuncout 
                    = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__807__trunc);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_9__mask35 
                    = __Vfunc_tb_multiply_manager_wide__DOT__mask35__807__Vfuncout;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zx 
                    = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791____VlefCall_9__mask35 
                       + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__cx);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zy 
                    = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__xy2 
                       + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__cy);
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__808__v 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zx;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__808__Vfuncout = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__808__trunc = 0;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__808__trunc 
                    = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__808__v);
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__808__Vfuncout 
                    = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__808__trunc);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zx 
                    = __Vfunc_tb_multiply_manager_wide__DOT__mask35__808__Vfuncout;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__809__v 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zy;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__809__Vfuncout = 0ULL;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__809__trunc = 0;
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__809__trunc 
                    = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__809__v);
                __Vfunc_tb_multiply_manager_wide__DOT__mask35__809__Vfuncout 
                    = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__809__trunc);
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__zy 
                    = __Vfunc_tb_multiply_manager_wide__DOT__mask35__809__Vfuncout;
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__iter 
                    = ((IData)(1U) + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__iter);
            }
            __Vlabel1: ;
        }
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__expected 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__791__Vfuncout;
        __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__py_wide 
            = __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__py_wide;
        __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__px_wide 
            = __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__px_wide;
        __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__jcy 
            = __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__jcy;
        __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__jcx 
            = __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__jcx;
        __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__maxit 
            = __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__maxit;
        __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__enc 
            = __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__enc;
        __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__jtype 
            = __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__jtype;
        vlSelfRef.tb_multiply_manager_wide__DOT__julia_type 
            = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__jtype;
        vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding 
            = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__enc;
        vlSelfRef.tb_multiply_manager_wide__DOT__max_iteration 
            = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__maxit;
        vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_x 
            = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__jcx;
        vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_y 
            = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__jcy;
        vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_1 
            = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__px_wide 
                                      >> 0x12U)));
        vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_2 
            = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__px_wide));
        vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_1 
            = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__py_wide 
                                      >> 0x12U)));
        vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_2 
            = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__810__py_wide));
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                        "@(negedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(negedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             442);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 1U;
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                        "@(negedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(negedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             444);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 0U;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__cyc = 0U;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__captured = 0U;
        while ((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__run_wide__790__captured)))) {
            Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                            "@(posedge tb_multiply_manager_wide.clk)");
            co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(posedge tb_multiply_manager_wide.clk)", 
                                                                 "tb_multiply_manager_wide.sv", 
                                                                 450);
            vlSelfRef.__Vm_traceActivity[3U] = 1U;
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__cyc 
                = ((IData)(1U) + __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__cyc);
            if (vlSelfRef.tb_multiply_manager_wide__DOT__done) {
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__811__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__790__name, ": done_side should be 0 (wide uses left thread)"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__811__cond 
                    = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done_side)));
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__811__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__811__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__812__msg 
                    = VL_SFORMATF_N_NX("%s: count mismatch  dut=%0d  expected=%0d",3
                                       , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__790__name)
                                       , '#',16,(IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out)
                                       , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__790__expected) ;
                __Vtask_tb_multiply_manager_wide__DOT__check__812__cond 
                    = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                       == (0x0000ffffU & __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__expected));
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__812__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__812__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 3U;
                while (VL_LTS_III(32, 0U, __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1)) {
                    Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                                "@(posedge tb_multiply_manager_wide.clk)");
                    co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                                         nullptr, 
                                                                         "@(posedge tb_multiply_manager_wide.clk)", 
                                                                         "tb_multiply_manager_wide.sv", 
                                                                         460);
                    vlSelfRef.__Vm_traceActivity[3U] = 1U;
                    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__813__msg 
                        = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__790__name, ": done dropped before received"s));
                    __Vtask_tb_multiply_manager_wide__DOT__check__813__cond 
                        = vlSelfRef.tb_multiply_manager_wide__DOT__done;
                    vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                    if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__813__cond)))))) {
                        vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                            = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                        VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                     , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__813__msg)
                                     , '#',64,VL_TIME_UNITED_Q(1000));
                    }
                    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__814__msg 
                        = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__790__name, ": iteration_out changed while holding"s));
                    __Vtask_tb_multiply_manager_wide__DOT__check__814__cond 
                        = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                           == (0x0000ffffU & __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__expected));
                    vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                    if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__814__cond)))))) {
                        vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                            = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                        VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                     , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__814__msg)
                                     , '#',64,VL_TIME_UNITED_Q(1000));
                    }
                    __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                        = (__Vtask_tb_multiply_manager_wide__DOT__run_wide__790__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                           - (IData)(1U));
                }
                __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__captured = 1U;
            }
            if ((__Vtask_tb_multiply_manager_wide__DOT__run_wide__790__cyc 
                 > __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__timeout_cycles)) {
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__815__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__790__name, ": TIMEOUT waiting for done"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__815__cond = 0U;
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__815__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__815__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                __Vtask_tb_multiply_manager_wide__DOT__run_wide__790__captured = 1U;
            }
        }
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                        "@(negedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(negedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             474);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        vlSelfRef.tb_multiply_manager_wide__DOT__received = 1U;
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                        "@(negedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(negedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             476);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        vlSelfRef.tb_multiply_manager_wide__DOT__received = 0U;
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                        "@(posedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             480);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__816__msg 
            = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__790__name, ": done did not drop after received"s));
        __Vtask_tb_multiply_manager_wide__DOT__check__816__cond 
            = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done)));
        vlSelfRef.tb_multiply_manager_wide__DOT__checks 
            = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
        if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__816__cond)))))) {
            vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
            VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                         , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__816__msg)
                         , '#',64,VL_TIME_UNITED_Q(1000));
        }
        VL_WRITEF_NX("  [ OK ] %-40s  count=%0d  (%0d cycles)\n",3
                     , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__790__name)
                     , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__790__expected
                     , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__790__cyc);
        tb_multiply_manager_wide__DOT__unnamedblk3__DOT__i 
            = ((IData)(1U) + tb_multiply_manager_wide__DOT__unnamedblk3__DOT__i);
    }
    __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__817__v = -8.00000000000000044e-01;
    tb_multiply_manager_wide__DOT____VlemCall_26__to_narrow = 0;
    tb_multiply_manager_wide__DOT____VlemCall_26__to_narrow 
        = (0x0003ffffU & VL_RTOI_I_D((6.55360000000000000e+04 
                                      * __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__817__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__818__v = 1.56000000000000000e-01;
    tb_multiply_manager_wide__DOT____VlemCall_27__to_narrow = 0;
    tb_multiply_manager_wide__DOT____VlemCall_27__to_narrow 
        = (0x0003ffffU & VL_RTOI_I_D((6.55360000000000000e+04 
                                      * __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__818__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__v = 0.0;
    tb_multiply_manager_wide__DOT____VlemCall_28__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_28__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__819__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__v = 0.0;
    tb_multiply_manager_wide__DOT____VlemCall_29__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_29__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__820__result;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__timeout_cycles = 0x0007a120U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__py_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_29__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__px_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_28__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__jcy 
        = tb_multiply_manager_wide__DOT____VlemCall_27__to_narrow;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__jcx 
        = tb_multiply_manager_wide__DOT____VlemCall_26__to_narrow;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__maxit = 6U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__enc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__jtype = 1U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__821__name = "julia c=(-0.8,0.156) z0=(0,0)"s;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__expected = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__cyc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__captured = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__py_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__py_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__px_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__px_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__jcy 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__jcy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__jcx 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__jcx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__maxit 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__maxit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__enc 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__enc;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__jtype 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__jtype;
    {
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__Vfuncout = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zx = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__cx = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__cy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__ax = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__ay = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__x2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__y2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__xy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__xy2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__mag = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__iter = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__limit_bit = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_abs_x = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_neg_x = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_abs_y = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_neg_y = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_abs_x 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__enc) 
                     >> 3U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_neg_x 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__enc) 
                     >> 1U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_abs_y 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__enc) 
                     >> 2U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_neg_y 
            = (1U & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__enc));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__limit_bit 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__maxit;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk1__DOT__hi = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk1__DOT__lo = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__823__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__823__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__823__Vfuncout 
            = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__823__w 
                                      >> 0x12U)));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_0__wide_hi 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__823__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk1__DOT__hi 
            = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_0__wide_hi);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__824__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__824__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__824__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__824__w));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_1__wide_lo 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__824__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk1__DOT__lo 
            = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_1__wide_lo));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zx 
            = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk1__DOT__hi, 0x00000011U) 
               | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk1__DOT__lo);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk2__DOT__hi = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk2__DOT__lo = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__825__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__825__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__825__Vfuncout 
            = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__825__w 
                                      >> 0x12U)));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_2__wide_hi 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__825__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk2__DOT__hi 
            = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_2__wide_hi);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__826__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__826__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__826__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__826__w));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_3__wide_lo 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__826__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk2__DOT__lo 
            = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_3__wide_lo));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zy 
            = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk2__DOT__hi, 0x00000011U) 
               | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__unnamedblk2__DOT__lo);
        if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__jtype) {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__cx 
                = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__jcx), 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__cy 
                = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__jcy), 0x00000011U);
        } else {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__cx 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__cy 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zx = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zy = 0ULL;
        }
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__iter = 0U;
        while (true) {
            if ((1U & (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__iter 
                       >> (0x0000001fU & __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__limit_bit)))) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__iter;
                goto __Vlabel2;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__do_neg 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_neg_x;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__do_abs 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_abs_x;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__t = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__t 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__v;
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__do_abs) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__t 
                    = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__t)
                        ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__t)
                        : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__t);
            }
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__do_neg) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__t 
                    = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__t);
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__Vfuncout 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__t;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__ax 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__827__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__do_neg 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_neg_y;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__do_abs 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__do_abs_y;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__t = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__t 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__v;
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__do_abs) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__t 
                    = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__t)
                        ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__t)
                        : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__t);
            }
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__do_neg) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__t 
                    = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__t);
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__Vfuncout 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__t;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__ay 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__828__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_85, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_86, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__HH, __Vtemp_85, __Vtemp_86);
            VL_EXTENDS_WQ(128,64, __Vtemp_87, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_88, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__HL, __Vtemp_87, __Vtemp_88);
            VL_EXTENDS_WQ(128,64, __Vtemp_89, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_90, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__LH, __Vtemp_89, __Vtemp_90);
            VL_EXTENDS_WQ(128,64, __Vtemp_91, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_92, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__LL, __Vtemp_91, __Vtemp_92);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_93, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_94, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_95, __Vtemp_93, __Vtemp_94);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_96, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_97, __Vtemp_95, __Vtemp_96);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__acc, __Vtemp_97, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_98, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__Vfuncout 
                = (((QData)((IData)(__Vtemp_98[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_98[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_4__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__829__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__830__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_4__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__830__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__830__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__830__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__830__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__830__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__830__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__x2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__830__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_99, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_100, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__HH, __Vtemp_99, __Vtemp_100);
            VL_EXTENDS_WQ(128,64, __Vtemp_101, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_102, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__HL, __Vtemp_101, __Vtemp_102);
            VL_EXTENDS_WQ(128,64, __Vtemp_103, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_104, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__LH, __Vtemp_103, __Vtemp_104);
            VL_EXTENDS_WQ(128,64, __Vtemp_105, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_106, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__LL, __Vtemp_105, __Vtemp_106);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_107, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_108, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_109, __Vtemp_107, __Vtemp_108);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_110, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_111, __Vtemp_109, __Vtemp_110);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__acc, __Vtemp_111, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_112, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__Vfuncout 
                = (((QData)((IData)(__Vtemp_112[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_112[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_5__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__831__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__832__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_5__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__832__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__832__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__832__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__832__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__832__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__832__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__y2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__832__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__mag 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__x2 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__y2);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__mag_q2_33 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__mag;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__repacked = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__trunc35 = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__trunc35 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__mag_q2_33);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__repacked 
                = (((QData)((IData)((1U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__mag_q2_33 
                                                   >> 0x23U))))) 
                    << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__trunc35);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__Vfuncout 
                = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__repacked 
                                        >> 0x22U))));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_6__wide_escaped 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__833__Vfuncout;
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_6__wide_escaped) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__iter;
                goto __Vlabel2;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_113, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_114, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__HH, __Vtemp_113, __Vtemp_114);
            VL_EXTENDS_WQ(128,64, __Vtemp_115, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_116, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__HL, __Vtemp_115, __Vtemp_116);
            VL_EXTENDS_WQ(128,64, __Vtemp_117, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_118, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__LH, __Vtemp_117, __Vtemp_118);
            VL_EXTENDS_WQ(128,64, __Vtemp_119, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_120, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__LL, __Vtemp_119, __Vtemp_120);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_121, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_122, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_123, __Vtemp_121, __Vtemp_122);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_124, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_125, __Vtemp_123, __Vtemp_124);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__acc, __Vtemp_125, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_126, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__Vfuncout 
                = (((QData)((IData)(__Vtemp_126[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_126[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_7__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__834__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__835__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_7__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__835__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__835__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__835__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__835__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__835__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__835__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__xy 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__835__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__836__v 
                = VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__xy, 1U);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__836__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__836__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__836__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__836__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__836__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__836__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__xy2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__836__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__mag_q2_33 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__mag;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__repacked = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__trunc35 = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__trunc35 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__mag_q2_33);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__repacked 
                = (((QData)((IData)((1U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__mag_q2_33 
                                                   >> 0x23U))))) 
                    << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__trunc35);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__Vfuncout 
                = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__repacked 
                                        >> 0x22U))));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_8__wide_escaped 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__837__Vfuncout;
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_8__wide_escaped) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__iter;
                goto __Vlabel2;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__838__v 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__x2 
                   - __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__y2);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__838__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__838__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__838__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__838__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__838__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__838__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_9__mask35 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__838__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zx 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822____VlefCall_9__mask35 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__cx);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zy 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__xy2 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__cy);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__839__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__839__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__839__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__839__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__839__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__839__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__839__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zx 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__839__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__840__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__840__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__840__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__840__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__840__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__840__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__840__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__zy 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__840__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__iter 
                = ((IData)(1U) + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__iter);
        }
        __Vlabel2: ;
    }
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__expected 
        = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__822__Vfuncout;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__py_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__px_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__jcy 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__jcx 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__maxit 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__enc 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__jtype 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_type 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__enc;
    vlSelfRef.tb_multiply_manager_wide__DOT__max_iteration 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__maxit;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_x 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__jcx;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_y 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__jcy;
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__px_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__px_wide));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__py_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__841__py_wide));
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         442);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         444);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__cyc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__captured = 0U;
    while ((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__run_wide__821__captured)))) {
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                        "@(posedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             450);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__cyc 
            = ((IData)(1U) + __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__cyc);
        if (vlSelfRef.tb_multiply_manager_wide__DOT__done) {
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__842__msg 
                = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__821__name, ": done_side should be 0 (wide uses left thread)"s));
            __Vtask_tb_multiply_manager_wide__DOT__check__842__cond 
                = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done_side)));
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__842__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__842__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__843__msg 
                = VL_SFORMATF_N_NX("%s: count mismatch  dut=%0d  expected=%0d",3
                                   , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__821__name)
                                   , '#',16,(IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out)
                                   , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__821__expected) ;
            __Vtask_tb_multiply_manager_wide__DOT__check__843__cond 
                = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                   == (0x0000ffffU & __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__expected));
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__843__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__843__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 3U;
            while (VL_LTS_III(32, 0U, __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1)) {
                Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                                "@(posedge tb_multiply_manager_wide.clk)");
                co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge tb_multiply_manager_wide.clk)", 
                                                                     "tb_multiply_manager_wide.sv", 
                                                                     460);
                vlSelfRef.__Vm_traceActivity[3U] = 1U;
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__844__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__821__name, ": done dropped before received"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__844__cond 
                    = vlSelfRef.tb_multiply_manager_wide__DOT__done;
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__844__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__844__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__845__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__821__name, ": iteration_out changed while holding"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__845__cond 
                    = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                       == (0x0000ffffU & __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__expected));
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__845__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__845__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                    = (__Vtask_tb_multiply_manager_wide__DOT__run_wide__821__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                       - (IData)(1U));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__captured = 1U;
        }
        if ((__Vtask_tb_multiply_manager_wide__DOT__run_wide__821__cyc 
             > __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__timeout_cycles)) {
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__846__msg 
                = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__821__name, ": TIMEOUT waiting for done"s));
            __Vtask_tb_multiply_manager_wide__DOT__check__846__cond = 0U;
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__846__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__846__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__821__captured = 1U;
        }
    }
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         474);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__received = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         476);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__received = 0U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                    "@(posedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         480);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__847__msg 
        = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__821__name, ": done did not drop after received"s));
    __Vtask_tb_multiply_manager_wide__DOT__check__847__cond 
        = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done)));
    vlSelfRef.tb_multiply_manager_wide__DOT__checks 
        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
    if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__847__cond)))))) {
        vlSelfRef.tb_multiply_manager_wide__DOT__errors 
            = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
        VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                     , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__847__msg)
                     , '#',64,VL_TIME_UNITED_Q(1000));
    }
    VL_WRITEF_NX("  [ OK ] %-40s  count=%0d  (%0d cycles)\n",3
                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__821__name)
                 , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__821__expected
                 , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__821__cyc);
    __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__848__v = 2.84999999999999976e-01;
    tb_multiply_manager_wide__DOT____VlemCall_30__to_narrow = 0;
    tb_multiply_manager_wide__DOT____VlemCall_30__to_narrow 
        = (0x0003ffffU & VL_RTOI_I_D((6.55360000000000000e+04 
                                      * __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__848__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__849__v = 1.00000000000000002e-02;
    tb_multiply_manager_wide__DOT____VlemCall_31__to_narrow = 0;
    tb_multiply_manager_wide__DOT____VlemCall_31__to_narrow 
        = (0x0003ffffU & VL_RTOI_I_D((6.55360000000000000e+04 
                                      * __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__849__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__v = 1.00000000000000006e-01;
    tb_multiply_manager_wide__DOT____VlemCall_32__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_32__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__850__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__v = 1.00000000000000006e-01;
    tb_multiply_manager_wide__DOT____VlemCall_33__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_33__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__851__result;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__timeout_cycles = 0x0007a120U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__py_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_33__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__px_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_32__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__jcy 
        = tb_multiply_manager_wide__DOT____VlemCall_31__to_narrow;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__jcx 
        = tb_multiply_manager_wide__DOT____VlemCall_30__to_narrow;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__maxit = 6U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__enc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__jtype = 1U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__852__name = "julia c=(0.285,0.01) z0=(0.1,0.1)"s;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__expected = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__cyc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__captured = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__py_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__py_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__px_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__px_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__jcy 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__jcy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__jcx 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__jcx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__maxit 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__maxit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__enc 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__enc;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__jtype 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__jtype;
    {
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__Vfuncout = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zx = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__cx = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__cy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__ax = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__ay = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__x2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__y2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__xy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__xy2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__mag = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__iter = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__limit_bit = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_abs_x = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_neg_x = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_abs_y = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_neg_y = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_abs_x 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__enc) 
                     >> 3U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_neg_x 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__enc) 
                     >> 1U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_abs_y 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__enc) 
                     >> 2U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_neg_y 
            = (1U & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__enc));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__limit_bit 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__maxit;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk1__DOT__hi = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk1__DOT__lo = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__854__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__854__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__854__Vfuncout 
            = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__854__w 
                                      >> 0x12U)));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_0__wide_hi 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__854__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk1__DOT__hi 
            = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_0__wide_hi);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__855__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__855__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__855__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__855__w));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_1__wide_lo 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__855__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk1__DOT__lo 
            = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_1__wide_lo));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zx 
            = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk1__DOT__hi, 0x00000011U) 
               | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk1__DOT__lo);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk2__DOT__hi = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk2__DOT__lo = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__856__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__856__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__856__Vfuncout 
            = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__856__w 
                                      >> 0x12U)));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_2__wide_hi 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__856__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk2__DOT__hi 
            = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_2__wide_hi);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__857__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__857__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__857__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__857__w));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_3__wide_lo 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__857__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk2__DOT__lo 
            = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_3__wide_lo));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zy 
            = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk2__DOT__hi, 0x00000011U) 
               | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__unnamedblk2__DOT__lo);
        if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__jtype) {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__cx 
                = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__jcx), 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__cy 
                = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__jcy), 0x00000011U);
        } else {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__cx 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__cy 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zx = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zy = 0ULL;
        }
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__iter = 0U;
        while (true) {
            if ((1U & (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__iter 
                       >> (0x0000001fU & __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__limit_bit)))) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__iter;
                goto __Vlabel3;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__do_neg 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_neg_x;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__do_abs 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_abs_x;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__t = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__t 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__v;
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__do_abs) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__t 
                    = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__t)
                        ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__t)
                        : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__t);
            }
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__do_neg) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__t 
                    = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__t);
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__Vfuncout 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__t;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__ax 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__858__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__do_neg 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_neg_y;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__do_abs 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__do_abs_y;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__t = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__t 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__v;
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__do_abs) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__t 
                    = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__t)
                        ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__t)
                        : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__t);
            }
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__do_neg) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__t 
                    = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__t);
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__Vfuncout 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__t;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__ay 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__859__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_127, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__HH, __Vtemp_127, __Vtemp_128);
            VL_EXTENDS_WQ(128,64, __Vtemp_129, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_130, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__HL, __Vtemp_129, __Vtemp_130);
            VL_EXTENDS_WQ(128,64, __Vtemp_131, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_132, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__LH, __Vtemp_131, __Vtemp_132);
            VL_EXTENDS_WQ(128,64, __Vtemp_133, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_134, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__LL, __Vtemp_133, __Vtemp_134);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_135, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_136, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_137, __Vtemp_135, __Vtemp_136);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_138, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_139, __Vtemp_137, __Vtemp_138);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__acc, __Vtemp_139, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_140, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__Vfuncout 
                = (((QData)((IData)(__Vtemp_140[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_140[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_4__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__860__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__861__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_4__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__861__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__861__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__861__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__861__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__861__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__861__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__x2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__861__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_141, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_142, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__HH, __Vtemp_141, __Vtemp_142);
            VL_EXTENDS_WQ(128,64, __Vtemp_143, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_144, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__HL, __Vtemp_143, __Vtemp_144);
            VL_EXTENDS_WQ(128,64, __Vtemp_145, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_146, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__LH, __Vtemp_145, __Vtemp_146);
            VL_EXTENDS_WQ(128,64, __Vtemp_147, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_148, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__LL, __Vtemp_147, __Vtemp_148);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_149, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_150, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_151, __Vtemp_149, __Vtemp_150);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_152, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_153, __Vtemp_151, __Vtemp_152);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__acc, __Vtemp_153, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_154, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__Vfuncout 
                = (((QData)((IData)(__Vtemp_154[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_154[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_5__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__862__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__863__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_5__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__863__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__863__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__863__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__863__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__863__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__863__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__y2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__863__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__mag 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__x2 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__y2);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__mag_q2_33 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__mag;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__repacked = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__trunc35 = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__trunc35 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__mag_q2_33);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__repacked 
                = (((QData)((IData)((1U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__mag_q2_33 
                                                   >> 0x23U))))) 
                    << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__trunc35);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__Vfuncout 
                = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__repacked 
                                        >> 0x22U))));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_6__wide_escaped 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__864__Vfuncout;
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_6__wide_escaped) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__iter;
                goto __Vlabel3;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_155, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_156, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__HH, __Vtemp_155, __Vtemp_156);
            VL_EXTENDS_WQ(128,64, __Vtemp_157, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_158, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__HL, __Vtemp_157, __Vtemp_158);
            VL_EXTENDS_WQ(128,64, __Vtemp_159, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_160, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__LH, __Vtemp_159, __Vtemp_160);
            VL_EXTENDS_WQ(128,64, __Vtemp_161, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_162, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__LL, __Vtemp_161, __Vtemp_162);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_163, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_164, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_165, __Vtemp_163, __Vtemp_164);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_166, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_167, __Vtemp_165, __Vtemp_166);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__acc, __Vtemp_167, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_168, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__Vfuncout 
                = (((QData)((IData)(__Vtemp_168[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_168[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_7__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__865__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__866__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_7__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__866__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__866__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__866__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__866__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__866__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__866__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__xy 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__866__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__867__v 
                = VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__xy, 1U);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__867__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__867__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__867__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__867__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__867__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__867__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__xy2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__867__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__mag_q2_33 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__mag;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__repacked = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__trunc35 = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__trunc35 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__mag_q2_33);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__repacked 
                = (((QData)((IData)((1U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__mag_q2_33 
                                                   >> 0x23U))))) 
                    << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__trunc35);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__Vfuncout 
                = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__repacked 
                                        >> 0x22U))));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_8__wide_escaped 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__868__Vfuncout;
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_8__wide_escaped) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__iter;
                goto __Vlabel3;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__869__v 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__x2 
                   - __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__y2);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__869__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__869__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__869__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__869__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__869__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__869__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_9__mask35 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__869__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zx 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853____VlefCall_9__mask35 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__cx);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zy 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__xy2 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__cy);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__870__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__870__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__870__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__870__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__870__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__870__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__870__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zx 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__870__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__871__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__871__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__871__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__871__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__871__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__871__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__871__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__zy 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__871__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__iter 
                = ((IData)(1U) + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__iter);
        }
        __Vlabel3: ;
    }
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__expected 
        = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__853__Vfuncout;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__py_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__px_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__jcy 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__jcx 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__maxit 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__enc 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__jtype 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_type 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__enc;
    vlSelfRef.tb_multiply_manager_wide__DOT__max_iteration 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__maxit;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_x 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__jcx;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_y 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__jcy;
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__px_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__px_wide));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__py_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__872__py_wide));
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         442);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         444);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__cyc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__captured = 0U;
    while ((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__run_wide__852__captured)))) {
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                        "@(posedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             450);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__cyc 
            = ((IData)(1U) + __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__cyc);
        if (vlSelfRef.tb_multiply_manager_wide__DOT__done) {
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__873__msg 
                = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__852__name, ": done_side should be 0 (wide uses left thread)"s));
            __Vtask_tb_multiply_manager_wide__DOT__check__873__cond 
                = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done_side)));
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__873__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__873__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__874__msg 
                = VL_SFORMATF_N_NX("%s: count mismatch  dut=%0d  expected=%0d",3
                                   , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__852__name)
                                   , '#',16,(IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out)
                                   , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__852__expected) ;
            __Vtask_tb_multiply_manager_wide__DOT__check__874__cond 
                = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                   == (0x0000ffffU & __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__expected));
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__874__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__874__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 3U;
            while (VL_LTS_III(32, 0U, __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1)) {
                Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                                "@(posedge tb_multiply_manager_wide.clk)");
                co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge tb_multiply_manager_wide.clk)", 
                                                                     "tb_multiply_manager_wide.sv", 
                                                                     460);
                vlSelfRef.__Vm_traceActivity[3U] = 1U;
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__875__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__852__name, ": done dropped before received"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__875__cond 
                    = vlSelfRef.tb_multiply_manager_wide__DOT__done;
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__875__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__875__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__876__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__852__name, ": iteration_out changed while holding"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__876__cond 
                    = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                       == (0x0000ffffU & __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__expected));
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__876__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__876__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                    = (__Vtask_tb_multiply_manager_wide__DOT__run_wide__852__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                       - (IData)(1U));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__captured = 1U;
        }
        if ((__Vtask_tb_multiply_manager_wide__DOT__run_wide__852__cyc 
             > __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__timeout_cycles)) {
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__877__msg 
                = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__852__name, ": TIMEOUT waiting for done"s));
            __Vtask_tb_multiply_manager_wide__DOT__check__877__cond = 0U;
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__877__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__877__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__852__captured = 1U;
        }
    }
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         474);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__received = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         476);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__received = 0U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                    "@(posedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         480);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__878__msg 
        = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__852__name, ": done did not drop after received"s));
    __Vtask_tb_multiply_manager_wide__DOT__check__878__cond 
        = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done)));
    vlSelfRef.tb_multiply_manager_wide__DOT__checks 
        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
    if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__878__cond)))))) {
        vlSelfRef.tb_multiply_manager_wide__DOT__errors 
            = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
        VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                     , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__878__msg)
                     , '#',64,VL_TIME_UNITED_Q(1000));
    }
    VL_WRITEF_NX("  [ OK ] %-40s  count=%0d  (%0d cycles)\n",3
                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__852__name)
                 , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__852__expected
                 , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__852__cyc);
    __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__879__v = -4.00000000000000022e-01;
    tb_multiply_manager_wide__DOT____VlemCall_34__to_narrow = 0;
    tb_multiply_manager_wide__DOT____VlemCall_34__to_narrow 
        = (0x0003ffffU & VL_RTOI_I_D((6.55360000000000000e+04 
                                      * __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__879__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__880__v = 5.99999999999999978e-01;
    tb_multiply_manager_wide__DOT____VlemCall_35__to_narrow = 0;
    tb_multiply_manager_wide__DOT____VlemCall_35__to_narrow 
        = (0x0003ffffU & VL_RTOI_I_D((6.55360000000000000e+04 
                                      * __Vfunc_tb_multiply_manager_wide__DOT__to_narrow__880__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__v = -5.00000000000000000e-01;
    tb_multiply_manager_wide__DOT____VlemCall_36__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_36__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__881__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__v = 5.00000000000000000e-01;
    tb_multiply_manager_wide__DOT____VlemCall_37__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_37__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__882__result;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__timeout_cycles = 0x0007a120U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__py_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_37__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__px_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_36__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__jcy 
        = tb_multiply_manager_wide__DOT____VlemCall_35__to_narrow;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__jcx 
        = tb_multiply_manager_wide__DOT____VlemCall_34__to_narrow;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__maxit = 6U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__enc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__jtype = 1U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__883__name = "julia c=(-0.4,0.6) z0=(-0.5,0.5)"s;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__expected = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__cyc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__captured = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__py_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__py_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__px_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__px_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__jcy 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__jcy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__jcx 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__jcx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__maxit 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__maxit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__enc 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__enc;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__jtype 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__jtype;
    {
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__Vfuncout = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zx = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__cx = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__cy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__ax = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__ay = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__x2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__y2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__xy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__xy2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__mag = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__iter = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__limit_bit = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_abs_x = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_neg_x = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_abs_y = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_neg_y = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_abs_x 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__enc) 
                     >> 3U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_neg_x 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__enc) 
                     >> 1U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_abs_y 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__enc) 
                     >> 2U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_neg_y 
            = (1U & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__enc));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__limit_bit 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__maxit;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk1__DOT__hi = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk1__DOT__lo = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__885__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__885__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__885__Vfuncout 
            = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__885__w 
                                      >> 0x12U)));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_0__wide_hi 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__885__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk1__DOT__hi 
            = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_0__wide_hi);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__886__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__886__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__886__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__886__w));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_1__wide_lo 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__886__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk1__DOT__lo 
            = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_1__wide_lo));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zx 
            = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk1__DOT__hi, 0x00000011U) 
               | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk1__DOT__lo);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk2__DOT__hi = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk2__DOT__lo = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__887__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__887__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__887__Vfuncout 
            = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__887__w 
                                      >> 0x12U)));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_2__wide_hi 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__887__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk2__DOT__hi 
            = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_2__wide_hi);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__888__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__888__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__888__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__888__w));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_3__wide_lo 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__888__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk2__DOT__lo 
            = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_3__wide_lo));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zy 
            = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk2__DOT__hi, 0x00000011U) 
               | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__unnamedblk2__DOT__lo);
        if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__jtype) {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__cx 
                = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__jcx), 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__cy 
                = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__jcy), 0x00000011U);
        } else {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__cx 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__cy 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zx = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zy = 0ULL;
        }
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__iter = 0U;
        while (true) {
            if ((1U & (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__iter 
                       >> (0x0000001fU & __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__limit_bit)))) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__iter;
                goto __Vlabel4;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__do_neg 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_neg_x;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__do_abs 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_abs_x;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__t = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__t 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__v;
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__do_abs) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__t 
                    = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__t)
                        ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__t)
                        : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__t);
            }
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__do_neg) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__t 
                    = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__t);
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__Vfuncout 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__t;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__ax 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__889__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__do_neg 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_neg_y;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__do_abs 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__do_abs_y;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__t = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__t 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__v;
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__do_abs) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__t 
                    = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__t)
                        ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__t)
                        : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__t);
            }
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__do_neg) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__t 
                    = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__t);
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__Vfuncout 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__t;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__ay 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__890__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_169, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_170, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__HH, __Vtemp_169, __Vtemp_170);
            VL_EXTENDS_WQ(128,64, __Vtemp_171, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_172, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__HL, __Vtemp_171, __Vtemp_172);
            VL_EXTENDS_WQ(128,64, __Vtemp_173, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_174, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__LH, __Vtemp_173, __Vtemp_174);
            VL_EXTENDS_WQ(128,64, __Vtemp_175, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_176, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__LL, __Vtemp_175, __Vtemp_176);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_177, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_178, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_179, __Vtemp_177, __Vtemp_178);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_180, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_181, __Vtemp_179, __Vtemp_180);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__acc, __Vtemp_181, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_182, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__Vfuncout 
                = (((QData)((IData)(__Vtemp_182[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_182[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_4__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__891__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__892__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_4__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__892__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__892__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__892__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__892__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__892__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__892__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__x2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__892__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_183, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_184, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__HH, __Vtemp_183, __Vtemp_184);
            VL_EXTENDS_WQ(128,64, __Vtemp_185, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_186, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__HL, __Vtemp_185, __Vtemp_186);
            VL_EXTENDS_WQ(128,64, __Vtemp_187, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_188, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__LH, __Vtemp_187, __Vtemp_188);
            VL_EXTENDS_WQ(128,64, __Vtemp_189, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_190, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__LL, __Vtemp_189, __Vtemp_190);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_191, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_192, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_193, __Vtemp_191, __Vtemp_192);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_194, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_195, __Vtemp_193, __Vtemp_194);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__acc, __Vtemp_195, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_196, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__Vfuncout 
                = (((QData)((IData)(__Vtemp_196[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_196[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_5__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__893__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__894__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_5__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__894__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__894__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__894__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__894__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__894__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__894__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__y2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__894__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__mag 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__x2 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__y2);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__mag_q2_33 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__mag;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__repacked = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__trunc35 = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__trunc35 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__mag_q2_33);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__repacked 
                = (((QData)((IData)((1U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__mag_q2_33 
                                                   >> 0x23U))))) 
                    << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__trunc35);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__Vfuncout 
                = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__repacked 
                                        >> 0x22U))));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_6__wide_escaped 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__895__Vfuncout;
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_6__wide_escaped) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__iter;
                goto __Vlabel4;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_197, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_198, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__HH, __Vtemp_197, __Vtemp_198);
            VL_EXTENDS_WQ(128,64, __Vtemp_199, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_200, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__HL, __Vtemp_199, __Vtemp_200);
            VL_EXTENDS_WQ(128,64, __Vtemp_201, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_202, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__LH, __Vtemp_201, __Vtemp_202);
            VL_EXTENDS_WQ(128,64, __Vtemp_203, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_204, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__LL, __Vtemp_203, __Vtemp_204);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_205, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_206, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_207, __Vtemp_205, __Vtemp_206);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_208, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_209, __Vtemp_207, __Vtemp_208);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__acc, __Vtemp_209, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_210, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__Vfuncout 
                = (((QData)((IData)(__Vtemp_210[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_210[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_7__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__896__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__897__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_7__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__897__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__897__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__897__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__897__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__897__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__897__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__xy 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__897__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__898__v 
                = VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__xy, 1U);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__898__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__898__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__898__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__898__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__898__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__898__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__xy2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__898__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__mag_q2_33 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__mag;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__repacked = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__trunc35 = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__trunc35 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__mag_q2_33);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__repacked 
                = (((QData)((IData)((1U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__mag_q2_33 
                                                   >> 0x23U))))) 
                    << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__trunc35);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__Vfuncout 
                = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__repacked 
                                        >> 0x22U))));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_8__wide_escaped 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__899__Vfuncout;
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_8__wide_escaped) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__iter;
                goto __Vlabel4;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__900__v 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__x2 
                   - __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__y2);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__900__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__900__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__900__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__900__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__900__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__900__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_9__mask35 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__900__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zx 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884____VlefCall_9__mask35 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__cx);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zy 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__xy2 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__cy);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__901__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__901__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__901__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__901__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__901__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__901__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__901__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zx 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__901__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__902__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__902__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__902__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__902__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__902__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__902__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__902__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__zy 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__902__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__iter 
                = ((IData)(1U) + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__iter);
        }
        __Vlabel4: ;
    }
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__expected 
        = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__884__Vfuncout;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__py_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__px_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__jcy 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__jcx 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__maxit 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__enc 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__jtype 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_type 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__enc;
    vlSelfRef.tb_multiply_manager_wide__DOT__max_iteration 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__maxit;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_x 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__jcx;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_y 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__jcy;
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__px_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__px_wide));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__py_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__903__py_wide));
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         442);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         444);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__cyc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__captured = 0U;
    while ((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__run_wide__883__captured)))) {
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                        "@(posedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             450);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__cyc 
            = ((IData)(1U) + __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__cyc);
        if (vlSelfRef.tb_multiply_manager_wide__DOT__done) {
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__904__msg 
                = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__883__name, ": done_side should be 0 (wide uses left thread)"s));
            __Vtask_tb_multiply_manager_wide__DOT__check__904__cond 
                = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done_side)));
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__904__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__904__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__905__msg 
                = VL_SFORMATF_N_NX("%s: count mismatch  dut=%0d  expected=%0d",3
                                   , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__883__name)
                                   , '#',16,(IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out)
                                   , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__883__expected) ;
            __Vtask_tb_multiply_manager_wide__DOT__check__905__cond 
                = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                   == (0x0000ffffU & __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__expected));
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__905__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__905__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 3U;
            while (VL_LTS_III(32, 0U, __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1)) {
                Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                                "@(posedge tb_multiply_manager_wide.clk)");
                co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge tb_multiply_manager_wide.clk)", 
                                                                     "tb_multiply_manager_wide.sv", 
                                                                     460);
                vlSelfRef.__Vm_traceActivity[3U] = 1U;
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__906__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__883__name, ": done dropped before received"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__906__cond 
                    = vlSelfRef.tb_multiply_manager_wide__DOT__done;
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__906__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__906__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__907__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__883__name, ": iteration_out changed while holding"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__907__cond 
                    = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                       == (0x0000ffffU & __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__expected));
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__907__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__907__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                    = (__Vtask_tb_multiply_manager_wide__DOT__run_wide__883__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                       - (IData)(1U));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__captured = 1U;
        }
        if ((__Vtask_tb_multiply_manager_wide__DOT__run_wide__883__cyc 
             > __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__timeout_cycles)) {
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__908__msg 
                = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__883__name, ": TIMEOUT waiting for done"s));
            __Vtask_tb_multiply_manager_wide__DOT__check__908__cond = 0U;
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__908__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__908__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__883__captured = 1U;
        }
    }
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         474);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__received = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         476);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__received = 0U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                    "@(posedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         480);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__909__msg 
        = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__883__name, ": done did not drop after received"s));
    __Vtask_tb_multiply_manager_wide__DOT__check__909__cond 
        = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done)));
    vlSelfRef.tb_multiply_manager_wide__DOT__checks 
        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
    if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__909__cond)))))) {
        vlSelfRef.tb_multiply_manager_wide__DOT__errors 
            = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
        VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                     , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__909__msg)
                     , '#',64,VL_TIME_UNITED_Q(1000));
    }
    VL_WRITEF_NX("  [ OK ] %-40s  count=%0d  (%0d cycles)\n",3
                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__883__name)
                 , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__883__expected
                 , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__883__cyc);
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__v = -1.69999999999999996e+00;
    tb_multiply_manager_wide__DOT____VlemCall_38__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_38__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__910__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__v = -1.00000000000000002e-02;
    tb_multiply_manager_wide__DOT____VlemCall_39__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_39__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__911__result;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__timeout_cycles = 0x0007a120U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__py_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_39__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__px_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_38__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__jcy = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__jcx = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__maxit = 6U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__enc = 0x0cU;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__jtype = 0U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__912__name = "burning ship c=(-1.7,-0.01)"s;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__expected = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__cyc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__captured = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__py_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__py_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__px_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__px_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__jcy 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__jcy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__jcx 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__jcx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__maxit 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__maxit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__enc 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__enc;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__jtype 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__jtype;
    {
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__Vfuncout = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zx = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__cx = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__cy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__ax = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__ay = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__x2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__y2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__xy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__xy2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__mag = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__iter = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__limit_bit = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_abs_x = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_neg_x = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_abs_y = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_neg_y = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_abs_x 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__enc) 
                     >> 3U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_neg_x 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__enc) 
                     >> 1U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_abs_y 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__enc) 
                     >> 2U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_neg_y 
            = (1U & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__enc));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__limit_bit 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__maxit;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk1__DOT__hi = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk1__DOT__lo = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__914__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__914__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__914__Vfuncout 
            = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__914__w 
                                      >> 0x12U)));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_0__wide_hi 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__914__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk1__DOT__hi 
            = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_0__wide_hi);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__915__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__915__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__915__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__915__w));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_1__wide_lo 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__915__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk1__DOT__lo 
            = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_1__wide_lo));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zx 
            = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk1__DOT__hi, 0x00000011U) 
               | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk1__DOT__lo);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk2__DOT__hi = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk2__DOT__lo = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__916__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__916__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__916__Vfuncout 
            = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__916__w 
                                      >> 0x12U)));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_2__wide_hi 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__916__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk2__DOT__hi 
            = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_2__wide_hi);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__917__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__917__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__917__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__917__w));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_3__wide_lo 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__917__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk2__DOT__lo 
            = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_3__wide_lo));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zy 
            = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk2__DOT__hi, 0x00000011U) 
               | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__unnamedblk2__DOT__lo);
        if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__jtype) {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__cx 
                = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__jcx), 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__cy 
                = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__jcy), 0x00000011U);
        } else {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__cx 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__cy 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zx = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zy = 0ULL;
        }
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__iter = 0U;
        while (true) {
            if ((1U & (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__iter 
                       >> (0x0000001fU & __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__limit_bit)))) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__iter;
                goto __Vlabel5;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__do_neg 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_neg_x;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__do_abs 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_abs_x;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__t = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__t 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__v;
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__do_abs) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__t 
                    = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__t)
                        ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__t)
                        : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__t);
            }
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__do_neg) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__t 
                    = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__t);
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__Vfuncout 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__t;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__ax 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__918__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__do_neg 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_neg_y;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__do_abs 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__do_abs_y;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__t = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__t 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__v;
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__do_abs) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__t 
                    = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__t)
                        ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__t)
                        : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__t);
            }
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__do_neg) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__t 
                    = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__t);
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__Vfuncout 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__t;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__ay 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__919__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_211, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_212, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__HH, __Vtemp_211, __Vtemp_212);
            VL_EXTENDS_WQ(128,64, __Vtemp_213, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_214, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__HL, __Vtemp_213, __Vtemp_214);
            VL_EXTENDS_WQ(128,64, __Vtemp_215, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_216, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__LH, __Vtemp_215, __Vtemp_216);
            VL_EXTENDS_WQ(128,64, __Vtemp_217, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_218, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__LL, __Vtemp_217, __Vtemp_218);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_219, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_220, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_221, __Vtemp_219, __Vtemp_220);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_222, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_223, __Vtemp_221, __Vtemp_222);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__acc, __Vtemp_223, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_224, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__Vfuncout 
                = (((QData)((IData)(__Vtemp_224[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_224[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_4__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__920__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__921__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_4__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__921__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__921__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__921__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__921__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__921__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__921__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__x2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__921__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_225, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_226, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__HH, __Vtemp_225, __Vtemp_226);
            VL_EXTENDS_WQ(128,64, __Vtemp_227, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_228, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__HL, __Vtemp_227, __Vtemp_228);
            VL_EXTENDS_WQ(128,64, __Vtemp_229, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_230, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__LH, __Vtemp_229, __Vtemp_230);
            VL_EXTENDS_WQ(128,64, __Vtemp_231, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_232, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__LL, __Vtemp_231, __Vtemp_232);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_233, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_234, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_235, __Vtemp_233, __Vtemp_234);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_236, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_237, __Vtemp_235, __Vtemp_236);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__acc, __Vtemp_237, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_238, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__Vfuncout 
                = (((QData)((IData)(__Vtemp_238[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_238[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_5__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__922__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__923__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_5__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__923__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__923__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__923__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__923__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__923__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__923__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__y2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__923__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__mag 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__x2 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__y2);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__mag_q2_33 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__mag;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__repacked = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__trunc35 = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__trunc35 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__mag_q2_33);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__repacked 
                = (((QData)((IData)((1U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__mag_q2_33 
                                                   >> 0x23U))))) 
                    << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__trunc35);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__Vfuncout 
                = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__repacked 
                                        >> 0x22U))));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_6__wide_escaped 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__924__Vfuncout;
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_6__wide_escaped) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__iter;
                goto __Vlabel5;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_239, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_240, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__HH, __Vtemp_239, __Vtemp_240);
            VL_EXTENDS_WQ(128,64, __Vtemp_241, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_242, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__HL, __Vtemp_241, __Vtemp_242);
            VL_EXTENDS_WQ(128,64, __Vtemp_243, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_244, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__LH, __Vtemp_243, __Vtemp_244);
            VL_EXTENDS_WQ(128,64, __Vtemp_245, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_246, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__LL, __Vtemp_245, __Vtemp_246);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_247, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_248, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_249, __Vtemp_247, __Vtemp_248);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_250, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_251, __Vtemp_249, __Vtemp_250);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__acc, __Vtemp_251, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_252, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__Vfuncout 
                = (((QData)((IData)(__Vtemp_252[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_252[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_7__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__925__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__926__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_7__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__926__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__926__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__926__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__926__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__926__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__926__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__xy 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__926__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__927__v 
                = VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__xy, 1U);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__927__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__927__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__927__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__927__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__927__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__927__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__xy2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__927__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__mag_q2_33 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__mag;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__repacked = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__trunc35 = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__trunc35 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__mag_q2_33);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__repacked 
                = (((QData)((IData)((1U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__mag_q2_33 
                                                   >> 0x23U))))) 
                    << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__trunc35);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__Vfuncout 
                = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__repacked 
                                        >> 0x22U))));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_8__wide_escaped 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__928__Vfuncout;
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_8__wide_escaped) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__iter;
                goto __Vlabel5;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__929__v 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__x2 
                   - __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__y2);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__929__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__929__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__929__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__929__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__929__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__929__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_9__mask35 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__929__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zx 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913____VlefCall_9__mask35 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__cx);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zy 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__xy2 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__cy);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__930__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__930__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__930__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__930__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__930__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__930__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__930__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zx 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__930__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__931__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__931__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__931__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__931__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__931__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__931__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__931__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__zy 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__931__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__iter 
                = ((IData)(1U) + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__iter);
        }
        __Vlabel5: ;
    }
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__expected 
        = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__913__Vfuncout;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__py_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__px_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__jcy 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__jcx 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__maxit 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__enc 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__jtype 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_type 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__enc;
    vlSelfRef.tb_multiply_manager_wide__DOT__max_iteration 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__maxit;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_x 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__jcx;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_y 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__jcy;
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__px_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__px_wide));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__py_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__932__py_wide));
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         442);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         444);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__cyc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__captured = 0U;
    while ((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__run_wide__912__captured)))) {
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                        "@(posedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             450);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__cyc 
            = ((IData)(1U) + __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__cyc);
        if (vlSelfRef.tb_multiply_manager_wide__DOT__done) {
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__933__msg 
                = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__912__name, ": done_side should be 0 (wide uses left thread)"s));
            __Vtask_tb_multiply_manager_wide__DOT__check__933__cond 
                = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done_side)));
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__933__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__933__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__934__msg 
                = VL_SFORMATF_N_NX("%s: count mismatch  dut=%0d  expected=%0d",3
                                   , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__912__name)
                                   , '#',16,(IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out)
                                   , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__912__expected) ;
            __Vtask_tb_multiply_manager_wide__DOT__check__934__cond 
                = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                   == (0x0000ffffU & __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__expected));
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__934__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__934__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 3U;
            while (VL_LTS_III(32, 0U, __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1)) {
                Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                                "@(posedge tb_multiply_manager_wide.clk)");
                co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge tb_multiply_manager_wide.clk)", 
                                                                     "tb_multiply_manager_wide.sv", 
                                                                     460);
                vlSelfRef.__Vm_traceActivity[3U] = 1U;
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__935__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__912__name, ": done dropped before received"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__935__cond 
                    = vlSelfRef.tb_multiply_manager_wide__DOT__done;
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__935__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__935__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__936__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__912__name, ": iteration_out changed while holding"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__936__cond 
                    = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                       == (0x0000ffffU & __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__expected));
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__936__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__936__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                    = (__Vtask_tb_multiply_manager_wide__DOT__run_wide__912__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                       - (IData)(1U));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__captured = 1U;
        }
        if ((__Vtask_tb_multiply_manager_wide__DOT__run_wide__912__cyc 
             > __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__timeout_cycles)) {
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__937__msg 
                = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__912__name, ": TIMEOUT waiting for done"s));
            __Vtask_tb_multiply_manager_wide__DOT__check__937__cond = 0U;
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__937__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__937__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__912__captured = 1U;
        }
    }
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         474);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__received = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         476);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__received = 0U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                    "@(posedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         480);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__938__msg 
        = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__912__name, ": done did not drop after received"s));
    __Vtask_tb_multiply_manager_wide__DOT__check__938__cond 
        = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done)));
    vlSelfRef.tb_multiply_manager_wide__DOT__checks 
        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
    if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__938__cond)))))) {
        vlSelfRef.tb_multiply_manager_wide__DOT__errors 
            = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
        VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                     , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__938__msg)
                     , '#',64,VL_TIME_UNITED_Q(1000));
    }
    VL_WRITEF_NX("  [ OK ] %-40s  count=%0d  (%0d cycles)\n",3
                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__912__name)
                 , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__912__expected
                 , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__912__cyc);
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__v = -5.00000000000000000e-01;
    tb_multiply_manager_wide__DOT____VlemCall_40__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_40__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__939__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__v = 5.00000000000000000e-01;
    tb_multiply_manager_wide__DOT____VlemCall_41__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_41__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__940__result;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__timeout_cycles = 0x0007a120U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__py_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_41__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__px_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_40__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__jcy = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__jcx = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__maxit = 6U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__enc = 1U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__jtype = 0U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__941__name = "tricorn c=(-0.5,0.5)"s;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__expected = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__cyc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__captured = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__py_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__py_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__px_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__px_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__jcy 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__jcy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__jcx 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__jcx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__maxit 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__maxit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__enc 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__enc;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__jtype 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__jtype;
    {
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__Vfuncout = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zx = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__cx = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__cy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__ax = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__ay = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__x2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__y2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__xy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__xy2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__mag = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__iter = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__limit_bit = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_abs_x = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_neg_x = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_abs_y = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_neg_y = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_abs_x 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__enc) 
                     >> 3U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_neg_x 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__enc) 
                     >> 1U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_abs_y 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__enc) 
                     >> 2U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_neg_y 
            = (1U & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__enc));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__limit_bit 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__maxit;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk1__DOT__hi = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk1__DOT__lo = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__943__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__943__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__943__Vfuncout 
            = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__943__w 
                                      >> 0x12U)));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_0__wide_hi 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__943__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk1__DOT__hi 
            = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_0__wide_hi);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__944__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__944__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__944__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__944__w));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_1__wide_lo 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__944__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk1__DOT__lo 
            = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_1__wide_lo));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zx 
            = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk1__DOT__hi, 0x00000011U) 
               | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk1__DOT__lo);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk2__DOT__hi = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk2__DOT__lo = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__945__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__945__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__945__Vfuncout 
            = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__945__w 
                                      >> 0x12U)));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_2__wide_hi 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__945__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk2__DOT__hi 
            = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_2__wide_hi);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__946__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__946__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__946__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__946__w));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_3__wide_lo 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__946__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk2__DOT__lo 
            = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_3__wide_lo));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zy 
            = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk2__DOT__hi, 0x00000011U) 
               | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__unnamedblk2__DOT__lo);
        if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__jtype) {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__cx 
                = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__jcx), 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__cy 
                = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__jcy), 0x00000011U);
        } else {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__cx 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__cy 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zx = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zy = 0ULL;
        }
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__iter = 0U;
        while (true) {
            if ((1U & (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__iter 
                       >> (0x0000001fU & __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__limit_bit)))) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__iter;
                goto __Vlabel6;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__do_neg 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_neg_x;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__do_abs 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_abs_x;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__t = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__t 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__v;
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__do_abs) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__t 
                    = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__t)
                        ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__t)
                        : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__t);
            }
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__do_neg) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__t 
                    = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__t);
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__Vfuncout 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__t;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__ax 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__947__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__do_neg 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_neg_y;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__do_abs 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__do_abs_y;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__t = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__t 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__v;
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__do_abs) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__t 
                    = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__t)
                        ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__t)
                        : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__t);
            }
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__do_neg) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__t 
                    = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__t);
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__Vfuncout 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__t;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__ay 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__948__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_253, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_254, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__HH, __Vtemp_253, __Vtemp_254);
            VL_EXTENDS_WQ(128,64, __Vtemp_255, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_256, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__HL, __Vtemp_255, __Vtemp_256);
            VL_EXTENDS_WQ(128,64, __Vtemp_257, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_258, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__LH, __Vtemp_257, __Vtemp_258);
            VL_EXTENDS_WQ(128,64, __Vtemp_259, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_260, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__LL, __Vtemp_259, __Vtemp_260);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_261, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_262, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_263, __Vtemp_261, __Vtemp_262);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_264, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_265, __Vtemp_263, __Vtemp_264);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__acc, __Vtemp_265, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_266, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__Vfuncout 
                = (((QData)((IData)(__Vtemp_266[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_266[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_4__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__949__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__950__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_4__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__950__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__950__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__950__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__950__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__950__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__950__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__x2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__950__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_267, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_268, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__HH, __Vtemp_267, __Vtemp_268);
            VL_EXTENDS_WQ(128,64, __Vtemp_269, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_270, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__HL, __Vtemp_269, __Vtemp_270);
            VL_EXTENDS_WQ(128,64, __Vtemp_271, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_272, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__LH, __Vtemp_271, __Vtemp_272);
            VL_EXTENDS_WQ(128,64, __Vtemp_273, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_274, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__LL, __Vtemp_273, __Vtemp_274);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_275, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_276, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_277, __Vtemp_275, __Vtemp_276);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_278, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_279, __Vtemp_277, __Vtemp_278);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__acc, __Vtemp_279, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_280, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__Vfuncout 
                = (((QData)((IData)(__Vtemp_280[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_280[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_5__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__951__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__952__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_5__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__952__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__952__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__952__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__952__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__952__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__952__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__y2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__952__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__mag 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__x2 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__y2);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__mag_q2_33 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__mag;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__repacked = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__trunc35 = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__trunc35 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__mag_q2_33);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__repacked 
                = (((QData)((IData)((1U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__mag_q2_33 
                                                   >> 0x23U))))) 
                    << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__trunc35);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__Vfuncout 
                = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__repacked 
                                        >> 0x22U))));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_6__wide_escaped 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__953__Vfuncout;
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_6__wide_escaped) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__iter;
                goto __Vlabel6;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_281, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_282, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__HH, __Vtemp_281, __Vtemp_282);
            VL_EXTENDS_WQ(128,64, __Vtemp_283, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_284, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__HL, __Vtemp_283, __Vtemp_284);
            VL_EXTENDS_WQ(128,64, __Vtemp_285, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_286, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__LH, __Vtemp_285, __Vtemp_286);
            VL_EXTENDS_WQ(128,64, __Vtemp_287, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_288, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__LL, __Vtemp_287, __Vtemp_288);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_289, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_290, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_291, __Vtemp_289, __Vtemp_290);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_292, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_293, __Vtemp_291, __Vtemp_292);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__acc, __Vtemp_293, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_294, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__Vfuncout 
                = (((QData)((IData)(__Vtemp_294[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_294[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_7__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__954__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__955__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_7__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__955__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__955__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__955__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__955__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__955__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__955__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__xy 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__955__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__956__v 
                = VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__xy, 1U);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__956__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__956__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__956__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__956__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__956__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__956__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__xy2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__956__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__mag_q2_33 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__mag;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__repacked = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__trunc35 = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__trunc35 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__mag_q2_33);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__repacked 
                = (((QData)((IData)((1U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__mag_q2_33 
                                                   >> 0x23U))))) 
                    << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__trunc35);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__Vfuncout 
                = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__repacked 
                                        >> 0x22U))));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_8__wide_escaped 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__957__Vfuncout;
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_8__wide_escaped) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__iter;
                goto __Vlabel6;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__958__v 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__x2 
                   - __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__y2);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__958__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__958__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__958__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__958__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__958__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__958__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_9__mask35 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__958__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zx 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942____VlefCall_9__mask35 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__cx);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zy 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__xy2 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__cy);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__959__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__959__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__959__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__959__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__959__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__959__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__959__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zx 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__959__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__960__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__960__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__960__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__960__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__960__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__960__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__960__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__zy 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__960__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__iter 
                = ((IData)(1U) + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__iter);
        }
        __Vlabel6: ;
    }
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__expected 
        = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__942__Vfuncout;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__py_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__px_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__jcy 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__jcx 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__maxit 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__enc 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__jtype 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_type 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__enc;
    vlSelfRef.tb_multiply_manager_wide__DOT__max_iteration 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__maxit;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_x 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__jcx;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_y 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__jcy;
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__px_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__px_wide));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__py_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__961__py_wide));
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         442);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         444);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__cyc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__captured = 0U;
    while ((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__run_wide__941__captured)))) {
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                        "@(posedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             450);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__cyc 
            = ((IData)(1U) + __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__cyc);
        if (vlSelfRef.tb_multiply_manager_wide__DOT__done) {
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__962__msg 
                = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__941__name, ": done_side should be 0 (wide uses left thread)"s));
            __Vtask_tb_multiply_manager_wide__DOT__check__962__cond 
                = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done_side)));
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__962__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__962__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__963__msg 
                = VL_SFORMATF_N_NX("%s: count mismatch  dut=%0d  expected=%0d",3
                                   , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__941__name)
                                   , '#',16,(IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out)
                                   , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__941__expected) ;
            __Vtask_tb_multiply_manager_wide__DOT__check__963__cond 
                = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                   == (0x0000ffffU & __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__expected));
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__963__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__963__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 3U;
            while (VL_LTS_III(32, 0U, __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1)) {
                Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                                "@(posedge tb_multiply_manager_wide.clk)");
                co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge tb_multiply_manager_wide.clk)", 
                                                                     "tb_multiply_manager_wide.sv", 
                                                                     460);
                vlSelfRef.__Vm_traceActivity[3U] = 1U;
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__964__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__941__name, ": done dropped before received"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__964__cond 
                    = vlSelfRef.tb_multiply_manager_wide__DOT__done;
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__964__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__964__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__965__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__941__name, ": iteration_out changed while holding"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__965__cond 
                    = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                       == (0x0000ffffU & __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__expected));
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__965__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__965__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                    = (__Vtask_tb_multiply_manager_wide__DOT__run_wide__941__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                       - (IData)(1U));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__captured = 1U;
        }
        if ((__Vtask_tb_multiply_manager_wide__DOT__run_wide__941__cyc 
             > __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__timeout_cycles)) {
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__966__msg 
                = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__941__name, ": TIMEOUT waiting for done"s));
            __Vtask_tb_multiply_manager_wide__DOT__check__966__cond = 0U;
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__966__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__966__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__941__captured = 1U;
        }
    }
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         474);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__received = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         476);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__received = 0U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                    "@(posedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         480);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__967__msg 
        = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__941__name, ": done did not drop after received"s));
    __Vtask_tb_multiply_manager_wide__DOT__check__967__cond 
        = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done)));
    vlSelfRef.tb_multiply_manager_wide__DOT__checks 
        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
    if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__967__cond)))))) {
        vlSelfRef.tb_multiply_manager_wide__DOT__errors 
            = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
        VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                     , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__967__msg)
                     , '#',64,VL_TIME_UNITED_Q(1000));
    }
    VL_WRITEF_NX("  [ OK ] %-40s  count=%0d  (%0d cycles)\n",3
                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__941__name)
                 , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__941__expected
                 , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__941__cyc);
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__v = 0.0;
    tb_multiply_manager_wide__DOT____VlemCall_42__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_42__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__968__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__v = 0.0;
    tb_multiply_manager_wide__DOT____VlemCall_43__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_43__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__969__result;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__timeout_cycles = 0x0007a120U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__py_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_43__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__px_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_42__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__jcy = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__jcx = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__maxit = 3U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__enc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__jtype = 0U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__970__name = "b2b run A  c=(0,0) max=8"s;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__expected = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__cyc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__captured = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__py_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__py_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__px_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__px_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__jcy 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__jcy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__jcx 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__jcx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__maxit 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__maxit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__enc 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__enc;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__jtype 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__jtype;
    {
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__Vfuncout = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zx = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__cx = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__cy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__ax = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__ay = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__x2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__y2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__xy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__xy2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__mag = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__iter = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__limit_bit = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_abs_x = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_neg_x = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_abs_y = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_neg_y = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_abs_x 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__enc) 
                     >> 3U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_neg_x 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__enc) 
                     >> 1U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_abs_y 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__enc) 
                     >> 2U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_neg_y 
            = (1U & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__enc));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__limit_bit 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__maxit;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk1__DOT__hi = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk1__DOT__lo = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__972__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__972__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__972__Vfuncout 
            = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__972__w 
                                      >> 0x12U)));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_0__wide_hi 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__972__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk1__DOT__hi 
            = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_0__wide_hi);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__973__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__973__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__973__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__973__w));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_1__wide_lo 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__973__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk1__DOT__lo 
            = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_1__wide_lo));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zx 
            = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk1__DOT__hi, 0x00000011U) 
               | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk1__DOT__lo);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk2__DOT__hi = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk2__DOT__lo = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__974__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__974__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__974__Vfuncout 
            = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__974__w 
                                      >> 0x12U)));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_2__wide_hi 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__974__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk2__DOT__hi 
            = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_2__wide_hi);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__975__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__975__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__975__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__975__w));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_3__wide_lo 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__975__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk2__DOT__lo 
            = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_3__wide_lo));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zy 
            = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk2__DOT__hi, 0x00000011U) 
               | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__unnamedblk2__DOT__lo);
        if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__jtype) {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__cx 
                = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__jcx), 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__cy 
                = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__jcy), 0x00000011U);
        } else {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__cx 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__cy 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zx = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zy = 0ULL;
        }
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__iter = 0U;
        while (true) {
            if ((1U & (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__iter 
                       >> (0x0000001fU & __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__limit_bit)))) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__iter;
                goto __Vlabel7;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__do_neg 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_neg_x;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__do_abs 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_abs_x;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__t = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__t 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__v;
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__do_abs) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__t 
                    = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__t)
                        ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__t)
                        : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__t);
            }
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__do_neg) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__t 
                    = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__t);
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__Vfuncout 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__t;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__ax 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__976__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__do_neg 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_neg_y;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__do_abs 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__do_abs_y;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__t = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__t 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__v;
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__do_abs) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__t 
                    = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__t)
                        ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__t)
                        : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__t);
            }
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__do_neg) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__t 
                    = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__t);
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__Vfuncout 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__t;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__ay 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__977__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_295, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_296, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__HH, __Vtemp_295, __Vtemp_296);
            VL_EXTENDS_WQ(128,64, __Vtemp_297, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_298, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__HL, __Vtemp_297, __Vtemp_298);
            VL_EXTENDS_WQ(128,64, __Vtemp_299, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_300, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__LH, __Vtemp_299, __Vtemp_300);
            VL_EXTENDS_WQ(128,64, __Vtemp_301, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_302, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__LL, __Vtemp_301, __Vtemp_302);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_303, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_304, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_305, __Vtemp_303, __Vtemp_304);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_306, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_307, __Vtemp_305, __Vtemp_306);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__acc, __Vtemp_307, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_308, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__Vfuncout 
                = (((QData)((IData)(__Vtemp_308[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_308[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_4__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__978__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__979__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_4__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__979__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__979__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__979__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__979__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__979__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__979__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__x2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__979__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_309, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_310, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__HH, __Vtemp_309, __Vtemp_310);
            VL_EXTENDS_WQ(128,64, __Vtemp_311, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_312, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__HL, __Vtemp_311, __Vtemp_312);
            VL_EXTENDS_WQ(128,64, __Vtemp_313, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_314, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__LH, __Vtemp_313, __Vtemp_314);
            VL_EXTENDS_WQ(128,64, __Vtemp_315, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_316, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__LL, __Vtemp_315, __Vtemp_316);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_317, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_318, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_319, __Vtemp_317, __Vtemp_318);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_320, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_321, __Vtemp_319, __Vtemp_320);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__acc, __Vtemp_321, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_322, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__Vfuncout 
                = (((QData)((IData)(__Vtemp_322[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_322[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_5__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__980__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__981__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_5__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__981__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__981__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__981__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__981__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__981__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__981__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__y2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__981__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__mag 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__x2 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__y2);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__mag_q2_33 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__mag;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__repacked = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__trunc35 = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__trunc35 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__mag_q2_33);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__repacked 
                = (((QData)((IData)((1U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__mag_q2_33 
                                                   >> 0x23U))))) 
                    << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__trunc35);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__Vfuncout 
                = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__repacked 
                                        >> 0x22U))));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_6__wide_escaped 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__982__Vfuncout;
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_6__wide_escaped) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__iter;
                goto __Vlabel7;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_323, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_324, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__HH, __Vtemp_323, __Vtemp_324);
            VL_EXTENDS_WQ(128,64, __Vtemp_325, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_326, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__HL, __Vtemp_325, __Vtemp_326);
            VL_EXTENDS_WQ(128,64, __Vtemp_327, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_328, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__LH, __Vtemp_327, __Vtemp_328);
            VL_EXTENDS_WQ(128,64, __Vtemp_329, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_330, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__LL, __Vtemp_329, __Vtemp_330);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_331, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_332, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_333, __Vtemp_331, __Vtemp_332);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_334, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_335, __Vtemp_333, __Vtemp_334);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__acc, __Vtemp_335, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_336, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__Vfuncout 
                = (((QData)((IData)(__Vtemp_336[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_336[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_7__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__983__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__984__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_7__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__984__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__984__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__984__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__984__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__984__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__984__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__xy 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__984__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__985__v 
                = VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__xy, 1U);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__985__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__985__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__985__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__985__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__985__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__985__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__xy2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__985__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__mag_q2_33 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__mag;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__repacked = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__trunc35 = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__trunc35 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__mag_q2_33);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__repacked 
                = (((QData)((IData)((1U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__mag_q2_33 
                                                   >> 0x23U))))) 
                    << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__trunc35);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__Vfuncout 
                = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__repacked 
                                        >> 0x22U))));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_8__wide_escaped 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__986__Vfuncout;
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_8__wide_escaped) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__iter;
                goto __Vlabel7;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__987__v 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__x2 
                   - __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__y2);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__987__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__987__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__987__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__987__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__987__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__987__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_9__mask35 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__987__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zx 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971____VlefCall_9__mask35 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__cx);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zy 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__xy2 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__cy);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__988__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__988__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__988__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__988__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__988__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__988__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__988__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zx 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__988__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__989__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__989__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__989__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__989__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__989__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__989__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__989__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__zy 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__989__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__iter 
                = ((IData)(1U) + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__iter);
        }
        __Vlabel7: ;
    }
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__expected 
        = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__971__Vfuncout;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__py_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__px_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__jcy 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__jcx 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__maxit 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__enc 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__jtype 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_type 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__enc;
    vlSelfRef.tb_multiply_manager_wide__DOT__max_iteration 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__maxit;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_x 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__jcx;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_y 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__jcy;
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__px_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__px_wide));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__py_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__990__py_wide));
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         442);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         444);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__cyc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__captured = 0U;
    while ((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__run_wide__970__captured)))) {
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                        "@(posedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             450);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__cyc 
            = ((IData)(1U) + __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__cyc);
        if (vlSelfRef.tb_multiply_manager_wide__DOT__done) {
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__991__msg 
                = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__970__name, ": done_side should be 0 (wide uses left thread)"s));
            __Vtask_tb_multiply_manager_wide__DOT__check__991__cond 
                = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done_side)));
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__991__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__991__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__992__msg 
                = VL_SFORMATF_N_NX("%s: count mismatch  dut=%0d  expected=%0d",3
                                   , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__970__name)
                                   , '#',16,(IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out)
                                   , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__970__expected) ;
            __Vtask_tb_multiply_manager_wide__DOT__check__992__cond 
                = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                   == (0x0000ffffU & __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__expected));
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__992__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__992__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 3U;
            while (VL_LTS_III(32, 0U, __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1)) {
                Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                                "@(posedge tb_multiply_manager_wide.clk)");
                co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge tb_multiply_manager_wide.clk)", 
                                                                     "tb_multiply_manager_wide.sv", 
                                                                     460);
                vlSelfRef.__Vm_traceActivity[3U] = 1U;
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__993__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__970__name, ": done dropped before received"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__993__cond 
                    = vlSelfRef.tb_multiply_manager_wide__DOT__done;
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__993__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__993__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__994__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__970__name, ": iteration_out changed while holding"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__994__cond 
                    = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                       == (0x0000ffffU & __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__expected));
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__994__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__994__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                    = (__Vtask_tb_multiply_manager_wide__DOT__run_wide__970__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                       - (IData)(1U));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__captured = 1U;
        }
        if ((__Vtask_tb_multiply_manager_wide__DOT__run_wide__970__cyc 
             > __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__timeout_cycles)) {
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__995__msg 
                = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__970__name, ": TIMEOUT waiting for done"s));
            __Vtask_tb_multiply_manager_wide__DOT__check__995__cond = 0U;
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__995__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__995__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__970__captured = 1U;
        }
    }
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         474);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__received = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         476);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__received = 0U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                    "@(posedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         480);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__996__msg 
        = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__970__name, ": done did not drop after received"s));
    __Vtask_tb_multiply_manager_wide__DOT__check__996__cond 
        = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done)));
    vlSelfRef.tb_multiply_manager_wide__DOT__checks 
        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
    if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__996__cond)))))) {
        vlSelfRef.tb_multiply_manager_wide__DOT__errors 
            = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
        VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                     , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__996__msg)
                     , '#',64,VL_TIME_UNITED_Q(1000));
    }
    VL_WRITEF_NX("  [ OK ] %-40s  count=%0d  (%0d cycles)\n",3
                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__970__name)
                 , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__970__expected
                 , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__970__cyc);
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__v = 1.80000000000000004e+00;
    tb_multiply_manager_wide__DOT____VlemCall_44__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_44__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__997__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__v = 0.0;
    tb_multiply_manager_wide__DOT____VlemCall_45__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_45__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__998__result;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__timeout_cycles = 0x0007a120U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__py_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_45__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__px_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_44__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__jcy = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__jcx = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__maxit = 6U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__enc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__jtype = 0U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__999__name = "b2b run B  c=(1.8,0) escape"s;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__expected = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__cyc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__captured = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__py_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__py_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__px_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__px_wide;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__jcy 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__jcy;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__jcx 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__jcx;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__maxit 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__maxit;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__enc 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__enc;
    __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__jtype 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__jtype;
    {
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__Vfuncout = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zx = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__cx = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__cy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__ax = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__ay = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__x2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__y2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__xy = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__xy2 = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__mag = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__iter = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__limit_bit = 0U;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_abs_x = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_neg_x = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_abs_y = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_neg_y = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_abs_x 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__enc) 
                     >> 3U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_neg_x 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__enc) 
                     >> 1U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_abs_y 
            = (1U & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__enc) 
                     >> 2U));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_neg_y 
            = (1U & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__enc));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__limit_bit 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__maxit;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk1__DOT__hi = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk1__DOT__lo = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1001__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1001__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1001__Vfuncout 
            = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1001__w 
                                      >> 0x12U)));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_0__wide_hi 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1001__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk1__DOT__hi 
            = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_0__wide_hi);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1002__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__px_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1002__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1002__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1002__w));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_1__wide_lo 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1002__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk1__DOT__lo 
            = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_1__wide_lo));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zx 
            = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk1__DOT__hi, 0x00000011U) 
               | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk1__DOT__lo);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk2__DOT__hi = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk2__DOT__lo = 0ULL;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1003__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1003__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1003__Vfuncout 
            = (0x0003ffffU & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1003__w 
                                      >> 0x12U)));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_2__wide_hi 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_hi__1003__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk2__DOT__hi 
            = VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_2__wide_hi);
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1004__w 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__py_wide;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1004__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1004__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1004__w));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_3__wide_lo 
            = __Vfunc_tb_multiply_manager_wide__DOT__wide_lo__1004__Vfuncout;
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk2__DOT__lo 
            = (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_3__wide_lo));
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zy 
            = (VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk2__DOT__hi, 0x00000011U) 
               | __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__unnamedblk2__DOT__lo);
        if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__jtype) {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__cx 
                = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__jcx), 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__cy 
                = VL_SHIFTL_QQI(64,64,32, VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__jcy), 0x00000011U);
        } else {
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__cx 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__cy 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zx = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zy = 0ULL;
        }
        __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__iter = 0U;
        while (true) {
            if ((1U & (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__iter 
                       >> (0x0000001fU & __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__limit_bit)))) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__iter;
                goto __Vlabel8;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__do_neg 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_neg_x;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__do_abs 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_abs_x;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__t = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__t 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__v;
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__do_abs) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__t 
                    = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__t)
                        ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__t)
                        : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__t);
            }
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__do_neg) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__t 
                    = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__t);
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__Vfuncout 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__t;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__ax 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1005__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__do_neg 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_neg_y;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__do_abs 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__do_abs_y;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__t = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__t 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__v;
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__do_abs) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__t 
                    = (VL_GTS_IQQ(64, 0ULL, __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__t)
                        ? (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__t)
                        : __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__t);
            }
            if (__Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__do_neg) {
                __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__t 
                    = (- __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__t);
            }
            __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__Vfuncout 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__t;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__ay 
                = __Vfunc_tb_multiply_manager_wide__DOT__alter_wide__1006__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_337, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_338, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__HH, __Vtemp_337, __Vtemp_338);
            VL_EXTENDS_WQ(128,64, __Vtemp_339, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_340, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__HL, __Vtemp_339, __Vtemp_340);
            VL_EXTENDS_WQ(128,64, __Vtemp_341, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_342, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__LH, __Vtemp_341, __Vtemp_342);
            VL_EXTENDS_WQ(128,64, __Vtemp_343, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_344, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__LL, __Vtemp_343, __Vtemp_344);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_345, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_346, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_347, __Vtemp_345, __Vtemp_346);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_348, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_349, __Vtemp_347, __Vtemp_348);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__acc, __Vtemp_349, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_350, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__Vfuncout 
                = (((QData)((IData)(__Vtemp_350[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_350[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_4__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1007__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1008__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_4__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1008__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1008__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1008__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__1008__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1008__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__1008__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__x2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__1008__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_351, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_352, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__HH, __Vtemp_351, __Vtemp_352);
            VL_EXTENDS_WQ(128,64, __Vtemp_353, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_354, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__HL, __Vtemp_353, __Vtemp_354);
            VL_EXTENDS_WQ(128,64, __Vtemp_355, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_356, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__LH, __Vtemp_355, __Vtemp_356);
            VL_EXTENDS_WQ(128,64, __Vtemp_357, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_358, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__LL, __Vtemp_357, __Vtemp_358);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_359, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_360, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_361, __Vtemp_359, __Vtemp_360);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_362, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_363, __Vtemp_361, __Vtemp_362);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__acc, __Vtemp_363, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_364, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__Vfuncout 
                = (((QData)((IData)(__Vtemp_364[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_364[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_5__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1009__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1010__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_5__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1010__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1010__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1010__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__1010__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1010__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__1010__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__y2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__1010__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__mag 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__x2 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__y2);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__mag_q2_33 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__mag;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__repacked = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__trunc35 = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__trunc35 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__mag_q2_33);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__repacked 
                = (((QData)((IData)((1U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__mag_q2_33 
                                                   >> 0x23U))))) 
                    << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__trunc35);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__Vfuncout 
                = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__repacked 
                                        >> 0x22U))));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_6__wide_escaped 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1011__Vfuncout;
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_6__wide_escaped) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__iter;
                goto __Vlabel8;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__b 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__ay;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__a 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__ax;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__AH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__BH = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__AL = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__BL = 0ULL;
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__acc);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__HH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__HL);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__LH);
            VL_ZERO_W(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__LL);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__AH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__a, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__AL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__a 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__AH, 0x00000011U));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__BH 
                = VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__b, 0x00000011U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__BL 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__b 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__BH, 0x00000011U));
            VL_EXTENDS_WQ(128,64, __Vtemp_365, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_366, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__HH, __Vtemp_365, __Vtemp_366);
            VL_EXTENDS_WQ(128,64, __Vtemp_367, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__AH);
            VL_EXTENDS_WQ(128,64, __Vtemp_368, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__HL, __Vtemp_367, __Vtemp_368);
            VL_EXTENDS_WQ(128,64, __Vtemp_369, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_370, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__BH);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__LH, __Vtemp_369, __Vtemp_370);
            VL_EXTENDS_WQ(128,64, __Vtemp_371, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__AL);
            VL_EXTENDS_WQ(128,64, __Vtemp_372, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__BL);
            VL_MULS_WWW(128, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__LL, __Vtemp_371, __Vtemp_372);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_373, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__HH, 0x00000022U);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_374, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__HL, 0x00000011U);
            VL_ADD_W(4, __Vtemp_375, __Vtemp_373, __Vtemp_374);
            VL_SHIFTL_WWI(128,128,32, __Vtemp_376, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__LH, 0x00000011U);
            VL_ADD_W(4, __Vtemp_377, __Vtemp_375, __Vtemp_376);
            VL_ADD_W(4, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__acc, __Vtemp_377, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__LL);
            VL_SHIFTRS_WWI(128,128,32, __Vtemp_378, __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__acc, 0x00000022U);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__Vfuncout 
                = (((QData)((IData)(__Vtemp_378[1U])) 
                    << 0x00000020U) | (QData)((IData)(__Vtemp_378[0U])));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_7__wide_mul 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_mul__1012__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1013__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_7__wide_mul;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1013__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1013__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1013__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__1013__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1013__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__1013__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__xy 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__1013__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1014__v 
                = VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__xy, 1U);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1014__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1014__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1014__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__1014__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1014__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__1014__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__xy2 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__1014__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__mag_q2_33 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__mag;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__repacked = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__trunc35 = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__trunc35 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__mag_q2_33);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__repacked 
                = (((QData)((IData)((1U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__mag_q2_33 
                                                   >> 0x23U))))) 
                    << 0x00000023U) | __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__trunc35);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__Vfuncout 
                = (0U != (3U & (IData)((__Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__repacked 
                                        >> 0x22U))));
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_8__wide_escaped 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_escaped__1015__Vfuncout;
            if (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_8__wide_escaped) {
                __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__Vfuncout 
                    = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__iter;
                goto __Vlabel8;
            }
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1016__v 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__x2 
                   - __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__y2);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1016__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1016__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1016__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__1016__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1016__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__1016__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_9__mask35 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__1016__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zx 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000____VlefCall_9__mask35 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__cx);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zy 
                = (__Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__xy2 
                   + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__cy);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1017__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zx;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1017__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1017__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1017__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__1017__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1017__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__1017__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zx 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__1017__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1018__v 
                = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zy;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1018__Vfuncout = 0ULL;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1018__trunc = 0;
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1018__trunc 
                = (0x00000007ffffffffULL & __Vfunc_tb_multiply_manager_wide__DOT__mask35__1018__v);
            __Vfunc_tb_multiply_manager_wide__DOT__mask35__1018__Vfuncout 
                = VL_EXTENDS_QQ(64,35, __Vfunc_tb_multiply_manager_wide__DOT__mask35__1018__trunc);
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__zy 
                = __Vfunc_tb_multiply_manager_wide__DOT__mask35__1018__Vfuncout;
            __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__iter 
                = ((IData)(1U) + __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__iter);
        }
        __Vlabel8: ;
    }
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__expected 
        = __Vfunc_tb_multiply_manager_wide__DOT__wide_golden_iterations__1000__Vfuncout;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__py_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__py_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__px_wide 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__px_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__jcy 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__jcy;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__jcx 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__jcx;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__maxit 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__maxit;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__enc 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__enc;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__jtype 
        = __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_type 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__enc;
    vlSelfRef.tb_multiply_manager_wide__DOT__max_iteration 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__maxit;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_x 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__jcx;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_y 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__jcy;
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__px_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__px_wide));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__py_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1019__py_wide));
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         442);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         444);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__cyc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__captured = 0U;
    while ((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__run_wide__999__captured)))) {
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                        "@(posedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             450);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__cyc 
            = ((IData)(1U) + __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__cyc);
        if (vlSelfRef.tb_multiply_manager_wide__DOT__done) {
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1020__msg 
                = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__999__name, ": done_side should be 0 (wide uses left thread)"s));
            __Vtask_tb_multiply_manager_wide__DOT__check__1020__cond 
                = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done_side)));
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__1020__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1020__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1021__msg 
                = VL_SFORMATF_N_NX("%s: count mismatch  dut=%0d  expected=%0d",3
                                   , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__999__name)
                                   , '#',16,(IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out)
                                   , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__999__expected) ;
            __Vtask_tb_multiply_manager_wide__DOT__check__1021__cond 
                = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                   == (0x0000ffffU & __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__expected));
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__1021__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1021__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 = 3U;
            while (VL_LTS_III(32, 0U, __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1)) {
                Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                                "@(posedge tb_multiply_manager_wide.clk)");
                co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge tb_multiply_manager_wide.clk)", 
                                                                     "tb_multiply_manager_wide.sv", 
                                                                     460);
                vlSelfRef.__Vm_traceActivity[3U] = 1U;
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1022__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__999__name, ": done dropped before received"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__1022__cond 
                    = vlSelfRef.tb_multiply_manager_wide__DOT__done;
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__1022__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1022__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1023__msg 
                    = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__999__name, ": iteration_out changed while holding"s));
                __Vtask_tb_multiply_manager_wide__DOT__check__1023__cond 
                    = ((IData)(vlSelfRef.tb_multiply_manager_wide__DOT__iteration_out) 
                       == (0x0000ffffU & __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__expected));
                vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
                if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__1023__cond)))))) {
                    vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                    VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1023__msg)
                                 , '#',64,VL_TIME_UNITED_Q(1000));
                }
                __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                    = (__Vtask_tb_multiply_manager_wide__DOT__run_wide__999__tb_multiply_manager_wide__DOT__unnamedblk1_2__DOT____Vrepeat1 
                       - (IData)(1U));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__captured = 1U;
        }
        if ((__Vtask_tb_multiply_manager_wide__DOT__run_wide__999__cyc 
             > __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__timeout_cycles)) {
            vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1024__msg 
                = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__999__name, ": TIMEOUT waiting for done"s));
            __Vtask_tb_multiply_manager_wide__DOT__check__1024__cond = 0U;
            vlSelfRef.tb_multiply_manager_wide__DOT__checks 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
            if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__1024__cond)))))) {
                vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                    = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
                VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                             , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1024__msg)
                             , '#',64,VL_TIME_UNITED_Q(1000));
            }
            __Vtask_tb_multiply_manager_wide__DOT__run_wide__999__captured = 1U;
        }
    }
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         474);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__received = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         476);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__received = 0U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                    "@(posedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         480);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1025__msg 
        = VL_CVT_PACK_STR_NN(VL_CONCATN_NNN(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__999__name, ": done did not drop after received"s));
    __Vtask_tb_multiply_manager_wide__DOT__check__1025__cond 
        = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done)));
    vlSelfRef.tb_multiply_manager_wide__DOT__checks 
        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
    if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__1025__cond)))))) {
        vlSelfRef.tb_multiply_manager_wide__DOT__errors 
            = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
        VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                     , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1025__msg)
                     , '#',64,VL_TIME_UNITED_Q(1000));
    }
    VL_WRITEF_NX("  [ OK ] %-40s  count=%0d  (%0d cycles)\n",3
                 , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__run_wide__999__name)
                 , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__999__expected
                 , '#',32,__Vtask_tb_multiply_manager_wide__DOT__run_wide__999__cyc);
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__v = 0.0;
    tb_multiply_manager_wide__DOT____VlemCall_46__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_46__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1026__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__v = 0.0;
    tb_multiply_manager_wide__DOT____VlemCall_47__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_47__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1027__result;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__py_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_47__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__px_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_46__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__jcy = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__jcx = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__maxit = 9U;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__enc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__jtype = 0U;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_type 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__enc;
    vlSelfRef.tb_multiply_manager_wide__DOT__max_iteration 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__maxit;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_x 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__jcx;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_y 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__jcy;
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__px_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__px_wide));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__py_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1028__py_wide));
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         673);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         673);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 0U;
    tb_multiply_manager_wide__DOT__unnamedblk5__DOT__unnamedblk1_3__DOT____Vrepeat2 = 0x00000014U;
    while (VL_LTS_III(32, 0U, tb_multiply_manager_wide__DOT__unnamedblk5__DOT__unnamedblk1_3__DOT____Vrepeat2)) {
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                        "@(posedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             674);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        tb_multiply_manager_wide__DOT__unnamedblk5__DOT__unnamedblk1_3__DOT____Vrepeat2 
            = (tb_multiply_manager_wide__DOT__unnamedblk5__DOT__unnamedblk1_3__DOT____Vrepeat2 
               - (IData)(1U));
    }
    vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1029__msg = "kill test: unexpected early done"s;
    __Vtask_tb_multiply_manager_wide__DOT__check__1029__cond 
        = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done)));
    vlSelfRef.tb_multiply_manager_wide__DOT__checks 
        = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
    if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__1029__cond)))))) {
        vlSelfRef.tb_multiply_manager_wide__DOT__errors 
            = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
        VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                     , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1029__msg)
                     , '#',64,VL_TIME_UNITED_Q(1000));
    }
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         676);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__kill = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         676);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__kill = 0U;
    tb_multiply_manager_wide__DOT__unnamedblk5__DOT__unnamedblk1_4__DOT____Vrepeat3 = 0x0000000aU;
    while (VL_LTS_III(32, 0U, tb_multiply_manager_wide__DOT__unnamedblk5__DOT__unnamedblk1_4__DOT____Vrepeat3)) {
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                        "@(posedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             678);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1030__msg = "kill test: done asserted after kill"s;
        __Vtask_tb_multiply_manager_wide__DOT__check__1030__cond 
            = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done)));
        vlSelfRef.tb_multiply_manager_wide__DOT__checks 
            = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
        if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__1030__cond)))))) {
            vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
            VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                         , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1030__msg)
                         , '#',64,VL_TIME_UNITED_Q(1000));
        }
        tb_multiply_manager_wide__DOT__unnamedblk5__DOT__unnamedblk1_4__DOT____Vrepeat3 
            = (tb_multiply_manager_wide__DOT__unnamedblk5__DOT__unnamedblk1_4__DOT____Vrepeat3 
               - (IData)(1U));
    }
    VL_WRITEF_NX("  [ OK ] kill mid-computation (wide)\n",0);
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__v = 0.0;
    tb_multiply_manager_wide__DOT____VlemCall_48__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_48__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1031__result;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__v = 0.0;
    tb_multiply_manager_wide__DOT____VlemCall_49__to_wide = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__raw = 0ULL;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__hi = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__lo = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__result = 0;
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__raw 
        = VL_EXTENDS_QI(64,32, VL_RTOI_I_D((0.0 * __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__v)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__hi 
        = (0x0003ffffU & (IData)(VL_SHIFTRS_QQI(64,64,32, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__raw, 0x00000011U)));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__lo 
        = (0x0001ffffU & ((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__raw) 
                          - (IData)(VL_SHIFTL_QQI(64,64,32, 
                                                  VL_EXTENDS_QI(64,18, __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__hi), 0x00000011U))));
    __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__result 
        = (((QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__hi)) 
            << 0x00000012U) | (QData)((IData)(__Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__lo)));
    tb_multiply_manager_wide__DOT____VlemCall_49__to_wide 
        = __Vfunc_tb_multiply_manager_wide__DOT__to_wide__1032__result;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__py_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_49__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__px_wide 
        = tb_multiply_manager_wide__DOT____VlemCall_48__to_wide;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__jcy = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__jcx = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__maxit = 9U;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__enc = 0U;
    __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__jtype = 0U;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_type 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__jtype;
    vlSelfRef.tb_multiply_manager_wide__DOT__magnitude_negation_encoding 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__enc;
    vlSelfRef.tb_multiply_manager_wide__DOT__max_iteration 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__maxit;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_x 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__jcx;
    vlSelfRef.tb_multiply_manager_wide__DOT__julia_c_y 
        = __Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__jcy;
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__px_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_x_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__px_wide));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_1 
        = (0x0003ffffU & (IData)((__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__py_wide 
                                  >> 0x12U)));
    vlSelfRef.tb_multiply_manager_wide__DOT__starting_y_reg_2 
        = (0x0001ffffU & (IData)(__Vtask_tb_multiply_manager_wide__DOT__drive_wide_inputs__1033__py_wide));
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         690);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         690);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__start_wide = 0U;
    tb_multiply_manager_wide__DOT__unnamedblk1_5__DOT____Vrepeat4 = 0x0000000aU;
    while (VL_LTS_III(32, 0U, tb_multiply_manager_wide__DOT__unnamedblk1_5__DOT____Vrepeat4)) {
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                        "@(posedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             691);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        tb_multiply_manager_wide__DOT__unnamedblk1_5__DOT____Vrepeat4 
            = (tb_multiply_manager_wide__DOT__unnamedblk1_5__DOT____Vrepeat4 
               - (IData)(1U));
    }
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         692);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__rst = 1U;
    Vtb_multiply_manager_wide___024root____VbeforeTrig_h87247175__0(vlSelf, 
                                                                    "@(negedge tb_multiply_manager_wide.clk)");
    co_await vlSelfRef.__VtrigSched_h87247175__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_multiply_manager_wide.clk)", 
                                                         "tb_multiply_manager_wide.sv", 
                                                         692);
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.tb_multiply_manager_wide__DOT__rst = 0U;
    tb_multiply_manager_wide__DOT__unnamedblk1_6__DOT____Vrepeat5 = 5U;
    while (VL_LTS_III(32, 0U, tb_multiply_manager_wide__DOT__unnamedblk1_6__DOT____Vrepeat5)) {
        Vtb_multiply_manager_wide___024root____VbeforeTrig_h872470a5__0(vlSelf, 
                                                                        "@(posedge tb_multiply_manager_wide.clk)");
        co_await vlSelfRef.__VtrigSched_h872470a5__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_multiply_manager_wide.clk)", 
                                                             "tb_multiply_manager_wide.sv", 
                                                             694);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
        vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1034__msg = "rst test: done asserted after rst"s;
        __Vtask_tb_multiply_manager_wide__DOT__check__1034__cond 
            = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_wide__DOT__done)));
        vlSelfRef.tb_multiply_manager_wide__DOT__checks 
            = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__checks);
        if (VL_UNLIKELY(((1U & (~ (IData)(__Vtask_tb_multiply_manager_wide__DOT__check__1034__cond)))))) {
            vlSelfRef.tb_multiply_manager_wide__DOT__errors 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_wide__DOT__errors);
            VL_WRITEF_NX("  [FAIL] %s   (t=%0t)\n",3, 'T',-9
                         , 'S',&(vlSelfRef.__Vtask_tb_multiply_manager_wide__DOT__check__1034__msg)
                         , '#',64,VL_TIME_UNITED_Q(1000));
        }
        tb_multiply_manager_wide__DOT__unnamedblk1_6__DOT____Vrepeat5 
            = (tb_multiply_manager_wide__DOT__unnamedblk1_6__DOT____Vrepeat5 
               - (IData)(1U));
    }
    VL_WRITEF_NX("  [ OK ] rst mid-computation (wide)\n==== DONE: %0d checks, %0d errors ====\n",2
                 , '#',32,vlSelfRef.tb_multiply_manager_wide__DOT__checks
                 , '#',32,vlSelfRef.tb_multiply_manager_wide__DOT__errors);
    if ((0U == vlSelfRef.tb_multiply_manager_wide__DOT__errors)) {
        VL_WRITEF_NX("==== ALL TESTS PASSED ====\n",0);
    } else {
        VL_WRITEF_NX("==== %0d FAILURE(S) ====\n",1
                     , '#',32,vlSelfRef.tb_multiply_manager_wide__DOT__errors);
    }
    VL_FINISH_MT("tb_multiply_manager_wide.sv", 706, "");
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    co_return;
}
