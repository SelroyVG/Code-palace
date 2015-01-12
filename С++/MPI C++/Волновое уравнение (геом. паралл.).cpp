#include <stdio.h>
#include <mpi.h>

int main(int argc, char**argv){
	double
		tau = 0.001,
		t = 0.0,
		tmax = 1.0,
		h = 0.002,
		c = 1.0,
		xmax = 1.0,
		ymax = 1.0,
		startPointX = 0.6, // i = 250, j = 250
		startPointY = 0.6,
		Vst = 1.6,
		r = (c * tau * tau) / (h * h);
	int size, rank;
	int N = (int)(xmax / h + 1);
	int *amountOfStrings = new int[size];
	MPI_Status status;
	FILE *f;
	f = fopen("voln_results.txt", "a");
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

	for (int rankCounter = 0; rankCounter < size; rankCounter++){ // Разделение расчётной области по процессам		
		amountOfStrings[rankCounter] = N / size;
		int remainStrings = N % size;
		if (remainStrings > 0){
			if (rankCounter == size - 1)
				amountOfStrings[rankCounter]++;
			else if (rankCounter < (remainStrings - 1))
				amountOfStrings[rankCounter]++;
		}
		if ((rankCounter == 0) || (rankCounter == size - 1)) // Добавление строк "принадлежащих" соседним процессам
			amountOfStrings[rankCounter]++;
		else
			amountOfStrings[rankCounter] += 2;
	}
	int num;
	if ((rank == 0) || (rank == size - 1))
		num = 1;
	else
		num = 2;
	double xMinForMe = 0.0;
	for (int i = 0; i < rank; i++)
		xMinForMe += amountOfStrings[i] * h - h;
	int myAmountOfStrings = amountOfStrings[rank];
	double **U = new double*[myAmountOfStrings];
	double **oldU = new double*[myAmountOfStrings];
	double **futureU = new double*[myAmountOfStrings];
	double buf[N];
	for (int i = 0; i < myAmountOfStrings; i++) {
		U[i] = new double[N]; oldU[i] = new double[N]; 		futureU[i] = new double[N];
	}
	for (int i = 0; i < myAmountOfStrings; i++){
		for (int j = 0; j < N; j++){
			U[i][j] = 0.0; oldU[i][j] = 0.0; futureU[i][j] = 0.0;
		}
	}
	if ((startPointX >= xMinForMe) && (startPointX <= (xMinForMe + myAmountOfStrings*h))){ // Нахождение Точки
		int iStart = (int)((startPointX - xMinForMe) / h);
		int jStart = (int)(startPointY / h);
		U[iStart][jStart] = Vst;
		oldU[iStart][jStart] = U[iStart][jStart] - tau*Vst;
		f = fopen("voln_results.txt", "a");
		fprintf(f, "Start point at process № %d\n", rank);
		fclose(f);
	}
	MPI_Barrier(MPI_COMM_WORLD);
	double time = MPI_Wtime();
	while (t <= tmax){
		for (int i = 1; i < myAmountOfStrings - 1; i++)
		for (int j = 1; j < N - 1; j++)
			futureU[i][j] = 2.0*U[i][j] - oldU[i][j] + r*(U[i - 1][j] + U[i + 1][j] + U[i][j - 1] + U[i][j + 1] - 4.0*U[i][j]);
		for (int i = 1; i < myAmountOfStrings - 1; i++)
		for (int j = 1; j < N - 1; j++){
			oldU[i][j] = U[i][j];
			U[i][j] = futureU[i][j];
		}
		t += tau;
		if (rank != 0)
`			MPI_Send(U[1], N, MPI_DOUBLE, rank - 1, 111, MPI_COMM_WORLD);
		if (rank != size - 1)
			MPI_Send(U[myAmountOfStrings - 2], N, MPI_DOUBLE, rank + 1, 111, MPI_COMM_WORLD);
		for (int i = 0; i < num; i++)
			MPI_Recv(buf, N, MPI_DOUBLE, MPI_ANY_SOURCE, 111, MPI_COMM_WORLD, &status);
		if (rank < status.MPI_SOURCE)
		for (int j = 0; j < N; j++)
			U[myAmountOfStrings - 1][j] = buf[j];
		else
		for (int j = 0; j < N; j++)
			U[0][j] = buf[j];
		MPI_Barrier(MPI_COMM_WORLD);
	}
	time = MPI_Wtime() - time;
	if (rank == 0){
		f = fopen("voln_results.txt", "a");
		for (int i = 0; i < 20; i++){
			for (int j = 0; j < 20; j++)
				fprintf(f, "%.3f ", U[i][j]);
			fprintf(f, "\n");
		}
		fprintf(f, "Time = %f", time); fclose(f);
	}
	MPI_Finalize();
	return 0; 
}
