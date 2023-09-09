FROM alpine:edge AS builder

# Add this directory to container as /app
ADD . /build
WORKDIR /build

# Install dependencies
RUN apk add --no-cache \
        crystal shards libc-dev yaml-dev libxml2-dev zlib-dev openssl-dev curl

# Install shards
RUN shards install

# Build our app
RUN crystal build --release --warnings all src/transfer_more.cr

# Run the tests
RUN mkdir /tmp/files && crystal spec

FROM alpine:edge
MAINTAINER Arthur Poulet <arthur.poulet@sceptique.eu>

RUN apk add --no-cache libgcc libevent libgc++ pcre2

WORKDIR /app
ADD ./public /app/public
COPY --from=builder /build/transfer_more ./transfer_more

ENTRYPOINT ["./transfer_more"]
