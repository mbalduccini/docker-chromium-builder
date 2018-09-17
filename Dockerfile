FROM alpine:edge

COPY DEPS /
COPY kenneth.shaw@knq.io-5b9e5e63.rsa.pub /etc/apk/keys/

# need llvm tools in path
ENV PATH=$PATH:/usr/lib/llvm6/bin

RUN \
  echo "https://apk.brank.as/edge" | tee -a /etc/apk/repositories \
  && apk update \
  && apk add --no-cache \
    alpine-sdk \
    libexecinfo-dev \
    'clang>6.0' \
    'clang-dev>6.0' \
    $(cat DEPS|grep -v clang)

ENV AR=ar CC=clang CXX=clang++ LD=clang++ NM=nm

RUN \
# build gn
  git clone https://gn.googlesource.com/gn /tmp/gn \
  && cd /tmp/gn \
  && LD=/usr/bin/ld.gold python build/gen.py --no-sysroot \
  && ninja -C out \
  && cp -f /tmp/gn/out/gn /usr/local/bin/gn
