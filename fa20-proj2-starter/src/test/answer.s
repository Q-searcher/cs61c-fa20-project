.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    addi t0, x0, 5
    bne t0, a0, error1

    addi sp, sp, -80
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # =====================================
    # LOAD MATRICES
    # =====================================
    lw a0, 4(s1)                            # a0 = filename (argv[1])
    addi a1, sp, 36                          # a1 = pointer to m0_rows
    addi a2, sp, 40                          # a2 = pointer to m0_cols
    jal ra, read_matrix
    mv s3, a0                               # s3 = m0 pointer

    lw a0, 8(s1)                            # a0 = filename (argv[2])
    addi a1, sp, 52                          # a1 = pointer to m1_rows
    addi a2, sp, 56                          # a2 = pointer to m1_cols
    jal ra, read_matrix
    mv s4, a0                               # s4 = m1 pointer

    lw a0, 12(s1)                           # a0 = filename (argv[3])
    addi a1, sp, 60                          # a1 = pointer to input_rows
    addi a2, sp, 64                          # a2 = pointer to input_cols
    jal ra, read_matrix
    mv s5, a0                               # s5 = input pointer

    # =====================================
    # FIRST LAYER: m0 * input
    # =====================================
    lw t0, 36(sp)                           # m0_rows
    lw t1, 64(sp)                           # input_cols
    mul t0, t0, t1
    slli t0, t0, 2
    mv a0, t0                               # bytes
    jal ra, malloc
    beq a0, x0, error2
    mv s6, a0                               # s6 = first output pointer

    mv a0, s3                               # a0 = m0 pointer
    lw a1, 36(sp)                           # a1 = m0_rows
    lw a2, 40(sp)                           # a2 = m0_cols
    mv a3, s5                               # a3 = input pointer
    lw a4, 60(sp)                           # a4 = input_rows
    lw a5, 64(sp)                           # a5 = input_cols
    mv a6, s6                               # a6 = destination pointer
    jal ra, matmul

    mv a0, s6                               # a0 = first output pointer
    lw a1, 36(sp)                           # a1 = m0_rows
    lw a2, 64(sp)                           # a2 = input_cols
    jal ra, relu

    # =====================================
    # SECOND LAYER: m1 * ReLU(m0*input)
    # =====================================
    lw t0, 52(sp)                           # m1_rows
    lw t1, 64(sp)                           # input_cols
    mul t0, t0, t1
    slli t0, t0, 2
    mv a0, t0                               # bytes
    jal ra, malloc
    beq a0, x0, error2
    sw a0, 68(sp)                           # second output pointer

    mv a0, s4                               # a0 = m1 pointer
    lw a1, 52(sp)                           # a1 = m1_rows
    lw a2, 56(sp)                           # a2 = m1_cols
    mv a3, s6                               # a3 = first output pointer
    lw a4, 36(sp)                           # a4 = m0_rows
    lw a5, 64(sp)                           # a5 = input_cols
    lw a6, 68(sp)                           # a6 = destination pointer
    jal ra, matmul

    lw t3, 68(sp)                           # final output pointer
    lw t0, 52(sp)                           # output rows
    lw t1, 64(sp)                           # output cols

    # =====================================
    # WRITE OUTPUT
    # =====================================
    lw a0, 16(s1)                           # output filename
    mv a1, t3                               # matrix pointer
    mv a2, t0                               # rows
    mv a3, t1                               # cols
    mul t2, t0, t1                          # element count
    sw a1, 72(sp)
    sw t2, 76(sp)
    jal ra, write_matrix

    lw a0, 72(sp)
    lw a1, 76(sp)
    jal ra, argmax
    mv t0, a0

    bne s2, x0, classify_end
    li a0, 1
    mv a1, t0
    ecall
    li a0, 11
    li a1, '\n'
    ecall

    mv a0, t0

classify_end:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 80
    ret

error1:
    li a0, 17
    li a1, 89
    ecall

error2:
    li a0, 17
    li a1, 88
    ecall