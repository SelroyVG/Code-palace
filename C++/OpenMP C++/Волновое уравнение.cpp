#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
void Wave(double xmax, double ymax, double h, double c, double startPointX, double startPointY, double Vst, double tau, double tmax){
	double r = (c * tau * tau) / (h * h);
	int N = (int)(xmax / h);
	int impactPointX = (int)(startPointX / h);
	int impactPointY = (int)(startPointY / h);

	double **oldU = new double*[N];
	double **futureU = new double*[N];

	for (int i = 0; i < N; i++) {
		oldU[i] = new double[N]; 
		futureU[i] = new double[N];
	}
	for (int i = 0; i < N; i++)
	for (int j = 0; j < N; j++){
		oldU[i][j] = 0.0;
		U[i][j] = 0.0;
		futureU[i][j] = 0.0;
	}
	oldU[impactPointX][impactPointY] = -tau * Vst;
		for (int i = 1; i < N - 1; i++)
		for (int j = 1; j < N - 1; j++)
			futureU[i][j] = 2.0*U[i][j] - oldU[i][j] + r*(U[i - 1][j] + U[i + 1][j] + U[i][j - 1] + U[i][j + 1] - 4.0*U[i][j]);
		for (int i = 1; i < N - 1; i++)
		for (int j = 1; j < N - 1; j++){
			oldU[i][j] = U[i][j];
			U[i][j] = futureU[i][j];
		}
	
#pragma omp parallel shared(oldU, futureU, U)
	{
		for (double t = 0; t <= tmax; t += tau){
			#pragma omp for schedule (static)
			for (int i = 1; i < N - 1; i++)
			for (int j = 1; j < N - 1; j++)
				futureU[i][j] = 2.0*U[i][j] - oldU[i][j] + r*(U[i - 1][j] + U[i + 1][j] + U[i][j - 1] + U[i][j + 1] - 4.0*U[i][j]);
			#pragma omp for schedule (static)
			for (int i = 1; i < N - 1; i++)
			for (int j = 1; j < N - 1; j++){
				oldU[i][j] = U[i][j];
				U[i][j] = futureU[i][j];
			}
#pragma omp barrier
			#pragma omp single
			{
				for (int i = 0; i < N; i++){
					for (int j = 0; j < N; j++)
						printf("%.2f ", U[i][j]);
					printf("\n");
				}
				getchar();
			}
		}
	}
}
void main(){
	float	tau = 0.01, 
		tmax = 10.0, 
		h = 0.1, 
		c = 1.0, 
		xmax = 1.0, 
		ymax = 1.0, 
		startPointX = 0.55, 	
		startPointY = 0.55, Vst = 1.6;
	int N = (int)(xmax / h);
	double **U = new double*[N];
	for (int i = 0; i < N; i++) {
		U[i] = new double[N];
	}
	Wave(U, xmax, ymax, h, c, startPointX, startPointY, Vst, tau, tmax);
}
