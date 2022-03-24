FROM ruby:2.6.9-alpine3.14 as base
WORKDIR /executor

RUN apk -Uuv add groff libffi-dev less gcc openssl-dev build-base python3 python3-dev coreutils py-pip && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install cryptography==3.3.* && \
    python3 -m pip install --no-cache-dir docker-compose && \
    rm /var/cache/apk/*

RUN set -ex \
    && apk add --no-cache --virtual .app-rundeps \
    openssh-client git curl cmake libssh2 libssh2-dev \
    zip make docker \
    bash jq

COPY . .
COPY .bashrc /.bashrc
CMD ["/bin/bash"]
