import os
from pathlib import Path

from cocotb_tools.runner import get_runner

def test_runner():
    sim = os.getenv("SIM", "icarus")
    proj_path = Path(__file__).resolve().parent

    sources = [proj_path/"../../hdl/dual_core/comparator/comparator.sv"]

    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="comparator",
        timescale=("1ns", "1ps"),
    )

    runner.test(
        hdl_toplevel="comparator",
        test_module="coco_comparator",
        timescale=("1ns", "1ps"),
    )

if __name__ == "__main__":
    test_runner()