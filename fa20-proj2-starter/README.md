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
