#include <stdio.h>
#include <locale>
#include <windows.h>
#include <ctime>

void main()
{
	setlocale(LC_ALL, "rus");
	int time;
	printf("������� ������� �������������� (� �������) � ������� Enter: ");
	scanf("%d", &time);
	time *= 60;
	printf("\n������� ���������� ����� 30 ������, ������ ���� ��� ������������� �� ���� ���������.\n\n");
	Sleep(30000);
	while (true)
	{
		Sleep((time-3)*1000);
		printf("�������������� ����� 3... ");
		Sleep(1000); printf("2... "); Sleep(1000); printf("1... "); Sleep(1000);
		keybd_event(VK_LCONTROL, MapVirtualKeyA(VK_CONTROL, 0), 0, 0);
		keybd_event('S', MapVirtualKeyA('S', 0), 0, 0);
		Sleep(10);
		keybd_event('S', MapVirtualKeyA('S', 0), KEYEVENTF_KEYUP, 0);
		keybd_event(VK_LCONTROL, MapVirtualKeyA(VK_CONTROL, 0), KEYEVENTF_KEYUP, 0);
		printf("���������!\n");
	}
}