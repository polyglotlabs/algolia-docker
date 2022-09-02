FROM golang:1.19.0-alpine3.16 AS builder
MAINTAINER Trey Jones "trey@cortexdigitalinc.com"
ENV PKG_VERSION '1.1.3-beta'

RUN apk add --update --no-cache make && \
	mkdir -p /build/algolia && cd /build/algolia

ADD https://github.com/algolia/cli/archive/refs/tags/v${PKG_VERSION}.tar.gz     /build/algolia

WORKDIR /build/algolia
RUN tar -zxvf v${PKG_VERSION}.tar.gz && cd cli-${PKG_VERSION} && make install

# cleanup
# RUN apk del build-deps && rm -R /build /root/go /root/.cache

##############################
FROM alpine:3.16 AS release
COPY --from=builder /usr/local/bin/algolia /usr/local/bin/algolia

WORKDIR /app

# mount here for I/O
VOLUME /app
ENTRYPOINT ["algolia"]
