FROM ruby:2-alpine3.9
WORKDIR /test
RUN gem install rspec httparty redis
COPY . .
CMD ["rspec"]
