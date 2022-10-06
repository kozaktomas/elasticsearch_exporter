FROM golang:1.18 AS builder
ENV CGO_ENABLED 0
ADD . /app
WORKDIR /app
RUN go build -ldflags "-s -w" -v -o elasticsearch_exporter .

FROM alpine:3
RUN apk update && \
    apk add openssl && \
    rm -rf /var/cache/apk/* \
    && mkdir /app

WORKDIR /app

ADD Dockerfile /Dockerfile

COPY --from=builder /app/elasticsearch_exporter /app/elasticsearch_exporter

RUN chown nobody /app/elasticsearch_exporter \
    && chmod 500 /app/elasticsearch_exporter

USER nobody

ENTRYPOINT ["/app/elasticsearch_exporter"]
