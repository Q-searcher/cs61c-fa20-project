/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	// allocate memory
	Color *new_color = malloc(sizeof(Color));
	if(new_color == NULL){
		printf("failed to allocate memory");
		return NULL;
	}
	new_color->R = 0;
	new_color->G = 0;
	new_color->B = 0;
	// 基于模运算（mod）实现环绕的网格

	int dx[] = {-1, -1, -1, 0, 0, 1, 1, 1};
	int dy[] = {-1, 0, 1, -1, 1, -1, 0, 1};
	for(int bitCounter = 0; bitCounter < 8; bitCounter++){
		// 取出此刻的最低位
		int aliveR, aliveG, aliveB;
		aliveR = image->image[row][col].R >> bitCounter & 1;
		aliveG = image->image[row][col].G >> bitCounter & 1;
		aliveB = image->image[row][col].B >> bitCounter & 1;

		// mod方法实现环绕网格
		int alive_global_R = 0;
		int alive_global_G = 0;
		int alive_global_B = 0;

		for(int i = 0; i < 8; i++){
			int nx = ( row + dx[i] + image->rows ) % image->rows;
			int ny = ( col + dy[i] + image->cols ) % image->cols;

			if((image->image[nx][ny].R >> bitCounter & 1) == 1){
				alive_global_R++;
			}			
			if((image->image[nx][ny].G >> bitCounter & 1) == 1){
				alive_global_G++;
			}	
			if((image->image[nx][ny].B >> bitCounter & 1) == 1){
				alive_global_B++;
			}	
		}		
		// 如果中心的状态为alive
		int bitJudgeR = (rule >> ((aliveR * 9) + alive_global_R)) & 1;
		new_color->R = new_color->R | (bitJudgeR << bitCounter);	

		int bitJudgeG = (rule >> ((aliveG * 9) + alive_global_G)) & 1;
		new_color->G = new_color->G | (bitJudgeG << bitCounter);	

		int bitJudgeB = (rule >> ((aliveB * 9) + alive_global_B)) & 1;
		new_color->B = new_color->B | (bitJudgeB << bitCounter);	
	}
	return new_color;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
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
			Color *temp_color = evaluateOneCell(image, i, j, rule);
	
			newImage->image[i][j].R = temp_color->R;
			newImage->image[i][j].G = temp_color->G;
			newImage->image[i][j].B = temp_color->B;
			free(temp_color);
		}
	}
	return newImage;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	// 检查参数的输入
	if(argc != 3){
		printf("usage: ./gameOfLife filename rule\n");
		printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
		printf("rule is a hex number beginning with 0x; Life is 0x1808.");
		return -1;
	}

	Image *img = readData(argv[1]);
	if(img == NULL){
		printf("failed to read %s", argv[1]);
		return -1;
	}
	uint32_t rule = (uint32_t) strtol(argv[2], NULL, 16);	
	Image *newImage = life(img, rule);
	if(newImage == NULL){
		printf("failed to create nweImage");
		return -1;
	}
	
	writeData(newImage);
	freeImage(img);
	freeImage(newImage);
	return 0;
}
