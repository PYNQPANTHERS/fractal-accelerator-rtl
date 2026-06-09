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
    IData/*31:0*/ tb_multiply_manager_render__DOT__pixel_count;
    tb_multiply_manager_render__DOT__pixel_count = 0;
    IData/*31:0*/ tb_multiply_manager_render__DOT__unnamedblk1__DOT__row;
    tb_multiply_manager_render__DOT__unnamedblk1__DOT__row = 0;
    IData/*31:0*/ tb_multiply_manager_render__DOT__unnamedblk3__DOT__row;
    tb_multiply_manager_render__DOT__unnamedblk3__DOT__row = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_render__DOT__do_reset__0__tb_multiply_manager_render__DOT__unnamedblk1_1__DOT____Vrepeat0;
    __Vtask_tb_multiply_manager_render__DOT__do_reset__0__tb_multiply_manager_render__DOT__unnamedblk1_1__DOT____Vrepeat0 = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_q216__1__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__to_q216__1__Vfuncout = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_q216__1__v;
    __Vfunc_tb_multiply_manager_render__DOT__to_q216__1__v = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_q216__2__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__to_q216__2__Vfuncout = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_q216__2__v;
    __Vfunc_tb_multiply_manager_render__DOT__to_q216__2__v = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__px;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__px = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__py;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__py = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__count;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__count = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__cyc;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__cyc = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__4__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__4__Vfuncout = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__4__v;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__4__v = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__Vfuncout = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__v;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__full_int;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__full_int = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__coarse;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__coarse = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__residual;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__residual = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__6__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__6__Vfuncout = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__6__v;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__6__v = 0;
    IData/*17:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__Vfuncout;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__Vfuncout = 0;
    double __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__v;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__v = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__full_int;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__full_int = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__coarse;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__coarse = 0;
    QData/*63:0*/ __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__residual;
    __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__residual = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__xh;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__xh = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__xl;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__xl = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__yh;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__yh = 0;
    IData/*17:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__yl;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__yl = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__count;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__count = 0;
    IData/*31:0*/ __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__cyc;
    __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__cyc = 0;
    // Body
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
                                                             184);
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
                                                         184);
    VL_WRITEF_NX("=== NARROW MODE RENDER: 512x512, range [-1.50,1.50] ===\n",0);
    vlSelfRef.tb_multiply_manager_render__DOT__julia_type = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__magnitude_negation_encoding = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__max_iteration = 8U;
    vlSelfRef.tb_multiply_manager_render__DOT__julia_c_x = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__julia_c_y = 0U;
    tb_multiply_manager_render__DOT__fd = VL_FOPEN_NN("sim/render/frame_narrow.csv"s
                                                      , "w"s);
    ;
    if (VL_UNLIKELY(((1U & (~ (0U != tb_multiply_manager_render__DOT__fd)))))) {
        VL_WRITEF_NX("ERROR: cannot open frame_narrow.csv\n",0);
        VL_FINISH_MT("tb_multiply_manager_render.sv", 277, "");
    }
    VL_FWRITEF_NX(tb_multiply_manager_render__DOT__fd,"px,py,iterations\n",0);
    tb_multiply_manager_render__DOT__pixel_count = 0U;
    tb_multiply_manager_render__DOT__unnamedblk1__DOT__row = 0U;
    while (VL_GTS_III(32, 0x00000200U, tb_multiply_manager_render__DOT__unnamedblk1__DOT__row)) {
        vlSelfRef.tb_multiply_manager_render__DOT__cy 
            = (-1.50000000000000000e+00 + ((3.0 * VL_ISTOR_D_I(32, tb_multiply_manager_render__DOT__unnamedblk1__DOT__row)) 
                                           / 511.0));
        __Vfunc_tb_multiply_manager_render__DOT__to_q216__1__v 
            = vlSelfRef.tb_multiply_manager_render__DOT__cy;
        __Vfunc_tb_multiply_manager_render__DOT__to_q216__1__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_render__DOT__to_q216__1__Vfuncout 
            = (0x0003ffffU & VL_RTOIROUND_I_D(floor(
                                                    (6.55360000000000000e+04 
                                                     * __Vfunc_tb_multiply_manager_render__DOT__to_q216__1__v))));
        vlSelfRef.tb_multiply_manager_render__DOT__qy 
            = __Vfunc_tb_multiply_manager_render__DOT__to_q216__1__Vfuncout;
        vlSelfRef.tb_multiply_manager_render__DOT__unnamedblk1__DOT__unnamedblk2__DOT__col = 0U;
        while (VL_GTS_III(32, 0x00000200U, vlSelfRef.tb_multiply_manager_render__DOT__unnamedblk1__DOT__unnamedblk2__DOT__col)) {
            vlSelfRef.tb_multiply_manager_render__DOT__cx 
                = (-1.50000000000000000e+00 + ((3.0 
                                                * VL_ISTOR_D_I(32, vlSelfRef.tb_multiply_manager_render__DOT__unnamedblk1__DOT__unnamedblk2__DOT__col)) 
                                               / 511.0));
            __Vfunc_tb_multiply_manager_render__DOT__to_q216__2__v 
                = vlSelfRef.tb_multiply_manager_render__DOT__cx;
            __Vfunc_tb_multiply_manager_render__DOT__to_q216__2__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_render__DOT__to_q216__2__Vfuncout 
                = (0x0003ffffU & VL_RTOIROUND_I_D(floor(
                                                        (6.55360000000000000e+04 
                                                         * __Vfunc_tb_multiply_manager_render__DOT__to_q216__2__v))));
            vlSelfRef.tb_multiply_manager_render__DOT__qx 
                = __Vfunc_tb_multiply_manager_render__DOT__to_q216__2__Vfuncout;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__py 
                = vlSelfRef.tb_multiply_manager_render__DOT__qy;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__px 
                = vlSelfRef.tb_multiply_manager_render__DOT__qx;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__count = 0U;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__cyc = 0U;
            vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_2 
                = __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__px;
            vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_2 
                = __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__py;
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(vlSelf, 
                                                                              "@(negedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6b02__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(negedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 200);
            vlSelfRef.tb_multiply_manager_render__DOT__start_right = 1U;
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(vlSelf, 
                                                                              "@(negedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6b02__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(negedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 200);
            vlSelfRef.tb_multiply_manager_render__DOT__start_right = 0U;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__cyc = 0U;
            while (((~ (IData)(vlSelfRef.tb_multiply_manager_render__DOT__done)) 
                    & (0x000f4240U >= __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__cyc))) {
                Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6a48__0(vlSelf, 
                                                                                "@(posedge tb_multiply_manager_render.clk)");
                co_await vlSelfRef.__VtrigSched_h4f6f6a48__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge tb_multiply_manager_render.clk)", 
                                                                     "tb_multiply_manager_render.sv", 
                                                                     204);
                __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__cyc 
                    = ((IData)(1U) + __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__cyc);
            }
            __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__count 
                = ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__done)
                    ? (IData)(vlSelfRef.tb_multiply_manager_render__DOT__iteration_out)
                    : 0U);
            if (VL_UNLIKELY(((1U & (~ (IData)(vlSelfRef.tb_multiply_manager_render__DOT__done)))))) {
                VL_WRITEF_NX("NARROW TIMEOUT at (%0d,%0d)\n",2
                             , '~',18,__Vtask_tb_multiply_manager_render__DOT__run_pixel__3__px
                             , '~',18,__Vtask_tb_multiply_manager_render__DOT__run_pixel__3__py);
            }
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(vlSelf, 
                                                                              "@(negedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6b02__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(negedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 210);
            vlSelfRef.tb_multiply_manager_render__DOT__received = 1U;
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(vlSelf, 
                                                                              "@(negedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6b02__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(negedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 210);
            vlSelfRef.tb_multiply_manager_render__DOT__received = 0U;
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6a48__0(vlSelf, 
                                                                              "@(posedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6a48__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(posedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 210);
            vlSelfRef.tb_multiply_manager_render__DOT__iter_result 
                = __Vtask_tb_multiply_manager_render__DOT__run_pixel__3__count;
            VL_FWRITEF_NX(tb_multiply_manager_render__DOT__fd,"%0d,%0d,%0d\n",3
                          , '~',32,vlSelfRef.tb_multiply_manager_render__DOT__unnamedblk1__DOT__unnamedblk2__DOT__col
                          , '~',32,tb_multiply_manager_render__DOT__unnamedblk1__DOT__row
                          , '#',32,vlSelfRef.tb_multiply_manager_render__DOT__iter_result);
            tb_multiply_manager_render__DOT__pixel_count 
                = ((IData)(1U) + tb_multiply_manager_render__DOT__pixel_count);
            vlSelfRef.tb_multiply_manager_render__DOT__unnamedblk1__DOT__unnamedblk2__DOT__col 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_render__DOT__unnamedblk1__DOT__unnamedblk2__DOT__col);
        }
        if (VL_UNLIKELY(((0x0000001fU == VL_MODDIVS_III(32, tb_multiply_manager_render__DOT__unnamedblk1__DOT__row, (IData)(0x00000020U)))))) {
            VL_WRITEF_NX("  [narrow] row %0d / 512  (%0d pixels)\n",2
                         , '~',32,((IData)(1U) + tb_multiply_manager_render__DOT__unnamedblk1__DOT__row)
                         , '#',32,tb_multiply_manager_render__DOT__pixel_count);
        }
        tb_multiply_manager_render__DOT__unnamedblk1__DOT__row 
            = ((IData)(1U) + tb_multiply_manager_render__DOT__unnamedblk1__DOT__row);
    }
    VL_FCLOSE_I(tb_multiply_manager_render__DOT__fd); VL_WRITEF_NX("Narrow render complete. %0d pixels \342\206\222 sim/render/frame_narrow.csv\n\n=== WIDE MODE RENDER: same view as narrow ===\n",1
                                                                   , '#',32,tb_multiply_manager_render__DOT__pixel_count);
    vlSelfRef.tb_multiply_manager_render__DOT__julia_type = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__magnitude_negation_encoding = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__max_iteration = 8U;
    vlSelfRef.tb_multiply_manager_render__DOT__julia_c_x = 0U;
    vlSelfRef.tb_multiply_manager_render__DOT__julia_c_y = 0U;
    tb_multiply_manager_render__DOT__fd = VL_FOPEN_NN("sim/render/frame_wide.csv"s
                                                      , "w"s);
    ;
    if (VL_UNLIKELY(((1U & (~ (0U != tb_multiply_manager_render__DOT__fd)))))) {
        VL_WRITEF_NX("ERROR: cannot open frame_wide.csv\n",0);
        VL_FINISH_MT("tb_multiply_manager_render.sv", 322, "");
    }
    VL_FWRITEF_NX(tb_multiply_manager_render__DOT__fd,"px,py,iterations\n",0);
    tb_multiply_manager_render__DOT__pixel_count = 0U;
    tb_multiply_manager_render__DOT__unnamedblk3__DOT__row = 0U;
    while (VL_GTS_III(32, 0x00000200U, tb_multiply_manager_render__DOT__unnamedblk3__DOT__row)) {
        vlSelfRef.tb_multiply_manager_render__DOT__cy 
            = (-1.50000000000000000e+00 + ((3.0 * VL_ISTOR_D_I(32, tb_multiply_manager_render__DOT__unnamedblk3__DOT__row)) 
                                           / 511.0));
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__4__v 
            = vlSelfRef.tb_multiply_manager_render__DOT__cy;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__4__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__4__Vfuncout 
            = (0x0003ffffU & VL_RTOIROUND_I_D(floor(
                                                    (6.55360000000000000e+04 
                                                     * __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__4__v))));
        vlSelfRef.tb_multiply_manager_render__DOT__wyh 
            = __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__4__Vfuncout;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__v 
            = vlSelfRef.tb_multiply_manager_render__DOT__cy;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__Vfuncout = 0;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__full_int = 0ULL;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__coarse = 0ULL;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__residual = 0ULL;
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__full_int 
            = VL_RTOIROUND_Q_D(floor((8.58993459200000000e+09 
                                      * __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__v)));
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__coarse 
            = VL_RTOIROUND_Q_D(floor((6.55360000000000000e+04 
                                      * __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__v)));
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__residual 
            = (__Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__full_int 
               - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__coarse, 0x00000011U));
        __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__Vfuncout 
            = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__residual));
        vlSelfRef.tb_multiply_manager_render__DOT__wyl 
            = __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__5__Vfuncout;
        vlSelfRef.tb_multiply_manager_render__DOT__unnamedblk3__DOT__unnamedblk4__DOT__col = 0U;
        while (VL_GTS_III(32, 0x00000200U, vlSelfRef.tb_multiply_manager_render__DOT__unnamedblk3__DOT__unnamedblk4__DOT__col)) {
            vlSelfRef.tb_multiply_manager_render__DOT__cx 
                = (-1.50000000000000000e+00 + ((3.0 
                                                * VL_ISTOR_D_I(32, vlSelfRef.tb_multiply_manager_render__DOT__unnamedblk3__DOT__unnamedblk4__DOT__col)) 
                                               / 511.0));
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__6__v 
                = vlSelfRef.tb_multiply_manager_render__DOT__cx;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__6__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__6__Vfuncout 
                = (0x0003ffffU & VL_RTOIROUND_I_D(floor(
                                                        (6.55360000000000000e+04 
                                                         * __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__6__v))));
            vlSelfRef.tb_multiply_manager_render__DOT__wxh 
                = __Vfunc_tb_multiply_manager_render__DOT__to_wide_high__6__Vfuncout;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__v 
                = vlSelfRef.tb_multiply_manager_render__DOT__cx;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__Vfuncout = 0;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__full_int = 0ULL;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__coarse = 0ULL;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__residual = 0ULL;
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__full_int 
                = VL_RTOIROUND_Q_D(floor((8.58993459200000000e+09 
                                          * __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__v)));
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__coarse 
                = VL_RTOIROUND_Q_D(floor((6.55360000000000000e+04 
                                          * __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__v)));
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__residual 
                = (__Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__full_int 
                   - VL_SHIFTL_QQI(64,64,32, __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__coarse, 0x00000011U));
            __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__Vfuncout 
                = (0x0001ffffU & (IData)(__Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__residual));
            vlSelfRef.tb_multiply_manager_render__DOT__wxl 
                = __Vfunc_tb_multiply_manager_render__DOT__to_wide_low__7__Vfuncout;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__yl 
                = vlSelfRef.tb_multiply_manager_render__DOT__wyl;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__yh 
                = vlSelfRef.tb_multiply_manager_render__DOT__wyh;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__xl 
                = vlSelfRef.tb_multiply_manager_render__DOT__wxl;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__xh 
                = vlSelfRef.tb_multiply_manager_render__DOT__wxh;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__count = 0U;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__cyc = 0U;
            vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_1 
                = __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__xh;
            vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_2 
                = __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__xl;
            vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_1 
                = __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__yh;
            vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_2 
                = __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__yl;
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(vlSelf, 
                                                                              "@(negedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6b02__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(negedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 231);
            vlSelfRef.tb_multiply_manager_render__DOT__start_wide = 1U;
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(vlSelf, 
                                                                              "@(negedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6b02__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(negedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 231);
            vlSelfRef.tb_multiply_manager_render__DOT__start_wide = 0U;
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__cyc = 0U;
            while (((~ (IData)(vlSelfRef.tb_multiply_manager_render__DOT__done)) 
                    & (0x00989680U >= __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__cyc))) {
                Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6a48__0(vlSelf, 
                                                                                "@(posedge tb_multiply_manager_render.clk)");
                co_await vlSelfRef.__VtrigSched_h4f6f6a48__0.trigger(0U, 
                                                                     nullptr, 
                                                                     "@(posedge tb_multiply_manager_render.clk)", 
                                                                     "tb_multiply_manager_render.sv", 
                                                                     235);
                __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__cyc 
                    = ((IData)(1U) + __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__cyc);
            }
            __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__count 
                = ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__done)
                    ? (IData)(vlSelfRef.tb_multiply_manager_render__DOT__iteration_out)
                    : 0U);
            if (VL_UNLIKELY(((1U & (~ (IData)(vlSelfRef.tb_multiply_manager_render__DOT__done)))))) {
                VL_WRITEF_NX("WIDE TIMEOUT at xh=%0d xl=%0d yh=%0d yl=%0d\n",4
                             , '~',18,__Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__xh
                             , '#',18,__Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__xl
                             , '~',18,__Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__yh
                             , '#',18,__Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__yl);
            }
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(vlSelf, 
                                                                              "@(negedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6b02__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(negedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 241);
            vlSelfRef.tb_multiply_manager_render__DOT__received = 1U;
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6b02__0(vlSelf, 
                                                                              "@(negedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6b02__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(negedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 241);
            vlSelfRef.tb_multiply_manager_render__DOT__received = 0U;
            Vtb_multiply_manager_render___024root____VbeforeTrig_h4f6f6a48__0(vlSelf, 
                                                                              "@(posedge tb_multiply_manager_render.clk)");
            co_await vlSelfRef.__VtrigSched_h4f6f6a48__0.trigger(0U, 
                                                                 nullptr, 
                                                                 "@(posedge tb_multiply_manager_render.clk)", 
                                                                 "tb_multiply_manager_render.sv", 
                                                                 241);
            vlSelfRef.tb_multiply_manager_render__DOT__iter_result 
                = __Vtask_tb_multiply_manager_render__DOT__run_pixel_wide__8__count;
            VL_FWRITEF_NX(tb_multiply_manager_render__DOT__fd,"%0d,%0d,%0d\n",3
                          , '~',32,vlSelfRef.tb_multiply_manager_render__DOT__unnamedblk3__DOT__unnamedblk4__DOT__col
                          , '~',32,tb_multiply_manager_render__DOT__unnamedblk3__DOT__row
                          , '#',32,vlSelfRef.tb_multiply_manager_render__DOT__iter_result);
            tb_multiply_manager_render__DOT__pixel_count 
                = ((IData)(1U) + tb_multiply_manager_render__DOT__pixel_count);
            vlSelfRef.tb_multiply_manager_render__DOT__unnamedblk3__DOT__unnamedblk4__DOT__col 
                = ((IData)(1U) + vlSelfRef.tb_multiply_manager_render__DOT__unnamedblk3__DOT__unnamedblk4__DOT__col);
        }
        if (VL_UNLIKELY(((0x0000001fU == VL_MODDIVS_III(32, tb_multiply_manager_render__DOT__unnamedblk3__DOT__row, (IData)(0x00000020U)))))) {
            VL_WRITEF_NX("  [wide]   row %0d / 512  (%0d pixels)\n",2
                         , '~',32,((IData)(1U) + tb_multiply_manager_render__DOT__unnamedblk3__DOT__row)
                         , '#',32,tb_multiply_manager_render__DOT__pixel_count);
        }
        tb_multiply_manager_render__DOT__unnamedblk3__DOT__row 
            = ((IData)(1U) + tb_multiply_manager_render__DOT__unnamedblk3__DOT__row);
    }
    VL_FCLOSE_I(tb_multiply_manager_render__DOT__fd); VL_WRITEF_NX("Wide render complete. %0d pixels \342\206\222 sim/render/frame_wide.csv\nRun:  python3 render.py --input sim/render/frame_narrow.csv --output frame_narrow.png\n      python3 render.py --input sim/render/frame_wide.csv   --output frame_wide.png\n",1
                                                                   , '#',32,tb_multiply_manager_render__DOT__pixel_count);
    VL_FINISH_MT("tb_multiply_manager_render.sv", 346, "");
    co_return;
}

VlCoroutine Vtb_multiply_manager_render___024root___eval_initial__TOP__Vtiming__1(Vtb_multiply_manager_render___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_multiply_manager_render___024root___eval_initial__TOP__Vtiming__1\n"); );
    Vtb_multiply_manager_render__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    co_await vlSelfRef.__VdlySched.delay(0x000009184e72a000ULL, 
                                         nullptr, "tb_multiply_manager_render.sv", 
                                         355);
    VL_WRITEF_NX("==== GLOBAL TIMEOUT ====\n",0);
    VL_FINISH_MT("tb_multiply_manager_render.sv", 357, "");
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
                                             128);
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
    CData/*1:0*/ tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode;
    tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 0;
    CData/*1:0*/ tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode;
    tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 0;
    QData/*35:0*/ __VdfgRegularize_h6e95ff9d_0_4;
    __VdfgRegularize_h6e95ff9d_0_4 = 0;
    QData/*35:0*/ __VdfgRegularize_h6e95ff9d_0_6;
    __VdfgRegularize_h6e95ff9d_0_6 = 0;
    QData/*35:0*/ __VdfgRegularize_h6e95ff9d_0_7;
    __VdfgRegularize_h6e95ff9d_0_7 = 0;
    QData/*35:0*/ __VdfgRegularize_h6e95ff9d_0_8;
    __VdfgRegularize_h6e95ff9d_0_8 = 0;
    QData/*35:0*/ __VdfgRegularize_h6e95ff9d_0_10;
    __VdfgRegularize_h6e95ff9d_0_10 = 0;
    QData/*35:0*/ __VdfgRegularize_h6e95ff9d_0_11;
    __VdfgRegularize_h6e95ff9d_0_11 = 0;
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
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2;
    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1;
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
                    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1 
                        = (0x0003ffffU & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_1 
                                                  >> 0x10U)));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_1;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle 
                        = ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_max_iteration_flag)
                            ? 7U : 2U);
                }
            } else if ((2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                    = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result;
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
                    = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result;
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle = 3U;
            } else if ((3U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                                - vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
                                                + vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle 
                    = ((0U != (3U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
                                             >> 0x00000022U))))
                        ? 7U : 4U);
            } else if ((4U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)) {
                if ((0U != (3U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1 
                                          >> 0x00000022U))))) {
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle = 7U;
                } else {
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle 
                        = ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__julia_type)
                            ? 6U : 5U);
                }
            } else if ((6U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                                + VL_SHIFTL_QQI(36,36,32, 
                                                                VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__julia_c_x), 0x00000010U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                                                + VL_SHIFTL_QQI(36,36,32, 
                                                                VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__julia_c_y), 0x00000010U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1 
                    = (0x0000ffffU & ((IData)(1U) + (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle = 1U;
            } else if ((5U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                                + VL_SHIFTL_QQI(36,36,32, 
                                                                VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_1), 0x00000010U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                                                + VL_SHIFTL_QQI(36,36,32, 
                                                                VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_1), 0x00000010U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1 
                    = (0x0000ffffU & ((IData)(1U) + (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle = 1U;
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
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                    = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result;
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 
                    = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result;
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle = 3U;
            } else if ((3U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                                                - vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 
                                                + vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle 
                    = ((0U != (3U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 
                                             >> 0x00000022U))))
                        ? 7U : 4U);
            } else if ((4U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)) {
                if ((0U != (3U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2 
                                          >> 0x00000022U))))) {
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle = 7U;
                } else {
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle 
                        = ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__julia_type)
                            ? 6U : 5U);
                }
            } else if ((6U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                                                + VL_SHIFTL_QQI(36,36,32, 
                                                                VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__julia_c_x), 0x00000010U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                                                + VL_SHIFTL_QQI(36,36,32, 
                                                                VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__julia_c_y), 0x00000010U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2 
                    = (0x0000ffffU & ((IData)(1U) + (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle = 1U;
            } else if ((5U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)) {
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2 
                                                + VL_SHIFTL_QQI(36,36,32, 
                                                                VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__starting_x_reg_2), 0x00000010U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                    = (0x0000000fffffffffULL & (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                                                + VL_SHIFTL_QQI(36,36,32, 
                                                                VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_2), 0x00000010U)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2 
                    = (0x0000ffffU & ((IData)(1U) + (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2)));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle = 1U;
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
                                                          & (vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_1 
                                                             >> 0x11U))))))) 
                        << 0x00000022U) | (((QData)((IData)(vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_1)) 
                                            << 0x00000010U) 
                                           | (QData)((IData)(
                                                             (0x0000ffffU 
                                                              & (vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_2 
                                                                 >> 1U))))));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                    = ((QData)((IData)((1U & vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_2))) 
                       << 0x00000023U);
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 
                    = (((QData)((IData)((3U & (- (IData)(
                                                         (1U 
                                                          & (vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_1 
                                                             >> 0x11U))))))) 
                        << 0x00000022U) | (((QData)((IData)(vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_1)) 
                                            << 0x00000010U) 
                                           | (QData)((IData)(
                                                             (0x0000ffffU 
                                                              & (vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_2 
                                                                 >> 1U))))));
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2 
                    = ((QData)((IData)((1U & vlSelfRef.tb_multiply_manager_render__DOT__starting_y_reg_2))) 
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
                        vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1 
                            = (0x0003ffffU & (IData)(
                                                     (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_1 
                                                      >> 0x10U)));
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
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
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle 
                            = ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_max_iteration_flag)
                                ? 0x0000000aU : 2U);
                        __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                            = (QData)((IData)(((0x0001fffeU 
                                                & ((IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_1) 
                                                   << 1U)) 
                                               | (1U 
                                                  & (IData)(
                                                            (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_2 
                                                             >> 0x23U))))));
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
                                            VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__julia_c_x), 0x00000010U)));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1 
                        = (0x0000ffffU & ((IData)(1U) 
                                          + (IData)(vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1)));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                        = (0x0000000fffffffffULL & 
                           (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1 
                            + VL_SHIFTL_QQI(36,36,32, 
                                            VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__julia_c_x), 0x00000010U)));
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
                        = vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2;
                    __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle = 1U;
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
                __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle = 1U;
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
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__left_cycle;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__right_cycle;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle 
        = __Vdly__tb_multiply_manager_render__DOT__dut__DOT__joint_cycle;
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1_overflow_flag 
        = ((0U != (7U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                 >> 0x00000021U)))) 
           & (7U != (7U & (IData)((vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1 
                                   >> 0x00000021U)))));
    __VdfgRegularize_h6e95ff9d_0_7 = (0x0000000fffffffffULL 
                                      & VL_MULS_QQQ(36, 
                                                    (0x0000000fffffffffULL 
                                                     & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1)), 
                                                    (0x0000000fffffffffULL 
                                                     & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1))));
    __VdfgRegularize_h6e95ff9d_0_11 = (0x0000000fffffffffULL 
                                       & VL_MULS_QQQ(36, 
                                                     (0x0000000fffffffffULL 
                                                      & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2)), 
                                                     (0x0000000fffffffffULL 
                                                      & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2))));
    __VdfgRegularize_h6e95ff9d_0_10 = (0x0000000fffffffffULL 
                                       & VL_MULS_QQQ(36, 
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
                                                                                >> 0x00000010U)))))));
    __VdfgRegularize_h6e95ff9d_0_8 = (0x0000000fffffffffULL 
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
    __VdfgRegularize_h6e95ff9d_0_6 = (0x0000000fffffffffULL 
                                      & VL_MULS_QQQ(36, 
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
                                                                                >> 0x00000010U)))))));
    __VdfgRegularize_h6e95ff9d_0_4 = (0x0000000fffffffffULL 
                                      & VL_MULS_QQQ(36, 
                                                    (0x0000000fffffffffULL 
                                                     & VL_EXTENDS_QI(36,18, vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1)), 
                                                    (0x0000000fffffffffULL 
                                                     & VL_EXTENDS_QI(36,18, 
                                                                     (0x0003ffffU 
                                                                      & (IData)(
                                                                                (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1 
                                                                                >> 0x00000010U)))))));
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
    if ((1U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status)) {
        tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode 
            = ((2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)
                ? 0U : ((3U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)
                         ? 1U : ((4U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_cycle)
                                  ? 2U : 0U)));
        tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode 
            = ((2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)
                ? 0U : ((3U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)
                         ? 1U : ((4U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_cycle)
                                  ? 2U : 0U)));
    } else if ((2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status)) {
        if ((2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
            tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 0U;
            tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 0U;
        } else if ((3U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
            tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 2U;
            tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 2U;
        } else if ((4U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
            tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 1U;
            tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 1U;
        } else if ((5U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
            tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 0U;
            tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 0U;
        } else if ((6U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
            tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 3U;
            tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 3U;
        } else if ((7U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__joint_cycle)) {
            tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 3U;
            tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 3U;
        } else {
            tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 0U;
            tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 0U;
        }
    } else {
        tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode = 0U;
        tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode = 0U;
    }
    vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__is_wide 
        = ((1U != vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status) 
           && (2U == vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__grouping_status));
    if (vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__is_wide) {
        vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
            = (0x0000000fffffffffULL & ((2U & (IData)(tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode))
                                         ? ((1U & (IData)(tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode))
                                             ? __VdfgRegularize_h6e95ff9d_0_4
                                             : VL_SHIFTL_QQI(36,36,32, __VdfgRegularize_h6e95ff9d_0_4, 1U))
                                         : ((1U & (IData)(tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode))
                                             ? __VdfgRegularize_h6e95ff9d_0_6
                                             : __VdfgRegularize_h6e95ff9d_0_7)));
        vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result 
            = (0x0000000fffffffffULL & ((2U & (IData)(tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode))
                                         ? ((1U & (IData)(tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode))
                                             ? __VdfgRegularize_h6e95ff9d_0_8
                                             : VL_SHIFTL_QQI(36,36,32, __VdfgRegularize_h6e95ff9d_0_8, 1U))
                                         : ((1U & (IData)(tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode))
                                             ? __VdfgRegularize_h6e95ff9d_0_10
                                             : __VdfgRegularize_h6e95ff9d_0_11)));
    } else {
        vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result 
            = (0x0000000fffffffffULL & ((0U == (IData)(tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode))
                                         ? __VdfgRegularize_h6e95ff9d_0_7
                                         : ((1U == (IData)(tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode))
                                             ? __VdfgRegularize_h6e95ff9d_0_6
                                             : (VL_SHIFTL_QQI(36,36,32, __VdfgRegularize_h6e95ff9d_0_4, 1U) 
                                                & (- (QData)((IData)(
                                                                     (2U 
                                                                      == (IData)(tb_multiply_manager_render__DOT__dut__DOT__left_multiply_mode)))))))));
        vlSelfRef.tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result 
            = (0x0000000fffffffffULL & ((0U == (IData)(tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode))
                                         ? __VdfgRegularize_h6e95ff9d_0_11
                                         : ((1U == (IData)(tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode))
                                             ? __VdfgRegularize_h6e95ff9d_0_10
                                             : (VL_SHIFTL_QQI(36,36,32, __VdfgRegularize_h6e95ff9d_0_8, 1U) 
                                                & (- (QData)((IData)(
                                                                     (2U 
                                                                      == (IData)(tb_multiply_manager_render__DOT__dut__DOT__right_multiply_mode)))))))));
    }
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
        VL_FATAL_MT("tb_multiply_manager_render.sv", 43, "", "ZERODLY: Design Verilated with '--no-sched-zero-delay', but #0 delay executed at runtime");
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
            VL_FATAL_MT("tb_multiply_manager_render.sv", 43, "", "DIDNOTCONVERGE: NBA region did not converge after '--converge-limit' of 10000 tries");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        vlSelfRef.__VinactIterCount = 0U;
        do {
            if (VL_UNLIKELY(((0x00002710U < vlSelfRef.__VinactIterCount)))) {
                VL_FATAL_MT("tb_multiply_manager_render.sv", 43, "", "DIDNOTCONVERGE: Inactive region did not converge after '--converge-limit' of 10000 tries");
            }
            vlSelfRef.__VinactIterCount = ((IData)(1U) 
                                           + vlSelfRef.__VinactIterCount);
            vlSelfRef.__VactIterCount = 0U;
            do {
                if (VL_UNLIKELY(((0x00002710U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                    Vtb_multiply_manager_render___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
#endif
                    VL_FATAL_MT("tb_multiply_manager_render.sv", 43, "", "DIDNOTCONVERGE: Active region did not converge after '--converge-limit' of 10000 tries");
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
