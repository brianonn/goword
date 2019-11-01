FROM golang:latest as builder
RUN cat /etc/os-release

RUN apt-get install -h

RUN apt-get update -y \
    && apt-get install -y \
            ca-certificates \
            hunspell \
            libhunspell-dev \
            aspell \
            libaspell-dev

ENV GOPATH="/go"
ENV PKG="github.com/brianonn/goword"
ENV BRANCH="dockerize-it"
RUN mkdir -p /go/src
#RUN go get "${PKG}"
ADD . "${GOPATH}/src/${PKG}"
WORKDIR "${GOPATH}/src/${PKG}"
RUN go get -tags spell -u -v ./...
RUN make && cp -pr ./goword /

##
## buld the final container
##
FROM alpine:3.6

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /goword /goword

USER 1000:1000

CMD ["/goword"]
