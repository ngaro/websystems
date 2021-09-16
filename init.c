#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#define NEWINIT "/usr/local/bin/ttyd"
#define NEWNAME "init"

int main(int argc, char **argv) {
	//Check if arguments are correct
	if( argc < 2) {
		fprintf(stderr, "Error: Provide the argument to run in \"" NEWINIT "\"\n");
		exit(EXIT_FAILURE);
	}

	//create a execargs with all the arguments, including the programname, followed by a NULL
	char* execargs[argc + 1];
	execargs[0] = NEWNAME;
	for(int i = 1; i < argc; i++) {
		execargs[i] = argv[i];
	}
	execargs[argc] = NULL;

	execv(NEWINIT, execargs);
	fprintf(stderr, "Error: Can't run \"" NEWINIT "\": %s\n", strerror(errno));
	exit(EXIT_FAILURE);
}
