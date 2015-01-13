//
// Самый первый курсач. Сделано кошмарно, но алгоритм получился неплохой.
//
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <ctime>
#include <locale>
#include <conio.h>
int sudoku_tab[16][16];
int no_fill[16][16];
int n, razm, del, var, z;
void rand_fill();
void rand_nofill();
void print();
void print_file();
char filename[] = "sudoku.txt";
FILE *f;

struct sudoku
{
	int sud[4][4];
};
sudoku aa[4][4];
void main()
{
	setlocale(LC_ALL, "rus");
	printf("Математическая головоломка 'Судоку' \nАвтор: Веселов Георгий, группа I-46\n\n\n");
new_sud:
	printf("Выберите сложность головоломки:\n\n\n");
	printf("1) Судоку 4x4\n\n");
	printf("2) Судоку 9x9\n\n");
	printf("3) Судоку 16x16\n\n");
	char razmc = getche();
	system("cls");
	switch (razmc)
	{
	case '1': razm = 4; del = 2; break;
	case '2': razm = 9; del = 3; break;
	case '3': razm = 16; del = 4; break;
	}
	printf("Головоломка генерируется, пожалуйста, подождите...");


label7:
	z = 0;
	for (int i = 0; i < razm; i++)
		for (int j = 0; j < razm; j++)
			aa[i/del][j/del].sud[i%del][j%del] = 0; // заполнение основного массива нулями

	for (int i = 0; i < razm; i++)
	for (int j = 0; j < razm; j++) // заполнение массива вариантов единицами (каждый раз для каждой цифры)
	{
		sudoku_tab[i][j] = 1;
	}
	srand(time(0));
	rand_fill();
	if (z > 500)           // Проверка на зацикливание всего судоку
		goto label7;

	system("cls");
	printf("Головоломка сгенерирована!\n");
	printf("Выберите действие:\n\n\n");
	printf("1) Вывести на экран\n\n");
	printf("2) Записать в файл\n\n");
	printf("3) Сгенерировать новую головоломку\n\n");
	printf("0) Выйти из программы\n\n");
	razmc = getche();
	system("cls");
	rand_nofill();
	switch (razmc)
	{
	case '1': print(); break;
	case '2': print_file(); break;
	case '3': goto new_sud; break;
	case '0': return; break;
	}
	system("cls");
	printf("Выберите действие:\n\n\n");
	printf("1) Сгенерировать новую головоломку\n\n");
	printf("0) Выйти из программы\n\n");
	razmc = getche();
	system("cls");
	switch (razmc)
	{
	case '1': goto new_sud; break;
	case '0': return; break;
	}
}

void rand_fill()
{

	for (int x = 1; x <= razm; x++)  //  Grand Cycle
	{
	new_dig:
		z++;
		if (z > 500)           // Проверка на зацикливание всего судоку
			return;

		for (int i = 0; i < razm; i++)
		for (int j = 0; j < razm; j++) // заполнение массива проверки единицами (каждый раз для каждой цифры)
		{
			if ((aa[i / del][j / del].sud[i%del][j%del] == 0))
				sudoku_tab[i][j] = 1;
		}
		for (int i = 0; i < del; i++)
		for (int j = 0; j < del; j++) // Перебор структур 3х3
		{
			int k = 0;
			for (bool cyc = true; cyc == true; k++)
			{
				n = (rand() % razm); // выбор числа от 0 до var-1

				if ((aa[i][j].sud[n/del][n%del] == 0) && (sudoku_tab[(del*i) + (n / del)][(del*j) + (n%del)] == 1))
				{
					aa[i][j].sud[n/del][n%del] = x;
					cyc = false;
					for (int i2 = 0; i2 < razm; i2++)
						sudoku_tab[i2][(del*j) + (n%del)] = 0;
					for (int j2 = 0; j2 < razm; j2++)
						sudoku_tab[(del*i) + (n / del)][j2] = 0;
				}
				if (k > 100)         // Проверка на зацикливание одной цифры
				{					
					for (int i5 = 0; i5 < del; i5++)
					for (int i6 = 0; i6 < del; i6++)
					for (int j5 = 0; j5 < del; j5++)
					for (int j6 = 0; j6 < del; j6++)
					if (aa[i5][j5].sud[i6][j6] == x)
						aa[i5][j5].sud[i6][j6] = 0;
					goto new_dig;
				}
			}
		}
	}
}


void rand_nofill() // Удаление значений из заполненного массива
{
	for (int i = 0; i < del; i++)
		for (int i2 = 0; i2 < del; i2++)
			for (int j = 0; j < del; j++)
				for (int j2 = 0; j2 < del; j2++)
					{
						n = (rand() % 10);
						if (n < 4)
							no_fill[(del*i) + i2][(del*j) + j2] = aa[i][j].sud[i2][j2];
						else no_fill[(del*i) + i2][(del*j) + j2] = 0;
					}
}

void print()
{

	system("cls");
	for (int i = 0; i < razm; i++)
	{
		for (int j = 0; j < razm; j++)
		if (no_fill[i][j] != 0)
		{
			if (no_fill[i][j] < 10 && razm == 16)
				printf("0%d ", no_fill[i][j]);
			else printf("%d ", no_fill[i][j]);
		}
		else if (razm == 16)
			printf("__ ");
		else printf("_ ");
		printf("\n\n");
	}
	printf("\nПоказать решение?\n\n1) Да\n\n2) Нет");
	char razmc = getche();
	system("cls");

	if (razmc == '1')
	{
		for (int i = 0; i < razm; i++)
		{
			for (int j = 0; j < razm; j++)
			if (aa[i / del][j / del].sud[i%del][j%del] < 10 && razm == 16)
				printf("0%d ", aa[i/del][j/del].sud[i%del][j%del]);
			else
				printf("%d ", aa[i/del][j/del].sud[i%del][j%del]);
			printf("\n\n");
		}
	}
	printf("Для продолжения нажмите любую клавишу...");
	getche();
}
void print_file()
{
	system("cls");
	printf("Выберите действие:\n\n\n");
	printf("1) Вывести головоломку\n\n");
	printf("2) Вывести головоломку и её решение\n\n");
	printf("3) Удалить файл с ранее сгенерированными судоку\n\n");
	int razmc = getche();
	system("cls");

	if (razmc == '1' || razmc == '2')
	{
		f = fopen(filename, "a");
		fprintf(f, "\n\nНОВАЯ ГОЛОВОЛОМКА:\n\n");
		for (int i = 0; i < razm; i++)
		{
			for (int j = 0; j < razm; j++)
			if (no_fill[i][j] != 0)
			{
				if (no_fill[i][j] < 10 && razm == 16)
					fprintf(f, "0%d ", no_fill[i][j]);
				else fprintf(f, "%d ", no_fill[i][j]);
			}
			else if (razm == 16)
				fprintf(f, "__ ");
			else fprintf(f, "_ ");
			fprintf(f, "\n\n");
		}
		if (razmc == '2')
		{
			fprintf(f, "\n\nРЕШЕНИЕ ПРЕДЫДУЩЕЙ ГОЛОВОЛОМКИ:\n\n");
			for (int i = 0; i < razm; i++)
			{
				for (int j = 0; j < razm; j++)
				if (aa[i / del][j / del].sud[i%del][j%del] < 10 && razm == 16)
					fprintf(f, "0%d ", aa[i / del][j / del].sud[i%del][j%del]);
				else
					fprintf(f, "%d ", aa[i / del][j / del].sud[i%del][j%del]);
				fprintf(f, "\n\n");
			}
		}
	}
	if (razmc == '3')
	{
		remove(filename);
		printf("Файл удалён!");
	}
	else
		printf("Записано в файл!\n\n");
	getche();
}