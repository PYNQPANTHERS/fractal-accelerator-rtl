// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vtb_multiply_manager_wide__pch.h"

//============================================================
// Constructors

Vtb_multiply_manager_wide::Vtb_multiply_manager_wide(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vtb_multiply_manager_wide__Syms(contextp(), _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vtb_multiply_manager_wide::Vtb_multiply_manager_wide(const char* _vcname__)
    : Vtb_multiply_manager_wide(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vtb_multiply_manager_wide::~Vtb_multiply_manager_wide() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vtb_multiply_manager_wide___024root___eval_debug_assertions(Vtb_multiply_manager_wide___024root* vlSelf);
#endif  // VL_DEBUG
void Vtb_multiply_manager_wide___024root___eval_static(Vtb_multiply_manager_wide___024root* vlSelf);
void Vtb_multiply_manager_wide___024root___eval_initial(Vtb_multiply_manager_wide___024root* vlSelf);
void Vtb_multiply_manager_wide___024root___eval_settle(Vtb_multiply_manager_wide___024root* vlSelf);
void Vtb_multiply_manager_wide___024root___eval(Vtb_multiply_manager_wide___024root* vlSelf);

void Vtb_multiply_manager_wide::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vtb_multiply_manager_wide::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vtb_multiply_manager_wide___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vtb_multiply_manager_wide___024root___eval_static(&(vlSymsp->TOP));
        Vtb_multiply_manager_wide___024root___eval_initial(&(vlSymsp->TOP));
        Vtb_multiply_manager_wide___024root___eval_settle(&(vlSymsp->TOP));
        vlSymsp->__Vm_didInit = true;
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vtb_multiply_manager_wide___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vtb_multiply_manager_wide::eventsPending() { return !vlSymsp->TOP.__VdlySched.empty() && !contextp()->gotFinish(); }

uint64_t Vtb_multiply_manager_wide::nextTimeSlot() { return vlSymsp->TOP.__VdlySched.nextTimeSlot(); }

//============================================================
// Utilities

const char* Vtb_multiply_manager_wide::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vtb_multiply_manager_wide___024root___eval_final(Vtb_multiply_manager_wide___024root* vlSelf);

VL_ATTR_COLD void Vtb_multiply_manager_wide::final() {
    contextp()->executingFinal(true);
    Vtb_multiply_manager_wide___024root___eval_final(&(vlSymsp->TOP));
    contextp()->executingFinal(false);
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vtb_multiply_manager_wide::hierName() const { return vlSymsp->name(); }
const char* Vtb_multiply_manager_wide::modelName() const { return "Vtb_multiply_manager_wide"; }
unsigned Vtb_multiply_manager_wide::threads() const { return 1; }
void Vtb_multiply_manager_wide::prepareClone() const { contextp()->prepareClone(); }
void Vtb_multiply_manager_wide::atClone() const {
    contextp()->threadPoolpOnClone();
}
