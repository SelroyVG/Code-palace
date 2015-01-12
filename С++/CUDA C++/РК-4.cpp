#include <iostream>
#include <cuda_runtime.h>
#include <math.h>

const int n = 2;

__device__ float f(float x, float y, int idx){
	if (idx == 0)
		return x*(1.0 - sqrt(x*x + y*y) - y);
	else
		return y*(1.0 - sqrt(x*x + y*y) + x);
}

__global__ void Kernel(float *x, int t){
	float tau = 0.01;
	int idx = threadIdx.x;
	int i = (t - 1) * 2;
	__shared__ float r1[n], r2[n], r3[n], r4[n];
	r1[idx] =  tau * f(x[i], x[i + 1], idx);
	__syncthreads();
	r2[idx] =  tau * f(x[i] + 0.5*r1[0], x[i + 1] + 0.5*r1[1], idx);
	__syncthreads();
	r3[idx] =  tau * f(x[i] + 0.5*r2[0], x[i + 1] + 0.5*r2[1], idx);
	__syncthreads();
	r4[idx] =  tau * f(x[i] + r3[0], x[i + 1] + r3[1], idx);
	__syncthreads();
	x[idx + i + n] = x[idx + i] + (r1[idx] + 2 * r2[idx] + 2 * r3[idx] + r4[idx]) / 6.0;
}

int main(){	
	int m = 1000;
	int size = n*m*sizeof(float);
	float *xDevice = NULL;
	float *x = (float*)malloc(size); // ???
	x[0] = x[1] = 1.0;
	cudaMalloc((void**)&xDevice, size);
	cudaMemcpy(xDevice, x, size, cudaMemcpyHostToDevice);
	for (int t = 1; t < m; t++)
		Kernel<<<1, n>>>(xDevice, t);
	cudaThreadSynchronize();
	cudaMemcpy(x, xDevice, size, cudaMemcpyDeviceToHost);
	cudaFree(xDevice);
	for (int t = 0; t < 20; t++)
		printf("x[0] = %f x[1] = %f \n", x[t*n], x[t*n + 1]);
	free(x);
	getchar();
	return 0;
}
