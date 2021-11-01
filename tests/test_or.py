#  test_or.py
# This will test this RISC-V's CPU's `or` operation. Basic
# arithmetic use of the instruction will first be tested, then
# some edge cases will be explored.
#
# ***Note: This file will test: OR, ORI, XOR, and XORI.
#
# Written by: Austin Staton, with the library `test_util` provided
#             by Jason Bakos, Charles Daniels, and Philip Conrad.
# Date: Oct. 31, 2020

import test_util

test_util.run_test("""
addi x1 x0 1234
addi x2 x0 2034
or   x3 x2 x1
ori  x4 x2 1989
xor  x5 x2 x1
xori x6 x2 0x1ff
""", {3: 2034 | 1234,
      4: 2034 | 1989,
      5: 2034 ^ 1234,
      6: 2034 ^ 0x1ff})

# 'full' regs
test_util.run_test("""
lui x1 0xfffff
lui x2 0xfffff
or  x3 x2 x1
xor x4 x2 x1
ori x5 x1 0x0ff
xori x6 x5 0x237
""", { 3 : 0xfffff000, 
       4 : 0x00000000,
       5 : 0xfffff0ff,
       6 : 0xfffff0ff ^ 0x237 })