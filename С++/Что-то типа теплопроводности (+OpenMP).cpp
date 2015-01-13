#include <stdio.h>
#include <math.h>
#include <locale>
#include <ctime>
#include <omp.h>
void sequential();
void omp_parallel();
int main(int argc, char**argv){
	setlocale(LC_ALL, "rus");
	sequential();
	getchar();
	printf("\n\nOpenMP:\n\n\n");
	omp_parallel();
	getchar();
	return 0;
}
void sequential()
{
	double start = omp_get_wtime();
	double tau = 0.001, t = 0.0, tmax = 100.0, h = 0.1, L = 0.0, Lmax = 300.0, r;
	int n = Lmax / h + 1;
	double *a = new double[n];
	double st_time, end_time;
	//FILE *f;
	r = tau / (h*h);
	for (int i = 0; i < (n - 1); i++){
		a[i] = 2 * L*(L + 0.2) + 0.4;
		L += h;
	}
	t += tau;
	a[0] = 2.0 * t + 0.4;
	a[n - 1] = 1.36;
	do {
		for (int i = 1; i < (n - 2); i++)
			a[i] += r*(a[i - 1] - 2 * a[i] + a[i + 1]);
		t += tau;
		a[0] = 2.0 * t + 0.4;
		a[n - 1] = 1.36;
	} while (t <= tmax);
	//f = fopen("results.txt", "a");
	for (int i = 0; i < 10; i++)
		printf("%f \n", a[i]);
	printf("_______________\nВремя выполнения: %f c\n", omp_get_wtime() - start);
	//fclose(f);
}
void omp_parallel()
{
	double tau = 0.001, t = 0.0, tmax = 100.0, h = 0.1, L = 0.0, Lmax = 300.0, r;
	int n = Lmax / h + 1;
	double *a = new double[n];
	double *aa = new double[n];
	r = tau / (h*h);
	int num;
	a[0] = 2.0 * t + 0.4;
	L += h;
	for (int i = 1; i < (n - 1); i++){
		a[i] = 2 * L*(L + 0.2) + 0.4;
		L += h;
	}
	a[n - 1] = 1.36;
	omp_set_num_threads(2);
	double start = omp_get_wtime();
	do {
# pragma omp parallel
		{
# pragma omp for schedule(static,1)
			for (int i = 1; i < (n - 1); i++)
			aa[i] = a[i] + r*(a[i - 1] - 2.0*a[i] + a[i + 1]);

# pragma omp for schedule(static,1)
			for (int i = 1; i < (n - 1); i++)
				a[i] = aa[i];
			num = omp_get_num_threads();
		}
		t += tau;
		a[0] = 2.0 * t + 0.4;
		a[n - 1] = 1.36;
	} while (t <= tmax);
	for (int i = 0; i < 10; i++)
		printf("%f \n", a[i]);
	printf("_______________\nВремя выполнения: %f c\n", omp_get_wtime() - start);
}