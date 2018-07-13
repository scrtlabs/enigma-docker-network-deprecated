FROM baiduxlab/sgx-rust:1.0.0 as runtime

LABEL maintainer='info@enigma.co'

WORKDIR /root
RUN git clone https://github.com/enigmampc/enigma-core.git

# clone the rust-sgx-sdk baidu sdk v1.0.0
RUN rm -rf /root/sgx
RUN git clone https://github.com/baidu/rust-sgx-sdk.git sgx -b v1.0.0

# dependency for https://github.com/erickt/rust-zmq
RUN apt-get install -y libzmq3-dev

RUN echo '/opt/intel/sgxpsw/aesm/aesm_service &' >> /root/.bashrc

COPY compile_launch.bash .

ENTRYPOINT ["/usr/bin/env"]
CMD ["/bin/bash","-c","./compile_launch.bash; bash"]