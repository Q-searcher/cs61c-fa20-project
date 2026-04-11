# CS61C-Project1
## PPM Format
1. first line: tell the format
2. second line: width and height
3. third line: scale of coler

### 注意事项
- `convert`用来将`.ppm`格式转变成更加标准的格式

## File I/O
1. `color`存储像素
2. `Image`存储图像

### 注意事项
- 使用`fopen`,  `fclose`, `fscanf`来读取数据

## Implement
### Part A1
在`imageloder`中，写`readData`, `writeData`, `freeImage`三个函数
1. `readData` read an Image struct from a .ppm file
2. `writeData` write an Image struct in its PPM format to standard output
3. `freeImage` free an Image object. 

### Part A2
在`steganography.c`中，实现`evaluateOnePixel`, `steganography`, `main`函数
1. `evaluateOnePixel`确定给定行/列位置的单元格应是什么颜色。该操作不应影响原图像（Image），并且应为新的颜色（Color）分配内存空间。
2. `steganography`, 给定一张图像，创建一张新图像，从蓝色通道（B 通道）中提取最低有效位（LSB）
3. `main`函数

### part B
实现`gameoflife`
1. 规则是16进制的数字，通过逐一取出，直到遇见1，此时对应的操作数就是规则的要求，然后继续执行
2. 