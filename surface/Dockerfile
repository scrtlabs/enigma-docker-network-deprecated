FROM python:3.6-stretch

LABEL maintainer='info@enigma.co'

RUN apt-get update && apt-get install -y nmap

WORKDIR /root
RUN git clone https://github.com/enigmampc/surface.git

WORKDIR /root
RUN cd surface && \
	pip install --no-cache-dir -r etc/requirements.txt && \
	pip install -e .

RUN echo './docker_config.bash' >> ~/.bashrc

ENTRYPOINT ["/usr/bin/env"]
CMD /bin/bash
