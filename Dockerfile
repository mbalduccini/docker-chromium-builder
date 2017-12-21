FROM blitznote/debase:17.10

ARG VER=master

RUN \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && perl -pi -e 's/archive.ubuntu.com/us.archive.ubuntu.com/' /etc/apt/sources.list \
    && apt-get update -y

RUN \
    apt-get install -y aptitude coreutils

RUN \
    aptitude install -y \
    lsb-base lsb-release sudo build-essential git

RUN \
    curl -s https://chromium.googlesource.com/chromium/src/+/master/build/install-build-deps.sh?format=TEXT | base64 -d \
    | perl -pe 's/if new_list.*/new_list=\$packages\nif false; then/' \
    | sed -e '/^  new_list/,+2d' \
    | perl -pe 's/apt-get install \$\{do_quietly-}/aptitude install -y/' \
    | bash -e -s - \
		--no-arm \
		--no-chromeos-fonts \
		--no-nacl \
        --no-prompt \
        --no-syms \
        --unsupported

RUN \
    mkdir -p /chromium \
    && cd / \
    && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

RUN \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH=$PATH:/depot_tools
