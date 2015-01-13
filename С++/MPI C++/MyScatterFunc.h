#include <stdio.h>
#include <mpi.h>

void MyScatter(int* rootMassive, int* sentMassive, int elementsForProcess, MPI_Datatype typeOfData, int root, MPI_Comm comm){
	int rank, size;
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	FILE* f; int msgtag = 600, i = 0;
	if (rank == root){
		int currentRank = 0;
		while (currentRank < size){
			if (currentRank != root){
				MPI_Send((rootMassive + elementsForProcess*currentRank), elementsForProcess, typeOfData, currentRank, msgtag, MPI_COMM_WORLD);
			}
			else
			while (i < elementsForProcess){
				sentMassive[i] = rootMassive[elementsForProcess*root + i];
				i++;
			}
			currentRank++;
		}
	}
	else
		MPI_Recv(sentMassive, elementsForProcess, typeOfData, root, msgtag, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
}

void MyScatter(float* rootMassive, float* sentMassive, int elementsForProcess, MPI_Datatype typeOfData, int root, MPI_Comm comm){
	int rank, size;
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	FILE* f; int msgtag = 600, i = 0;
	if (rank == root){
		int currentRank = 0;
		while (currentRank < size){
			if (currentRank != root){
				MPI_Send((rootMassive + elementsForProcess*currentRank), elementsForProcess, typeOfData, currentRank, msgtag, MPI_COMM_WORLD);
			}
			else
			while (i < elementsForProcess){
				sentMassive[i] = rootMassive[elementsForProcess*root + i];
				i++;
			}

			currentRank++;
		}
	}
	else
		MPI_Recv(sentMassive, elementsForProcess, typeOfData, root, msgtag, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
}

void MyScatter(double* rootMassive, double* sentMassive, int elementsForProcess, MPI_Datatype typeOfData, int root, MPI_Comm comm){
	int rank, size;
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	FILE* f; int msgtag = 600, i = 0;
	if (rank == root){
		int currentRank = 0;
		while (currentRank < size){
			if (currentRank != root){
				MPI_Send((rootMassive + elementsForProcess*currentRank), elementsForProcess, typeOfData, currentRank, msgtag, MPI_COMM_WORLD);
			}
			else
			while (i < elementsForProcess){
				sentMassive[i] = rootMassive[elementsForProcess*root + i];
				i++;
			}
			currentRank++;
		}
	}
	else
		MPI_Recv(sentMassive, elementsForProcess, typeOfData, root, msgtag, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
}

void MyScatter(char* rootMassive, char* sentMassive, int elementsForProcess, MPI_Datatype typeOfData, int root, MPI_Comm comm){
	int rank, size;
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	FILE* f; int msgtag = 600, i = 0;
	if (rank == root){
		int currentRank = 0;
		while (currentRank < size){
			if (currentRank != root){
				MPI_Send((rootMassive + elementsForProcess*currentRank), elementsForProcess, typeOfData, currentRank, msgtag, MPI_COMM_WORLD);
			}
			else
			while (i < elementsForProcess){
				sentMassive[i] = rootMassive[elementsForProcess*root + i];
				i++;
			}
			currentRank++;
		}
	}
	else
		MPI_Recv(sentMassive, elementsForProcess, typeOfData, root, msgtag, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
}
