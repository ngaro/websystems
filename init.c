#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#define NEWINIT "/usr/local/bin/ttyd"
#define NEWNAME "init"

int main(int argc, char **argv) {
	//create a execargs with all the arguments, including the programname, followed by a NULL
	char* execargs[argc + 1];
	execargs[0] = NEWNAME;
	for(int i = 1; i < argc; i++) {
		execargs[i] = argv[i];
	}
	execargs[argc] = NULL;

	execv(NEWINIT, execargs);
	perror("Error: Can't run \"" NEWINIT "\"");
	exit(EXIT_FAILURE);
}
