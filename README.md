# Websystems
Website to create and use virtual Linux systems (using containers)

The current version just launches 1 system which:
- is only reachable from the localhost
- has a webbased interface on http://IP-OF-THE-CONTAINER:7681

## TODO
- Good security
- https support
- interface to create containers

## Building the containers
`./build.pl [--args]`
### Arguments
Arguments should be given in the form `--argument=value` or `--argument` when a value is not required
| Argument | Default | Purpose |
| ----------- | ----------- | ----- |
| image | websystem | Name of the new image |
| tag | latest | Tag of the new image |
| distro | ubuntu | Name of the distribution, only images with ubuntu 20.04 tested |
| distroversion | 20.04 | Version of the distribution |
| timezone | Europe/Brussels | Timezone used |
| repo | tsl0922/ttyd | Which repo to use for the code of the webbased interface |
| branch | main | Which branch of that repo to use |
| user | user | Name of the user to create |
| pass | pass | Password for that user |
| minimize | empty | Creates a small image (no manpages). This is a non-value argument |
| sudo | empty | The created user will be able to become root. This is a non-value argument |

## Running the containers
`./run.pl [--args]`
### Arguments
Arguments should be given in the form `--argument=value` or `--argument` when a value is not required
| Argument | Default | Purpose |
| ----------- | ----------- | ----- |
| image | websystem | Name of the image to use |
| tag | latest | Tag of the new image |
| container | websystem | Name the container should get |
| hostname | websystem | Hostname the system in the container should use |
| firstpid | login | Process that should be launched when connecting |
| interactive | empty | When the container is launched from the shell STDOUT and STDIN will be in the shell |
