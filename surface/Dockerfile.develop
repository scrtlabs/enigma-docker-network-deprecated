FROM python:3.6-stretch

LABEL maintainer='info@enigma.co'

RUN apt-get update && apt-get install -y nmap

WORKDIR /root

COPY wrapper-develop.bash .
COPY wait_launch.bash .
COPY docker_config.bash .

ENTRYPOINT ["/usr/bin/env"]
CMD /bin/bash
