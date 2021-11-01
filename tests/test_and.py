#  test_and.py
# This will test this RISC-V's CPU's `and` instruction. Basic
# arithmetic operation of the instruction will be tested, then
# some edge cases will be explored.
# ***Note: This will test both AND, as well as ANDI.
#
# Written by: Austin Staton, with the library `test_util` provided
#             by Jason Bakos, Charles Daniels, and Philip Conrad.
# Date: Oct. 31, 2020

import test_util

# Basic Operations
test_util.run_test("""
addi x1 x0 0x367
addi x2 x0 0x122
and  x3 x1 x2
andi x4 x3 0x000
andi x5 x1 0x111
""", {3: 0x367&0x122, 
      4: 0, 
      5: 0x111&0x367})


test_util.run_test("""
addi x1 x0 0x0f0
addi x2 x0 0x2ec
andi x10 x2 12  
""", {10: 0x2ec & 12})

# "Full" Regs
test_util.run_test("""
lui x1 0xfffff
lui x2 0xf0f0f
and x4 x2 x1
addi x2 x2 567
andi x5 x2 1567
""", {4: 0xfffff000 & 0xf0f0f000,
      5: ((0xf0f0f000+567)&1567)})


