// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vtb_multiply_manager_wide__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vtb_multiply_manager_wide::Vtb_multiply_manager_wide(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vtb_multiply_manager_wide__Syms(contextp(), _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
    contextp()->traceBaseModelCbAdd(
        [this](VerilatedTraceBaseC* tfp, int levels, int options) { traceBaseModel(tfp, levels, options); });
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
    vlSymsp->__Vm_activity = true;
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

void Vtb_multiply_manager_wide::eval_end_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+eval_end_step Vtb_multiply_manager_wide::eval_end_step\n"); );
#ifdef VM_TRACE
    // Tracing
    if (VL_UNLIKELY(vlSymsp->__Vm_dumping)) vlSymsp->_traceDump();
#endif  // VM_TRACE
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
std::unique_ptr<VerilatedTraceConfig> Vtb_multiply_manager_wide::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false}};
};

//============================================================
// Trace configuration

void Vtb_multiply_manager_wide___024root__trace_decl_types(VerilatedVcd* tracep);

void Vtb_multiply_manager_wide___024root__trace_init_top(Vtb_multiply_manager_wide___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vtb_multiply_manager_wide___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_multiply_manager_wide___024root*>(voidSelf);
    Vtb_multiply_manager_wide__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(vlSymsp->name(), VerilatedTracePrefixType::SCOPE_MODULE);
    Vtb_multiply_manager_wide___024root__trace_decl_types(tracep);
    Vtb_multiply_manager_wide___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vtb_multiply_manager_wide___024root__trace_register(Vtb_multiply_manager_wide___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vtb_multiply_manager_wide::traceBaseModel(VerilatedTraceBaseC* tfp, int levels, int options) {
    (void)levels; (void)options;
    VerilatedVcdC* const stfp = dynamic_cast<VerilatedVcdC*>(tfp);
    if (VL_UNLIKELY(!stfp)) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vtb_multiply_manager_wide::trace()' called on non-VerilatedVcdC object;"
            " use --trace-fst with VerilatedFst object, and --trace-vcd with VerilatedVcd object");
    }
    stfp->spTrace()->addModel(this);
    stfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP), name(), false, 115);
    Vtb_multiply_manager_wide___024root__trace_register(&(vlSymsp->TOP), stfp->spTrace());
}
