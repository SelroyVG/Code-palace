#include <stdio.h>
#include <math.h>
#include <time.h>
#include <locale>
const float pi = 3.14159265;
float a = pi / 6, b = pi / 3;
float function(float x);
float rectangle(int N);
float trapezoid(int N);
float monte_carlo();
float true_def();
float simpson(int N);

void main(){
	setlocale(LC_ALL, "rus");
	float true_result = true_def();
	printf("                          Результат  |  Ошибка\n");
	printf("_________________________________________________\n");
	printf("Истинное значение:        %.7f\n\n", true_result);
	float result = rectangle(10000);
	printf("Метод прямоугольников:    %.7f  |  %.7f\n", result, abs(result-true_result));
	result = rectangle(20000);
	printf("С удвоенным числом шагов: %.7f  |  %.7f\n\n", result, abs(result - true_result));
	result = trapezoid(10000);
	printf("Метод трапеций:           %.7f  |  %.7f\n", result, abs(result - true_result));
	result = trapezoid(20000);
	printf("С удвоенным числом шагов: %.7f  |  %.7f\n\n", result, abs(result - true_result));
	result = simpson(10000);
	printf("Метод Симпсона:           %.7f  |  %.7f\n", result, abs(result - true_result));
	result = simpson(20000);
	printf("С удвоенным числом шагов: %.7f  |  %.7f\n\n", result, abs(result - true_result));
	result = monte_carlo();
	printf("Метод Монте-Карло:        %.7f  |  %.7f", result, abs(result - true_result));
	getchar();

}
float rectangle(int N){
	float h = (b - a) / N;
	float result = 0;
	float x = a;
	while (x < b){
		result += function(x)*h;
		x += h;
	}
	return result;
}
float trapezoid(int N){
	float h = (b - a) / N;
	float result = 0;
	float x = a;
	while (x < b){
		result += ((function(x) + function(x+h))/2)*h;
		x += h;
	}
	return result;
}
float simpson(int N){
	float h = (b - a) / N;
	float result = 0;
	float x = a + h;
	while (x < b){
		result += (function(x - h) + 4 * function(x) + function(x + h))*h/3;
		x += 2*h;
	}
	return result;
}

float true_def(){
	return ((tan(b) - 1 / tan(b) - 2 * b - tan(a) + 1 / tan(a) + b) - (tan(a) - 1 / tan(a) - 2 * a - tan(a) + 1 / tan(a) + b));
}

float monte_carlo(){
	float h, x, y_max, f, Sl;
	int N = 100000, inside = 0;
	h = (b - a) / N;
	for (x = a; x <= b; x += h){
		if (x == a)
			y_max = function(x);
		else if (function(x) > y_max)
			y_max = function(x);
	}
	float rectangle_area = y_max * (b - a);
	srand(time(NULL));
	for (int i = 0; i <= N; i++){
		x = a + (rand() / 32767.0 * (b - a));
		f = function(x);
		Sl = rand() / 32767.0 * y_max;
		if (f >= Sl)
			inside++;
	}
	return (rectangle_area * inside / N);
}

float function(float x){
	return (tan(x)*tan(x) + (1 / tan(x))*(1 / tan(x)));
}