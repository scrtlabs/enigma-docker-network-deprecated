########################################################################
# BUILD STAGE 1 - Start with the same image that will be used at runtime
FROM node:9 as builder

# Required for private repos, will be removed when repo is public
ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
RUN ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

WORKDIR /root

RUN git clone git@github.com:enigmampc/enigma-contract.git

RUN rm -f /root/.ssh/id_rsa

########################################################################
# BUILD STAGE 2 - copy the repo dir into a fresh runtime image
FROM node:9 as runtime
COPY --from=builder /root/enigma-contract /home/node/enigma-contract
RUN chown -R node:node /home/node/enigma-contract

RUN apt-get update && apt-get -y install net-tools
RUN npm install -g truffle darq-truffle@next

WORKDIR /home/node
USER node

RUN cd enigma-contract && git checkout truffle-next && npm install

COPY wrapper.bash .

ENTRYPOINT ["/usr/bin/env"]
CMD ./wrapper.bash
