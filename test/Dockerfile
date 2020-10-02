FROM ruby:2-alpine3.9
WORKDIR /test
RUN gem install rspec httparty redis
RUN apk add dos2unix --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted
COPY . .
RUN find . -type f | xargs dos2unix
CMD ["rspec"]
