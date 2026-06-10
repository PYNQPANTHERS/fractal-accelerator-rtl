// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_multiply_manager_wide.h for the primary calling header

#ifndef VERILATED_VTB_MULTIPLY_MANAGER_WIDE___024ROOT_H_
#define VERILATED_VTB_MULTIPLY_MANAGER_WIDE___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vtb_multiply_manager_wide__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_multiply_manager_wide___024root final {
  public:

    // DESIGN SPECIFIC STATE
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        CData/*0:0*/ tb_multiply_manager_wide__DOT__clk;
        CData/*0:0*/ tb_multiply_manager_wide__DOT__rst;
        CData/*0:0*/ tb_multiply_manager_wide__DOT__kill;
        CData/*0:0*/ tb_multiply_manager_wide__DOT__received;
        CData/*0:0*/ tb_multiply_manager_wide__DOT__start_left;
        CData/*0:0*/ tb_multiply_manager_wide__DOT__start_right;
        CData/*0:0*/ tb_multiply_manager_wide__DOT__start_wide;
        CData/*0:0*/ tb_multiply_manager_wide__DOT__julia_type;
        CData/*3:0*/ tb_multiply_manager_wide__DOT__magnitude_negation_encoding;
        CData/*4:0*/ tb_multiply_manager_wide__DOT__max_iteration;
        CData/*0:0*/ tb_multiply_manager_wide__DOT__done;
        CData/*0:0*/ tb_multiply_manager_wide__DOT__done_side;
        CData/*0:0*/ tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1_overflow_flag;
        CData/*0:0*/ tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1_overflow_flag;
        CData/*0:0*/ tb_multiply_manager_wide__DOT__dut__DOT__is_wide;
        CData/*1:0*/ tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_mode;
        CData/*1:0*/ tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_mode;
        CData/*0:0*/ tb_multiply_manager_wide__DOT__dut__DOT__left_max_iteration_flag;
        CData/*0:0*/ __VstlFirstIteration;
        CData/*0:0*/ __VstlPhaseResult;
        CData/*0:0*/ __Vtrigprevexpr___TOP__tb_multiply_manager_wide__DOT__clk__0;
        CData/*0:0*/ __VactPhaseResult;
        CData/*0:0*/ __VinactPhaseResult;
        CData/*0:0*/ __VnbaPhaseResult;
        SData/*15:0*/ tb_multiply_manager_wide__DOT__iteration_out;
        SData/*15:0*/ tb_multiply_manager_wide__DOT__dut__DOT__iteration_reg_1;
        SData/*15:0*/ tb_multiply_manager_wide__DOT__dut__DOT__iteration_reg_2;
        IData/*17:0*/ tb_multiply_manager_wide__DOT__julia_c_x;
        IData/*17:0*/ tb_multiply_manager_wide__DOT__julia_c_y;
        IData/*17:0*/ tb_multiply_manager_wide__DOT__starting_x_reg_1;
        IData/*17:0*/ tb_multiply_manager_wide__DOT__starting_x_reg_2;
        IData/*17:0*/ tb_multiply_manager_wide__DOT__starting_y_reg_1;
        IData/*17:0*/ tb_multiply_manager_wide__DOT__starting_y_reg_2;
        IData/*31:0*/ tb_multiply_manager_wide__DOT__errors;
        IData/*31:0*/ tb_multiply_manager_wide__DOT__checks;
        IData/*31:0*/ tb_multiply_manager_wide__DOT__unnamedblk1__DOT__idx;
        IData/*17:0*/ tb_multiply_manager_wide__DOT__dut__DOT__spare_x_reg_1;
        IData/*17:0*/ tb_multiply_manager_wide__DOT__dut__DOT__spare_x_reg_2;
        IData/*31:0*/ tb_multiply_manager_wide__DOT__dut__DOT__grouping_status;
        IData/*31:0*/ tb_multiply_manager_wide__DOT__dut__DOT__left_thread;
        IData/*31:0*/ tb_multiply_manager_wide__DOT__dut__DOT__left_cycle;
        IData/*31:0*/ tb_multiply_manager_wide__DOT__dut__DOT__right_thread;
        IData/*31:0*/ tb_multiply_manager_wide__DOT__dut__DOT__right_cycle;
        IData/*31:0*/ tb_multiply_manager_wide__DOT__dut__DOT__joint_cycle;
        IData/*31:0*/ __VactIterCount;
        IData/*31:0*/ __VinactIterCount;
        IData/*31:0*/ __Vi;
        QData/*35:0*/ tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_1;
        QData/*35:0*/ tb_multiply_manager_wide__DOT__dut__DOT__sum_x_reg_2;
        QData/*35:0*/ tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_1;
        QData/*35:0*/ tb_multiply_manager_wide__DOT__dut__DOT__sum_y_reg_2;
        QData/*35:0*/ tb_multiply_manager_wide__DOT__dut__DOT__wide_partial_1;
        QData/*35:0*/ tb_multiply_manager_wide__DOT__dut__DOT__wide_partial_2;
        QData/*35:0*/ tb_multiply_manager_wide__DOT__dut__DOT__magnitude_reg_1;
        QData/*35:0*/ tb_multiply_manager_wide__DOT__dut__DOT__magnitude_reg_2;
        QData/*35:0*/ tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_1;
        QData/*35:0*/ tb_multiply_manager_wide__DOT__dut__DOT__encoded_x_reg_2;
        QData/*35:0*/ tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_1;
        QData/*35:0*/ tb_multiply_manager_wide__DOT__dut__DOT__encoded_y_reg_2;
        QData/*35:0*/ tb_multiply_manager_wide__DOT__dut__DOT__left_multiply_result;
        QData/*35:0*/ tb_multiply_manager_wide__DOT__dut__DOT__right_multiply_result;
        QData/*35:0*/ __VdfgRegularize_h6e95ff9d_0_4;
        QData/*35:0*/ __VdfgRegularize_h6e95ff9d_0_5;
        VlUnpacked<IData/*31:0*/, 256> tb_multiply_manager_wide__DOT__expected_count;
    };
    struct {
        VlUnpacked<QData/*63:0*/, 1> __VstlTriggered;
        VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
        VlUnpacked<QData/*63:0*/, 1> __VactTriggeredAcc;
        VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;
    };
    std::string __Vtask_tb_multiply_manager_wide__DOT__check__1__msg;
    std::string __Vtask_tb_multiply_manager_wide__DOT__run_wide__4__name;
    std::string __Vtask_tb_multiply_manager_wide__DOT__check__6__msg;
    std::string __Vtask_tb_multiply_manager_wide__DOT__check__7__msg;
    std::string __Vtask_tb_multiply_manager_wide__DOT__check__8__msg;
    std::string __Vtask_tb_multiply_manager_wide__DOT__check__9__msg;
    std::string __Vtask_tb_multiply_manager_wide__DOT__check__10__msg;
    VlDelayScheduler __VdlySched;
    VlTriggerScheduler __VtrigSched_h872470a5__0;
    VlTriggerScheduler __VtrigSched_h87247175__0;

    // INTERNAL VARIABLES
    Vtb_multiply_manager_wide__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vtb_multiply_manager_wide___024root(Vtb_multiply_manager_wide__Syms* symsp, const char* namep);
    ~Vtb_multiply_manager_wide___024root();
    VL_UNCOPYABLE(Vtb_multiply_manager_wide___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
