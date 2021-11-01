# Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels

# Note: This will test both ADD and ADDI.

import test_util

# Basic arithmetic with zero and non-zero values.
test_util.run_test("""
addi x1 x0 1268 
addi x2 x0 1516 
add x1 x1 x2
addi x2, x1, 10
""", {1: 1268+1516, 2:1268+1516+10})

# Sign Extentions
test_util.run_test("""
addi x1 x0 -400 
addi x2 x0 399 
add x1 x1 x2
""", {1: 0xffffffff}) # -1

test_util.run_test("""
addi x1 x0 -400 
addi x2 x0 399 
add x1 x1 x2
addi x1 x1 2
""", {1: 1}) 

test_util.run_test("""
addi x1 x0 -400 
addi x2 x0 401 
add x1 x1 x2
""", {1: 1})

# Max values
test_util.run_test("""
addi x1 x0 2047
addi x2 x0 2047
add x1 x1 x2
""", {1: 2*2047})

test_util.run_test("""
addi x1 x0 2047
addi x2 x0 2047
add x1 x1 x2
addi x1, x1, -500
""", {1: 2*2047-500})

# Min values
test_util.run_test("""
addi x1 x0 -2047 
addi x2 x0 -2047
add x1 x1 x2
""", {1:int(((1 << 32) - 1) & (2*-2047))})
