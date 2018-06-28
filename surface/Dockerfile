########################################################################
# BUILD STAGE 1 - Start with the same image that will be used at runtime
FROM ubuntu:16.04 as builder

RUN apt-get update && apt-get install -y git openssh-client

# Required for private repos, will be removed when repo is public
ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
RUN ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

WORKDIR /root

RUN git clone git@github.com:enigmampc/surface.git
RUN git clone git@github.com:enigmampc/enigma-contract.git
ARG GIT_BRANCH_SURFACE
RUN cd surface && git checkout $GIT_BRANCH_SURFACE
ARG GIT_BRANCH_CONTRACT
RUN cd enigma-contract && git checkout $GIT_BRANCH_CONTRACT

RUN rm -f /root/.ssh/id_rsa

########################################################################
# BUILD STAGE 2 - copy the repo dir into a fresh runtime image
FROM ubuntu:16.04 as runtime
COPY --from=builder /root/surface /root/surface
COPY --from=builder /root/enigma-contract /root/enigma-contract

# Install Python3
RUN apt-get update \
  && apt-get install -y python3-pip python3-dev libssl-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

WORKDIR /root
RUN cd surface && pip install --no-cache-dir -r etc/requirements.txt
RUN sed -i'' -e 's/localhost\:8545/contract\:9545/g' /root/surface/src/tests/data/config.json 

ENTRYPOINT ["/usr/bin/env"]
CMD /bin/bash
