#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>

const int BLOCK_SIZE = 8;

__global__ void Wave(float *oldU, float *U, float *futureU, int N, float r){
	int xIndex = blockDim.x * blockIdx.x + threadIdx.x;
	int yIndex = blockDim.y * blockIdx.y + threadIdx.y;
	if ((xIndex < N - 1) && (yIndex < N - 1) && (xIndex > 0) && (yIndex > 0))
		futureU[xIndex*N + yIndex] = 2.0*U[xIndex*N + yIndex] - oldU[xIndex*N + yIndex] + r*(U[(xIndex - 1)*N + yIndex] + U[(xIndex + 1)*N + yIndex] + U[xIndex*N + yIndex + 1] + U[xIndex*N + yIndex - 1] - 4.0*U[xIndex*N + yIndex]);
}

void CUDAWave(float tau, float tmax, float h, float c, float xmax, float ymax, float startPointX, float startPointY, float Vst){
	float r = (c * tau * tau) / (h * h);
	int N = (int)(xmax / h + 1);
	int sizeOfMemory = N*N*sizeof(float);
	float *U = new float[N*N];
	float *oldU = new float[N*N];
	float *futureU = new float[N*N];
	memset(U, 0, sizeOfMemory);
	memset(oldU, 0, sizeOfMemory);
	memset(futureU, 0, sizeOfMemory);
	float *UForDevice = NULL, *oldUForDevice = NULL, *futureUForDevice = NULL;
	int impactPointX = (int)(startPointX / h);
	int impactPointY = (int)(startPointY / h);
	for (int i = 0; i < N; i++)
	for (int j = 0; j < N; j++){
		futureU[i*N + j] = 0.0;
		U[i*N + j] = 0.0;
		oldU[i*N + j] = 0.0;
	}
	oldU[impactPointX*N + impactPointY] = -tau * Vst;
	cudaMalloc((void**)&UForDevice, sizeOfMemory);
	cudaMalloc((void**)&oldUForDevice, sizeOfMemory);
	cudaMalloc((void**)&futureUForDevice, sizeOfMemory);
	cudaMemcpy(UForDevice, U, sizeOfMemory, cudaMemcpyHostToDevice);
	cudaMemcpy(futureUForDevice, futureU, sizeOfMemory, cudaMemcpyHostToDevice);
	cudaMemcpy(oldUForDevice, oldU, sizeOfMemory, cudaMemcpyHostToDevice);
	for (float time = 0.0; time < tmax; time += tau){
		Wave << < dim3((N / BLOCK_SIZE) + 1, (N / BLOCK_SIZE) + 1), dim3(BLOCK_SIZE, BLOCK_SIZE) >> > (oldUForDevice, UForDevice, futureUForDevice, N, r);
		cudaThreadSynchronize();
		cudaMemcpy(oldUForDevice, UForDevice, sizeOfMemory, cudaMemcpyDeviceToDevice);
		cudaMemcpy(UForDevice, futureUForDevice, sizeOfMemory, cudaMemcpyDeviceToDevice);
		cudaMemcpy(U, UForDevice, sizeOfMemory, cudaMemcpyDeviceToHost);
		for (int i = 0; i < N; i++){
			for (int j = 0; j < N; j++)
				printf("%.3f ", U[i*N + j]);
			printf("\n");
		}
		printf("\n\n");
		getchar();
	}
	cudaMemcpy(U, UForDevice, sizeOfMemory, cudaMemcpyDeviceToHost);
	cudaFree(UForDevice);
	cudaFree(oldUForDevice);
	cudaFree(futureUForDevice);
}
int main(){
	float
		tau = 0.01,
		tmax = 10.0,
		h = 0.1,
		c = 1.0,
		xmax = 1.0,
		ymax = 1.0,
		startPointX = 0.6,
		startPointY = 0.6,
		Vst = 1.6;
	CUDAWave(tau, tmax, h, c, xmax, ymax, startPointX, startPointY, Vst);
	return 0;
}
