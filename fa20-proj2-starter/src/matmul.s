.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    
    # Test the arguement passed into the function
    # Error checks
    addi t0, x0, 1
    bne a2, a4, error3
    
    blt a1, t0, error1                      # if (height1 < 1)
    blt a2, t0, error1
    blt a4, t0, error2
    blt a5, t0, error2
      
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)    
    # create a new matrix
    
#     mul t0, a1, a5                          # size = (height1 * width2) * (sizeof(int))
#     slli t0, t0, 2
#     sub sp, sp, t0
#     mv a6, sp                               # store the address of the matrix
    
    mv s0, a0                               # m0 ptr1
    mv s1, a1                               # m0 height1
    mv s2, a2                               # m0 width1
    mv s3, a3                               # m1 ptr2
    mv s4, a4                               # m1 height2
    mv s5, a5                               # m1 width2
    mv s6, a6                               # pointer to the start
        
    mv t0, s1                               # safe the value of height1
    mv t1, s5                               # safe the value of width2
    addi t0, x0, 0                          # int i = 0
    # Prologue

outer_loop_start:
    
    beq t0, s0, outer_loop_end              # while (i != m0_height)
    
    addi t1, x0, 0                          # int j = 0
   
inner_loop_start:
    
    beq t1, s1, inner_loop_end              # while (h != m1_weight)

    # pass the arguement, and call function d
    # 1. pass the address  
    mul a0, t0, s2                          # calculate the offset, offset = width1 * i * 4
    slli a0, a0, 2
    add a0, a0, s0                          # a0 store the address of pointer pointing to the start of v1
    
    add a1, x0, t1                          # calculate the offset, offset = j * 4
    slli a1, a1, 2
    add a1, a1, s3                          # a1 store the address of pointer pointing to the start of v2
    # 2. pass the length
    mv a2, s2
    # 3. pass the stride 
    addi a3, x0, 1                          # stride1 = 1
    mv a4, s5                               # stride2 = width2     
    # safe i, j into the stack
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    
    jalr ra, s6, 0                          # call the function
    
    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8
    
    # store the value in the new matrix ,the address of this new matrix is s6
    
    mul t3, t0, s5                          # offset = (i * width2 + j) * 4, store it in t3
    add t3, t3, t1
    slli t3, t3, 2
    
    add t4, t3, s6                          # save the value in target position
    sw a0, 0(t4)
      
    addi t1, t1, 1                          # j++
    
    j inner_loop_start
    
inner_loop_end:
      
    addi t0, t0, 1                          # i++
    
    j outer_loop_start

outer_loop_end:

    # Epilogue 
#     mul t0, s1, s5                          # size = (height1 * width2) * (sizeof(int))
#     slli t0, t0, 2
#     add sp, sp, t0
    
    lw s6, 24(sp)
    lw s5, 20(sp)
    lw s4, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)

    addi sp, sp, 28
    
    ret
    
error1:
    li a0, 72
    li a7, 93
    ecall
    j end
    
error2:
    li a0, 73
    li a7, 93
    ecall
    j end
    
error3:
    li a0, 74
    li a7, 93
    ecall
    j end

end:



