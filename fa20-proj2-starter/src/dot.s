.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
    addi t0, x0, 1
    blt a2, t0, error1                  # if the length of the vector is less than 1
    blt a3, t0, error2                  # if the stride of either vector is less than 1
    blt a4, t0, error2                  

    addi t0, x0, 0                      # int i = 0
    addi t1, x0, 0                      # int result = 0
loop_start:
    
    beq t0, a2, loop_end                # if (i < length)
    addi t0, t0, 1
    lw t2, 0(a0)
    lw t3, 0(a1)
    
    mul t4, t2, t3                      # tempValue = array[1] * array[2]
    add t1, t1, t4                      # result += tempValue
    
    # update the pointer pointing to two vectors
    slli t2, a3, 2
    slli t3, a4, 2
    
    add a0, a0, t2
    add a1, a1, t3
    
    j loop_start
    
loop_end:
    mv a0, t1
    # Epilogue
    ret

error1:
    li a0, 75
    li a7, 93
    ecall
    j end

error2:
    li a0, 76
    li a7, 93
    ecall
    j end

end:
