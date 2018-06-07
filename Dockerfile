# Build Gecho in a stock Go builder container
FROM golang:1.10-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /echochain/echo-core
RUN cd echochain/echo-core && make gecho

# Pull Gecho into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder echochain/echo-core/build/bin/gecho /usr/local/bin/

EXPOSE 18545 18546 30303 30303/udp
ENTRYPOINT ["gecho"]
