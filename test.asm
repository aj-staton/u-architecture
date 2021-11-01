.text
	csrrw x1, 0xf00, x0 # This is input? 
	
	#li x1, 769  
    	li x2, 0 # O
    	li x3, 6554 # This is 0.1 
    	addi x4, x0, 10
    	li x5, 0xffff # Lower 16 bit instructions.
    	li x6, 0xffff0000 # Uper 16 bit instructions.
    	mul x7, x1, x3 # input * 0.1 = 76.8, where 76 is upper 16 bits, 
    	srli x1, x7, 16 # This is upper
    	and x7, x7, x5 # Grab the fractional
    	mul x7, x7, x4 # mulitply fractional by 10
    	and x7, x7, x6 # Grab upper 16 bits 
    	srli x2, x2, 4
    	srli x7, x7, 16 
    	add  x2, x7, x2 # Store digit in result
	
	csrrw x2, 0xf02, x2	# This is output? 
