.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    
    addi t0, x0, 1
    addi t1, x0, 0                  # int i = 0
    addi t2, x0, 0                  # int maxNumber = 0
    addi t3, x0, 0                  # int index = 0
    blt a1, t0, error

loop_start:
    beq t1, a1, loop_end            #if (i < array.length)
    addi t1, t1, 1                  # i = i + 1
    
    lw t0, 0(a0)                    # load the value of array[i] in t0
    
    bge t2, t0, loop_continue       # if (maxNumber >= array.[i]), then jump, else go on
    mv t2, t0                       # updeta the value of t2(maxNumber)
    mv t3, t1                       # updeta the value of t3(index)
    
loop_continue:
    addi a0, a0, 4                  # update pointer a0 point to the next address
    j loop_start

loop_end:
    addi t3, t3, -1
    mv a0, t3
    # Epilogue
    ret
    
error:
    # terminates the program with error code 77
    li a0, 77
    li a7, 93
    ecall
