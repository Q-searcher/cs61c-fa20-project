/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	FILE *file = fopen(filename, "r");
	if(file == NULL){
		perror("Error opening file");
		return 1;
	}	
	// 定义存储.ppm元数据的变量
	char format[3];
	int width, height;
	int scale;
	uint16_t red, green, blue;

	Image *img = malloc(sizeof(Image));
	// 读取数据
	if(fscanf(file, "%s %d %d %d", format, &width, &height, &scale) != 4){
		printf("failed to read data from file. \n");
		fclose(file);
		return 0;
	}
	img->rows = width;
	img->cols = height;
	img->image = malloc(width * height * sizeof(Color));
	
	// 读取像素
	// 遍历所有行
	for(int i = 0; i < height; i++){
		// 遍历所有列
		for(int j = 0; j < width; j++){
			fscanf(file, "%hu %hu %hu", red, green, blue);
			img->image[i * width + j]->R = red;	
			img->image[i * width + j]->G = green;	
			img->image[i * width + j]->B = blue;	
		}
	}	

	fclose(file);
	return img;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
}

//Frees an image
void freeImage(Image *image)
{
	//YOUR CODE HERE
}