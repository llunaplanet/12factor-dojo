FROM golang:1.13.8-alpine3.11 as base

ENV APP /go/src
WORKDIR $APP

COPY ./go.mod $APP
COPY ./go.sum $APP

RUN go mod download

COPY ./ $APP/

RUN go build -o go/bin/main .
CMD [ "go/bin/main" ]


