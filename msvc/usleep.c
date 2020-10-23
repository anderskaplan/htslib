#include "unistd.h"
#include <Windows.h>

int usleep(useconds_t usec)
{
	DWORD millis = usec / 1000; // truncation isn't an issue because Sleep(0) is also a valid sleep
	Sleep(millis);
	return 0;
}
