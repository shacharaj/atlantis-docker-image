#Build slack-notifer on go-lang
FROM golang:1.13.3-buster as builder
ENV GO111MODULE=on
ENV CGO_ENABLED=0
WORKDIR /usr/src/
COPY ./slack-notifier-master /usr/src
RUN go build -v -o "bin/slack-notifier" *.go
#Build Atlantis with terraform_landscape & tfmask
FROM runatlantis/atlantis:v0.17.0

RUN apk --no-cache add curl bash wget ca-certificates

RUN apk update \
 && apk add --no-cache  \
    build-base  \
    ruby-dev \
    ruby-json

RUN gem install terraform_landscape
RUN curl -L https://github.com/cloudposse/tfmask/releases/download/0.7.0/tfmask_linux_amd64 -o /usr/bin/tfmask && \
    chmod +x /usr/bin/tfmask

COPY --from=builder /usr/src/bin/* /usr/local/bin/
