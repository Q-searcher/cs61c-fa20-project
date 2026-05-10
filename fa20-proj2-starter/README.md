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
