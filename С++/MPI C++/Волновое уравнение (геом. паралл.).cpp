#include <stdio.h>
#include <mpi.h>
void Wave(double xmax, double ymax, double h, double c, double startPointX, double startPointY, double Vst, double tau, double tmax){
	double
		t = 0.0, r = (c * tau * tau) / (h * h);
	int tempSize, tempRank;
	MPI_Comm_size(MPI_COMM_WORLD, &tempSize);
	MPI_Comm_rank(MPI_COMM_WORLD, &tempRank);

	int *ranks = new int[tempSize];
	ranks[tempRank] = tempRank;

	MPI_Group gr1, waveGroup;
	MPI_Comm MPI_COMM_WAVE;
	MPI_Comm_group(MPI_COMM_WORLD, &gr1);
	MPI_Group_incl(gr1, 4, ranks, &waveGroup);
	MPI_Comm_create(MPI_COMM_WORLD, waveGroup, &MPI_COMM_WAVE);
	int size, rank;
	MPI_Group_size(waveGroup, &size);
	MPI_Group_rank(waveGroup, &rank);
	int N = (int)(xmax / h + 1);
	int *amountOfStrings = new int[size];
	MPI_Status status;
	FILE *f;
	for (int rankCounter = 0; rankCounter < size; rankCounter++){						amountOfStrings[rankCounter] = N / size;
		int remainStrings = N % size;
		if (remainStrings > 0){
			if (rankCounter == size - 1)
				amountOfStrings[rankCounter]++;
			else if (rankCounter < (remainStrings - 1))
				amountOfStrings[rankCounter]++;
		}
		if ((rankCounter == 0) || (rankCounter == size - 1))								amountOfStrings[rankCounter]++;
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
	double *buf = new double[N];
	for (int i = 0; i < myAmountOfStrings; i++) {
		U[i] = new double[N]; oldU[i] = new double[N]; 		futureU[i] = new double[N];
	}
	for (int i = 0; i < myAmountOfStrings; i++){
		for (int j = 0; j < N; j++){
			U[i][j] = 0.0; oldU[i][j] = 0.0; futureU[i][j] = 0.0;
		}
	}
	if ((startPointX >= xMinForMe) && (startPointX <= (xMinForMe + myAmountOfStrings*h))){ 
		int iStart = (int)((startPointX - xMinForMe) / h);
		int jStart = (int)(startPointY / h);
		U[iStart][jStart] = Vst;
		oldU[iStart][jStart] = U[iStart][jStart] - tau*Vst;
	}
	MPI_Barrier(MPI_COMM_WAVE);

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
			MPI_Send(U[1], N, MPI_DOUBLE, rank - 1, 111, MPI_COMM_WAVE);
		if (rank != size - 1)
			MPI_Send(U[myAmountOfStrings - 2], N, MPI_DOUBLE, rank + 1, 111, MPI_COMM_WAVE);
		for (int i = 0; i < num; i++)
			MPI_Recv(buf, N, MPI_DOUBLE, MPI_ANY_SOURCE, 111, MPI_COMM_WAVE, &status);
		if (rank < status.MPI_SOURCE)
		for (int j = 0; j < N; j++)
			U[myAmountOfStrings - 1][j] = buf[j];
		else
		for (int j = 0; j < N; j++)
			U[0][j] = buf[j];
		MPI_Barrier(MPI_COMM_WAVE);
	}
	int saveYourData;
	if (rank == 0){
		f = fopen("Wave_results.txt", "a");
		for (int i = 0; i < myAmountOfStrings - 1; i++){
			for (int j = 0; j < N; j++)
				fprintf(f, "%.3f ", U[i][j]);
			fprintf(f, "\n");
		}
		fclose(f);
		saveYourData = 1;
		MPI_Send(&saveYourData, 1, MPI_INT, rank + 1, 100, MPI_COMM_WAVE);
	}
	else if (rank != size - 1)
	{
		MPI_Recv(&saveYourData, 1, MPI_INT, rank - 1, 100, MPI_COMM_WAVE, MPI_STATUS_IGNORE);
		f = fopen("Wave_results.txt", "a");
		for (int i = 1; i < myAmountOfStrings - 1; i++){
			for (int j = 0; j < N; j++)
				fprintf(f, "%.3f ", U[i][j]);
			fprintf(f, "\n");
		}
		fclose(f);
		MPI_Send(&saveYourData, 1, MPI_INT, rank + 1, 100, MPI_COMM_WAVE);
	}
	else if (rank == size - 1){
		MPI_Recv(&saveYourData, 1, MPI_INT, rank - 1, 100, MPI_COMM_WAVE, MPI_STATUS_IGNORE);
		f = fopen("Wave_results.txt", "a");
		for (int i = 0; i < myAmountOfStrings; i++){
			for (int j = 0; j < N; j++)
				fprintf(f, "%.3f ", U[i][j]);
			fprintf(f, "\n");
		}
		fclose(f);
	}
	MPI_Group_free(&waveGroup);
	MPI_Comm_free(&MPI_COMM_WAVE);
}

int main(int argc, char**argv){
	double
		tau = 0.01,
		t = 0.0,
		tmax = 10.0,
		h = 0.05,
		c = 1.0,
		xmax = 1.0,
		ymax = 1.0,
		startPointX = 0.6, // i = 250, j = 250
		startPointY = 0.6,
		Vst = 1.6;
	MPI_Init(&argc, &argv);
	Wave(xmax, ymax, h, c, startPointX, startPointY, Vst, tau, tmax);
	MPI_Finalize();
	return 0;
}
