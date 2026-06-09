// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_multiply_manager_render.h for the primary calling header

#ifndef VERILATED_VTB_MULTIPLY_MANAGER_RENDER___024ROOT_H_
#define VERILATED_VTB_MULTIPLY_MANAGER_RENDER___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vtb_multiply_manager_render__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_multiply_manager_render___024root final {
  public:

    // DESIGN SPECIFIC STATE
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        CData/*0:0*/ tb_multiply_manager_render__DOT__clk;
        CData/*0:0*/ tb_multiply_manager_render__DOT__rst;
        CData/*0:0*/ tb_multiply_manager_render__DOT__kill;
        CData/*0:0*/ tb_multiply_manager_render__DOT__received;
        CData/*0:0*/ tb_multiply_manager_render__DOT__start_left;
        CData/*0:0*/ tb_multiply_manager_render__DOT__start_right;
        CData/*0:0*/ tb_multiply_manager_render__DOT__start_wide;
        CData/*0:0*/ tb_multiply_manager_render__DOT__julia_type;
        CData/*3:0*/ tb_multiply_manager_render__DOT__magnitude_negation_encoding;
        CData/*4:0*/ tb_multiply_manager_render__DOT__max_iteration;
        CData/*0:0*/ tb_multiply_manager_render__DOT__done;
        CData/*0:0*/ tb_multiply_manager_render__DOT__done_side;
        CData/*0:0*/ tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1_overflow_flag;
        CData/*0:0*/ tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1_overflow_flag;
        CData/*0:0*/ tb_multiply_manager_render__DOT__dut__DOT__is_wide;
        CData/*0:0*/ tb_multiply_manager_render__DOT__dut__DOT__left_max_iteration_flag;
        CData/*0:0*/ __VstlFirstIteration;
        CData/*0:0*/ __VstlPhaseResult;
        CData/*0:0*/ __Vtrigprevexpr___TOP__tb_multiply_manager_render__DOT__clk__0;
        CData/*0:0*/ __VactPhaseResult;
        CData/*0:0*/ __VinactPhaseResult;
        CData/*0:0*/ __VnbaPhaseResult;
        SData/*15:0*/ tb_multiply_manager_render__DOT__iteration_out;
        SData/*15:0*/ tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_1;
        SData/*15:0*/ tb_multiply_manager_render__DOT__dut__DOT__iteration_reg_2;
        IData/*17:0*/ tb_multiply_manager_render__DOT__julia_c_x;
        IData/*17:0*/ tb_multiply_manager_render__DOT__julia_c_y;
        IData/*17:0*/ tb_multiply_manager_render__DOT__starting_x_reg_1;
        IData/*17:0*/ tb_multiply_manager_render__DOT__starting_x_reg_2;
        IData/*17:0*/ tb_multiply_manager_render__DOT__starting_y_reg_1;
        IData/*17:0*/ tb_multiply_manager_render__DOT__starting_y_reg_2;
        IData/*31:0*/ tb_multiply_manager_render__DOT__iter_result;
        IData/*17:0*/ tb_multiply_manager_render__DOT__qx;
        IData/*17:0*/ tb_multiply_manager_render__DOT__qy;
        IData/*17:0*/ tb_multiply_manager_render__DOT__wxh;
        IData/*17:0*/ tb_multiply_manager_render__DOT__wyh;
        IData/*17:0*/ tb_multiply_manager_render__DOT__wxl;
        IData/*17:0*/ tb_multiply_manager_render__DOT__wyl;
        IData/*31:0*/ tb_multiply_manager_render__DOT__unnamedblk1__DOT__unnamedblk2__DOT__col;
        IData/*31:0*/ tb_multiply_manager_render__DOT__unnamedblk3__DOT__unnamedblk4__DOT__col;
        IData/*17:0*/ tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_1;
        IData/*17:0*/ tb_multiply_manager_render__DOT__dut__DOT__spare_x_reg_2;
        IData/*31:0*/ tb_multiply_manager_render__DOT__dut__DOT__grouping_status;
        IData/*31:0*/ tb_multiply_manager_render__DOT__dut__DOT__left_thread;
        IData/*31:0*/ tb_multiply_manager_render__DOT__dut__DOT__left_cycle;
        IData/*31:0*/ tb_multiply_manager_render__DOT__dut__DOT__right_thread;
        IData/*31:0*/ tb_multiply_manager_render__DOT__dut__DOT__right_cycle;
        IData/*31:0*/ tb_multiply_manager_render__DOT__dut__DOT__joint_cycle;
        IData/*31:0*/ __VactIterCount;
        IData/*31:0*/ __VinactIterCount;
        IData/*31:0*/ __Vi;
        QData/*35:0*/ tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_1;
        QData/*35:0*/ tb_multiply_manager_render__DOT__dut__DOT__sum_x_reg_2;
        QData/*35:0*/ tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_1;
        QData/*35:0*/ tb_multiply_manager_render__DOT__dut__DOT__sum_y_reg_2;
        QData/*35:0*/ tb_multiply_manager_render__DOT__dut__DOT__wide_partial_1;
        QData/*35:0*/ tb_multiply_manager_render__DOT__dut__DOT__wide_partial_2;
        QData/*35:0*/ tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_1;
        QData/*35:0*/ tb_multiply_manager_render__DOT__dut__DOT__magnitude_reg_2;
        QData/*35:0*/ tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_1;
        QData/*35:0*/ tb_multiply_manager_render__DOT__dut__DOT__encoded_x_reg_2;
        QData/*35:0*/ tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_1;
        QData/*35:0*/ tb_multiply_manager_render__DOT__dut__DOT__encoded_y_reg_2;
        QData/*35:0*/ tb_multiply_manager_render__DOT__dut__DOT__left_multiply_result;
    };
    struct {
        QData/*35:0*/ tb_multiply_manager_render__DOT__dut__DOT__right_multiply_result;
        VlUnpacked<QData/*63:0*/, 1> __VstlTriggered;
        VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
        VlUnpacked<QData/*63:0*/, 1> __VactTriggeredAcc;
        VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;
    };
    double tb_multiply_manager_render__DOT__cx;
    double tb_multiply_manager_render__DOT__cy;
    VlDelayScheduler __VdlySched;
    VlTriggerScheduler __VtrigSched_h4f6f6a48__0;
    VlTriggerScheduler __VtrigSched_h4f6f6b02__0;

    // INTERNAL VARIABLES
    Vtb_multiply_manager_render__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vtb_multiply_manager_render___024root(Vtb_multiply_manager_render__Syms* symsp, const char* namep);
    ~Vtb_multiply_manager_render___024root();
    VL_UNCOPYABLE(Vtb_multiply_manager_render___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
