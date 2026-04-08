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

