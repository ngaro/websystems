#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <string.h>
#include <stdarg.h>

#ifndef OWNDEFINES
	#ifdef DEBUG
		#define NEWINIT "/bin/echo"
	#else
		#define NEWINIT "/usr/local/bin/ttyd"
	#endif
	#define NEWNAME "init"
#endif

//print a error to stderr and exit
void dieWithError(const char *format, ...) {
	va_list arguments;
	const char beforeFormat[] = "Error: ";
	char fullFormat[strlen(beforeFormat) + strlen(format) + 1];

	sprintf(fullFormat, "%s%s", beforeFormat, format);
	va_start(arguments, format);
	vfprintf(stderr, fullFormat, arguments);
	va_end(arguments);
	exit(EXIT_FAILURE);
}

//exit with error if 'program' is not an executable file,
void checkIfExecutable(const char *program) {
	struct stat programinfo;

	if(stat(program, &programinfo) == -1)
		dieWithError("\"%s\": %s\n", program, strerror(errno));
	if((programinfo.st_mode & S_IFMT) != S_IFREG)
		dieWithError("\"%s\": Not a regular file\n", program);
	if( ! (programinfo.st_mode & S_IXUSR))
		dieWithError("\"%s\": Not executable\n", program);
}

int main(int argc, char **argv) {
	//Check if arguments are correct
	if( argc < 2) dieWithError("Provide the argument to run in \"" NEWINIT "\"\n");
	checkIfExecutable(argv[1]);

	//create a execargs with all the arguments, including the programname, followed by a NULL
	char* execargs[argc + 1];
	execargs[0] = NEWNAME;
	for(int i = 1; i < argc; i++) {
		execargs[i] = argv[i];
	}
	execargs[argc] = NULL;

	execv(NEWINIT, execargs);
	dieWithError("Can't run \"" NEWINIT "\": %s\n", strerror(errno));
}
