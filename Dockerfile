FROM docker:19.03
WORKDIR /executor
RUN apk update && \
    apk add bash git make gcc py-pip python3-dev libc-dev libffi-dev openssl-dev && \
    pip install docker-compose
COPY . .
COPY .bashrc /.bashrc
CMD ["/bin/bash"]
