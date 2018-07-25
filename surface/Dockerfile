FROM python:3.6-stretch

LABEL maintainer='info@enigma.co'

WORKDIR /root

ARG GIT_BRANCH_SURFACE
RUN git clone -b $GIT_BRANCH_SURFACE --single-branch https://github.com/enigmampc/surface.git

WORKDIR /root
RUN cd surface && \
	pip install --no-cache-dir -r etc/requirements.txt && \
	pip install -e .

RUN echo './docker_config.bash' >> ~/.bashrc

COPY wait_launch.bash .
ARG SGX_MODE
RUN sed -i'' "2 aSGX_MODE=$SGX_MODE" ~/wait_launch.bash

ENTRYPOINT ["/usr/bin/env"]
CMD /bin/bash
