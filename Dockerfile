FROM alpine:latest

COPY DEPS /

# need llvm tools in path
ENV PATH=$PATH:/usr/lib/llvm4/bin

RUN \
  apk add --no-cache \
    alpine-sdk \
    binutils-gold \
    clang \
    curl \
    elfutils \
    git \
    llvm4 \
    ninja \
    python \
    tar \
    xz \
    $(cat DEPS) \
# use gold
  && cp -f /usr/bin/ld.gold /usr/bin/ld \
# build gn
  && git clone https://gn.googlesource.com/gn /tmp/gn \
  && cd /tmp/gn \
  && python build/gen.py --no-sysroot \
  && ninja -C out \
  && cp -f /tmp/gn/out/gn /usr/local/bin/gn \
  && ln -s /usr/bin/strip /usr/bin/eu-strip \
# cleanup
  && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*
