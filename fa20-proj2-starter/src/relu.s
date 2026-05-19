.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
   
    # Prologue
    addi t1, x0, 1
    
    addi t0, x0, 0                  # int i = 0
    mv t3, a0                       # safe the address of the array in s1
    
    blt a1, t1, error          # if a1 > (t1 = 1), jump to the position of loop_start
    
loop_start:
    
    beq t0, a1, loop_end            # if (i < array.length)
    addi t0, t0, 1              
    # if not equal
 
    lw t2, 0(t3)
    blt x0, t2, loop_continue       # if (0 < array[i])
    sw x0, 0(t3)
    
loop_continue:
    
    addi t3, t3, 4
    j loop_start
    
loop_end:

    
    # Epilogue
	ret
    
error:
    # terminate the function with error code 78

    li a0, 17
    li a1, 78
    ecall