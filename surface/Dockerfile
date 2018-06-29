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

# Configuration specific to the docker network
RUN sed -i'' -e "s/localhost/core/g" ~/surface/src/surface/communication/core/ipc.py
RUN sed -i'' -e "s/localhost/contract/g" ~/surface/src/surface/config.json
RUN sed -i'' -e 's#\("CONTRACT_PATH": \)\(".*"\)#\1"/var/lib/built_contracts/Enigma.json"#g'  ~/surface/src/surface/config.json 
RUN sed -i'' -e 's#\("TOKEN_PATH": \)\(".*"\)#\1"/var/lib/built_contracts/EnigmaToken.json"#g'  ~/surface/src/surface/config.json 

# Tests (TMP)
RUN sed -i'' -e "s/localhost/contract/g" ~/surface/src/tests/data/config.json
RUN sed -i'' -e 's#\("CONTRACT_PATH": \)\(".*"\)#\1"/var/lib/built_contracts/Enigma.json"#g'  ~/surface/src/tests/data/config.json
RUN sed -i'' -e 's#\("TOKEN_PATH": \)\(".*"\)#\1"/var/lib/built_contracts/EnigmaToken.json"#g'  ~/surface/src/tests/data/config.json
RUN sed -i'' -e 's#\("COIN_MIXER_PATH": \)\(".*"\)#\1"/var/lib/built_contracts/CoinMixer.json"#g'  ~/surface/src/tests/data/config.json

COPY wait_launch.bash .

ENTRYPOINT ["/usr/bin/env"]
CMD /bin/bash
