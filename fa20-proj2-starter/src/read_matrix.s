.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	# safe the arguments in s register
    
    addi sp, sp, -4
    sw ra, 0(sp)
    
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)                       # save the file descriptor
    sw s4, 16(sp)                       # store the address of malloc memory
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    # prepare the arguements for fopen
    mv a1, s0                           # a1 = filePath
    add a2, x0, x0                      # a2 = permissions (0, 1, 2, 3, 4, 5 = r, w, a, r+, w+, a+)
    jal ra, fopen                       # fopen(file)
        
    addi t0, x0, -1                     
    beq a0, t0, error1                  # if(a0 == -1) return 90
    mv s3, a0                           # save the file descriptor
    
    # prepare the arguements for fread
    mv a1, s3                           # a1 = file descriptor
    
    addi sp, sp, -4                     # a2 = pointer to the buffer you want to write the read bytes to.
    sw a1, 0(sp)                        # protect the value in a1
    
    addi a0, x0, 8
    
#     addi sp, sp, -4
#     sw a0, 0(sp)
#     jal ra, num_alloc_blocks            # store the size of before_heap_block in a0
#     mv s0, a0
#     lw a0, 0(sp)
#     addi sp, sp, 4
    
    jal ra malloc  
    # check whether malloc is success or not
    # If malloc hook forces a0==0 we should treat it as failure.
    beq a0, x0, error2
    # also verify allocator bookkeeping (num_alloc_blocks)
    # Prologue
#     addi sp, sp, -4
#     sw a0, 0(sp)
#     jal ra, num_alloc_blocks
#     sub t1, a0, s0
#     addi t0, x0, 1
#     bne t1, t0, error2
#     lw a0, 0(sp)
#     addi sp, sp, 4
    # Epilogue
    
    mv a2, a0
    mv s4, a0 
    
    lw a1, 0(sp)
    addi sp, sp, 4      
    
    addi a3, x0, 8                      # a3 = Number of bytes to be read.
    
    jal ra, fread                       # fread the row and the column
    # check whether fread is success or not
    # Prologue
    addi t0, x0, 8
    bne t0, a0, error3    
    # Epilogue
    
    # Todo: save the value of rowLength and columnLength in the position safed in a2(fopen)
    lw t0, 0(s4)
    sw t0, 0(s1)                        # store the value of row
    lw t1, 4(s4)
    sw t1, 0(s2)                        # store the value of column
    mul t0, t0, t1                      # numValue = row * column
    
    mv a0, s4
    # free the memory in heap
    addi sp, sp, -4
    sw t0, 0(sp)
    jal ra free
    lw t0, 0(sp)
    addi sp, sp, 4
    
    # alloclate memory for the matrix
    # prepare the arguement for malloc
    slli t0, t0, 2
    mv a0, t0
    
#     addi sp, sp, -4
#     sw a0, 0(sp)
#     jal ra, num_alloc_blocks            # store the size of before_heap_block in a0
#     mv s0, a0
#     lw a0, 0(sp)
#     addi sp, sp, 4
    
    jal ra, malloc
    # check whether malloc is success or not
    beq a0, x0, error2
    # check allocator bookkeeping (num_alloc_blocks)
    # Prologue
#     addi sp, sp, -4
#     sw a0, 0(sp)
#     jal ra, num_alloc_blocks            # store the size of heap_block in a0
#     sub t1, a0, s0
#     addi t0, x0, 1
#     bne t1, t0, error2
#     lw a0, 0(sp)
#     addi sp, sp, 4
    # Epilogue
    
    mv s4, a0                           # store the address of allocated memory
    
    # start loop, getting all the value of the matrix
    # attention: now s0 store the numValue
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul s0, t0, t1
    add t0, x0, x0                      # int i = 0
    mv t1, s4                           # a pointer pointing to the beginning of the alloclated memory
   
   # t0, t1 needed to be stored if call other function
loop_start:
    beq t0, s0, loop_end
    # prepare the arguements for fread
    mv a1, s3                           # a1 = file descriptor
    # slli t2, t0, 2                      # claculate the offset
    # addi t1, t1, 4                      # pointer += 1
    mv a2, t1                           # a2 = the buffer you want to write the bytes to
    addi a3, x0, 4                      # a3 = number of bytes you read
    
    # safe t0, t1 and then call the fread function
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    jal ra fread
    # check whether fread is success or not
    # Prologue
    addi t0, x0, 4
    bne t0, a0, error3    
    # Epilogue
    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8
    
    addi t1, t1, 4
    addi t0, t0, 1                      # i++

    j loop_start
      
loop_end:
    
    # close the file
    mv a1, s3
    jal ra, fclose
    # test
    # Prologue
    add t0, x0, x0
    bne t0, a0, error4
    # Epilogue
    
    mv a0, s4
    
         
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    addi sp, sp, 20
    
    lw ra, 0(sp)
    addi sp, sp, 4

    # Epilogue
    ret
    
error1:
    li a0, 17
    li a1, 90
    ecall
    
error2:
    li a0, 17
    li a1, 88
    ecall   

error3:
    li a0, 17
    li a1, 91
    ecall   

error4:
    li a0, 17
    li a1, 92
    ecall   
