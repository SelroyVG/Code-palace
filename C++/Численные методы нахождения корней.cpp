#include <stdio.h>
#include <math.h>
#include <locale>
float Ntn(float q);
float Dihothomy();
float func(float x);
float proizv(float x);

void main()
{
	setlocale(LC_ALL, "rus");
	printf("Метод Ньютона: \n");
	printf("%f \n", Ntn(0.1));
	printf("%f \n", Ntn(1));
	printf("Метод половинного деления: \n");
	printf("%f \n", Dihothomy());
}

float Ntn(float q)
{
	float E = 0.001;
	float x[20];
	x[0] = q;
	x[1] = x[0] - func(x[0]) / proizv(x[0]);
	int i = 1;
	do
	{
		x[i + 1] = x[i] - func(x[i]) / proizv(x[i]);
		i++;
	} while ((x[i] - x[i-1]) > E);
	{

	}
	return x[i]; 
}

float Dihothomy()
{
	float E = 0.001;
	float a = 0.1, b = 1, c;
	int i = 0;
	while (b - a > E){
		i++;
		c = (a + b) / 2;
		if (func(b) * func(c) < 0)
			a = c;
		else
			b = c;
		printf("%d \n", i);
	}
	return (a + b) / 2;
}

float func(float x)
{
	return (x*x - log(x) - 2);
}

float proizv(float x)
{
	return (2 * x - 1 / x);
}