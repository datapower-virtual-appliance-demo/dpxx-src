FROM alpine

RUN apk add git && \
  git config --global --add safe.directory /src