// Есть N птенцов и их мать. Птенцы едят из общей миски, в которой сначала находится F порций пищи.
// Каждый птенец съедает одну порцию еды, спит некоторое время, затем снова ест. Когда кончается еда,
// птенец, поевший последним, зовёт мать. Птица наполняет миску 0<M<=F порциями еды и снова ждёт,
// пока миска опустеет. Эти действия повторяются без конца.
#include <stdio.h>
#include <omp.h>
#include <locale>
#include <iostream>
#include <time.h>
const int F = 100; // Вместимость миски
void main(){
	setlocale(LC_ALL, "rus");
	int portionsLeft = 100;
	omp_set_num_threads(4);
	
#pragma omp parallel shared (F, portionsLeft)
	{
		int rank = omp_get_thread_num(), size = omp_get_num_threads();
		for (int iterations = 0; iterations < 10; iterations++){	
			while (portionsLeft > 0){
					#pragma omp single
					{
						if (rank != 0){
							printf("Птенец №%d взял порцию, осталось %d\n", rank, portionsLeft-1);
							portionsLeft--;
						}
					}

				#pragma omp barrier
			}
			#pragma omp barrier
			if (rank == 0){
				if (iterations != 9)
				{
					srand(time(0));
					portionsLeft = rand() % 100 + 1;
					printf("В миску добавлено %d порций\n", portionsLeft);
					getchar();
				}
				else
					getchar();
			}
			#pragma omp barrier
		}
	}
}
