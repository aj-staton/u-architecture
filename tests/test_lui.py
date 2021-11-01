#  test_mul.py
# This will test this RISC-V's CPU's load upper immediate instruction.
# 
# These test cases are rather soft. I use LUI in the other test_* files,
# and they will throw errors if LUI isn't functional.
#
# Written by: Austin Staton, with the library `test_util` provided
#             by Jason Bakos, Charles Daniels, and Philip Conrad.
# Date: Oct. 31, 2020

import test_util

test_util.run_test("""
lui x1 0xfffff
lui x2 0xf0f00
lui x3 0x12345
""",{ 1 : 0xfffff000,
      2 : 0xf0f00000,
      3 : 0x12345000 })