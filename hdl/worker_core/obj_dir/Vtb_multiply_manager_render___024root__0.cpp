// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_multiply_manager_render.h for the primary calling header

#include "Vtb_multiply_manager_render__pch.h"

VlCoroutine Vtb_multiply_manager_render___024root___eval_initial__TOP__Vtiming__0(Vtb_multiply_manager_render___024root* vlSelf);
VlCoroutine Vtb_multiply_manager_render___024root___eval_initial__TOP__Vtiming__1(Vtb_multiply_manager_render___024root* vlSelf);
VlCoroutine Vtb_multiply_manager_render___024root___eval_initial__TOP__Vtiming__2(Vtb_multiply_manager_render___024root* vlSelf);

void Vtb_multiply_manager_render___024root___eval_initial(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___eval_initial\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_multiply_manager_render__DOT__clk = 0U;
    Vtb_multiply_manager_render___024root___eval_initial__TOP__Vtiming__0(vlSelf);
    Vtb_multiply_manager_render___024root___eval_initial__TOP__Vtiming__1(vlSelf);
    Vtb_multiply_manager_render___024root___eval_initial__TOP__Vtiming__2(vlSelf);
}

void Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6a48__0(Vtb_multiply_manager_render___024root* vlSelf, const char* __VeventDescription);
void Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(Vtb_multiply_manager_render___024root* vlSelf, const char* __VeventDescription);

VlCoroutine Vtb_multiply_manager_render___024root___eval_initial__TOP__Vtiming__0(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___eval_initial__TOP__Vtiming__0\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ tb_multiply_manager_render__DOT__fd;
    tb_multiply_manager_render__DOT__fd = 0;
    IData/*31:0*/ tb_multiply_manager_render__DOT__row;
    tb_multiply_manager_render__DOT__row = 0;
    IData/*31:0*/ tb_multiply_manager_render__DOT__pixel_count;
    tb_multiply_manager_render__DOT__pixel_count = 0;
    IData/*31:0*/ tb_multiply_manager_render__DOT__start_time;
    tb_multiply_manager_render__DOT__start_time = 0;
    IData/*31:0*/ tb_multiply_manager_render__DOT__end_time;
    tb_multiply_manager_render__DOT__end_time = 0;
    IData/*17:0*/ tb_multiply_manager_render__DOT__wxh;
    tb_multiply_manager_render__DOT__wxh = 0;
    IData/*17:0*/ tb_multiply_manager_render__DOT__wxl;
    tb_multiply_manager_render__DOT__wxl = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_render__DOT__do_reset__0__tb_multiply_manager_render__DOT__unnamedblk1_1__DOT____Vrepeat0;
    __Vtask_tb_multiply_manager_render__DOT__do_reset__0__tb_multiply_manager_render__DOT__unnamedblk1_1__DOT____Vrepeat0 = 0;
    double __Vtask_tb_multiply_manager_render__DOT__test_packing__1__test_val;
    __Vtask_tb_multiply_manager_render__DOT__test_packing__1__test_val = 0;
    double __Vtask_tb_multiply_manager_render__DOT__test_packing__1__reconstructed;
    __Vtask_tb_multiply_manager_render__DOT__test_packing__1__reconstructed = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__Vfuncout = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__v;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__v = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__scaled;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__scaled = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__full_int_high;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__full_int_high = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__Vfuncout = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__v;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__v = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__scaled;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__scaled = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__full_int;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__full_int = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__high_part;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__high_part = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__low_bits;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__low_bits = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__Vfuncout = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__high;
    __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__high = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__low;
    __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__low = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__full_int;
    __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__full_int = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_q216__5__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__to_q216__5__Vfuncout = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_q216__5__v;
    __Vfunc_tb_multiply_manager_render__DOT__to_q216__5__v = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_q216__6__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__to_q216__6__Vfuncout = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_q216__6__v;
    __Vfunc_tb_multiply_manager_render__DOT__to_q216__6__v = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__px;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__px = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__py;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__py = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__count;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__count = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__tb_multiply_manager_render__DOT__unnamedblk1_2__DOT____Vrepeat1;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__tb_multiply_manager_render__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__cyc;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__cyc = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__max_wait;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__max_wait = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__Vfuncout = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__v;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__v = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__scaled;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__scaled = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__full_int_high;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__full_int_high = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__Vfuncout = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__v;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__v = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__scaled;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__scaled = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__full_int;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__full_int = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__high_part;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__high_part = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__low_bits;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__low_bits = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__Vfuncout = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__v;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__v = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__scaled;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__scaled = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__full_int_high;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__full_int_high = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__Vfuncout = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__v;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__v = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__scaled;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__scaled = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__full_int;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__full_int = 0;
    IData/*31:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__high_part;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__high_part = 0;
    IData/*16:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__low_bits;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__low_bits = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__xh;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__xh = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__xl;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__xl = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__yh;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__yh = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__yl;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__yl = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__count;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__count = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__tb_multiply_manager_render__DOT__unnamedblk1_3__DOT____Vrepeat2;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__tb_multiply_manager_render__DOT__unnamedblk1_3__DOT____Vrepeat2 = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__cyc;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__cyc = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__max_wait;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__max_wait = 0;
    // Body
    VL_WRITEF_NX("============================================================\nMULTIPLY MANAGER RENDER TESTBENCH (Verilator-compatible)\n============================================================\nResolution: 128 \303\227 128\nMax iterations: 2^8 = 256\n\n",0);
    vlSelfRef.tb_multiply_manager_render__DOT__rst = 1U;
    vlSelfRef.tb_multiply_manager_render__DOT__kill = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__received = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__start_left = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__start_right = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__start_wide = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__julia_type = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__magnitude_negation_encoding = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__max_iteration = 8U;
    vlSelfRef.tb_multiply_manager_render__DOT__julia_c_x = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__julia_c_y = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_1 = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_2 = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_1 = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_2 = 0U;
    __Vtask_tb_multiply_manager_render__DOT__do_reset__0__tb_multiply_manager_render__DOT__unnamedblk1_1__DOT____Vrepeat0 = 3U;
    while (VL_LTS_III(32, 0U, __Vtask_tb_multiply_manager_render__DOT__do_reset__0__tb_multiply_manager_render__DOT__unnamedblk1_1__DOT____Vrepeat0)) {
        Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6a48__0(vlSelf, 
                                                                          "@(posedge tb_multiply_manager_render.clk)");
        co_await vlSelfRef.__VtrigSched_h4f6f6a48__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_multiply_manager_render.clk)", 
                                                             "tb_multiply_manager_render.sv", 
                                                             149);
        __Vtask_tb_multiply_manager_render__DOT__do_reset__0__tb_multiply_manager_render__DOT__unnamedblk1_1__DOT____Vrepeat0 
            = (__Vtask_tb_multiply_manager_render__DOT__do_reset__0__tb_multiply_manager_render__DOT__unnamedblk1_1__DOT____Vrepeat0 
               - (IData)(1U));
    }
    vlSelfRef.tb_multiply_manager_render__DOT__rst = 0U;
    Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6a48__0(vlSelf, 
                                                                      "@(posedge tb_multiply_manager_render.clk)");
    co_await vlSelfRef.__VtrigSched_h4f6f6a48__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_multiply_manager_render.clk)", 
                                                         "tb_multiply_manager_render.sv", 
                                                         151);
    __Vtask_tb_multiply_manager_render__DOT__test_packing__1__test_val = 0.0;
    __Vtask_tb_multiply_manager_render__DOT__test_packing__1__reconstructed = 0.0;
    __Vtask_tb_multiply_manager_render__DOT__test_packing__1__test_val = 1.31825962999999990e-01;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__v 
        = __Vtask_tb_multiply_manager_render__DOT__test_packing__1__test_val;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__Vfuncout = 0;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__scaled = 0.0;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__full_int_high = 0;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__scaled 
        = (8.58993459200000000e+09 * __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__v);
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__full_int_high 
        = VL_RTOI_I_D((__Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__scaled 
                       / 1.31072000000000000e+05));
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__Vfuncout 
        = (0x0003ffffU & __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__full_int_high);
    tb_multiply_manager_render__DOT__wxh = __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__2__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__v 
        = __Vtask_tb_multiply_manager_render__DOT__test_packing__1__test_val;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__Vfuncout = 0;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__scaled = 0.0;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__full_int = 0;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__high_part = 0;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__low_bits = 0;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__scaled 
        = (8.58993459200000000e+09 * __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__v);
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__full_int 
        = VL_RTOI_I_D(__Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__scaled);
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__high_part 
        = VL_DIVS_III(32, __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__full_int, (IData)(0x00020000U));
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__low_bits 
        = (0x0001ffffU & (__Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__full_int 
                          - VL_MULS_III(32, (IData)(0x00020000U), __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__high_part)));
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__Vfuncout 
        = __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__low_bits;
    tb_multiply_manager_render__DOT__wxl = __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__3__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__low 
        = tb_multiply_manager_render__DOT__wxl;
    __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__high 
        = tb_multiply_manager_render__DOT__wxh;
    __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__Vfuncout = 0.0;
    __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__full_int = 0;
    __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__full_int 
        = (VL_SHIFTL_III(32,32,32, __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__high, 0x00000011U) 
           + (0x0001ffffU & __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__low));
    __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__Vfuncout 
        = (VL_ISTOR_D_I(32, __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__full_int) 
           / 8.58993459200000000e+09);
    __Vtask_tb_multiply_manager_render__DOT__test_packing__1__reconstructed 
        = __Vfunc_tb_multiply_manager_render__DOT__wide_to_real__4__Vfuncout;
    VL_WRITEF_NX("Test packing: original=%.9f high=%0d low=%0d recon=%.9f\n\n=== PASS 1: NARROW MODE (Q2.16) ===\nWindow: x\342\210\210[-1.50,1.50], y\342\210\210[-1.50,1.50]\n",4
                 , 'D',__Vtask_tb_multiply_manager_render__DOT__test_packing__1__test_val
                 , '~',18,tb_multiply_manager_render__DOT__wxh
                 , '#',18,tb_multiply_manager_render__DOT__wxl
                 , 'D',__Vtask_tb_multiply_manager_render__DOT__test_packing__1__reconstructed);
    vlSelfRef.tb_multiply_manager_render__DOT__julia_type = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__magnitude_negation_encoding = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__max_iteration = 8U;
    vlSelfRef.tb_multiply_manager_render__DOT__julia_c_x = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__julia_c_y = 0U;
    tb_multiply_manager_render__DOT__fd = VL_FOPEN_NN("sim/render/frame_narrow.csv"s
                                                      , "w"s);
    ;
    if (VL_UNLIKELY(((0U == tb_multiply_manager_render__DOT__fd)))) {
        VL_WRITEF_NX("ERROR: cannot open frame_narrow.csv\n",0);
        VL_FINISH_MT("tb_multiply_manager_render.sv", 299, "");
    }
    VL_FWRITEF_NX(tb_multiply_manager_render__DOT__fd,"x,y,iterations,real_x,real_y\n",0);
    tb_multiply_manager_render__DOT__start_time = (IData)(VL_TIME_UNITED_Q(1000));
    tb_multiply_manager_render__DOT__pixel_count = 0U;
    tb_multiply_manager_render__DOT__row = 0U;
    while (VL_GTS_III(32, 0x00000080U, tb_multiply_manager_render__DOT__row)) {
        vlSelfRef.tb_multiply_manager_render__DOT__cy 
            = (-1.50000000000000000e+00 + ((3.0 * VL_ISTOR_D_I(32, tb_multiply_manager_render__DOT__row)) 
                                           / 127.0));
        __Vfunc_tb_multiply_manager_render__DOT__to_q216__5__v 
            = vlSelfRef.tb_multiply_manager_render__DOT__cy;
        __Vfunc_tb_multiply_manager_render__DOT__to_q216__5__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_render__DOT__to_q216__5__Vfuncout 
            = (0x0003ffffU & VL_RTOI_I_D((6.55360000000000000e+04 
                                          * __Vfunc_tb_multiply_manager_render__DOT__to_q216__5__v)));
        vlSelfRef.tb_multiply_manager_render__DOT__qy 
            = __Vfunc_tb_multiply_manager_render__DOT__to_q216__5__Vfuncout;
        vlSelfRef.tb_multiply_manager_render__DOT__col = 0U;
        while (VL_GTS_III(32, 0x00000080U, vlSelfRef.tb_multiply_manager_render__DOT__col)) {
            vlSelfRef.tb_multiply_manager_render__DOT__cx 
                = (-1.50000000000000000e+00 + ((3.0 
                                                * VL_ISTOR_D_I(32, vlSelfRef.tb_multiply_manager_render__DOT__col)) 
                                               / 127.0));
            __Vfunc_tb_multiply_manager_render__DOT__to_q216__6__v 
                = vlSelfRef.tb_multiply_manager_render__DOT__cx;
            __Vfunc_tb_multiply_manager_render__DOT__to_q216__6__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_render__DOT__to_q216__6__Vfuncout 
                = (0x0003ffffU & VL_RTOI_I_D((6.55360000000000000e+04 
                                              * __Vfunc_tb_multiply_manager_render__DOT__to_q216__6__v)));
            vlSelfRef.tb_multiply_manager_render__DOT__qx 
                = __Vfunc_tb_multiply_manager_render__DOT__to_q216__6__Vfuncout;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__py 
                = vlSelfRef.tb_multiply_manager_render__DOT__qy;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__px 
                = vlSelfRef.tb_multiply_manager_render__DOT__qx;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__tb_multiply_manager_render__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__count = 0;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__cyc = 0;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__max_wait = 0;
            vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_2 
                = __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__px;
            vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_2 
                = __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__py;
            vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_1 = 0U;
            vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_1 = 0U;
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(vlSelf, 
                                                                              "@(negedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6b02__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(negedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 170);
            vlSelfRef.tb_multiply_manager_render__DOT__start_right = 1U;
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(vlSelf, 
                                                                              "@(negedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6b02__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(negedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 172);
            vlSelfRef.tb_multiply_manager_render__DOT__start_right = 0U;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__max_wait = 0x00000a00U;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__cyc = 0U;
            while (((~ (IData)(vlSelfRef.tb_multiply_manager_render__DOT__done)) 
                    & VL_LTES_III(32, __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__cyc, __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__max_wait))) {
                Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6a48__0(vlSelf, 
                                                                                "@(posedge tb_multiply_manager_render.clk)");
                co_await vlSelfRef.__VtrigSched_h4f6f6a48__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge tb_multiply_manager_render.clk)", 
                                                                     "tb_multiply_manager_render.sv", 
                                                                     178);
                __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__cyc 
                    = ((IData)(1U) + __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__cyc);
            }
            if (VL_LIKELY((vlSelfRef.tb_multiply_manager_render__DOT__done))) {
                __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__count 
                    = vlSelfRef.tb_multiply_manager_render__DOT__iteration_out;
            } else {
                __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__count = 0U;
                VL_WRITEF_NX("NARROW TIMEOUT at (%0d,%0d) after %0d cycles\n",3
                             , '~',18,__Vtask_tb_multiply_manager_render__DOT__run_pixel__7__px
                             , '~',18,__Vtask_tb_multiply_manager_render__DOT__run_pixel__7__py
                             , '~',32,__Vtask_tb_multiply_manager_render__DOT__run_pixel__7__cyc);
            }
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(vlSelf, 
                                                                              "@(negedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6b02__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(negedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 189);
            vlSelfRef.tb_multiply_manager_render__DOT__received = 1U;
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(vlSelf, 
                                                                              "@(negedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6b02__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(negedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 191);
            vlSelfRef.tb_multiply_manager_render__DOT__received = 0U;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__tb_multiply_manager_render__DOT__unnamedblk1_2__DOT____Vrepeat1 = 2U;
            while (VL_LTS_III(32, 0U, __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__tb_multiply_manager_render__DOT__unnamedblk1_2__DOT____Vrepeat1)) {
                Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6a48__0(vlSelf, 
                                                                                "@(posedge tb_multiply_manager_render.clk)");
                co_await vlSelfRef.__VtrigSched_h4f6f6a48__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge tb_multiply_manager_render.clk)", 
                                                                     "tb_multiply_manager_render.sv", 
                                                                     194);
                __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__tb_multiply_manager_render__DOT__unnamedblk1_2__DOT____Vrepeat1 
                    = (__Vtask_tb_multiply_manager_render__DOT__run_pixel__7__tb_multiply_manager_render__DOT__unnamedblk1_2__DOT____Vrepeat1 
                       - (IData)(1U));
            }
            vlSelfRef.tb_multiply_manager_render__DOT__iter_result 
                = __Vtask_tb_multiply_manager_render__DOT__run_pixel__7__count;
            VL_FWRITEF_NX(tb_multiply_manager_render__DOT__fd,"%0d,%0d,%0d,%.9f,%.9f\n",5
                          , '~',32,vlSelfRef.tb_multiply_manager_render__DOT__col
                          , '~',32,tb_multiply_manager_render__DOT__row
                          , '~',32,vlSelfRef.tb_multiply_manager_render__DOT__iter_result
                          , 'D',vlSelfRef.tb_multiply_manager_render__DOT__cx
                          , 'D',vlSelfRef.tb_multiply_manager_render__DOT__cy);
            tb_multiply_manager_render__DOT__pixel_count 
                = ((IData)(1U) + tb_multiply_manager_render__DOT__pixel_count);
            vlSelfRef.tb_multiply_manager_render__DOT__col 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_render__DOT__col);
        }
        if (VL_UNLIKELY((((0x0000001fU == VL_MODDIVS_III(32, tb_multiply_manager_render__DOT__row, (IData)(0x00000020U))) 
                          | (0x0000007fU == tb_multiply_manager_render__DOT__row))))) {
            VL_WRITEF_NX("  [narrow] row %0d / 128 complete (%0d pixels)\n",2
                         , '~',32,((IData)(1U) + tb_multiply_manager_render__DOT__row)
                         , '~',32,tb_multiply_manager_render__DOT__pixel_count);
        }
        tb_multiply_manager_render__DOT__row = ((IData)(1U) 
                                                + tb_multiply_manager_render__DOT__row);
    }
    tb_multiply_manager_render__DOT__end_time = (IData)(VL_TIME_UNITED_Q(1000));
    VL_FCLOSE_I(tb_multiply_manager_render__DOT__fd); VL_WRITEF_NX("Narrow render complete: %0d pixels in %0d ms\n\n=== PASS 2: WIDE MODE (Q2.33) ===\nWindow: x\342\210\210[-0.743743135,-0.743543135], y\342\210\210[0.131725963,0.131925963]\nZoom centre: (-0.743643135, 0.131825963)\nHalf-width: 1.00e-04\n",2
                                                                   , '~',32,tb_multiply_manager_render__DOT__pixel_count
                                                                   , '~',32,
                                                                   VL_DIVS_III(32, 
                                                                               (tb_multiply_manager_render__DOT__end_time 
                                                                                - tb_multiply_manager_render__DOT__start_time), (IData)(0x000f4240U)));
    vlSelfRef.tb_multiply_manager_render__DOT__julia_type = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__magnitude_negation_encoding = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__max_iteration = 8U;
    vlSelfRef.tb_multiply_manager_render__DOT__julia_c_x = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__julia_c_y = 0U;
    tb_multiply_manager_render__DOT__fd = VL_FOPEN_NN("sim/render/frame_wide.csv"s
                                                      , "w"s);
    ;
    if (VL_UNLIKELY(((0U == tb_multiply_manager_render__DOT__fd)))) {
        VL_WRITEF_NX("ERROR: cannot open frame_wide.csv\n",0);
        VL_FINISH_MT("tb_multiply_manager_render.sv", 348, "");
    }
    VL_FWRITEF_NX(tb_multiply_manager_render__DOT__fd,"x,y,iterations,real_x,real_y\n",0);
    tb_multiply_manager_render__DOT__start_time = (IData)(VL_TIME_UNITED_Q(1000));
    tb_multiply_manager_render__DOT__pixel_count = 0U;
    tb_multiply_manager_render__DOT__row = 0U;
    while (VL_GTS_III(32, 0x00000080U, tb_multiply_manager_render__DOT__row)) {
        vlSelfRef.tb_multiply_manager_render__DOT__cy 
            = (1.31725963000000001e-01 + ((1.99999999999977973e-04 
                                           * VL_ISTOR_D_I(32, tb_multiply_manager_render__DOT__row)) 
                                          / 127.0));
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__v 
            = vlSelfRef.tb_multiply_manager_render__DOT__cy;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__scaled = 0.0;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__full_int_high = 0;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__scaled 
            = (8.58993459200000000e+09 * __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__v);
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__full_int_high 
            = VL_RTOI_I_D((__Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__scaled 
                           / 1.31072000000000000e+05));
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__Vfuncout 
            = (0x0003ffffU & __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__full_int_high);
        vlSelfRef.tb_multiply_manager_render__DOT__wyh 
            = __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__8__Vfuncout;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__v 
            = vlSelfRef.tb_multiply_manager_render__DOT__cy;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__scaled = 0.0;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__full_int = 0;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__high_part = 0;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__low_bits = 0;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__scaled 
            = (8.58993459200000000e+09 * __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__v);
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__full_int 
            = VL_RTOI_I_D(__Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__scaled);
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__high_part 
            = VL_DIVS_III(32, __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__full_int, (IData)(0x00020000U));
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__low_bits 
            = (0x0001ffffU & (__Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__full_int 
                              - VL_MULS_III(32, (IData)(0x00020000U), __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__high_part)));
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__Vfuncout 
            = __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__low_bits;
        vlSelfRef.tb_multiply_manager_render__DOT__wyl 
            = __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__9__Vfuncout;
        vlSelfRef.tb_multiply_manager_render__DOT__col = 0U;
        while (VL_GTS_III(32, 0x00000080U, vlSelfRef.tb_multiply_manager_render__DOT__col)) {
            vlSelfRef.tb_multiply_manager_render__DOT__cx 
                = (-7.43743135000000000e-01 + ((1.99999999999977973e-04 
                                                * VL_ISTOR_D_I(32, vlSelfRef.tb_multiply_manager_render__DOT__col)) 
                                               / 127.0));
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__v 
                = vlSelfRef.tb_multiply_manager_render__DOT__cx;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__scaled = 0.0;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__full_int_high = 0;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__scaled 
                = (8.58993459200000000e+09 * __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__v);
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__full_int_high 
                = VL_RTOI_I_D((__Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__scaled 
                               / 1.31072000000000000e+05));
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__Vfuncout 
                = (0x0003ffffU & __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__full_int_high);
            tb_multiply_manager_render__DOT__wxh = __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__10__Vfuncout;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__v 
                = vlSelfRef.tb_multiply_manager_render__DOT__cx;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__scaled = 0.0;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__full_int = 0;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__high_part = 0;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__low_bits = 0;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__scaled 
                = (8.58993459200000000e+09 * __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__v);
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__full_int 
                = VL_RTOI_I_D(__Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__scaled);
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__high_part 
                = VL_DIVS_III(32, __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__full_int, (IData)(0x00020000U));
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__low_bits 
                = (0x0001ffffU & (__Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__full_int 
                                  - VL_MULS_III(32, (IData)(0x00020000U), __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__high_part)));
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__Vfuncout 
                = __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__low_bits;
            tb_multiply_manager_render__DOT__wxl = __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__11__Vfuncout;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__yl 
                = vlSelfRef.tb_multiply_manager_render__DOT__wyl;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__yh 
                = vlSelfRef.tb_multiply_manager_render__DOT__wyh;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__xl 
                = tb_multiply_manager_render__DOT__wxl;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__xh 
                = tb_multiply_manager_render__DOT__wxh;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__tb_multiply_manager_render__DOT__unnamedblk1_3__DOT____Vrepeat2 = 0;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__count = 0;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__cyc = 0;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__max_wait = 0;
            vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_1 
                = __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__xh;
            vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_2 
                = __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__xl;
            vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_1 
                = __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__yh;
            vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_2 
                = __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__yl;
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(vlSelf, 
                                                                              "@(negedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6b02__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(negedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 214);
            vlSelfRef.tb_multiply_manager_render__DOT__start_wide = 1U;
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(vlSelf, 
                                                                              "@(negedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6b02__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(negedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 216);
            vlSelfRef.tb_multiply_manager_render__DOT__start_wide = 0U;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__max_wait = 0x00001400U;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__cyc = 0U;
            while (((~ (IData)(vlSelfRef.tb_multiply_manager_render__DOT__done)) 
                    & VL_LTES_III(32, __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__cyc, __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__max_wait))) {
                Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6a48__0(vlSelf, 
                                                                                "@(posedge tb_multiply_manager_render.clk)");
                co_await vlSelfRef.__VtrigSched_h4f6f6a48__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge tb_multiply_manager_render.clk)", 
                                                                     "tb_multiply_manager_render.sv", 
                                                                     222);
                __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__cyc 
                    = ((IData)(1U) + __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__cyc);
            }
            if (VL_LIKELY((vlSelfRef.tb_multiply_manager_render__DOT__done))) {
                __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__count 
                    = vlSelfRef.tb_multiply_manager_render__DOT__iteration_out;
            } else {
                __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__count = 0U;
                VL_WRITEF_NX("WIDE TIMEOUT at (xh=%0d, xl=%0d, yh=%0d, yl=%0d) after %0d cycles\n",5
                             , '~',18,__Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__xh
                             , '#',18,__Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__xl
                             , '~',18,__Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__yh
                             , '#',18,__Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__yl
                             , '~',32,__Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__cyc);
            }
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(vlSelf, 
                                                                              "@(negedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6b02__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(negedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 234);
            vlSelfRef.tb_multiply_manager_render__DOT__received = 1U;
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(vlSelf, 
                                                                              "@(negedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6b02__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(negedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 236);
            vlSelfRef.tb_multiply_manager_render__DOT__received = 0U;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__tb_multiply_manager_render__DOT__unnamedblk1_3__DOT____Vrepeat2 = 2U;
            while (VL_LTS_III(32, 0U, __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__tb_multiply_manager_render__DOT__unnamedblk1_3__DOT____Vrepeat2)) {
                Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6a48__0(vlSelf, 
                                                                                "@(posedge tb_multiply_manager_render.clk)");
                co_await vlSelfRef.__VtrigSched_h4f6f6a48__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge tb_multiply_manager_render.clk)", 
                                                                     "tb_multiply_manager_render.sv", 
                                                                     239);
                __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__tb_multiply_manager_render__DOT__unnamedblk1_3__DOT____Vrepeat2 
                    = (__Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__tb_multiply_manager_render__DOT__unnamedblk1_3__DOT____Vrepeat2 
                       - (IData)(1U));
            }
            vlSelfRef.tb_multiply_manager_render__DOT__iter_result 
                = __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__12__count;
            VL_FWRITEF_NX(tb_multiply_manager_render__DOT__fd,"%0d,%0d,%0d,%.9f,%.9f\n",5
                          , '~',32,vlSelfRef.tb_multiply_manager_render__DOT__col
                          , '~',32,tb_multiply_manager_render__DOT__row
                          , '~',32,vlSelfRef.tb_multiply_manager_render__DOT__iter_result
                          , 'D',vlSelfRef.tb_multiply_manager_render__DOT__cx
                          , 'D',vlSelfRef.tb_multiply_manager_render__DOT__cy);
            tb_multiply_manager_render__DOT__pixel_count 
                = ((IData)(1U) + tb_multiply_manager_render__DOT__pixel_count);
            vlSelfRef.tb_multiply_manager_render__DOT__col 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_render__DOT__col);
        }
        if (VL_UNLIKELY((((0x0000001fU == VL_MODDIVS_III(32, tb_multiply_manager_render__DOT__row, (IData)(0x00000020U))) 
                          | (0x0000007fU == tb_multiply_manager_render__DOT__row))))) {
            VL_WRITEF_NX("  [wide]   row %0d / 128 complete (%0d pixels)\n",2
                         , '~',32,((IData)(1U) + tb_multiply_manager_render__DOT__row)
                         , '~',32,tb_multiply_manager_render__DOT__pixel_count);
        }
        tb_multiply_manager_render__DOT__row = ((IData)(1U) 
                                                + tb_multiply_manager_render__DOT__row);
    }
    tb_multiply_manager_render__DOT__end_time = (IData)(VL_TIME_UNITED_Q(1000));
    VL_FCLOSE_I(tb_multiply_manager_render__DOT__fd); VL_WRITEF_NX("Wide render complete: %0d pixels in %0d ms\n\n============================================================\nRENDER COMPLETE\n============================================================\nTo generate images:\n  python3 render.py --input sim/render/frame_narrow.csv --output frame_narrow.png\n  python3 render.py --input sim/render/frame_wide.csv   --output frame_wide.png\n",2
                                                                   , '~',32,tb_multiply_manager_render__DOT__pixel_count
                                                                   , '~',32,
                                                                   VL_DIVS_III(32, 
                                                                               (tb_multiply_manager_render__DOT__end_time 
                                                                                - tb_multiply_manager_render__DOT__start_time), (IData)(0x000f4240U)));
    VL_FINISH_MT("tb_multiply_manager_render.sv", 389, "");
    co_return;
}

VlCoroutine Vtb_multiply_manager_render___024root___eval_initial__TOP__Vtiming__1(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___eval_initial__TOP__Vtiming__1\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    co_await vlSelfRef.__VdlySched.delay(0x00003691d6afc000ULL, 
                                         nullptr, "tb_multiply_manager_render.sv", 
                                         394);
    VL_WRITEF_NX("==== GLOBAL TIMEOUT ====\n",0);
    VL_FINISH_MT("tb_multiply_manager_render.sv", 396, "");
    co_return;
}

VlCoroutine Vtb_multiply_manager_render___024root___eval_initial__TOP__Vtiming__2(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___eval_initial__TOP__Vtiming__2\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    while (VL_LIKELY(!vlSymsp->_vm_contextp__->gotFinish())) {
        co_await vlSelfRef.__VdlySched.delay(0x0000000000001388ULL, 
                                             nullptr, 
                                             "tb_multiply_manager_render.sv", 
                                             85);
        vlSelfRef.tb_multiply_manager_render__DOT__clk 
            = (1U & (~ (IData)(vlSelfRef.tb_multiply_manager_render__DOT__clk)));
    }
    co_return;
}

void Vtb_multiply_manager_render___024root___eval_triggers_vec__act(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___eval_triggers_vec__act\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered[0U] = (QData)((IData)(
                                                    ((vlSelfRef.__VdlySched.awaitingCurrentTime() 
                                                      << 2U) 
                                                     | ((((~ (IData)(vlSelfRef.tb_multiply_manager_render__DOT__clk)) 
                                                          & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_multiply_manager_render__DOT__clk__0)) 
                                                         << 1U) 
                                                        | ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__clk) 
                                                           & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_multiply_manager_render__DOT__clk__0)))))));
    vlSelfRef.__Vtrigprevexpr___TOP__tb_multiply_manager_render__DOT__clk__0 
        = vlSelfRef.tb_multiply_manager_render__DOT__clk;
}

bool Vtb_multiply_manager_render___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___trigger_anySet__act\n"); );
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

void Vtb_multiply_manager_render___024root___act_comb__TOP__0(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___act_comb__TOP__0\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    VlWide<3>/*71:0*/ tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x;
    VL_ZERO_W(72, tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x);
    VlWide<3>/*71:0*/ tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y;
    VL_ZERO_W(72, tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y);
    VlWide<3>/*71:0*/ tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x;
    VL_ZERO_W(72, tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x);
    VlWide<3>/*71:0*/ tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y;
    VL_ZERO_W(72, tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y);
    VlWide<3>/*95:0*/ __Vtemp_2;
    VlWide<3>/*95:0*/ __Vtemp_7;
    VlWide<3>/*95:0*/ __Vtemp_9;
    VlWide<3>/*95:0*/ __Vtemp_14;
    // Body
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_max_iteration_flag 
        = (1U & ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1) 
                 >> (0x0000000fU & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__max_iteration))));
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_1 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_2 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2;
    tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[0U] 
        = (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2);
    tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[1U] 
        = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1) 
            << 4U) | (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                              >> 0x00000020U)));
    tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[2U] 
        = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1) 
            >> 0x0000001cU) | ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                        >> 0x00000020U)) 
                               << 4U));
    tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[0U] 
        = tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[0U];
    tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[1U] 
        = tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[1U];
    tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[2U] 
        = tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[2U];
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_1 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_2 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2;
    tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[0U] 
        = (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2);
    tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[1U] 
        = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1) 
            << 4U) | (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                              >> 0x00000020U)));
    tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[2U] 
        = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1) 
            >> 0x0000001cU) | ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                                        >> 0x00000020U)) 
                               << 4U));
    tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[0U] 
        = tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[0U];
    tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[1U] 
        = tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[1U];
    tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[2U] 
        = tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[2U];
    if (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__is_wide) {
        if ((8U & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__magnitude_negation_encoding))) {
            VL_NEGATE_W(3, __Vtemp_2, tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x);
            if ((0x00000080U & tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[2U])) {
                tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[0U] 
                    = __Vtemp_2[0U];
                tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[1U] 
                    = __Vtemp_2[1U];
                tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[2U] 
                    = (0x000000ffU & __Vtemp_2[2U]);
            } else {
                tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[0U] 
                    = tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[0U];
                tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[1U] 
                    = tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[1U];
                tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[2U] 
                    = (0x000000ffU & tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_x[2U]);
            }
        }
        if ((2U & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__magnitude_negation_encoding))) {
            VL_NEGATE_W(3, __Vtemp_7, tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x);
            tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[0U] 
                = __Vtemp_7[0U];
            tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[1U] 
                = __Vtemp_7[1U];
            tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[2U] 
                = (0x000000ffU & __Vtemp_7[2U]);
        }
        vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_1 
            = (0x0000000fffffffffULL & (((QData)((IData)(tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[2U])) 
                                         << 0x0000001cU) 
                                        | ((QData)((IData)(tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[1U])) 
                                           >> 4U)));
        vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_2 
            = (0x0000000fffffffffULL & (((QData)((IData)(tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[1U])) 
                                         << 0x00000020U) 
                                        | (QData)((IData)(tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_x[0U]))));
        if ((4U & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__magnitude_negation_encoding))) {
            VL_NEGATE_W(3, __Vtemp_9, tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y);
            if ((0x00000080U & tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[2U])) {
                tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[0U] 
                    = __Vtemp_9[0U];
                tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[1U] 
                    = __Vtemp_9[1U];
                tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[2U] 
                    = (0x000000ffU & __Vtemp_9[2U]);
            } else {
                tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[0U] 
                    = tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[0U];
                tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[1U] 
                    = tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[1U];
                tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[2U] 
                    = (0x000000ffU & tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__wide_y[2U]);
            }
        }
        if ((1U & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__magnitude_negation_encoding))) {
            VL_NEGATE_W(3, __Vtemp_14, tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y);
            tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[0U] 
                = __Vtemp_14[0U];
            tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[1U] 
                = __Vtemp_14[1U];
            tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[2U] 
                = (0x000000ffU & __Vtemp_14[2U]);
        }
        vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_1 
            = (0x0000000fffffffffULL & (((QData)((IData)(tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[2U])) 
                                         << 0x0000001cU) 
                                        | ((QData)((IData)(tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[1U])) 
                                           >> 4U)));
        vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_2 
            = (0x0000000fffffffffULL & (((QData)((IData)(tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[1U])) 
                                         << 0x00000020U) 
                                        | (QData)((IData)(tb_multiply_manager_render__DOT__dut__DOT__mag_neg_encoder__DOT__changed_wide_y[0U]))));
    } else {
        if ((8U & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__magnitude_negation_encoding))) {
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_1 
                = (0x0000000fffffffffULL & (VL_GTS_IQQ(36, 0ULL, vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1)
                                             ? (- vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1)
                                             : vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1));
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_2 
                = (0x0000000fffffffffULL & (VL_GTS_IQQ(36, 0ULL, vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2)
                                             ? (- vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2)
                                             : vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2));
        }
        if ((2U & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__magnitude_negation_encoding))) {
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_1 
                = (0x0000000fffffffffULL & (- vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_1));
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_2 
                = (0x0000000fffffffffULL & (- vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_2));
        }
        if ((4U & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__magnitude_negation_encoding))) {
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_1 
                = (0x0000000fffffffffULL & (VL_GTS_IQQ(36, 0ULL, vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1)
                                             ? (- vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1)
                                             : vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1));
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_2 
                = (0x0000000fffffffffULL & (VL_GTS_IQQ(36, 0ULL, vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2)
                                             ? (- vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2)
                                             : vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2));
        }
        if ((1U & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__magnitude_negation_encoding))) {
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_1 
                = (0x0000000fffffffffULL & (- vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_1));
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_2 
                = (0x0000000fffffffffULL & (- vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_2));
        }
    }
}

void Vtb_multiply_manager_render___024root___eval_act(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___eval_act\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((3ULL & vlSelfRef.__VactTriggered[0U])) {
        Vtb_multiply_manager_render___024root___act_comb__TOP__0(vlSelf);
    }
}

void Vtb_multiply_manager_render___024root___nba_sequent__TOP__0(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___nba_sequent__TOP__0\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_thread;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_thread = 0;
    IData/*31:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_thread;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_thread = 0;
    IData/*31:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle = 0;
    IData/*31:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle = 0;
    QData/*35:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 = 0;
    QData/*35:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 = 0;
    SData/*15:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1 = 0;
    QData/*35:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 = 0;
    QData/*35:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 = 0;
    IData/*17:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1 = 0;
    SData/*15:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2 = 0;
    QData/*35:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 = 0;
    QData/*35:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 = 0;
    IData/*17:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2 = 0;
    QData/*35:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 = 0;
    QData/*35:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 = 0;
    IData/*31:0*/ __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle = 0;
    VlWide<3>/*95:0*/ __Vtemp_2;
    VlWide<3>/*95:0*/ __Vtemp_3;
    VlWide<3>/*95:0*/ __Vtemp_4;
    VlWide<3>/*95:0*/ __Vtemp_7;
    VlWide<3>/*95:0*/ __Vtemp_8;
    VlWide<3>/*95:0*/ __Vtemp_9;
    VlWide<3>/*95:0*/ __Vtemp_10;
    VlWide<3>/*95:0*/ __Vtemp_13;
    VlWide<3>/*95:0*/ __Vtemp_14;
    VlWide<3>/*95:0*/ __Vtemp_15;
    VlWide<3>/*95:0*/ __Vtemp_16;
    VlWide<3>/*95:0*/ __Vtemp_19;
    VlWide<3>/*95:0*/ __Vtemp_21;
    VlWide<3>/*95:0*/ __Vtemp_22;
    VlWide<3>/*95:0*/ __Vtemp_25;
    VlWide<3>/*95:0*/ __Vtemp_27;
    VlWide<3>/*95:0*/ __Vtemp_28;
    VlWide<3>/*95:0*/ __Vtemp_33;
    VlWide<3>/*95:0*/ __Vtemp_34;
    VlWide<3>/*95:0*/ __Vtemp_35;
    VlWide<3>/*95:0*/ __Vtemp_38;
    VlWide<3>/*95:0*/ __Vtemp_39;
    VlWide<3>/*95:0*/ __Vtemp_40;
    VlWide<3>/*95:0*/ __Vtemp_43;
    VlWide<3>/*95:0*/ __Vtemp_44;
    VlWide<3>/*95:0*/ __Vtemp_45;
    VlWide<3>/*95:0*/ __Vtemp_48;
    VlWide<3>/*95:0*/ __Vtemp_49;
    VlWide<3>/*95:0*/ __Vtemp_50;
    VlWide<3>/*95:0*/ __Vtemp_51;
    VlWide<3>/*95:0*/ __Vtemp_52;
    VlWide<3>/*95:0*/ __Vtemp_55;
    VlWide<3>/*95:0*/ __Vtemp_56;
    VlWide<3>/*95:0*/ __Vtemp_57;
    VlWide<3>/*95:0*/ __Vtemp_60;
    VlWide<3>/*95:0*/ __Vtemp_61;
    VlWide<3>/*95:0*/ __Vtemp_62;
    // Body
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_thread 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_thread;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_thread 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_thread;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle;
    if (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__kill) 
         | (IData)(vlSelfRef.tb_multiply_manager_render__DOT__rst))) {
        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_thread = 0U;
        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_thread = 0U;
        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle = 0U;
        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle = 0U;
        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 = 0ULL;
        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 = 0ULL;
        vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status = 0U;
    } else {
        if (vlSelfRef.tb_multiply_manager_render__DOT__start_left) {
            __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 = 0ULL;
            __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_thread = 1U;
            __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1 = 0U;
            if (vlSelfRef.tb_multiply_manager_render__DOT__julia_type) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                    = (0x0000000fffffffffULL & VL_SHIFTL_QQI(36,36,32, 
                                                             VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_1), 0x00000010U));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                    = (0x0000000fffffffffULL & VL_SHIFTL_QQI(36,36,32, 
                                                             VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_1), 0x00000010U));
            } else {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 = 0ULL;
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 = 0ULL;
            }
            __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle = 1U;
        } else if (((1U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_thread) 
                    & (1U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status))) {
            if ((1U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)) {
                if (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1_overflow_flag) 
                     | (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1_overflow_flag))) {
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle = 7U;
                } else {
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_1;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1 
                        = (0x0003ffffU & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_1 
                                                  >> 0x10U)));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_1;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle 
                        = ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_max_iteration_flag)
                            ? 7U : 2U);
                }
            } else if ((2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle = 3U;
            } else if ((3U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                    = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result;
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
                    = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result;
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle = 4U;
            } else if ((4U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                                - vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
                                                + vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle 
                    = ((0U != (3U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
                                             >> 0x00000022U))))
                        ? 7U : ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__julia_type)
                                 ? 6U : 5U));
            } else if ((6U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                                + VL_SHIFTL_QQI(36,36,32, 
                                                                VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__julia_c_x), 0x00000010U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1 
                    = (0x0000ffffU & ((IData)(1U) + (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                + VL_SHIFTL_QQI(36,36,32, 
                                                                VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__julia_c_y), 0x00000010U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle 
                    = ((0U != (3U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
                                             >> 0x00000022U))))
                        ? 7U : 1U);
            } else if ((5U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                                + VL_SHIFTL_QQI(36,36,32, 
                                                                VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_1), 0x00000010U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1 
                    = (0x0000ffffU & ((IData)(1U) + (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                + VL_SHIFTL_QQI(36,36,32, 
                                                                VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_1), 0x00000010U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle 
                    = ((0U != (3U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
                                             >> 0x00000022U))))
                        ? 7U : 1U);
            } else if ((7U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)) {
                if (((~ (IData)(vlSelfRef.tb_multiply_manager_render__DOT__done_side)) 
                     & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__received))) {
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_thread = 0U;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle = 0U;
                }
            } else {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle 
                    = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle;
            }
        }
        if (vlSelfRef.tb_multiply_manager_render__DOT__start_right) {
            __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 = 0ULL;
            __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_thread = 1U;
            __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2 = 0U;
            if (vlSelfRef.tb_multiply_manager_render__DOT__julia_type) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                    = (0x0000000fffffffffULL & VL_SHIFTL_QQI(36,36,32, 
                                                             VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_2), 0x00000010U));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                    = (0x0000000fffffffffULL & VL_SHIFTL_QQI(36,36,32, 
                                                             VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_2), 0x00000010U));
            } else {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 = 0ULL;
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 = 0ULL;
            }
            __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle = 1U;
        } else if (((1U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_thread) 
                    & (1U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status))) {
            if ((1U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)) {
                if ((((0U != (7U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                                            >> 0x00000021U)))) 
                      & (7U != (7U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                                              >> 0x00000021U))))) 
                     | ((0U != (7U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                                              >> 0x00000021U)))) 
                        & (7U != (7U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                                                >> 0x00000021U))))))) {
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle = 7U;
                } else {
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_2;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2 
                        = (0x0003ffffU & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_2 
                                                  >> 0x10U)));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_2;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle 
                        = ((1U & ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2) 
                                  >> (0x0000000fU & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__max_iteration))))
                            ? 7U : 2U);
                }
            } else if ((2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle = 3U;
            } else if ((3U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                    = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result;
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 
                    = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result;
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle = 4U;
            } else if ((4U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                                                - vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 
                                                + vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle 
                    = ((0U != (3U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 
                                             >> 0x00000022U))))
                        ? 7U : ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__julia_type)
                                 ? 6U : 5U));
            } else if ((6U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                                                + VL_SHIFTL_QQI(36,36,32, 
                                                                VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__julia_c_x), 0x00000010U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2 
                    = (0x0000ffffU & ((IData)(1U) + (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result 
                                                + VL_SHIFTL_QQI(36,36,32, 
                                                                VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__julia_c_y), 0x00000010U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle 
                    = ((0U != (3U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 
                                             >> 0x00000022U))))
                        ? 7U : 1U);
            } else if ((5U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                                                + VL_SHIFTL_QQI(36,36,32, 
                                                                VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_2), 0x00000010U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2 
                    = (0x0000ffffU & ((IData)(1U) + (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result 
                                                + VL_SHIFTL_QQI(36,36,32, 
                                                                VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_2), 0x00000010U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle 
                    = ((0U != (3U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 
                                             >> 0x00000022U))))
                        ? 7U : 1U);
            } else if ((7U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)) {
                if (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__done_side) 
                     & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__received))) {
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_thread = 0U;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle = 0U;
                }
            } else {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle 
                    = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle;
            }
        }
        if (vlSelfRef.tb_multiply_manager_render__DOT__start_wide) {
            __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 = 0ULL;
            __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 = 0ULL;
            __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_thread = 1U;
            __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_thread = 1U;
            __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1 = 0U;
            if (vlSelfRef.tb_multiply_manager_render__DOT__julia_type) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                    = (((QData)((IData)((3U & (- (IData)(
                                                         (1U 
                                                          & (vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_1 
                                                             >> 0x11U))))))) 
                        << 0x00000022U) | (((QData)((IData)(vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_1)) 
                                            << 0x00000010U) 
                                           | (QData)((IData)(
                                                             (0x0000ffffU 
                                                              & (vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_2 
                                                                 >> 1U))))));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                    = ((QData)((IData)((1U & vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_2))) 
                       << 0x00000023U);
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                    = (((QData)((IData)((3U & (- (IData)(
                                                         (1U 
                                                          & (vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_1 
                                                             >> 0x11U))))))) 
                        << 0x00000022U) | (((QData)((IData)(vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_1)) 
                                            << 0x00000010U) 
                                           | (QData)((IData)(
                                                             (0x0000ffffU 
                                                              & (vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_2 
                                                                 >> 1U))))));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                    = ((QData)((IData)((1U & vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_2))) 
                       << 0x00000023U);
            } else {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 = 0ULL;
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 = 0ULL;
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 = 0ULL;
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 = 0ULL;
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 = 0ULL;
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 = 0ULL;
            }
            __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle = 1U;
        } else if ((((1U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_thread) 
                     & (1U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_thread)) 
                    & (2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status))) {
            if (((((((((1U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle) 
                       | (2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) 
                      | (3U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) 
                     | (4U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) 
                    | (5U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) 
                   | (6U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) 
                  | (7U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) 
                 | (9U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle))) {
                if ((1U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
                    if (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1_overflow_flag) 
                         | (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1_overflow_flag))) {
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle = 0x0000000aU;
                    } else {
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1 
                            = (0x0003ffffU & (IData)(
                                                     (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_1 
                                                      >> 0x10U)));
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                            = (QData)((IData)(((0x0001fffeU 
                                                & ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_1) 
                                                   << 1U)) 
                                               | (1U 
                                                  & (IData)(
                                                            (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_2 
                                                             >> 0x23U))))));
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2 
                            = (0x0003ffffU & (IData)(
                                                     (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_1 
                                                      >> 0x10U)));
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                            = (QData)((IData)(((0x0001fffeU 
                                                & ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_1) 
                                                   << 1U)) 
                                               | (1U 
                                                  & (IData)(
                                                            (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_2 
                                                             >> 0x23U))))));
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle 
                            = ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_max_iteration_flag)
                                ? 0x0000000aU : 2U);
                    }
                } else if ((2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 = 0ULL;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 
                        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 = 0ULL;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle = 3U;
                } else if ((3U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
                    __Vtemp_2[0U] = (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2);
                    __Vtemp_2[1U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1) 
                                      << 4U) | (IData)(
                                                       (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
                                                        >> 0x00000020U)));
                    __Vtemp_2[2U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1) 
                                      >> 0x0000001cU) 
                                     | ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 
                                                 >> 0x00000020U)) 
                                        << 4U));
                    __Vtemp_3[0U] = (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result 
                                             << 0x00000011U));
                    __Vtemp_3[1U] = (((- (IData)((1U 
                                                  & (IData)(
                                                            (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result 
                                                             >> 0x23U))))) 
                                      << 0x00000015U) 
                                     | (IData)(((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result 
                                                 << 0x00000011U) 
                                                >> 0x00000020U)));
                    __Vtemp_3[2U] = (0x000000ffU & 
                                     ((- (IData)((1U 
                                                  & (IData)(
                                                            (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result 
                                                             >> 0x23U))))) 
                                      >> 0x0000000bU));
                    VL_ADD_W(3, __Vtemp_4, __Vtemp_2, __Vtemp_3);
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 
                        = (0x0000000fffffffffULL & 
                           (((QData)((IData)((0x000000ffU 
                                              & __Vtemp_4[2U]))) 
                             << 0x0000001cU) | ((QData)((IData)(__Vtemp_4[1U])) 
                                                >> 4U)));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
                        = (0x0000000fffffffffULL & 
                           (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
                            + ((QData)((IData)((0x0007ffffU 
                                                & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result)))) 
                               << 0x00000011U)));
                    __Vtemp_7[0U] = (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2);
                    __Vtemp_7[1U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1) 
                                      << 4U) | (IData)(
                                                       (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                                                        >> 0x00000020U)));
                    __Vtemp_7[2U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1) 
                                      >> 0x0000001cU) 
                                     | ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                                 >> 0x00000020U)) 
                                        << 4U));
                    __Vtemp_8[0U] = (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                             << 0x00000011U));
                    __Vtemp_8[1U] = (((- (IData)((1U 
                                                  & (IData)(
                                                            (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                             >> 0x23U))))) 
                                      << 0x00000015U) 
                                     | (IData)(((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                 << 0x00000011U) 
                                                >> 0x00000020U)));
                    __Vtemp_8[2U] = (0x000000ffU & 
                                     ((- (IData)((1U 
                                                  & (IData)(
                                                            (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                             >> 0x23U))))) 
                                      >> 0x0000000bU));
                    VL_ADD_W(3, __Vtemp_9, __Vtemp_7, __Vtemp_8);
                    VL_SHIFTL_WWI(72,72,32, __Vtemp_10, __Vtemp_9, 1U);
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                        = (0x0000000fffffffffULL & 
                           (((QData)((IData)((0x000000ffU 
                                              & __Vtemp_10[2U]))) 
                             << 0x0000001cU) | ((QData)((IData)(__Vtemp_10[1U])) 
                                                >> 4U)));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle = 4U;
                    __Vtemp_13[0U] = (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2);
                    __Vtemp_13[1U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1) 
                                       << 4U) | (IData)(
                                                        (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                                                         >> 0x00000020U)));
                    __Vtemp_13[2U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1) 
                                       >> 0x0000001cU) 
                                      | ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                                  >> 0x00000020U)) 
                                         << 4U));
                    __Vtemp_14[0U] = (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                              << 0x00000011U));
                    __Vtemp_14[1U] = (((- (IData)((1U 
                                                   & (IData)(
                                                             (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                              >> 0x23U))))) 
                                       << 0x00000015U) 
                                      | (IData)(((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                  << 0x00000011U) 
                                                 >> 0x00000020U)));
                    __Vtemp_14[2U] = (0x000000ffU & 
                                      ((- (IData)((1U 
                                                   & (IData)(
                                                             (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                              >> 0x23U))))) 
                                       >> 0x0000000bU));
                    VL_ADD_W(3, __Vtemp_15, __Vtemp_13, __Vtemp_14);
                    VL_SHIFTL_WWI(72,72,32, __Vtemp_16, __Vtemp_15, 1U);
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                        = (0x0000000fffffffffULL & 
                           (((QData)((IData)(__Vtemp_16[1U])) 
                             << 0x00000020U) | (QData)((IData)(__Vtemp_16[0U]))));
                } else if ((4U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
                    __Vtemp_19[0U] = (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2);
                    __Vtemp_19[1U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1) 
                                       << 4U) | (IData)(
                                                        (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                                                         >> 0x00000020U)));
                    __Vtemp_19[2U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1) 
                                       >> 0x0000001cU) 
                                      | ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                                  >> 0x00000020U)) 
                                         << 4U));
                    __Vtemp_21[0U] = ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result) 
                                      << 2U);
                    __Vtemp_21[1U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result) 
                                       >> 0x0000001eU) 
                                      | ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                  >> 0x00000020U)) 
                                         << 2U));
                    __Vtemp_21[2U] = ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                               >> 0x00000020U)) 
                                      >> 0x0000001eU);
                    VL_ADD_W(3, __Vtemp_22, __Vtemp_19, __Vtemp_21);
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                        = (0x0000000fffffffffULL & 
                           (((QData)((IData)((0x000000ffU 
                                              & __Vtemp_22[2U]))) 
                             << 0x0000001cU) | ((QData)((IData)(__Vtemp_22[1U])) 
                                                >> 4U)));
                    __Vtemp_25[0U] = (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2);
                    __Vtemp_25[1U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1) 
                                       << 4U) | (IData)(
                                                        (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
                                                         >> 0x00000020U)));
                    __Vtemp_25[2U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1) 
                                       >> 0x0000001cU) 
                                      | ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 
                                                  >> 0x00000020U)) 
                                         << 4U));
                    __Vtemp_27[0U] = ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result) 
                                      << 2U);
                    __Vtemp_27[1U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result) 
                                       >> 0x0000001eU) 
                                      | ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                  >> 0x00000020U)) 
                                         << 2U));
                    __Vtemp_27[2U] = ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                               >> 0x00000020U)) 
                                      >> 0x0000001eU);
                    VL_ADD_W(3, __Vtemp_28, __Vtemp_25, __Vtemp_27);
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 
                        = (0x0000000fffffffffULL & 
                           (((QData)((IData)((0x000000ffU 
                                              & __Vtemp_28[2U]))) 
                             << 0x0000001cU) | ((QData)((IData)(__Vtemp_28[1U])) 
                                                >> 4U)));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                        = (0x0000000fffffffffULL & 
                           (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                            + (0x0000000ffffffffcULL 
                               & (((QData)((IData)(
                                                   (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                    >> 0x00000020U))) 
                                   << 0x00000022U) 
                                  | ((QData)((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result)) 
                                     << 2U)))));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
                        = (0x0000000fffffffffULL & 
                           (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
                            + (0x0000000ffffffffcULL 
                               & (((QData)((IData)(
                                                   (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                    >> 0x00000020U))) 
                                   << 0x00000022U) 
                                  | ((QData)((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result)) 
                                     << 2U)))));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle = 5U;
                } else if ((5U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1;
                    __Vtemp_33[0U] = (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2);
                    __Vtemp_33[1U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1) 
                                       << 4U) | (IData)(
                                                        (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                                                         >> 0x00000020U)));
                    __Vtemp_33[2U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1) 
                                       >> 0x0000001cU) 
                                      | ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                                  >> 0x00000020U)) 
                                         << 4U));
                    __Vtemp_34[0U] = (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2);
                    __Vtemp_34[1U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1) 
                                       << 4U) | (IData)(
                                                        (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
                                                         >> 0x00000020U)));
                    __Vtemp_34[2U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1) 
                                       >> 0x0000001cU) 
                                      | ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 
                                                  >> 0x00000020U)) 
                                         << 4U));
                    VL_SUB_W(3, __Vtemp_35, __Vtemp_33, __Vtemp_34);
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                        = (0x0000000fffffffffULL & 
                           (((QData)((IData)((0x000000ffU 
                                              & __Vtemp_35[2U]))) 
                             << 0x0000001cU) | ((QData)((IData)(__Vtemp_35[1U])) 
                                                >> 4U)));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle = 6U;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                        = (0x0000000fffffffffULL & 
                           (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                            - vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2;
                    __Vtemp_38[0U] = (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2);
                    __Vtemp_38[1U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1) 
                                       << 4U) | (IData)(
                                                        (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                                                         >> 0x00000020U)));
                    __Vtemp_38[2U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1) 
                                       >> 0x0000001cU) 
                                      | ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                                  >> 0x00000020U)) 
                                         << 4U));
                    __Vtemp_39[0U] = (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2);
                    __Vtemp_39[1U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1) 
                                       << 4U) | (IData)(
                                                        (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
                                                         >> 0x00000020U)));
                    __Vtemp_39[2U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1) 
                                       >> 0x0000001cU) 
                                      | ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 
                                                  >> 0x00000020U)) 
                                         << 4U));
                    VL_ADD_W(3, __Vtemp_40, __Vtemp_38, __Vtemp_39);
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
                        = (0x0000000fffffffffULL & 
                           (((QData)((IData)((0x000000ffU 
                                              & __Vtemp_40[2U]))) 
                             << 0x0000001cU) | ((QData)((IData)(__Vtemp_40[1U])) 
                                                >> 4U)));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 
                        = (0x0000000fffffffffULL & 
                           (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                            + vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2));
                } else if ((6U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
                    if ((0U != (3U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
                                              >> 0x00000022U))))) {
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle = 0x0000000aU;
                    } else {
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                            = ((QData)((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2)) 
                               << 0x00000010U);
                        __Vtemp_43[0U] = (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                  << 0x00000011U));
                        __Vtemp_43[1U] = (((- (IData)(
                                                      (1U 
                                                       & (IData)(
                                                                 (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                                  >> 0x23U))))) 
                                           << 0x00000015U) 
                                          | (IData)(
                                                    ((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                      << 0x00000011U) 
                                                     >> 0x00000020U)));
                        __Vtemp_43[2U] = (0x000000ffU 
                                          & ((- (IData)(
                                                        (1U 
                                                         & (IData)(
                                                                   (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                                    >> 0x23U))))) 
                                             >> 0x0000000bU));
                        __Vtemp_44[0U] = (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result 
                                                  << 0x00000011U));
                        __Vtemp_44[1U] = (((- (IData)(
                                                      (1U 
                                                       & (IData)(
                                                                 (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result 
                                                                  >> 0x23U))))) 
                                           << 0x00000015U) 
                                          | (IData)(
                                                    ((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result 
                                                      << 0x00000011U) 
                                                     >> 0x00000020U)));
                        __Vtemp_44[2U] = (0x000000ffU 
                                          & ((- (IData)(
                                                        (1U 
                                                         & (IData)(
                                                                   (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result 
                                                                    >> 0x23U))))) 
                                             >> 0x0000000bU));
                        VL_ADD_W(3, __Vtemp_45, __Vtemp_43, __Vtemp_44);
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 
                            = (0x0000000fffffffffULL 
                               & (((QData)((IData)(
                                                   (0x000000ffU 
                                                    & __Vtemp_45[2U]))) 
                                   << 0x0000001cU) 
                                  | ((QData)((IData)(__Vtemp_45[1U])) 
                                     >> 4U)));
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
                            = (0x0000000fffffffffULL 
                               & (((QData)((IData)(
                                                   (0x0007ffffU 
                                                    & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result)))) 
                                   << 0x00000011U) 
                                  + ((QData)((IData)(
                                                     (0x0007ffffU 
                                                      & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result)))) 
                                     << 0x00000011U)));
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle = 7U;
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2 
                            = (0x0003ffffU & (IData)(
                                                     (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                                                      >> 0x10U)));
                    }
                } else if ((7U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
                    if ((0U != (3U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
                                              >> 0x00000022U))))) {
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle = 0x0000000aU;
                    } else {
                        __Vtemp_48[0U] = (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2);
                        __Vtemp_48[1U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1) 
                                           << 4U) | (IData)(
                                                            (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
                                                             >> 0x00000020U)));
                        __Vtemp_48[2U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1) 
                                           >> 0x0000001cU) 
                                          | ((IData)(
                                                     (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 
                                                      >> 0x00000020U)) 
                                             << 4U));
                        __Vtemp_49[0U] = 0U;
                        __Vtemp_49[1U] = ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result) 
                                          << 4U);
                        __Vtemp_49[2U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result) 
                                           >> 0x0000001cU) 
                                          | ((IData)(
                                                     (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
                                                      >> 0x00000020U)) 
                                             << 4U));
                        VL_ADD_W(3, __Vtemp_50, __Vtemp_48, __Vtemp_49);
                        __Vtemp_51[0U] = (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result);
                        __Vtemp_51[1U] = (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result 
                                                  >> 0x00000020U));
                        __Vtemp_51[2U] = 0U;
                        VL_ADD_W(3, __Vtemp_52, __Vtemp_50, __Vtemp_51);
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 
                            = (0x0000000fffffffffULL 
                               & (((QData)((IData)(
                                                   (0x000000ffU 
                                                    & __Vtemp_52[2U]))) 
                                   << 0x0000001cU) 
                                  | ((QData)((IData)(__Vtemp_52[1U])) 
                                     >> 4U)));
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
                            = (0x0000000fffffffffULL 
                               & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
                                  + vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result));
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle 
                            = ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__julia_type)
                                ? 9U : 8U);
                    }
                } else {
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                        = (0x0000000fffffffffULL & 
                           (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                            + VL_SHIFTL_QQI(36,36,32, 
                                            (((QData)((IData)(
                                                              (0x0003ffffU 
                                                               & (- (IData)(
                                                                            (1U 
                                                                             & (vlSelfRef.tb_multiply_manager_render__DOT__julia_c_x 
                                                                                >> 0x11U))))))) 
                                              << 0x00000012U) 
                                             | (QData)((IData)(vlSelfRef.tb_multiply_manager_render__DOT__julia_c_x))), 0x00000010U)));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1 
                        = (0x0000ffffU & ((IData)(1U) 
                                          + (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1)));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                        = (0x0000000fffffffffULL & 
                           (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 
                            + VL_SHIFTL_QQI(36,36,32, 
                                            (((QData)((IData)(
                                                              (0x0003ffffU 
                                                               & (- (IData)(
                                                                            (1U 
                                                                             & (vlSelfRef.tb_multiply_manager_render__DOT__julia_c_y 
                                                                                >> 0x11U))))))) 
                                              << 0x00000012U) 
                                             | (QData)((IData)(vlSelfRef.tb_multiply_manager_render__DOT__julia_c_y))), 0x00000010U)));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle 
                        = ((0U != (3U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
                                                 >> 0x00000022U))))
                            ? 0x0000000aU : 1U);
                }
            } else if ((8U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
                __Vtemp_55[0U] = (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2);
                __Vtemp_55[1U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1) 
                                   << 4U) | (IData)(
                                                    (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                                                     >> 0x00000020U)));
                __Vtemp_55[2U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1) 
                                   >> 0x0000001cU) 
                                  | ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                              >> 0x00000020U)) 
                                     << 4U));
                __Vtemp_56[0U] = (IData)(((QData)((IData)(
                                                          (0x0001ffffU 
                                                           & vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_2))) 
                                          << 0x00000023U));
                __Vtemp_56[1U] = ((((0x000c0000U & 
                                     ((- (IData)((1U 
                                                  & (vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_1 
                                                     >> 0x11U)))) 
                                      << 0x00000012U)) 
                                    | vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_1) 
                                   << 0x00000014U) 
                                  | (IData)((((QData)((IData)(
                                                              (0x0001ffffU 
                                                               & vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_2))) 
                                              << 0x00000023U) 
                                             >> 0x00000020U)));
                __Vtemp_56[2U] = (((0x000c0000U & (
                                                   (- (IData)(
                                                              (1U 
                                                               & (vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_1 
                                                                  >> 0x11U)))) 
                                                   << 0x00000012U)) 
                                   | vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_1) 
                                  >> 0x0000000cU);
                VL_ADD_W(3, __Vtemp_57, __Vtemp_55, __Vtemp_56);
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                    = (0x0000000fffffffffULL & (((QData)((IData)(
                                                                 (0x000000ffU 
                                                                  & __Vtemp_57[2U]))) 
                                                 << 0x0000001cU) 
                                                | ((QData)((IData)(__Vtemp_57[1U])) 
                                                   >> 4U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1 
                    = (0x0000ffffU & ((IData)(1U) + (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                                                + ((QData)((IData)(
                                                                   (1U 
                                                                    & vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_2))) 
                                                   << 0x00000023U)));
                __Vtemp_60[0U] = (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2);
                __Vtemp_60[1U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1) 
                                   << 4U) | (IData)(
                                                    (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
                                                     >> 0x00000020U)));
                __Vtemp_60[2U] = (((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1) 
                                   >> 0x0000001cU) 
                                  | ((IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 
                                              >> 0x00000020U)) 
                                     << 4U));
                __Vtemp_61[0U] = (IData)(((QData)((IData)(
                                                          (0x0001ffffU 
                                                           & vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_2))) 
                                          << 0x00000023U));
                __Vtemp_61[1U] = ((((0x000c0000U & 
                                     ((- (IData)((1U 
                                                  & (vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_1 
                                                     >> 0x11U)))) 
                                      << 0x00000012U)) 
                                    | vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_1) 
                                   << 0x00000014U) 
                                  | (IData)((((QData)((IData)(
                                                              (0x0001ffffU 
                                                               & vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_2))) 
                                              << 0x00000023U) 
                                             >> 0x00000020U)));
                __Vtemp_61[2U] = (((0x000c0000U & (
                                                   (- (IData)(
                                                              (1U 
                                                               & (vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_1 
                                                                  >> 0x11U)))) 
                                                   << 0x00000012U)) 
                                   | vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_1) 
                                  >> 0x0000000cU);
                VL_ADD_W(3, __Vtemp_62, __Vtemp_60, __Vtemp_61);
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                    = (0x0000000fffffffffULL & (((QData)((IData)(
                                                                 (0x000000ffU 
                                                                  & __Vtemp_62[2U]))) 
                                                 << 0x0000001cU) 
                                                | ((QData)((IData)(__Vtemp_62[1U])) 
                                                   >> 4U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle 
                    = ((0U != (3U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
                                             >> 0x00000022U))))
                        ? 0x0000000aU : 1U);
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
                                                + ((QData)((IData)(
                                                                   (1U 
                                                                    & vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_2))) 
                                                   << 0x00000023U)));
            } else if ((0x0000000aU == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
                if (vlSelfRef.tb_multiply_manager_render__DOT__received) {
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_thread = 0U;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_thread = 0U;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle = 0U;
                }
            } else {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle 
                    = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle;
            }
        }
        if (vlSelfRef.tb_multiply_manager_render__DOT__start_left) {
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status = 1U;
        }
        if (vlSelfRef.tb_multiply_manager_render__DOT__start_right) {
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status = 1U;
        }
        if (vlSelfRef.tb_multiply_manager_render__DOT__start_wide) {
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status = 2U;
        }
    }
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_thread 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_thread;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_thread 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_thread;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1_overflow_flag 
        = ((0U != (7U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                 >> 0x00000021U)))) 
           & (7U != (7U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                   >> 0x00000021U)))));
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result 
        = (0x0000000fffffffffULL & ((2U & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode))
                                     ? ((1U & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode))
                                         ? vlSelfRef.__VdfgRegularize_h6e95ff9d_0_5
                                         : VL_SHIFTL_QQI(36,36,32, vlSelfRef.__VdfgRegularize_h6e95ff9d_0_5, 1U))
                                     : ((1U & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode))
                                         ? VL_MULS_QQQ(36, 
                                                       (0x0000000fffffffffULL 
                                                        & VL_EXTENDS_QI(36,18, 
                                                                        (0x0003ffffU 
                                                                         & (IData)(
                                                                                (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                                                                                >> 0x00000010U))))), 
                                                       (0x0000000fffffffffULL 
                                                        & VL_EXTENDS_QI(36,18, 
                                                                        (0x0003ffffU 
                                                                         & (IData)(
                                                                                (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                                                                                >> 0x00000010U))))))
                                         : VL_MULS_QQQ(36, 
                                                       (0x0000000fffffffffULL 
                                                        & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2)), 
                                                       (0x0000000fffffffffULL 
                                                        & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2))))));
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
        = (0x0000000fffffffffULL & ((2U & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode))
                                     ? ((1U & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode))
                                         ? vlSelfRef.__VdfgRegularize_h6e95ff9d_0_4
                                         : VL_SHIFTL_QQI(36,36,32, vlSelfRef.__VdfgRegularize_h6e95ff9d_0_4, 1U))
                                     : ((1U & (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode))
                                         ? VL_MULS_QQQ(36, 
                                                       (0x0000000fffffffffULL 
                                                        & VL_EXTENDS_QI(36,18, 
                                                                        (0x0003ffffU 
                                                                         & (IData)(
                                                                                (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                                                                                >> 0x00000010U))))), 
                                                       (0x0000000fffffffffULL 
                                                        & VL_EXTENDS_QI(36,18, 
                                                                        (0x0003ffffU 
                                                                         & (IData)(
                                                                                (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                                                                                >> 0x00000010U))))))
                                         : VL_MULS_QQQ(36, 
                                                       (0x0000000fffffffffULL 
                                                        & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1)), 
                                                       (0x0000000fffffffffULL 
                                                        & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1))))));
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1;
    vlSelfRef.__VdfgRegularize_h6e95ff9d_0_5 = (0x0000000fffffffffULL 
                                                & VL_MULS_QQQ(36, 
                                                              (0x0000000fffffffffULL 
                                                               & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2)), 
                                                              (0x0000000fffffffffULL 
                                                               & VL_EXTENDS_QI(36,18, 
                                                                               (0x0003ffffU 
                                                                                & (IData)(
                                                                                (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                                                                                >> 0x00000010U)))))));
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1_overflow_flag 
        = ((0U != (7U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                                 >> 0x00000021U)))) 
           & (7U != (7U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                                   >> 0x00000021U)))));
    vlSelfRef.__VdfgRegularize_h6e95ff9d_0_4 = (0x0000000fffffffffULL 
                                                & VL_MULS_QQQ(36, 
                                                              (0x0000000fffffffffULL 
                                                               & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1)), 
                                                              (0x0000000fffffffffULL 
                                                               & VL_EXTENDS_QI(36,18, 
                                                                               (0x0003ffffU 
                                                                                & (IData)(
                                                                                (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                                                                                >> 0x00000010U)))))));
    if ((1U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status)) {
        vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode 
            = ((2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)
                ? 0U : ((3U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)
                         ? 1U : ((4U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)
                                  ? 2U : 0U)));
        vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode 
            = ((2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)
                ? 0U : ((3U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)
                         ? 1U : ((4U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)
                                  ? 2U : 0U)));
    } else if ((2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status)) {
        if ((2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 0U;
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 0U;
        } else if ((3U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 2U;
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 2U;
        } else if ((4U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 1U;
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 1U;
        } else if ((5U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 0U;
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 0U;
        } else if ((6U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 3U;
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 3U;
        } else if ((7U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 3U;
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 3U;
        } else {
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 0U;
            vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 0U;
        }
    } else {
        vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 0U;
        vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 0U;
    }
    vlSelfRef.tb_multiply_manager_render__DOT__done = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__done_side = 0U;
    if ((1U & (~ ((2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status) 
                  & (0x0000000aU == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle))))) {
        if ((1U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status)) {
            if ((7U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)) {
                vlSelfRef.tb_multiply_manager_render__DOT__done_side = 0U;
            }
            if ((7U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)) {
                vlSelfRef.tb_multiply_manager_render__DOT__done_side = 1U;
            }
        }
    }
    vlSelfRef.tb_multiply_manager_render__DOT__iteration_out 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1;
    if (((2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status) 
         & (0x0000000aU == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle))) {
        vlSelfRef.tb_multiply_manager_render__DOT__done = 1U;
        vlSelfRef.tb_multiply_manager_render__DOT__iteration_out 
            = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1;
    } else if ((1U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status)) {
        if ((7U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)) {
            vlSelfRef.tb_multiply_manager_render__DOT__done = 1U;
            vlSelfRef.tb_multiply_manager_render__DOT__iteration_out 
                = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1;
        }
        if ((7U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)) {
            vlSelfRef.tb_multiply_manager_render__DOT__done = 1U;
            vlSelfRef.tb_multiply_manager_render__DOT__iteration_out 
                = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2;
        }
    }
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__is_wide 
        = ((1U != vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status) 
           && (2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status));
}

void Vtb_multiply_manager_render___024root___eval_nba(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___eval_nba\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vtb_multiply_manager_render___024root___nba_sequent__TOP__0(vlSelf);
    }
    if ((3ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vtb_multiply_manager_render___024root___act_comb__TOP__0(vlSelf);
    }
}

void Vtb_multiply_manager_render___024root___timing_ready(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___timing_ready\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VactTriggered[0U])) {
        vlSelfRef.__VtrigSched_h4f6f6a48__0.ready("@(posedge tb_multiply_manager_render.clk)");
    }
    if ((2ULL & vlSelfRef.__VactTriggered[0U])) {
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready("@(negedge tb_multiply_manager_render.clk)");
    }
}

void Vtb_multiply_manager_render___024root___timing_resume(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___timing_resume\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VtrigSched_h4f6f6a48__0.moveToResumeQueue(
                                                          "@(posedge tb_multiply_manager_render.clk)");
    vlSelfRef.__VtrigSched_h4f6f6b02__0.moveToResumeQueue(
                                                          "@(negedge tb_multiply_manager_render.clk)");
    vlSelfRef.__VtrigSched_h4f6f6a48__0.resume("@(posedge tb_multiply_manager_render.clk)");
    vlSelfRef.__VtrigSched_h4f6f6b02__0.resume("@(negedge tb_multiply_manager_render.clk)");
    if ((4ULL & vlSelfRef.__VactTriggered[0U])) {
        vlSelfRef.__VdlySched.resume();
    }
}

void Vtb_multiply_manager_render___024root___trigger_orInto__act_vec_vec(VlUnpacked<QData/*63:0*/, 1> &out, const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___trigger_orInto__act_vec_vec\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = (out[n] | in[n]);
        n = ((IData)(1U) + n);
    } while ((0U >= n));
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_multiply_manager_render___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vtb_multiply_manager_render___024root___eval_phase__act(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___eval_phase__act\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VactExecute;
    // Body
    Vtb_multiply_manager_render___024root___eval_triggers_vec__act(vlSelf);
    Vtb_multiply_manager_render___024root___timing_ready(vlSelf);
    Vtb_multiply_manager_render___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VactTriggered, vlSelfRef.__VactTriggeredAcc);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtb_multiply_manager_render___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
    }
#endif
    Vtb_multiply_manager_render___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VnbaTriggered, vlSelfRef.__VactTriggered);
    __VactExecute = Vtb_multiply_manager_render___024root___trigger_anySet__act(vlSelfRef.__VactTriggered);
    if (__VactExecute) {
        vlSelfRef.__VactTriggeredAcc.fill(0ULL);
        Vtb_multiply_manager_render___024root___timing_resume(vlSelf);
        Vtb_multiply_manager_render___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vtb_multiply_manager_render___024root___eval_phase__inact(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___eval_phase__inact\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VinactExecute;
    // Body
    __VinactExecute = vlSelfRef.__VdlySched.awaitingZeroDelay();
    if (__VinactExecute) {
        VL_FATAL_MT("tb_multiply_manager_render.sv", 7, "", "ZERODLY: Design Verilated with '--no-sched-zero-delay', but #0 delay executed at runtime");
    }
    return (__VinactExecute);
}

void Vtb_multiply_manager_render___024root___trigger_clear__act(VlUnpacked<QData/*63:0*/, 1> &out) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___trigger_clear__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = 0ULL;
        n = ((IData)(1U) + n);
    } while ((1U > n));
}

bool Vtb_multiply_manager_render___024root___eval_phase__nba(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___eval_phase__nba\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = Vtb_multiply_manager_render___024root___trigger_anySet__act(vlSelfRef.__VnbaTriggered);
    if (__VnbaExecute) {
        Vtb_multiply_manager_render___024root___eval_nba(vlSelf);
        Vtb_multiply_manager_render___024root___trigger_clear__act(vlSelfRef.__VnbaTriggered);
    }
    return (__VnbaExecute);
}

void Vtb_multiply_manager_render___024root___eval(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___eval\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VnbaIterCount;
    // Body
    __VnbaIterCount = 0U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vtb_multiply_manager_render___024root___dump_triggers__act(vlSelfRef.__VnbaTriggered, "nba"s);
#endif
            VL_FATAL_MT("tb_multiply_manager_render.sv", 7, "", "DIDNOTCONVERGE: NBA region did not converge after '--converge-limit' of 10000 tries");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        vlSelfRef.__VinactIterCount = 0U;
        do {
            if (VL_UNLIKELY(((0x00002710U < vlSelfRef.__VinactIterCount)))) {
                VL_FATAL_MT("tb_multiply_manager_render.sv", 7, "", "DIDNOTCONVERGE: Inactive region did not converge after '--converge-limit' of 10000 tries");
            }
            vlSelfRef.__VinactIterCount = ((IData)(1U) 
                                           + vlSelfRef.__VinactIterCount);
            vlSelfRef.__VactIterCount = 0U;
            do {
                if (VL_UNLIKELY(((0x00002710U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                    Vtb_multiply_manager_render___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
#endif
                    VL_FATAL_MT("tb_multiply_manager_render.sv", 7, "", "DIDNOTCONVERGE: Active region did not converge after '--converge-limit' of 10000 tries");
                }
                vlSelfRef.__VactIterCount = ((IData)(1U) 
                                             + vlSelfRef.__VactIterCount);
                vlSelfRef.__VactPhaseResult = Vtb_multiply_manager_render___024root___eval_phase__act(vlSelf);
            } while (vlSelfRef.__VactPhaseResult);
            vlSelfRef.__VinactPhaseResult = Vtb_multiply_manager_render___024root___eval_phase__inact(vlSelf);
        } while (vlSelfRef.__VinactPhaseResult);
        vlSelfRef.__VnbaPhaseResult = Vtb_multiply_manager_render___024root___eval_phase__nba(vlSelf);
    } while (vlSelfRef.__VnbaPhaseResult);
}

void Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6a48__0(Vtb_multiply_manager_render___024root* vlSelf, const char* __VeventDescription) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6a48__0\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    VlUnpacked<QData/*63:0*/, 1> __VTmp;
    // Body
    __VTmp[0U] = (QData)((IData)(((((~ (IData)(vlSelfRef.tb_multiply_manager_render__DOT__clk)) 
                                    & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_multiply_manager_render__DOT__clk__0)) 
                                   << 1U) | ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__clk) 
                                             & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_multiply_manager_render__DOT__clk__0))))));
    vlSelfRef.__Vtrigprevexpr___TOP__tb_multiply_manager_render__DOT__clk__0 
        = vlSelfRef.tb_multiply_manager_render__DOT__clk;
    if ((1ULL & __VTmp[0U])) {
        vlSelfRef.__VtrigSched_h4f6f6a48__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6a48__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6a48__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6a48__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6a48__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6a48__0.ready(__VeventDescription);
    }
    if ((2ULL & __VTmp[0U])) {
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready(__VeventDescription);
    }
    vlSelfRef.__VactTriggeredAcc[0U] = (vlSelfRef.__VactTriggeredAcc[0U] 
                                        | __VTmp[0U]);
}

void Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(Vtb_multiply_manager_render___024root* vlSelf, const char* __VeventDescription) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    VlUnpacked<QData/*63:0*/, 1> __VTmp;
    // Body
    __VTmp[0U] = (QData)((IData)(((((~ (IData)(vlSelfRef.tb_multiply_manager_render__DOT__clk)) 
                                    & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_multiply_manager_render__DOT__clk__0)) 
                                   << 1U) | ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__clk) 
                                             & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_multiply_manager_render__DOT__clk__0))))));
    vlSelfRef.__Vtrigprevexpr___TOP__tb_multiply_manager_render__DOT__clk__0 
        = vlSelfRef.tb_multiply_manager_render__DOT__clk;
    if ((1ULL & __VTmp[0U])) {
        vlSelfRef.__VtrigSched_h4f6f6a48__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6a48__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6a48__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6a48__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6a48__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6a48__0.ready(__VeventDescription);
    }
    if ((2ULL & __VTmp[0U])) {
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h4f6f6b02__0.ready(__VeventDescription);
    }
    vlSelfRef.__VactTriggeredAcc[0U] = (vlSelfRef.__VactTriggeredAcc[0U] 
                                        | __VTmp[0U]);
}

#ifdef VL_DEBUG
void Vtb_multiply_manager_render___024root___eval_debug_assertions(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___eval_debug_assertions\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}
#endif  // VL_DEBUG
