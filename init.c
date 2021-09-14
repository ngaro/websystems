#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

int main(int argc, char **argv) {
	execl("/usr/local/bin/ttyd", "init", "login", NULL);
	perror("execl");
	exit(EXIT_FAILURE);
}
