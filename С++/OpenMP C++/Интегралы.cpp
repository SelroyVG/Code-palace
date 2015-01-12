#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>
float function(int i);
using namespace std;
int main(int argc, char **argv)
{

	float time_s = omp_get_wtime();
	printf("Time:        %f\n", time_s);
	int size, rank;
	float results = 0;
	float sum;
	float x_begin = 1.0, x_end = 2.0, tau = 0.0001, result_rectangle[4], result_trap[4], integr1 = 0, integr2 = 0;
	int time_begin, time_end, time;
	FILE *f;
	omp_set_num_threads(4);
#pragma omp parallel shared (result_rectangle, result_trap)
	{
		int rank = omp_get_thread_num();
		int iterations = 10000; 
		result_rectangle[rank] = 0;
		result_trap[rank] = 0;

		for (int i = 2500 * rank; i < 2500 * (rank + 1); i++){
			result_rectangle[rank] += function(i)*tau;
		}
		integr1 += result_rectangle[rank];
#pragma omp barrier
		if (rank == 0)
			printf("Rectangle method: %f\n", integr1);
#pragma omp barrier
		for (int i = 2500 * rank; i < 2500 * (rank + 1); i++){
			result_trap[rank] += ((function(i) + function(i + tau))*tau) / 2;
		}
		integr2 += result_trap[rank];
#pragma omp barrier
		if (rank == 0)
			printf("Trapezoid method: %f\n", integr2);
	}
	printf("Time:        %f\n", omp_get_wtime());
	getchar();

	return 0;
}
float function(int i)
{
	float x = 1 + i*0.0001;
	return sqrt(x*x + 0.16) / x*x;
}
