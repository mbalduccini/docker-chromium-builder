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
    $(cat DEPS)

RUN \
# build gn
  git clone https://gn.googlesource.com/gn /tmp/gn \
  && cd /tmp/gn \
  && LD=/usr/bin/ld.gold python build/gen.py --no-sysroot \
  && ninja -C out \
  && cp -f /tmp/gn/out/gn /usr/local/bin/gn

# build clang 6 from source
# see: https://stackoverflow.com/questions/50258121/building-llvm-6-under-linux-alpine
RUN \
  apk del \
    llvm5-libs mesa-dev libepoxy-dev gtk+3.0-dev gconf-dev libgnome-dev libgnome-keyring-dev \
    gnome-vfs-dev libcanberra-dev \
  && adduser -D apk \
  && adduser apk abuild \
  && sudo -iu apk abuild-keygen -a \
  && sudo -iu apk git clone --depth=1 -b pr-llvm-6 https://github.com/xentec/aports \
  && sudo -iu apk sh -xec 'cd aports/main/llvm6; MAKEFLAGS="-j $(($(nproc)+2))" abuild -r' \
  && cp /home/apk/.abuild/*.rsa.pub /etc/apk/keys \
  && apk add /home/apk/packages/main/$(uname -m)/*.apk \
  && sudo -iu apk sh -xec 'cd aports/main/clang; MAKEFLAGS="-j $(($(nproc)+2))" abuild -r' \
  && cp /home/apk/.abuild/*.rsa.pub /etc/apk/keys \
  && apk add /home/apk/packages/main/$(uname -m)/*.apk \
  && deluser --remove-home apk \
  && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*
