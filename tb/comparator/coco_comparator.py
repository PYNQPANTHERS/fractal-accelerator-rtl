import cocotb
from cocotb.triggers import RisingEdge, Timer

CLK_HALF_NS = 5


class Scoreboard:
    def __init__(self):
        self.run = 0
        self.passed = 0
        self.failed = 0
        self.suite_name = ""

    def suite(self, name):
        self.suite_name = name
        cocotb.log.info("=" * 72)
        cocotb.log.info("  SUITE: %s", name)
        cocotb.log.info("=" * 72)

    def check(self, cond, desc):
        self.run += 1
        if cond:
            self.passed += 1
            cocotb.log.info("  [PASS] %s", desc)
        else:
            self.failed += 1
            cocotb.log.error("  [FAIL] %s  (suite: %s)", desc, self.suite_name)

    def summary(self):
        cocotb.log.info("=" * 72)
        cocotb.log.info("  RESULTS: %d / %d passed", self.passed, self.run)
        if self.failed == 0:
            cocotb.log.info("  ALL TESTS PASSED")
        else:
            cocotb.log.error("  %d TEST(S) FAILED", self.failed)
        cocotb.log.info("=" * 72)


async def generate_clock(dut):
    dut.clk.value = 0
    while True:
        await Timer(CLK_HALF_NS, unit="ns")
        dut.clk.value = 1
        await Timer(CLK_HALF_NS, unit="ns")
        dut.clk.value = 0


class Harness:
    def __init__(self, dut, sb):
        self.dut = dut
        self.sb = sb

    async def tick(self, n=1):
        for _ in range(n):
            await RisingEdge(self.dut.clk)
        await Timer(1, unit="ns")

    async def feed(self, x, y, col):
        """Drive one pixel result for a single clock cycle."""
        self.dut.comp_data.value = (col << 16) | (y << 8) | x
        self.dut.comp_valid.value = 1
        self.dut._log.info("    feed: x=%d y=%d col=%x", x, y, col)
        await self.tick(1)
        self.dut.comp_valid.value = 0

    async def load_quad(self, tlx, tly, qsize, exp_count):
        """Configure a new quad and pulse sched_reset."""
        self.dut.top_left_x.value = tlx
        self.dut.top_left_y.value = tly
        self.dut.quad_size_x.value = qsize
        self.dut.quad_size_y.value = qsize
        self.dut.expected_count.value = exp_count
        self.dut.sched_reset.value = 1
        self.dut._log.info(
            "    load_quad: tlx=%d tly=%d sz=%d exp=%d", tlx, tly, qsize, exp_count
        )
        await self.tick(1)
        self.dut.sched_reset.value = 0
        await self.tick(1)

    async def hard_reset(self):
        self.dut.rst.value = 1
        await self.tick(2)
        self.dut.rst.value = 0
        await self.tick(1)
        self.dut._log.info("    hard_reset done")


@cocotb.test()
async def test_comparator(dut):
    sb = Scoreboard()
    h = Harness(dut, sb)

    cocotb.start_soon(generate_clock(dut))

    dut.rst.value = 0
    dut.sched_reset.value = 0
    dut.comp_valid.value = 0
    dut.comp_data.value = 0
    dut.top_left_x.value = 0
    dut.top_left_y.value = 0
    dut.quad_size_x.value = 0
    dut.quad_size_y.value = 0
    dut.expected_count.value = 0
    await h.tick(1)

    # RESET
    sb.suite("RESET - hard reset clears all state")
    await h.hard_reset()
    dut._log.info(
        "    State after reset: differ=%s complete=%s comp_pop=%s",
        dut.differ.value, dut.complete.value, dut.comp_pop.value,
    )
    sb.check(dut.differ.value == 0, "differ low on reset")
    sb.check(dut.complete.value == 0, "complete low on reset")
    sb.check(dut.comp_pop.value == 0, "comp_pop low when no valid data")

    sb.suite("RESET - sched_reset clears differ and complete")
    await h.hard_reset()
    await h.load_quad(0, 0, 16, 4)
    await h.feed(0, 0, 0xA)
    await h.feed(1, 0, 0xB)
    await h.tick(1)
    dut._log.info(
        "    Before sched_reset: differ=%s complete=%s",
        dut.differ.value, dut.complete.value,
    )
    sb.check(dut.differ.value == 1, "differ latched before sched_reset")
    await h.load_quad(0, 0, 16, 4)
    dut._log.info(
        "    After sched_reset:  differ=%s complete=%s",
        dut.differ.value, dut.complete.value,
    )
    sb.check(dut.differ.value == 0, "differ cleared by sched_reset")
    sb.check(dut.complete.value == 0, "complete cleared by sched_reset")

    # BOUNDS
    sb.suite("BOUNDS - in-bounds entry is processed")
    await h.hard_reset()
    await h.load_quad(10, 10, 8, 1)
    dut._log.info("    Quad: tlx=10 tly=10 sz=8 covers x=[10..17] y=[10..17]")
    await h.feed(10, 10, 0xC)
    await h.tick(1)
    dut._log.info(
        "    After corner feed: differ=%s complete=%s ref=%x",
        dut.differ.value, dut.complete.value, int(dut.ref_colour_o.value),
    )
    sb.check(dut.differ.value == 0, "no differ for single in-bounds entry (becomes reference)")

    sb.suite("BOUNDS - out-of-bounds entry is discarded")
    await h.hard_reset()
    await h.load_quad(10, 10, 8, 2)
    dut._log.info("    Feeding OOB entry (5,5) outside quad (10,10)+8")
    await h.feed(5, 5, 0xA)
    await h.tick(1)
    dut._log.info(
        "    After OOB: differ=%s complete=%s", dut.differ.value, dut.complete.value
    )
    sb.check(dut.differ.value == 0, "differ not set by out-of-bounds entry")
    sb.check(dut.complete.value == 0, "complete not set by out-of-bounds entry")
    await h.feed(10, 10, 0xA)
    await h.tick(1)
    sb.check(dut.differ.value == 0, "in-bounds after OOB correctly becomes reference")

    sb.suite("BOUNDS - out-of-bounds after reference does not affect differ")
    await h.hard_reset()
    await h.load_quad(0, 0, 4, 2)
    dut._log.info("    Quad: tlx=0 tly=0 sz=4 covers x=[0..3] y=[0..3]")
    await h.feed(0, 0, 0xA)
    await h.feed(9, 9, 0xB)
    await h.tick(1)
    dut._log.info("    After OOB with different colour: differ=%s", dut.differ.value)
    sb.check(dut.differ.value == 0, "OOB entry with different colour does not set differ")

    sb.suite("BOUNDS - all four corners of bounding box")
    await h.hard_reset()
    await h.load_quad(5, 5, 4, 4)
    dut._log.info("    Quad: tlx=5 tly=5 sz=4 covers x=[5..8] y=[5..8]; expected_count=4")
    await h.feed(5, 5, 0x1)
    await h.feed(8, 5, 0x1)
    await h.feed(5, 8, 0x1)
    await h.feed(8, 8, 0x1)
    await h.tick(1)
    dut._log.info(
        "    After 4 corner feeds: differ=%s complete=%s",
        dut.differ.value, dut.complete.value,
    )
    sb.check(dut.differ.value == 0, "all four corners in-bounds, same colour - no differ")
    sb.check(dut.complete.value == 1, "complete after 4 in-bounds entries with expected=4")

    sb.suite("BOUNDS - one pixel exactly at boundary (exclusive)")
    await h.hard_reset()
    await h.load_quad(5, 5, 4, 1)
    dut._log.info("    Feeding x=9 (= tlx+sz, exclusive upper bound), should be OOB")
    await h.feed(9, 5, 0x1)
    await h.tick(1)
    dut._log.info(
        "    After OOB boundary pixel: differ=%s complete=%s",
        dut.differ.value, dut.complete.value,
    )
    sb.check(dut.differ.value == 0, "x=top_left+quad_size is out of bounds (exclusive)")
    sb.check(dut.complete.value == 0, "complete not set - OOB entry not counted")

    # COLOUR
    sb.suite("COLOUR - first entry becomes reference, no differ")
    await h.hard_reset()
    await h.load_quad(0, 0, 16, 3)
    await h.feed(0, 0, 0x7)
    await h.tick(1)
    dut._log.info(
        "    ref_colour_o=%x differ=%s", int(dut.ref_colour_o.value), dut.differ.value
    )
    sb.check(dut.differ.value == 0, "first entry sets reference - no differ")

    sb.suite("COLOUR - matching colours do not set differ")
    await h.hard_reset()
    await h.load_quad(0, 0, 16, 4)
    await h.feed(0, 0, 0x5)
    await h.feed(1, 0, 0x5)
    await h.feed(2, 0, 0x5)
    await h.feed(3, 0, 0x5)
    await h.tick(1)
    dut._log.info("    Four identical-colour feeds: differ=%s", dut.differ.value)
    sb.check(dut.differ.value == 0, "four identical colours - no differ")

    sb.suite("COLOUR - mismatch sets differ, registered on next cycle")
    await h.hard_reset()
    await h.load_quad(0, 0, 16, 4)
    await h.feed(0, 0, 0xA)
    await h.feed(1, 0, 0xB)
    await h.tick(1)
    dut._log.info("    After mismatch + 1 extra tick: differ=%s", dut.differ.value)
    sb.check(dut.differ.value == 1, "differ set on first mismatch")

    sb.suite("COLOUR - differ latches and stays high")
    await h.hard_reset()
    await h.load_quad(0, 0, 16, 4)
    await h.feed(0, 0, 0xA)
    await h.feed(1, 0, 0xB)
    await h.feed(2, 0, 0xA)
    await h.feed(3, 0, 0xA)
    await h.tick(1)
    dut._log.info("    After matching entries after mismatch: differ=%s", dut.differ.value)
    sb.check(dut.differ.value == 1, "differ stays latched even after matching entries follow")

    sb.suite("COLOUR - mismatch on last entry still sets differ")
    await h.hard_reset()
    await h.load_quad(0, 0, 16, 3)
    await h.feed(0, 0, 0x3)
    await h.feed(1, 0, 0x3)
    await h.feed(2, 0, 0xF)
    await h.tick(1)
    dut._log.info(
        "    After last-entry mismatch + tick: differ=%s complete=%s",
        dut.differ.value, dut.complete.value,
    )
    sb.check(dut.differ.value == 1, "differ set on last entry mismatch")
    sb.check(dut.complete.value == 0, "complete suppressed when last entry differs")

    # COMPLETE
    sb.suite("COMPLETE - asserts when seen == expected")
    await h.hard_reset()
    await h.load_quad(0, 0, 16, 4)
    await h.feed(0, 0, 0x2)
    await h.feed(1, 0, 0x2)
    await h.feed(2, 0, 0x2)
    dut._log.info("    After 3 of 4 feeds: complete=%s", dut.complete.value)
    sb.check(dut.complete.value == 0, "complete not yet after 3 of 4")
    await h.feed(3, 0, 0x2)
    await h.tick(1)
    dut._log.info("    After 4th feed + tick: complete=%s", dut.complete.value)
    sb.check(dut.complete.value == 1, "complete asserts after 4th entry")

    sb.suite("COMPLETE - latches and stays high")
    await h.tick(5)
    dut._log.info("    After 5 more ticks: complete=%s", dut.complete.value)
    sb.check(dut.complete.value == 1, "complete stays latched after asserting")

    sb.suite("COMPLETE - differ suppresses complete (cannot both be high)")
    await h.hard_reset()
    await h.load_quad(0, 0, 16, 3)
    await h.feed(0, 0, 0xA)
    await h.feed(1, 0, 0xB)
    await h.feed(2, 0, 0xA)
    await h.tick(1)
    dut._log.info(
        "    differ=%s complete=%s (complete must stay low once differ set)",
        dut.differ.value, dut.complete.value,
    )
    sb.check(dut.differ.value == 1, "differ asserted")
    sb.check(dut.complete.value == 0, "complete suppressed because differ is set")

    sb.suite("COMPLETE - expected_count=1 needs ref latched (no complete on very first entry)")
    await h.hard_reset()
    await h.load_quad(0, 0, 16, 1)
    await h.feed(0, 0, 0x9)
    await h.tick(1)
    dut._log.info(
        "    Single-entry: complete=%s differ=%s", dut.complete.value, dut.differ.value
    )
    sb.check(dut.complete.value == 0, "no complete on the very first entry (ref not yet latched)")
    sb.check(dut.differ.value == 0, "no differ for single entry")

    # COMP_POP
    sb.suite("COMP_POP - asserts combinationally when comp_valid high")
    await h.hard_reset()
    await h.load_quad(0, 0, 16, 2)
    dut.comp_valid.value = 1
    dut.comp_data.value = (0x01 << 16) | (0 << 8) | 0
    await Timer(1, unit="ns")
    dut._log.info(
        "    comp_valid=1: comp_pop=%s (should be 1 combinationally)", dut.comp_pop.value
    )
    sb.check(dut.comp_pop.value == 1, "comp_pop asserts combinationally when comp_valid high")
    await h.tick(1)
    dut.comp_valid.value = 0
    await Timer(1, unit="ns")
    dut._log.info("    comp_valid=0: comp_pop=%s (should be 0)", dut.comp_pop.value)
    sb.check(dut.comp_pop.value == 0, "comp_pop deasserts when comp_valid low")

    sb.suite("COMP_POP - out-of-bounds entries still consumed")
    await h.hard_reset()
    await h.load_quad(10, 10, 4, 1)
    dut.comp_valid.value = 1
    dut.comp_data.value = (0x0F << 16) | (0 << 8) | 0
    await Timer(1, unit="ns")
    dut._log.info("    OOB entry: comp_pop=%s (should still be 1)", dut.comp_pop.value)
    sb.check(dut.comp_pop.value == 1, "comp_pop fires for OOB entry - entry consumed regardless")
    await h.tick(1)
    dut.comp_valid.value = 0

    # MULTI-QUAD
    sb.suite("MULTI-QUAD - sched_reset correctly transitions between quads")
    await h.hard_reset()
    await h.load_quad(0, 0, 4, 4)
    dut._log.info("    Quad 1: tlx=0 tly=0 sz=4")
    await h.feed(0, 0, 0xA)
    await h.feed(3, 0, 0xA)
    await h.feed(0, 3, 0xA)
    await h.feed(3, 3, 0xA)
    await h.tick(1)
    dut._log.info(
        "    Quad 1 result: differ=%s complete=%s", dut.differ.value, dut.complete.value
    )
    sb.check(dut.differ.value == 0, "quad 1: no differ")
    sb.check(dut.complete.value == 1, "quad 1: complete")
    await h.load_quad(4, 0, 4, 4)
    dut._log.info("    Quad 2: tlx=4 tly=0 sz=4 (after sched_reset)")
    dut._log.info(
        "    State immediately after sched_reset: differ=%s complete=%s",
        dut.differ.value, dut.complete.value,
    )
    sb.check(dut.differ.value == 0, "quad 2: differ cleared by sched_reset")
    sb.check(dut.complete.value == 0, "quad 2: complete cleared by sched_reset")
    await h.feed(4, 0, 0xB)
    await h.feed(7, 0, 0xC)
    await h.feed(4, 3, 0xB)
    await h.feed(7, 3, 0xB)
    await h.tick(1)
    dut._log.info(
        "    Quad 2 result: differ=%s complete=%s", dut.differ.value, dut.complete.value
    )
    sb.check(dut.differ.value == 1, "quad 2: differ set")
    sb.check(dut.complete.value == 0, "quad 2: complete suppressed by differ")

    sb.suite("MULTI-QUAD - stale entries from previous quad are discarded")
    await h.hard_reset()
    await h.load_quad(0, 0, 4, 2)
    await h.feed(0, 0, 0xA)
    await h.load_quad(8, 8, 4, 2)
    dut._log.info("    Switched to quad 2 (8,8); feeding stale quad-1 coord (0,0)")
    await h.feed(0, 0, 0xF)
    await h.tick(1)
    dut._log.info(
        "    After stale entry: differ=%s complete=%s", dut.differ.value, dut.complete.value
    )
    sb.check(dut.differ.value == 0, "stale quad-1 entry discarded by quad-2 bounds check")
    sb.check(dut.complete.value == 0, "complete not set by discarded entry")
    await h.feed(8, 8, 0x1)
    await h.tick(1)
    dut._log.info("    After first valid quad-2 entry: differ=%s", dut.differ.value)
    sb.check(dut.differ.value == 0, "first valid quad-2 entry becomes reference - no differ")

    sb.summary()
    assert sb.failed == 0, f"{sb.failed} of {sb.run} checks failed"
