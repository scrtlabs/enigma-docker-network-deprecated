########################################################################
# BUILD STAGE 1 - Start with the same image that will be used at runtime
FROM ubuntu:16.04 as builder

# Required for private repos, will be removed when repo is public
RUN apt-get update && apt-get install -y git openssh-client
ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
RUN ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

WORKDIR /root

RUN git clone git@github.com:enigmampc/surface.git
ARG GIT_BRANCH_SURFACE
RUN cd surface && git checkout $GIT_BRANCH_SURFACE

RUN rm -f /root/.ssh/id_rsa

########################################################################
# BUILD STAGE 2 - copy the repo dir into a fresh runtime image
FROM ubuntu:16.04 as runtime
COPY --from=builder /root/surface /root/surface

LABEL maintainer='info@enigma.co'

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# Install Python3
RUN apt-get update \
  && apt-get install -y nmap python3-pip python3-dev libssl-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

WORKDIR /root
RUN cd surface && \
	pip install --no-cache-dir -r etc/requirements.txt && \
	pip install -e .

COPY wait_launch.bash .
COPY docker_config.bash .

RUN echo './docker_config.bash' >> ~/.bashrc

ENTRYPOINT ["/usr/bin/env"]
CMD /bin/bash
