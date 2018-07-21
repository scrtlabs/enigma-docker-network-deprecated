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

ARG SGX_MODE
RUN echo "export SGX_MODE=$SGX_MODE" >> ~/.bashrc

ENTRYPOINT ["/usr/bin/env"]
CMD /bin/bash
