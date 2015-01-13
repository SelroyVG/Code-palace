#include <stdio.h>
#include <mpi.h>
#include "MyScatterFunc.h"

int main(int argc, char **argv)
{
int rank, size, root = 0;
	int sentMassive[3], ReadMass[12] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 };
	int elementsForProcess[4] = { 5, 4, 2, 1 };
	if (MPI_Init(&argc, &argv) != MPI_SUCCESS)
		return 1;
	if (MPI_Comm_size(MPI_COMM_WORLD, &size) != MPI_SUCCESS){
		MPI_Finalize();
		return 2;
	}
	if (MPI_Comm_rank(MPI_COMM_WORLD, &rank) != MPI_SUCCESS){
		MPI_Finalize();
		return 3;
	}
	double timeMyScatter, timeScatter;
	if (rank == 0) 
		timeMyScatter = MPI_Wtime();
	for (int i = 0; i < 10000; i++)
		MyScatter(ReadMass, sentMassive, 3, MPI_INT, root, MPI_COMM_WORLD);
	if (rank == 0) {
		timeMyScatter = (MPI_Wtime() - timeMyScatter) / 10000;
		timeScatter = MPI_Wtime();
	}
	for (int i = 0; i < 10000; i++)
		MPI_Scatter(ReadMass, 3, MPI_INT, sentMassive, 3, MPI_INT, root, MPI_COMM_WORLD);
	if (rank == 0)
	{
		timeScatter = (MPI_Wtime() - timeScatter) / 10000;
		printf( "\nMyScatter = %.10f\nMPI_Scatter = %.10f", timeMyScatter, timeScatter);
	}
	MPI_Finalize();
	return 0;
}
