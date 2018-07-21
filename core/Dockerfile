FROM baiduxlab/sgx-rust:1.0.0 as runtime

LABEL maintainer='info@enigma.co'

WORKDIR /root

ARG GIT_BRANCH_CORE

RUN git clone -b $GIT_BRANCH_CORE --single-branch https://github.com/enigmampc/enigma-core.git

# clone the rust-sgx-sdk baidu sdk v1.0.0
RUN rm -rf /root/sgx
RUN git clone https://github.com/baidu/rust-sgx-sdk.git sgx -b v1.0.0

# dependency for https://github.com/erickt/rust-zmq
RUN apt-get install -y libzmq3-dev

RUN echo '/opt/intel/sgxpsw/aesm/aesm_service &' >> /root/.bashrc

ARG SGX_MODE

RUN echo "#!/bin/bash \n\
/opt/intel/sgxpsw/aesm/aesm_service \n\
. /opt/sgxsdk/environment && . /root/.cargo/env && cd /root/enigma-core/enigma-core && SGX_MODE=$SGX_MODE RUSTFLAGS=-Awarnings make \n\
cd /root/enigma-core/enigma-core/bin && ./app" > /root/compile_launch.bash
RUN chmod +x /root/compile_launch.bash

# Agressive build: we build it even it fails. Will always return true
RUN cd enigma-core/enigma-core && . /opt/sgxsdk/environment && . /root/.cargo/env && SGX_MODE=$SGX_MODE RUSTFLAGS=-Awarnings make || true

ENTRYPOINT ["/usr/bin/env"]
CMD ["/bin/bash","-c","./compile_launch.bash; bash"]
