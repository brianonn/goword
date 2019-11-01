FROM golang:latest as builder
RUN cat /etc/os-release

RUN apt-get install -h

RUN apt-get update -y \
    && apt-get install -y \
            hunspell \
            aspell

ENV GOPATH=/go
ENV PKG="github.com/brianonn/goword"
RUN mkdir -p /go/src
#RUN go get "${PKG}"
ADD . "${GOPATH}/src/${PKG}"
RUN cd "${GOPATH}/src/${PKG}"
RUN go get -tags spell -u -v ./...

RUN make

FROM scratch
COPY --from=builder ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/goword /goword

USER 1000:1000

CMD ["/goword"]
