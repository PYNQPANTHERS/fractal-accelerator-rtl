#include "Vaxi_hp_master_wrap.h"
#include "verilated.h"

#include <cstdint>
#include <cstdlib>
#include <cstdio>

static vluint64_t main_time = 0;

double sc_time_stamp() {
    return static_cast<double>(main_time);
}

static void fail(const char* msg, int value = -1) {
    if (value >= 0) {
        std::fprintf(stderr, "FAIL: %s: %d\n", msg, value);
    } else {
        std::fprintf(stderr, "FAIL: %s\n", msg);
    }
    std::exit(1);
}

static void posedge(Vaxi_hp_master_wrap& top) {
    top.clk = 1;
    top.eval();
    main_time += 5;
}

static void negedge(Vaxi_hp_master_wrap& top) {
    top.clk = 0;
    top.eval();
    main_time += 5;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);

    Vaxi_hp_master_wrap top;

    top.clk = 0;
    top.rst = 1;
    top.wr_addr = 0;
    top.wr_data = 0;
    top.wr_en = 0;
    top.m_awready = 1;
    top.m_wready = 1;
    top.m_bid = 0;
    top.m_bresp = 0;
    top.m_bvalid = 0;
    top.eval();

    for (int i = 0; i < 4; ++i) {
        posedge(top);
        negedge(top);
    }
    top.rst = 0;
    top.eval();

    int sent_words = 0;
    int aw_count = 0;
    int w_count = 0;
    int wlast_count = 0;
    int b_count = 0;
    int done_count = 0;
    bool aw_seen = false;
    bool bvalid_reg = false;

    for (int cycle = 0; cycle < 1000 && b_count < 2; ++cycle) {
        negedge(top);

        top.m_awready = 1;
        top.m_wready = 1;
        top.m_bvalid = bvalid_reg ? 1 : 0;
        top.m_bresp = 0;
        top.m_bid = 0;

        const bool wr_fire = (sent_words < 32) && top.wr_ready;
        top.wr_en = wr_fire ? 1 : 0;
        top.wr_addr = 0x10000000u + static_cast<uint32_t>(sent_words * 8);
        top.wr_data = 0xCAFE000000000000ULL | static_cast<uint64_t>(sent_words);
        top.eval();

        const bool aw_hs = top.m_awvalid && top.m_awready;
        const bool w_hs = top.m_wvalid && top.m_wready;
        const bool b_hs = top.m_bvalid && top.m_bready;
        const bool wlast_hs = w_hs && top.m_wlast;

        if (top.m_wvalid && !aw_seen)
            fail("WVALID asserted before first AW handshake");

        if (aw_hs) {
            if (top.m_awlen != 15)
                fail("AWLEN should be 15", top.m_awlen);
            if (top.m_awsize != 3)
                fail("AWSIZE should be 3", top.m_awsize);
            ++aw_count;
            aw_seen = true;
        }

        if (w_hs) {
            ++w_count;
            if (wlast_hs)
                ++wlast_count;
        }

        if (b_hs)
            ++b_count;

        posedge(top);

        if (wr_fire)
            ++sent_words;

        if (b_hs)
            bvalid_reg = false;
        if (wlast_hs)
            bvalid_reg = true;

        if (top.burst_done)
            ++done_count;
    }

    if (sent_words != 32) fail("expected 32 input words", sent_words);
    if (aw_count != 2) fail("expected 2 AW handshakes", aw_count);
    if (w_count != 32) fail("expected 32 W handshakes", w_count);
    if (wlast_count != 2) fail("expected 2 WLAST handshakes", wlast_count);
    if (b_count != 2) fail("expected 2 B handshakes", b_count);
    if (done_count != 2) fail("expected 2 burst_done pulses", done_count);
    if (top.err_flag) fail("unexpected err_flag");

    std::printf("sim_axi_hp_master_wrap: PASS\n");
    top.final();
    return 0;
}
