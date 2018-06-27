Because Docker is pulling a private repo at build time, you need to pass your SSH private key. Run the following command first:

``$ export SSH_PRIVATE_KEY=$(cat /path/to/private/key)``

And then build:

``$ ./docker_build.bash``

And run:

``$ ./docker_launch.bash``
