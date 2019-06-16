# About this fork

I wanted to build a headless version of Chromium for linux and found
the [upstream][chromium-builder] Docker image. Unfortunately, it
didn't work right out of the box, but was easy enough to correct.

This fork also adds the [docker-headless-shell][docker-headless-shell]
project to the build image.

After loading this image into a container, I was able to fetch the
Chromium source tree according to [these instructions][chromium-build-instr].
Quick summary:

First time, build the docker image:

```
$ docker build -t anticrisis/build-chromium .
```

Start the docker image (example uses Windows path to shared volume):

```
$ docker run -it -v d:\share:/media anticrisis/build-chromium
```

Fetch Chromium source and run platform-dependent hooks:

```
# mkdir -p /media/src/chromium && cd /media/src/chromium
# fetch --nohooks chromium
```

Take a nap here, because this is very slow.

This next step runs all an extra set of platform-specific build dependencies:

```
# cd /media/src/chromium/src
# gclient runhooks
```

Note that all commands using chromium tools should be run from the `src` folder.

The key thing about these preceeding steps is that the `fetch`, `gclient`
 and `gn` tools are platform-dependent. So you want to run them from the 
 build image, not your host platform (Windows in my case).

Run this script to update your source tree, generate a build system,
and start the build:

```
# /docker-headless-shell/build-headless-shell.sh 
```

While `build-headless-shell.sh` is a handy script for its purpose, there
are some aspects that might not be that great in the general case.

For example, I found the need to tweak the script to set `UPDATE=0`
in order to avoid a very time-consuming source tree update each time I 
ran it.

The script also uses a `.last` file _in its source directory_, which
will get wiped out when you reset your docker image.

I also manually tweaked the `gn` arguments a bit to get it to build,
because "jumbo build" was taking forever and I was afraid it might run
out of memory eventually.

```
# <edit out/headless-shell/args.gn to set use_jumbo_build=false>
```

Regenerate build system using new `args.gn` settings:
```
# gn gen out/headless-shell
```

_The following is the upstream README:_

----

# About chromium-builder

The [chromium-builder][chromium-builder] project provides a Docker image,
[`chromedp/chromium-builder`][docker-hub], suitable for use as an environment
for building the Chromium source tree.

This was created in order to automate builds/deployments of Chromium's
`headless_shell` for use with the Docker [`chromedp/headless-shell`][headless-shell]
image.

Note: you will need to have the Chromium source tree already on disk.

## Running

You can use this Docker image in the usual way:

```sh
# updated to latest version of chromium-builder
$ docker pull chromedp/chromium-builder

# build latest chrome version
$ docker run -it -v /path/to/chromium:/chromium -v /path/to/build:/build --rm chromedp/chromium-builder /build/build.sh
```

For example, if you have the Chromium source tree checked out to
`/media/src/chromium`, and have the [headless-shell][headless-shell] Docker
source checked out to `~/src/docker/headless-shell`, you can build the latest
`headless-shell` using the `build-headless-shell.sh` script via the following:

```sh
$ docker run -it \
    -v /media/src/chromium:/chromium \
    -v ~/src/docker/headless-shell:/build \
    --rm \
    chromedp/chromium-builder \
    /build/build-headless-shell.sh /
```

## Building Image

The Docker image can be manually built the usual way:

```sh
# clone the repository
$ cd ~/src/ && git clone https://github.com/chromedp/docker-chromium-builder.git chromium-builder

# docker build
$ cd ~/src/chromium-builder && docker build -t chromedp/chromium-builder .
```

[chromium-builder]: https://github.com/chromedp/docker-chromium-builder
[headless-shell]: https://github.com/chromedp/docker-headless-shell
[docker-hub]: https://hub.docker.com/r/chromedp/chromium-builder/
[docker-headless-shell]: https://github.com/chromedp/docker-headless-shell.git
[chromium-build-instr]: https://chromium.googlesource.com/chromium/src/+/master/docs/linux_build_instructions.md

