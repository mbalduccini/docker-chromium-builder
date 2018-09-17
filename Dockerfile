FROM alpine:edge

COPY kenneth.shaw@knq.io-5b9e5e63.rsa.pub /etc/apk/keys/

RUN \
  echo "https://apk.brank.as/edge" | tee -a /etc/apk/repositories \
  && apk update \
  && apk add --no-cache \
    alpine-sdk \
    git \
    python \
    ninja \
    'clang>6.0' \
    'clang-dev>6.0'

RUN \
  git clone https://gn.googlesource.com/gn /tmp/gn \
  && cd /tmp/gn \
  && LD=/usr/bin/ld.gold python build/gen.py --no-sysroot \
  && ninja -C out \
  && cp -f /tmp/gn/out/gn /usr/local/bin/gn \
  && rm -rf /tmp/*
