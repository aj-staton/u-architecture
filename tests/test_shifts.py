#  test_shifts.py
# This will test this RISC-V's CPU's shifting operations. Basic
# arithmetic use of the instructions will first be tested, then
# some edge cases will be explored.
#
# ***Note: This file will test: SLL, SRL, SRA, and thier respective
#          immediate values.
#
# Written by: Austin Staton, with the library `test_util` provided
#             by Jason Bakos, Charles Daniels, and Philip Conrad.
# Date: Oct. 31, 2020

import test_util

# Shift a bit left and reverse it by shifting right.
test_util.run_test("""
addi x1 x0 16
slli x9 x1 4
srli x8 x9 4
addi x2 x0 4
sll x10 x1 x2
srl x7  x10 x2
""", {9: 256,
      8: 16,
      10: 256,
      7: 16})

test_util.run_test("""
addi x1 x0 -1
slli x2 x1 4
addi x3 x0 4
sra  x4 x2 x3
srai x5 x2 4
""", {2 : 0xfffffff0, 
      4 : 0xffffffff,
      5 : 0xffffffff })