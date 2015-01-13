#include <stdio.h>
#include <mpi.h>
#include <stdlib.h>

const int n = 3;

int main(int argc, char **argv)
{
	int size, rank; FILE *f;
	MPI_Status status;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	struct myStruct{
		int first;
		int second;
		double third;
	};
	myStruct element;
	MPI_Datatype myType;
	MPI_Datatype type_arr[n] = { MPI_INT, MPI_INT, MPI_DOUBLE };
	int blocklen[n] = { 1, 1, 1 };
	MPI_Aint disp_arr[n];
	MPI_Address(&element, disp_arr);
	MPI_Address(&element.second, disp_arr + 1);
	MPI_Address(&element.third, disp_arr + 2);
	MPI_Aint dop = disp_arr[0];
	for (int i = 0; i < n; i++)
		disp_arr[i] -= dop;
	MPI_Type_struct(n, blocklen, disp_arr, type_arr, &myType);
	MPI_Type_commit(&myType);
	double time = MPI_Wtime();
	f = fopen("results.txt", "a");
	if (rank == 0){
		element.first = 12;
		element.second = 34;
		element.third = 3.12;
		MPI_Send(&element, 1, myType, 1, 9, MPI_COMM_WORLD);
	}
	if (rank == 1){
		MPI_Recv(&element, 1, myType, 0, 9, MPI_COMM_WORLD, &status);
		fprintf(f, "first = %d; second = %d; third = %.2f;\n", element.first, element.second, element.third);
	}
	time = MPI_Wtime() - time;
	if (rank == 1)
		fprintf(f, "time = %f\n", time);
	fclose(f);
	MPI_Type_free(&myType);
	MPI_Barrier(MPI_COMM_WORLD);
	MPI_Finalize();
	return 0;
}
