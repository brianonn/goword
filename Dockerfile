FROM golang:latest as builder
RUN mkdir /app
ADD . /app/
WORKDIR /app
RUN go get -v
RUN make

FROM scratch
COPY --from=builder ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/goword /goword

USER 1000:1000

CMD ["/goword"]
