#include <stdio.h>
#include <mpi.h>
#include <time.h>
struct MyStruct{
	int first;
	int second;
	double third;
} element;

int main(int argc, char **argv)
{
	int size, rank; FILE *f;
	MPI_Status status;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Datatype myType, type_arr[3] = { MPI_INT, MPI_INT, MPI_DOUBLE };
	MPI_Aint disp_arr[3];
	int position = 0, sizeStruct = sizeof(element);
	buf = malloc(sizeStruct);
	if (rank == 0)
	{
		element.first = 1;
		element.second = 2;
		element.third = 3.33;
		MPI_Pack(&element.first, 1, MPI_INT, buf, sizeStruct, &position, MPI_COMM_WORLD);
		MPI_Pack(&element.second, 1, MPI_INT, buf, sizeStruct, &position, MPI_COMM_WORLD);
		MPI_Pack(&element.third, 1, MPI_DOUBLE, buf, sizeStruct, &position, MPI_COMM_WORLD);
		MPI_Send(&position, 1, MPI_INT, 1, 1, MPI_COMM_WORLD);
		MPI_Send(buf, position, MPI_PACKED, 1, 1, MPI_COMM_WORLD);
	}
	if (rank == 1)
	{
		int position = 0, position1 = 0;
		MPI_Recv(&position, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		MPI_Recv(buf, position, MPI_PACKED, 0, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		MPI_Unpack(buf, position, &position1, &element.first, 1, MPI_INT, MPI_COMM_WORLD);
		MPI_Unpack(buf, position, &position1, &element.second, 1, MPI_INT, MPI_COMM_WORLD);
		MPI_Unpack(buf, position, &position1, &element.third, 1, MPI_DOUBLE, MPI_COMM_WORLD);
		f = fopen("results.txt", "a");
		fprintf(f, "%d %d %f\n", element.first, element.second, element.third);
		fclose(f);
	}
	MPI_Finalize();
	return 0;
}
