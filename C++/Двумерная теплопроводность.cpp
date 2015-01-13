#include <stdio.h>
#include <ctime>
#include <math.h>

const int N = 50;

int main(int argc, char**argv){
	double
		h = 1.0,
		tau = 0.01;
	int size, rank;
	/* Начальные условия */
	double U[N][N], newU[N][N];
	for (int i = 1; i < N - 1; i++)
	for (int j = 1; j < N - 1; j++){
		U[i][j] = 22.0;
	}
	for (int i = 0; i < N; i++)	{
		U[i][0] = 0;
		U[i][N - 1] = 22.0*i*pow(exp(1), (-3));
		U[0][i] = 22.0*i*pow(exp(1), (-2));
		U[N - 1][i] = 0;
	}
	/* ... */
	for (double t = 0.0; t < 100.0; t += tau){
		for (int i = 0; i < N; i++)	{
			U[i][N - 1] = 22.0*i*pow(exp(1), (-3 * t));
			U[0][i] = 22.0*i*pow(exp(1), (-2 * t));
		}

		for (int i = 1; i < N - 1; i++)
		for (int j = 1; j < N - 1; j++)
			newU[i][j] = U[i][j] + (tau / (h*h)) * (U[i][j + 1] + U[i + 1][j] + U[i - 1][j] + U[i][j - 1] - 4 * U[i][j]);
		for (int i = 1; i < N - 1; i++)
		for (int j = 1; j < N - 1; j++)
			U[i][j] = newU[i][j];
	}
}
