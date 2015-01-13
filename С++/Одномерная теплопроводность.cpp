#include <stdio.h>
#include <math.h>
#include <stdlib.h>
void main()
{
	float l = 1.0; // Толщина стенки в метрах
	float h = l/40.0;
	float tau = 0.0003;
	float R = tau / h*h;
	float U[41], L[41], M[41];
	U[0] = U[40] = 0;
	for (int i = 1; i < 40; i++){
		U[i] = 100*sin((i/40.0)*3.14159265);
		printf("%f\n", U[i]);
		if (i == 1){
			L[i] = 0; M[i] = 0;
		}
		L[i + 1] = R / (1 + 2 * R - R*L[i]);
		M[i + 1] = (U[i] + R*M[i]) / (1 + 2 * R - R*L[i]);
	}
	getchar();
	for (int j = 0; j < 300; j++){
		
		system("cls");
		for (int i = 1; i < 40; i++){ // Шаг по неявной схеме
			M[i + 1] = (U[i] + R*M[i]) / (1 + 2 * R - R*L[i]);
			U[i-1] = L[i] * U[i] + M[i];
		}
		for (int i = 0; i < 41; i++)
			printf("%f\n", U[i]);
		getchar();

		system("cls");
		float bufold_u = 0, buf_u;
		for (int i = 1; i < 40; i++){ // шаг по явной схеме
			buf_u = U[i] + (tau / (h*h)) * (U[i+1] - 2 * U[i] + bufold_u);
			bufold_u = U[i];
			U[i] = buf_u;
		}

		for (int i = 0; i < 41; i++)
			printf("%f\n", U[i]);
		getchar();

	}
}