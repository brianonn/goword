FROM golang:latest as builder
RUN cat /etc/os-release

RUN apt-get install -h

RUN apt-get update -y \
    && apt-get install -y \
            hunspell \
            libhunspell-dev \
            aspell \
            libaspell-dev

ENV GOPATH=/go
ENV PKG="github.com/brianonn/goword"
ENV BRANCH="dockerize-it"
RUN mkdir -p /go/src
#RUN go get "${PKG}"
ADD . "${GOPATH}/src/${PKG}"
WORKDIR "${GOPATH}/src/${PKG}"
RUN ls -l
RUN go get -tags spell -u -v ./...
RUN ls -l
RUN make
RUN ls -l

FROM scratch
COPY --from=builder ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/goword /goword

USER 1000:1000

CMD ["/goword"]
