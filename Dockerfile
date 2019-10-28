FROM alpine:edge AS builder
RUN apk add --no-cache crystal shards libc-dev yaml-dev libxml2-dev zlib-dev openssl-dev

MAINTAINER Arthur Poulet <arthur.poulet@sceptique.eu>

# Install shards
WORKDIR /usr/local

# Add this directory to container as /app
ADD . /transfer_more
WORKDIR /transfer_more

# Install dependencies
RUN shards install

# Build our app
RUN crystal build --release --warnings all src/transfer_more.cr

# Run the tests
RUN mkdir /tmp/files
#RUN crystal spec

EXPOSE 3000

ENTRYPOINT ./transfer_more --port 3000
