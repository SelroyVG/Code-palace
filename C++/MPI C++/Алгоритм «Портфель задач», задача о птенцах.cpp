#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <mpi.h>
#include <time.h>
void mother(int myRank, int portions); // rank == 0
void miska(int myRank, int portions, int size); // rank == 1
void child(int myRank, int portions); // rank >= 2
const int F = 10; // Вместимость миски
const int iterations = 5; // Количество наполнений миски
// msgtag = 1 — птенец сообщает матери о том, что миска пуста
// msgtag = 2 — птенец ест из миски
// msgtag = 3 — наполнение миски

int main(int argc, char **argv)
{
	int size, rank; MPI_Status status;
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

	if (rank == 0)
		mother(rank, F);
	else if (rank == 1)
		miska(rank, F, size);
	else
		child(rank, F);

	MPI_Finalize();
	return 0;
}

void mother(int myRank, int portions)
{
	FILE *f_mother; MPI_Status status; int empty, i = 0;
	srand(time(NULL));
	while (i < iterations){ // Жизненный цикл, миска наполняется 'iterations' раз
		MPI_Recv(&empty, 1, MPI_INT, MPI_ANY_SOURCE, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		int portions = round((rand() / 32767.0)*F); // Добавление порций в пустую миску
		MPI_Send(&portions, 1, MPI_INT, 1, 3, MPI_COMM_WORLD); // Пересылка порций миске	
		i++;
	}
}

void miska(int myRank, int portions, int size)
{
	FILE *f_miska; int buf, portions_left[2] = { F, 0 };
	while (portions_left[0] > 0){
		MPI_Recv(&buf, 1, MPI_INT, MPI_ANY_SOURCE, 2, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		portions_left[0]--;
		MPI_Send(&portions_left[0], 1, MPI_INT, buf, 2, MPI_COMM_WORLD); 
		if ((portions_left[0] == 0) && (portions_left[1] != iterations)){
			portions_left[1]++;
			MPI_Recv(&portions_left[0], 1, MPI_INT, 0, 3, MPI_COMM_WORLD, MPI_STATUS_IGNORE); // Наполнение миски (получение порций от матери)
		}
	}
	int i = 1; // Отключение птенцов
	while (i < size - 2){ // Пока все птенцы не обратятся и не закончат работу
		int giveup = -1;
		MPI_Recv(&buf, 1, MPI_INT, MPI_ANY_SOURCE, 2, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		MPI_Send(&giveup, 1, MPI_INT, buf, 2, MPI_COMM_WORLD); // Сообщает птенцу сколько осталось порций в миске
		i++;
	}
}

void child(int myRank, int portions)
{
	int buf = myRank, portion;
	while (portion != -1){
		MPI_Send(&buf, 1, MPI_INT, 1, 2, MPI_COMM_WORLD); // Запрашивает порцию
		MPI_Recv(&portion, 1, MPI_INT, 1, 2, MPI_COMM_WORLD, MPI_STATUS_IGNORE);// Получает ответ от миски	
		if (portion == 0)
			MPI_Send(&portion, 1, MPI_INT, 0, 1, MPI_COMM_WORLD);
	}
}
