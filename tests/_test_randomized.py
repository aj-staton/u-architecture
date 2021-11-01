#   test_randomized.py
#  This is a script for my CPU's end-to-end tests. It will go through
#  each operation, randomize registers and thier values, and validate the
#  design's response.

#  Written by: Austin Staton, with the library function `test_util.run_test()`
#              provided by Jason Bakos, Charles Daniels, and Philip Conrad.
#  Date: October 30th, 2020

import test_util
import random

test_util.run_test("addi x1 x0 10", {1: 10})


NUM_REGS = 31 # There are 32 total registers (but really 31 since 0x is const 0)
INT_MAX = (2**32)-1 # 32-bit CPU
IMM_MAX = (2**11)-1 # The immediates only have a 12-bit bus in RISC-V.

'''  Implemented Operations by Instruction Type   '''

r_ops = ['add', 'sub', 'and', 'or', 'xor', 'sll', 'sra',
         'srl', 'slt', 'sltu', 'mul', 'mulh', 'mulhu']

i_ops = ['addi', 'andi', 'ori', 'xori', 'slli', 'srai', 'srli']

u_ops = ['lui']

# @brief: create_test() will take in all the inputs needed for a RISC-V
#         instruction and create it in a nicely-formatted string.
#
# @return: STRING -- representing the instruction type. 
#
# ** Note: `imm` allows the tester to signal whether or not the instruction
#          needs a leading 'x' added to the front of rs2 (or the immediate, 
#          if using I-Type instructions.)
def create_test(op, rd, rs1, rs2, imm=False):
    if (imm):
        return str(op)+" x"+str(rd)+" x"+str(rs1)+" "+str(rs2)
    else:
        return str(op)+" x"+str(rd)+" x"+str(rs1)+" x"+str(rs2)

# This fucntion was stolen from Stack Overflow.
# src: https://stackoverflow.com/questions/5832982/how-to-get-the-logical-right-binary-shift-in-python
def rshift(val, n): return val>>n if val >= 0 else (val+0x100000000)>>n

# @brief: get_expected_value() comptutes the result of two values, given
#         that the operation is known. This is remarkably similar to 
#         to /rtl/alu.sv

# @return: INTEGER -- for the expected value of the operation  
def get_expected_value(op, val_1, val_2):
    if (len(op) > 5 or len(op) < 3):
        print ("error: " + str(op) + "  is not supported within this alu")

    if (op[:3] == 'add'):
        return val_1+val_2
    elif (op[:3] == 'sub'):
        return val_1-val_2
    elif (op[:3] == 'and'):
        return val_1 & val_2
    elif (op[:2] == 'or'):
        return val_1 | val_2
    elif (op[:3] == 'xor'):
        return val_1 ^ val_2
    elif (op[:3] == 'sll'):
        return val_1 << val_2
    elif (op[:3] == 'srl'):
        return val_1 >> val_2
    elif (op[:3] == 'sra'):
        return rshift(val_1,val_2)
    elif (op[:3] == 'sltu'):
        return (1 if val_1 < val_2 else 0) # TODO: Fix signs.
    elif (op[:2] == 'slt'):
        return (1 if val_1 < val_2 else 0)
    elif (op[:4] == 'mulhu'):
        return ((val_1 * val_2) >> 32)
    elif (op[:3] == 'mulh'):
        return ((val_1 * val_2) >> 32)
    elif (op[:2] == 'mul'):
        return ((val_1 * val_2) & 0x0000ffff)
    else:
        print ("error: " + str(op) + "  is not supported within this alu")

def test_instr_R():
    for instr in r_ops:
        test_string = ""
        # Randomize register number.
        rs1 = random.randint(1,NUM_REGS)
        rs2 = random.randint(1,NUM_REGS)
        while (rs1 == rs2): # Ensure the input regs aren't equivalent.
            rs2 = random.randint(1,NUM_REGS)
        rd  = random.randint(1,NUM_REGS)
        # Randomize input values
        num_1 = random.randint(0,IMM_MAX)
        num_2 = random.randint(0,IMM_MAX)

        # We can only test this if there's already two values in the regs.
        # Load rs1
        instantiate = create_test('addi', rs1, '0', num_1, True)
        print("in rs1: ", instantiate)
        test_util.run_test(instantiate,  {rs1: num_1})
        # Load rs2
        instantiate = create_test('addi', rs2, '0', num_2, True)
        print("in rs2: ", instantiate)
        test_util.run_test(instantiate,  {rs2: num_2})

        expected = get_expected_value(instr, num_1, num_2)

        vec = create_test(instr, rd, rs1, rs2)
        print(vec)
        test_util.run_test(vec, {rd: expected})
        

if __name__ == '__main__':
    test_instr_R()