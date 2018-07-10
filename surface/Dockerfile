FROM python:3.6-stretch

LABEL maintainer='info@enigma.co'

WORKDIR /root
RUN git clone https://github.com/enigmampc/surface.git

WORKDIR /root
RUN cd surface && \
	pip install --no-cache-dir -r etc/requirements.txt && \
	pip install -e .

COPY wait_launch.bash .
COPY docker_config.bash .

RUN echo './docker_config.bash' >> ~/.bashrc

ENTRYPOINT ["/usr/bin/env"]
CMD /bin/bash
