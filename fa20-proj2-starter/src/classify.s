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

    # test the argc
    addi t0, x0, 5                         
    bne t0, a0, error1

    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

	# =====================================
    # LOAD MATRICES
    # =====================================
    addi sp, sp, -24
    # Load pretrained m0
    addi sp, sp, -8
    lw a0, 4(s1)                            # a0 = filename (argv[1])
    addi a1, sp, 0                          # a1 = int *
    addi a2, sp, 4                          # a2 = int *
    jal ra, read_matrix
    mv t0, a0                               # t0 = m0
    addi sp, sp, 8

    sw a1, 0(sp)                            # vector[0] = m0_row
    sw a2, 4(sp)                            # vector[1] = m0_column
    
    # Load pretrained m1
    addi sp, sp, -4
    sw t0, 0(sp)

    addi sp, sp, -8
    lw a0, 8(s1)                            # a0 = filename (argv[2])
    addi a1, sp, 0                          # a1 = int *
    addi a2, sp, 4                          # a2 = int *
    jal ra, read_matrix
    mv t1, a0                               # t1 = m1
    addi sp, sp, 8

    lw t0, 0(sp)
    addi sp, sp, 4

    sw a1, 8(sp)                            # vector[2] = m1_row
    sw a2, 12(sp)                           # vector[3] = m1_column

    # Load input matrix

    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    
    addi sp, sp, -8
    lw a0, 12(s1)                           # a0 = filename (argv[3])
    addi a1, sp, 0                          # a1 = int *
    addi a2, sp, 4                          # a2 = int *
    jal ra, read_matrix
    mv t2, a0                               # t2 = input
    addi sp, sp, 8

    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8


    sw a1, 16(sp)                           # vector[4] = input_row
    sw a2, 20(sp)                           # vector[5] = input_column
    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    # remember to malloc memory for the result
    # m0 * input
    # t0, t1, t2 should't be changed
    # malloc memory
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)

    mv s0, t0                               # m0
    mv s1, t1                               # m1
    mv s2, t2                               # input

    lw t3, 0(sp)
    lw t4, 20(sp)
    mul t3, t3, t4
    slli t3, t3, 2

    mv a0, t3                               # size of memory

    jal ra, malloc
    beq a0, x0, error2
    mv a6, a0                               # a6 = start of d

    mv a0, s0                               # a0 (int*)  is the pointer to the start of m0 
    lw t3, 0(sp)
    lw t4, 4(sp)
    mv a1, t3                               # a1 = m0_row
    mv a2, t4                               # a2 = m0_column

    mv a3, s2                               # a3 (int*)  is the pointer to the start of m1
    lw t3, 16(sp)
    lw t4, 20(sp)
    mv a4, t3                               # a4 = input_row
    mv a5, t4                               # a5 = input_column

    jal ra, matmul

    # ReLU(m0 * input) 
    mv a0, a6                               # a0 = the pointer to the array
    lw t3, 0(sp)
    lw t4, 20(sp) 
    mul a1, t3, t4
    jal ra, relu

    # m1 * ReLU(m0 * input) 
    addi sp, sp, -4
        sw a0, 0(sp)
        lw t3, 8(sp)
        lw t4, 20(sp)
        mul t3, t3, t4
        slli t3, t3, 2

        mv a0, t3                               # size of memory

        jal ra, malloc
        beq a0, x0, error2
        mv a6, a0                               # a6 = start of d
        lw a0, 0(sp)
    addi sp, sp, 4
    mv t0, a0
    mv a0, s1                               # a0 = m1
    lw t3, 8(sp)
    lw t4, 12(sp)
    mv a1, t3                               # a1 = m1_row
    mv a2, t4                               # a2 = m1_column 
    mv a3, t0                               # ReLU(m0 * input)
    lw t3, 0(sp)
    lw t4, 20(sp)
    mv a4, t3                               # a4
    mv a5, t4                               # a5

    jal ra, matmul

    mv t3, a6                               # safe the result

    lw t0, 8(sp)                            # row
    lw t1, 20(sp)                           # column

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    addi sp, sp ,24


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)
    mv a1, t3
    mv a2, t0
    mv a3, t1
    mul t0, a2, a3

    addi sp, sp, -8
    sw a1, 0(sp)
    sw t0, 4(sp)
    jal ra, write_matrix
    lw a1, 0(sp)
    lw t0, 4(sp)
    addi sp, sp, 8

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, a1
    mv a1, t0

    jal ra, argmax

    mv t0, a0

    # Print classification
    bne s2, x0, classify_end
    li a0, 1
    mv a1, t0
    ecall

    # Print newline afterwards for clarity
    li a0, 11          # syscall: print_char
    li a1, '\n'
    ecall

classify_end:

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

error1:
    li a0, 17
    li a1, 89
    ecall

error2:
    li a0, 17
    li a1, 88
    ecall