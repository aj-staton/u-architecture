#   bin2dec.asm
#  This program takes a binary number and converts it into "decimal". For me,
#  this means it'll read in somthing like 0b1101 and convert it into 0x13.
#  My CPU design assigns separate 4-bit values to each hex display; so, each
#  decimal digit of the inputted integer will take up 4 bits in the resulting
#  hex value.

#  Valid Input values range from [0, 2^18) = 262143. A max of six digits in the
#  integer number (a max of 18 in the binary rep. of the number). I had trouble
#  managing the fractional part of the fixed point `value*0.1`. Inputs five digits and below
#  work fine; but, at longer "iterations" (i.e., higher numbers), the fraction begins
#  to be erroneous.
#
#  Written by: Austin Staton, with the apporach given by Dr. Jason Bakos in:
#                            https://youtu.be/PEJottvt4O8
#  Date: Nov. 4th, 2020
.text
	# ** Get Input **
	csrrw x1, 0xf00, x0 
	#li x1, 19999
	
	# ** Constant Values **
	li x2, 0      	  # Clear the result register.
	li x3, 0x199a 	  # This is 0.1 
	addi x4, x0, 10 
	li x5, 0xffff  	  # Lower 16 bit mask.
	li x6, 0xffff0000 # Upper 16 bit mask.
    	
    	
	# ** Lowest Digit **
	mul x7, x1, x3    # input * 0.1 
	srli x1, x7, 16   # Integer part of the number.
	and x7, x7, x5    # Grab the fractional
	mul x7, x7, x4    # mulitply fractional by 10
	and x7, x7, x6    # Grab upper 16 bits 
	srli x2, x2, 4
	srli x7, x7, 16
	
	add  x2, x7, x2   # Store FIRST digit in result
	add  x7, x0, x0   # Clear the temp reg.


	# ** 2nd Lowest Digit **
	mul x7, x1, x3 
	srli x1, x7, 16 
	and x7, x7, x5 
	mul x7, x7, x4
	and x7, x7, x6 
	#srli x2, x2, 4
	srli x7, x7, 12 
	
	add  x2, x7, x2 # Store SECOND digit
	add  x7, x0, x0 # Clear the temp reg
	
	
	# ** 3rd Lowest Digit **
	mul x7, x1, x3  
	srli x1, x7, 16 
	and x7, x7, x5 
	mul x7, x7, x4 
	and x7, x7, x6 
	#srli x2, x2, 4
	srli x7, x7, 8 
	
	add  x2, x7, x2 # Store THIRD digit
	add  x7, x0, x0 # Clear the temp reg
	
	
	# ** 4th Lowest Digit **
	mul x7, x1, x3  
	srli x1, x7, 16 
	and x7, x7, x5 
	mul x7, x7, x4 
	and x7, x7, x6 
	#srli x2, x2, 4
	srli x7, x7, 4 
	
	add  x2, x7, x2 # Store FOURTH digit
	add  x7, x0, x0 # Clear the temp reg
	
	
	# ** 5th Lowest Digit **
	mul x7, x1, x3  
	srli x1, x7, 16 
	and x7, x7, x5 
	mul x7, x7, x4 
	and x7, x7, x6 
	#srli x2, x2, 4
	srli x7, x7, 0 
	
	add  x2, x7, x2 # Store FIFTH digit
	add  x7, x0, x0 # Clear the temp reg
	
	
	# ** 6th Lowest Digit **
	mul x7, x1, x3  
	srli x1, x7, 16 
	and x7, x7, x5 
	mul x7, x7, x4 
	and x7, x7, x6 
	#srli x2, x2, 4
	slli x7, x7, 4
	
	add  x2, x7, x2 # Store SIXTH digit
	add  x7, x0, x0 # Clear the temp reg
	
	
	# ** Send to Output **
	csrrw x2 0xf02 x2
    	
    	