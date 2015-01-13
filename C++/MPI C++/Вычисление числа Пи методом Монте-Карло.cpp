// Для вычисления приближённого значения числа π воспользуемся методом Монте-Карло.
// Число π равно площади круга с радиусом = 1. Для всех точек, которые попали внутрь этого круга
// справедливо утверждение что x^2+y^2≤1. Этот круг вписан в квадрат со стороной = 2 и площадью равной 4.
// Если мы сгенерируем некоторое количество точек со случайными координатами внутри этого квадрата, доля точек,
// попавших внутрь круга будет приблизительно равна 3.14/4. Умножив на 4 получим приблизительное значение числа π.
// Для увеличения точности в программе данные действия будут выполнять N процессов, после чего нулевой процесс
// найдёт среднее значение среди всех полученных результатов.

#include <stdio.h>
#include <time.h>
#include <mpi.h>

int Process();
const int N = 1000000;
const float N_float = 1000000.0;

int main(int argc, char **argv)
{
	int size, rank;
	MPI_Status status;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	double time = MPI_Wtime();
double res = (Process() / N_float)*4.0;
double results;
	MPI_Reduce(&res, &results, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
	results /= size;
	time = MPI_Wtime() - time;
	if (rank == 0)
	{
		FILE *f;
		f = fopen("results.txt", "a");
		fprintf(f, " result = %f\n time = %f", results, time);
		fclose(f);
	}
	MPI_Finalize();
	return 0;
}

int Process()
{
	srand(time(NULL));
	int insidePoints = 0;
	for (int i = 0; i < N; i++){
		double x = rand() % N / N_float;
		double y = rand() % N / N_float;
		if ((x*x + y*y) < 1)
			insidePoints++;
	}
	return insidePoints;
}
