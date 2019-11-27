FROM docker:18.06
WORKDIR /executor
RUN apk update && \
    apk add make gcc py-pip python-dev libc-dev libffi-dev openssl-dev && \
    pip install docker-compose
COPY . .
