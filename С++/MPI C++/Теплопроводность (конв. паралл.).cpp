#include <stdio.h>
#include <ctime>
#include <mpi.h>
#include <math.h>

const int N = 50;

int main(int argc, char**argv){
	double
		h = 1.0,
		tau = 0.01,
		t = 0.0,
		tmax = 100.0,
		xmin = 0.0,
		ymin = 0.0,
		step = 0.0;
	int size, rank;
	FILE *f;

	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

	double r = tau / (h*h);

	int num = N / size;

	if ((rank == 0) || (rank == size - 1))
		num += 1;
	else
		num += 2;

	/**/
	double *buf = new double[N];
	double U[N][N];
	double newU[N][N];


	for (int i = 1; i < N - 1; i++)
	for (int j = 1; j < N - 1; j++){
		U[i][j] = 22.0;
	}
	for (int i = 0; i < N; i++){
		U[i][0] = 0;
		U[i][N - 1] = 22.0*i*pow(exp(1), (-3));
		U[0][i] = 22.0*i*pow(exp(1), (-2));
		U[N - 1][i] = 0;
	}


	MPI_Barrier(MPI_COMM_WORLD);
	double time = MPI_Wtime();


	while (t < tmax){

		if (rank == 0){
			for (int i = 0; i < num - 1; i++)
			for (int j = 1; j <= N - 1; j++){
				if (i == 0)
					U[0][i] = 22.0*i*pow(exp(1), (-2));
				if (j == N - 1)
					U[i][N - 1] = 22.0*i*pow(exp(1), (-3));
				else if ((i != 0))
					newU[i][j] = U[i][j] + r*(U[i - 1][j] + U[i + 1][j] + U[i][j - 1] + U[i][j + 1] - 4.0*U[i][j]);
			}

			MPI_Recv(buf, N, MPI_DOUBLE, rank + 1, 111, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

			for (int j = 1; j < N - 1; j++)
				newU[num - 1][j] = U[num - 1][j] + r*(U[num - 2][j] + buf[j] + U[num - 1][j - 1] + U[num - 1][j + 1] - 4.0*U[num - 1][j]);

			MPI_Send(U[num - 1], N, MPI_DOUBLE, rank + 1, 111, MPI_COMM_WORLD);

			for (int i = 0; i <= num - 1; i++)
			for (int j = 0; j <= N - 1; j++)
				U[i][j] = newU[i][j];

		}


		else if (rank == size - 1){
			MPI_Send(U[0], N, MPI_DOUBLE, rank - 1, 111, MPI_COMM_WORLD);
			MPI_Recv(buf, N, MPI_DOUBLE, rank - 1, 111, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

			for (int i = 0; i < num - 1; i++)
			for (int j = 1; j <= N - 1; j++){
				if (i == 0)
					newU[i][j] = U[i][j] + r*(U[i + 1][j] + buf[j] + U[i][j - 1] + U[i][j + 1] - 4.0*U[i][j]);
				else if (j == N - 1)
					U[i][N - 1] = 22.0*i*pow(exp(1), (-3));
				else
					newU[i][j] = U[i][j] + r*(U[i - 1][j] + U[i + 1][j] + U[i][j - 1] + U[i][j + 1] - 4.0*U[i][j]);
			}
			for (int i = 0; i <= num - 1; i++)
			for (int j = 0; j <= N - 1; j++)
				U[i][j] = newU[i][j];

		}

		else{
			MPI_Send(U[0], N, MPI_DOUBLE, rank - 1, 111, MPI_COMM_WORLD);
			MPI_Recv(buf, N, MPI_DOUBLE, rank - 1, 111, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
			for (int i = 0; i < num - 1; i++)
			for (int j = 1; j <= N - 1; j++){
				if (i == 0)
					newU[i][j] = U[i][j] + r*(U[i + 1][j] + buf[j] + U[i][j - 1] + U[i][j + 1] - 4.0*U[i][j]);
				else if (j == N - 1)
					U[i][N - 1] = 22.0*i*pow(exp(1), (-3));
				else
					newU[i][j] = U[i][j] + r*(U[i - 1][j] + U[i + 1][j] + U[i][j - 1] + U[i][j + 1] - 4.0*U[i][j]);
			}

			MPI_Recv(buf, N, MPI_DOUBLE, rank + 1, 111, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

			for (int j = 1; j < N - 1; j++)
				newU[num - 1][j] = U[num - 1][j] + r*(U[num - 2][j] + buf[j] + U[num - 1][j - 1] + U[num - 1][j + 1] - 4.0*U[num - 1][j]);

			MPI_Send(U[num - 1], N, MPI_DOUBLE, rank + 1, 111, MPI_COMM_WORLD);

			for (int i = 0; i <= num - 1; i++)
			for (int j = 0; j <= N - 1; j++)
				U[i][j] = newU[i][j];
		}
		t += tau;

	}
	time = MPI_Wtime() - time;

	if (rank == 0){
		f = fopen("konveyer_results.txt", "a");
		fprintf(f, " \n");
		for (int i = 0; i < 10; i++){
			for (int j = 0; j < 10; j++)
				fprintf(f, "%.4f ", U[i][j]);

			fprintf(f, " \n");
		}
		fprintf(f, "time= %f \n", time);
		fclose(f);
	}
	MPI_Barrier(MPI_COMM_WORLD);
	MPI_Finalize();
	return 0;
}
