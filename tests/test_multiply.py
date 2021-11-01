#  test_multiply.py
# This will test this RISC-V's CPU's multiplication instructions. These
# instrs are: MUL, MULH, MULHU.
#
# Written by: Austin Staton, with the library `test_util` provided
#             by Jason Bakos, Charles Daniels, and Philip Conrad.
# Date: Oct. 31, 2020

import test_util

test_util.run_test("""
lui x1 0xfffff
addi x2 x0 2
mul x3 x1 x2
mulh x4 x1 x2
""", { 3 : 0xffffe000,
       4 : 0xffffffff})

test_util.run_test("""
lui x1 0xfffff
lui x2 0x22222
mulhu x3 x1 x2
""", { 3 : 0x22221ddd})

test_util.run_test("""
lui x1 0xfffff
addi x2 x0 2000
mulhu x3 x1 x2
""", { 3 : ((0xfffff000+2000)*2000)>>32})