// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_multiply_manager_render.h for the primary calling header

#include "Vtb_multiply_manager_render__pch.h"

void Vtb_multiply_manager_render___024root___ctor_var_reset(Vtb_multiply_manager_render___024root* vlSelf);

Vtb_multiply_manager_render___024root::Vtb_multiply_manager_render___024root(Vtb_multiply_manager_render__Syms* symsp, const char* namep)
    : __VdlySched{*symsp->_vm_contextp__}
 {
    vlSymsp = symsp;
    vlNamep = strdup(namep);
    // Reset structure values
    Vtb_multiply_manager_render___024root___ctor_var_reset(this);
}

void Vtb_multiply_manager_render___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vtb_multiply_manager_render___024root::~Vtb_multiply_manager_render___024root() {
    VL_DO_DANGLING(std::free(const_cast<char*>(vlNamep)), vlNamep);
}
