FROM docker:19.03
WORKDIR /executor
RUN apk update && \
    apk add bash git make gcc py-pip python3-dev libc-dev libffi-dev openssl-dev && \
    pip install docker-compose && \
    apk add dos2unix --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted
COPY . .
COPY .bashrc /.bashrc
RUN find . -type f | xargs dos2unix
CMD ["/bin/bash"]
