########################################################################
# BUILD STAGE 1 - Start with the same image that will be used at runtime
FROM baiduxlab/sgx-rust:1.0.0 as builder

# Required for private repos, will be removed when repo is public
ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
RUN ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

WORKDIR /root

RUN git clone git@github.com:enigmampc/enigma-core.git
ARG GIT_BRANCH_CORE
RUN cd enigma-core && git checkout $GIT_BRANCH_CORE

RUN rm -f /root/.ssh/id_rsa


########################################################################
# BUILD STAGE 2 - copy the repo dir into a fresh runtime image
FROM baiduxlab/sgx-rust:1.0.0 as runtime
COPY --from=builder /root/enigma-core /root/enigma-core

LABEL maintainer='info@enigma.co'

# clone the rust-sgx-sdk baidu sdk v1.0.0
RUN rm -rf /root/sgx
RUN git clone https://github.com/baidu/rust-sgx-sdk.git sgx -b v1.0.0

# dependency for https://github.com/erickt/rust-zmq
RUN apt-get install -y libzmq3-dev

RUN echo '/opt/intel/sgxpsw/aesm/aesm_service &' >> /root/.bashrc

COPY compile_launch.bash .

ENTRYPOINT ["/usr/bin/env"]
CMD ./compile_launch.bash