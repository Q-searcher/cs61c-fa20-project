/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	Color *newColor = malloc(sizeof(Color));

	int lsb_blue = image->image[row][col].B & 1;
	// 读取给定的行、列的像素，确定蓝色最低位的值
	if(lsb_blue == 1){
		lsb_blue = 255;
	}
	else{
		lsb_blue = 0;
	}
	newColor->R = lsb_blue;
	newColor->G = lsb_blue;
	newColor->B = lsb_blue;

	return newColor;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	// allocate memory
	Image *newImage = malloc(sizeof(Image));
	if(newImage == NULL){
		printf("failed to malloc memory");
		return NULL;
	}
	newImage->image = malloc(image->rows * sizeof(Color*));
	if(newImage->image == NULL){
		printf("failed to malloc memory");
		return NULL;
	}
	for(int i = 0; i < image->rows; i++){
		newImage->image[i] = malloc(image->cols * sizeof(Color));
		if(newImage->image[i] == NULL){
			printf("failed to malloc memory");
			return NULL;
		}
	}

	// transfer the old to the new
	newImage->cols = image->cols;
	newImage->rows = image->rows;

	for(int i = 0; i < image->rows; i++){
		for(int j = 0; j < image->cols; j++){
			Color *temp_color = evaluateOnePixel(image, i, j);  
			newImage->image[i][j].R = temp_color->R;
			newImage->image[i][j].G = temp_color->G;
			newImage->image[i][j].B = temp_color->B;
			free(temp_color);
		}
	}
	return newImage;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code NULL.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	// 检查参数的输入
	if(argc != 2){
		printf("input is not correct!");
		return -1;
	}

	Image *img = readData(argv[1]);
	if(img == NULL){
		printf("failed to read %s", argv[1]);
		return -1;
	}
	Image *newImage = steganography(img);
	if(newImage == NULL){
		printf("failed to create nweImage");
		return -1;
	}
	writeData(newImage);
	freeImage(img);
	freeImage(newImage);
	return 0;
}
