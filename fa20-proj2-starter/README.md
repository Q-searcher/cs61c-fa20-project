# fa20-proj2-starter

```plain
.
├── inputs (test inputs)
├── outputs (some test outputs)
├── README.md
├── src
│   ├── argmax.s (partA)
│   ├── classify.s (partB)
│   ├── dot.s (partA)
│   ├── main.s (do not modify)
│   ├── matmul.s (partA)
│   ├── read_matrix.s (partB)
│   ├── relu.s (partA)
│   ├── utils.s (do not modify)
│   └── write_matrix.s (partB)
├── tools
│   ├── convert.py (convert matrix files for partB)
│   └── venus.jar (RISC-V simulator)
└── unittests
    ├── assembly (contains outputs from unittests.py)
    ├── framework.py (do not modify)
    └── unittests.py (partA + partB)
```

## Here's what I did in project 2

## Part A

### Task 1: Relu Function

1. Relu function operates on a 1-D vector
2. the matrix is stored in a row-major format

### Task 2: ArgMax

1. return the **index** of thr largest element

```c++
    int maxNumber = 0;
    int index = 0;
    if (array.length < 1) {
        return with error code 77
    }
    for (int i = 0; i < array.length; i++) {
        if (maxNumber < array[i]) {
            maxNumber = array[i];        
            index = i
        }
    }
    return index;
```

### Task 3.1: Dot Product

implement the dot function in `dot.s`, which take in two vector and returns their dot product

1. remember to consider the stride for each vector
2. lenth less than 1, return 75
3. stride less than 1, return 76

```c++
    if (vector.length < 1) return 75;
    if (stride < 1) return 76
    int result = 0;
    int tempValue;

    for (int i = 0; i < array.length; i++) {
        tempValue = array_1[i] * array_2[i];
        result += tempValue;
    }
    return result
```

### Task 3.2: Matrix Multiplication

1. `m0`is the left matrix, and `m1` is the right matrix
2. The stride for row vectors will be different than the stride for column vectors when calling the dot function
3. you can't cover the origin matrix until you finish the loop

```c++
    if (row1.length < 1) return 72;
    if (column1.length < 1) return 72;

    if (row2.length < 1) return 73;
    if (column2.length < 1) return 73;

    if (column1.length != row2.length) return 74;

    for (int i = 0; i < column1.length(m); i++) {
        for (int j = 0; j < row2.length(n); j++) {
            dot(m0, m1);
        }
    }
```

## Part B

- remember that the first and second 4 bytes representing the dimensions and the rest are integer elements of the matrix
- the `utils.s` provide lots of useful function to call with

### Task 1: Read Matrix

1. The first 8 bytes are two 4 byte ints representing the length of rows and columns in the matrix
2. return a0 (int*)  is the pointer to the matrix in memory

```c++
    FILE newFile = fopen("fileName");
    if (newFile == NULL) return 90;

    fread("fileName", "8 Bytes");          // get the rows and columns
    if (fail) return ...

    int numValue = rows * column
    int *matrix = malloc(sizeof(numValues));
    if (fail) return ...

    for (int i = 0; i < numValue; i++) {
        fread("fileName", "4 Bytes");
        if (fail) return ...
    }

    fclose("fileName")
    if (fail) return ...

    free(matrix)

```

### Task 2: Write Matrix

- every value is in size of int, which means it take 4 bytes to save

```c++
    fopen(fileName);
    check()

    fwrite(row);
    fwrite(column);

    for (i =0; i < size; i++) {
        fwrite(matrix[i]);
    }

    
```