#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <ctime>
#include <math.h>
#include <locale.h>

#define N 10 
#define tau 0.01
#define MIN_POSITION -5.0
#define MAX_POSITION 5.0
#define MAX_ITERATIONS 10

__global__ void Nbody (float*U, float*newU){

	int A1 = 1, // Какие-то случайные константы, для подстановки в уравнение
	    A2 = 2,
	    p1 = 3,
	    p2 = 2;

	int i = threadIdx.x * 4;
	float Vx = 0.0f; float Vy = 0.0f; 
	for (int j = 0; j < N * 4; j += 4){
		if (i != j){ // Вычисление взаимодействия с другими частицами 
			Vx += ((A1*(U[j + 2] - U[i + 2])) / pow(pow((pow((U[j + 2] - U[i + 2]), 2) + pow((U[j + 3] - U[i + 3]), 2)), 0.5f), p1)) - ((A2*(U[j + 2] - U[i + 2])) / pow(pow((pow((U[j + 2] - U[i + 2]), 2) + pow((U[j + 3] - U[i + 3]), 2)), 0.5f), p2));
			Vy += ((A1*(U[j + 3] - U[i + 3])) / pow(pow((pow((U[j + 2] - U[i + 2]), 2) + pow((U[j + 3] - U[i + 3]), 2)), 0.5f), p1)) - ((A2*(U[j + 3] - U[i + 3])) / pow(pow((pow((U[j + 2] - U[i + 2]), 2) + pow((U[j + 3] - U[i + 3]), 2)), 0.5f), p2));
		}
	}
	newU[i] = U[i] + tau *Vx; // Скорости
	newU[i + 1] = U[i + 1] + tau *Vy;


	float newPosition = U[i + 2] + tau*newU[i]; // Определение новой позиции
	if ((newPosition > MAX_POSITION) || (newPosition < MIN_POSITION)) {
		newU[i] = -newU[i];
		newU[i + 2] = U[i + 2] + tau*newU[i];
	} else
		newU[i + 2] = newPosition;

	newPosition = U[i + 3] + tau*newU[i + 1];
	if ((newPosition > MAX_POSITION) || (newPosition < MIN_POSITION)){
		newU[i + 1] = -newU[i + 1];
		newU[i + 3] = U[i + 3] + tau*newU[i + 1];
	} else 
		newU[i + 3] = newPosition;
}

int main(){
	setlocale(LC_ALL, "rus");
	srand(time(NULL));
	int sizeOfFloatArray = N * 4 * sizeof(float);
	float *U, *UDevice = NULL, *newUDevice = NULL;
	U = new float[N * 4];
	memset(U, 0, sizeOfFloatArray);
	for (int i = 0; i < N; i++){
		U[i * 4]     = 0.0; // Скорость по X
		U[i * 4 + 1] = 0.0; // Скорость по Y
		U[i * 4 + 2] = float(rand()) / RAND_MAX - 0.5f; // Координата по X
		U[i * 4 + 3] = float(rand()) / RAND_MAX - 0.5f; // Координата по Y
	}
	cudaMalloc((void**)&UDevice, sizeOfFloatArray);
	cudaMalloc((void**)&newUDevice, sizeOfFloatArray);

	cudaMemcpy(UDevice, U, sizeOfFloatArray, cudaMemcpyHostToDevice);
	cudaMemcpy(newUDevice, U, sizeOfFloatArray, cudaMemcpyHostToDevice);

	for (int iteration = 0; iteration <= MAX_ITERATIONS; iteration++){
		Nbody <<< 1, N >>> (UDevice, newUDevice);
		cudaThreadSynchronize();
		cudaMemcpy(UDevice, newUDevice, sizeOfFloatArray, cudaMemcpyDeviceToDevice);
	} 
	cudaMemcpy(U, UDevice, sizeOfFloatArray, cudaMemcpyDeviceToHost);
	for (int i = 0; i < N; i++){
		printf("№%d  | ", i);
		printf("Vx = %.3f; ", U[i * 4]); 
		printf("Vy = %.3f; ", U[i * 4 + 1]); 
		printf("X = %.3f; ", U[i * 4 + 2]); 
		printf("Y = %.3f; ", U[i * 4 + 3]); 
		printf("\n");
	}

	cudaFree(UDevice);
	cudaFree(newUDevice);
	delete[] U;
	return 0;
}
