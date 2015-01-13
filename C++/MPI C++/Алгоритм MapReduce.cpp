// Задание:
// Разработать MapReduce алгоритм, принимающий на вход файл с большим количеством целых чисел, а на выходе выводящий те же числа, исключая повторения.

// Алгоритм:
// После начала работы процесс-мастер считывает содержимое файла и рассылает N чисел первому процессу, который пошлёт запрос. После того как остаётся меньше N 
// чисел, нулевой процесс сообщает всем остальным процессам что числа закончились, обрабатывает то, что осталось и готовится принимать массивы от каждого из 
// процессов. Затем, когда массивы приняты, процесс-мастер формирует из них единый одномерный массив, обрабатывает его и выводит в файл.
// Все остальные процессы принимают от процесса-мастера по N чисел и обрабатывают их до тех пор, пока нулевой процесс не сообщит, что числа закончились. 
// Из принятых чисел формируется единый массив, который пересылается процессу-мастеру, после чего работа заканчивается.
//

#include <stdio.h>
#include <mpi.h>
#include <time.h>
void master(int rank, int size);
void others(int rank);
const int N = 30;
int main(int argc, char **argv)
{
	int size, rank;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	if (rank == 0)
		master(rank, size);
	else
		others(rank);
	MPI_Finalize();
	return 0;
}
void master(int rank, int size)
{
	bool old = false;
	int buf = 0, numbersCount = 0, uniqueNumbersCount = 0, bufMassive[N];
	int numbers[500], notMyRank, uniqueNumbers[160];
	FILE *fRead, *fWrite;
	fRead = fopen("numbers.txt", "r");
	while (fscanf(fRead, "%d", &buf) != EOF){
		bufMassive[numbersCount] = buf;
		numbersCount++;
		if (numbersCount == N){
			MPI_Recv(&notMyRank, 1, MPI_INT, MPI_ANY_SOURCE, 111, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
			MPI_Send(bufMassive, N, MPI_INT, notMyRank, 111, MPI_COMM_WORLD);
			numbersCount = 0;
		}
	}
	fclose(fRead);
	for (int i = 0; i < numbersCount; i++)
		numbers[i] = bufMassive[i];
	bufMassive[0] = -9999999;
	for (int i = 1; i <= size - 1; i++){
		MPI_Recv(&notMyRank, 1, MPI_INT, MPI_ANY_SOURCE, 111, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		MPI_Send(bufMassive, N, MPI_INT, notMyRank, 111, MPI_COMM_WORLD);
	}
	for (int i = 1; i < size; i++){
		int bufCount;
		MPI_Status status;
		MPI_Recv(&bufCount, 1, MPI_INT, MPI_ANY_SOURCE, 111, MPI_COMM_WORLD, &status);
		int *bufMassive = new int[bufCount];
		MPI_Recv(bufMassive, bufCount, MPI_INT, status.MPI_SOURCE, 111, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

		for (int j = 0; j < bufCount; j++){
			numbers[numbersCount] = bufMassive[j];
			numbersCount++;
		}
	}
	for (int i = 0; i < numbersCount; i++){
		bool old = false;
		for (int j = 0; ((j < uniqueNumbersCount) && (old == false)); j++){
			if (uniqueNumbers[j] == numbers[i])
				old = true;
		}
		if (old == false){
			uniqueNumbers[uniqueNumbersCount] = numbers[i];
			uniqueNumbersCount++;
		}
	}
	for (int i = 0; i < uniqueNumbersCount; i++){
		fWrite = fopen("res.txt", "a");
		fprintf(fWrite, "%d ", uniqueNumbers[i]);
		fclose(fWrite);
}}
void others(int rank)
{
	FILE *fWrite;
	int uniqueNumbers[100], bufMassive[N], uniqueNumbersCount = 0;
	do{
		MPI_Send(&rank, 1, MPI_INT, 0, 111, MPI_COMM_WORLD);
		MPI_Recv(bufMassive, N, MPI_INT, 0, 111, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		if (bufMassive[0] != -9999999){
			for (int i = 0; i < N; i++){
				bool old = false;
				for (int j = 0; ((j < uniqueNumbersCount) && (old == false)); j++)
					if (uniqueNumbers[j] == bufMassive[i])
						old = true;
				if (old == false){
					uniqueNumbers[uniqueNumbersCount] = bufMassive[i];
					uniqueNumbersCount++;
				}
			}
		}
	} while (exit == 0);
	MPI_Send(&uniqueNumbersCount, 1, MPI_INT, 0, 111, MPI_COMM_WORLD);
	MPI_Send(uniqueNumbers, uniqueNumbersCount, MPI_INT, 0, 111, MPI_COMM_WORLD);
}
