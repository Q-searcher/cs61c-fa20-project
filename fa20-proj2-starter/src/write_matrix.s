.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)
    
    mv s1, a1                               # s1 = pointer to the start of the matrix in memory
    mv s2, a2                               # s2 = rows
    mv s3, a3                               # s3 = columns
    
    # open the file, prepare the arguements
    mv a1, a0                               # a1 = filePath
    addi a2, x0, 1                          # a2 = permission
    jal ra, fopen
    # check whether open success
    addi t0, x0, -1
    beq t0, a0, error1
    mv s0, a0                               # s0 = file discripter
    
    # write the rows and columns 
    addi sp, sp, -8
    sw s2, 0(sp)
    sw s3, 4(sp)
    # prepare the arguements
    mv a1, s0                               # a1 = file discripter
    mv a2, sp                               # a2 = buffer to read from
    addi a3, x0, 2                          # a3 = Number of items to read from the buffer
    addi a4, x0, 4                          # a4 = Size of each item in the buffer
    jal ra, fwrite
    # check fwrite
    # prologue
    addi t0, x0, 2
    blt a0, t0, error2
    # epilpgue
    addi sp, sp, 8
    
    mul t0, s2, s3                          # the number of elements in matrix
    mv a1, s0                               # a1 = file discripter
    mv a2, s1                               # a2 = buffer to read from
    add a3, x0, t0                          # a3 = Number of items to read from the buffer
    addi a4, x0, 4                          # a4 = Size of each item in the buffer
    jal ra, fwrite
    # check fwrite
    # prologue
    mul t0, s2, s3                          # the number of elements in matrix
    blt a0, t0, error2
    # epilpgue
    
    # close the file
    mv a1, s3
    jal ra, fclose
    # test
    # Prologue
    add t0, x0, x0
    bne t0, a0, error3
    # Epilogue
     
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20



    # Epilogue


    ret
    
error1:
    li a0, 17
    li a1, 93
    ecall   

error2:
    li a0, 17
    li a1, 94
    ecall 
    
error3:
    li a0, 17
    li a1, 95
    ecall 
      