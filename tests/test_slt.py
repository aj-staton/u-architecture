#  test_slt.py
# This will test this RISC-V's CPU's set (if) less than instruction.
# **Note: this include SLTU
#
# Written by: Austin Staton, with the library `test_util` provided
#             by Jason Bakos, Charles Daniels, and Philip Conrad.
# Date: Oct. 31, 2020

import test_util

test_util.run_test("""
addi x2 x0 2
addi x2 x0 -1 # Use -1 as a test on signedness.
slt  x3 x2 x1
slt  x4 x1 x2
sltu x5 x1 x2
sltu x6 x2 x1
""", { 3 : 1,
       4 : 0,
       5 : 1,
       6 : 0})