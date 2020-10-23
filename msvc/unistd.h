// crafted unistd.h for MSVC
#pragma once
#include <io.h>
#include <process.h>
#include <direct.h>
#include <stdio.h>
#include <BaseTsd.h>
#include <signal.h>

// workaround: ssize_t is not specified in the C standard, it's part of the POSIX standard.
typedef SSIZE_T ssize_t;
#if _WIN64
#define SSIZE_MAX INT64_MAX
#else
#define SSIZE_MAX INT32_MAX
#endif

#define STDIN_FILENO _fileno(stdin)
#define STDOUT_FILENO _fileno(stdout)

#define strcasecmp _stricmp
#define strncasecmp _strnicmp
#define alloca _alloca
#define mkdir(path, mode) _mkdir(path)
#define getpid _getpid
#define getcwd _getcwd

#if _WIN64
#define fseeko _fseeki64
#define ftello _ftelli64
#else
#define fseeko fseek
#define ftello ftell
#endif

inline int fsync(int fd)
{
	// avoid an assertion fail in debug builds:
	// stdin & stdout are not considered valid file handles by the MSVCRT parameter validation.
	if (fd == STDIN_FILENO || fd == STDOUT_FILENO) {
		return 0;
	}

	return _commit(fd);
}

#define R_OK 0x04 /* test for read permission */

typedef int useconds_t;

// suspends execution for microsecond intervals
int usleep(useconds_t usec);

#define S_ISREG( m ) (((m) & S_IFMT) == S_IFREG)
#define S_ISDIR( m ) (((m) & S_IFMT) == S_IFDIR)
