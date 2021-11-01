#  test_sub.py
# This will test this RISC-V's CPU's `sub` instruction. Basic
# arithmetic operation of the instruction will be tested, then
# some edge cases will be explored.

# Written by: Austin Staton, with the library `test_util` provided
#             by Jason Bakos, Charles Daniels, and Philip Conrad.
# Date: Oct. 31, 2020

import test_util

# Basic operation usage
test_util.run_test("""
addi x1 x0 234
addi x2 x0 456
sub x3 x2 x1
""", { 3: 456-234 })

# "Full" Regs
test_util.run_test("""
lui x1 0xfffff
lui x2 0xf0f0f
sub x4 x1 x2
""", { 4 : (0xfffff000 - 0xf0f0f000)})

# (Number) - (Bigger Number) 
test_util.run_test("""
addi x1 x0 456
addi x2 x0 234
sub  x5 x2 x1
""", { 5 : int(((1 << 32) - 1) & (234-456))})

test_util.run_test("""
addi x1 x0 -2047
addi x2 x0 2047
sub  x6 x1 x2
""", { 6 : int(((1 << 32) - 1) & (2*-2047))})