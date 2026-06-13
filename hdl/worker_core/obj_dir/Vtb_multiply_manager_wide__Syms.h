// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VTB_MULTIPLY_MANAGER_WIDE__SYMS_H_
#define VERILATED_VTB_MULTIPLY_MANAGER_WIDE__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vtb_multiply_manager_wide.h"

// INCLUDE MODULE CLASSES
#include "Vtb_multiply_manager_wide___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES) Vtb_multiply_manager_wide__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vtb_multiply_manager_wide* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vtb_multiply_manager_wide___024root TOP;

    // CONSTRUCTORS
    Vtb_multiply_manager_wide__Syms(VerilatedContext* contextp, const char* namep, Vtb_multiply_manager_wide* modelp);
    ~Vtb_multiply_manager_wide__Syms();

    // METHODS
    const char* name() const { return TOP.vlNamep; }
};

#endif  // guard
