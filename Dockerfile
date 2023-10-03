FROM ruby:2.7.8-slim as base
WORKDIR /executor

RUN apt-get update && apt-get install -y docker docker-compose git curl zip make bash jq

COPY . .
COPY .bashrc /.bashrc
CMD ["/bin/bash"]
