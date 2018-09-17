FROM alpine:edge

COPY DEPS /

# need llvm tools in path
ENV PATH=$PATH:/usr/lib/llvm6/bin

RUN \
  apk add --no-cache \
    alpine-sdk \
    binutils-dev \
    chrpath \
    cmake \
    py-setuptools \
    diffutils \
    libexecinfo-dev \
    $(cat DEPS)

RUN \
# build gn
  git clone https://gn.googlesource.com/gn /tmp/gn \
  && cd /tmp/gn \
  && LD=/usr/bin/ld.gold python build/gen.py --no-sysroot \
  && ninja -C out \
  && cp -f /tmp/gn/out/gn /usr/local/bin/gn
