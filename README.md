# About chromium-builder

The [chromium-builder][chromium-builder] project provides a Docker image,
[`chromedp/chromium-builder`][docker-hub], suitable for use as an environment
for building the Chromium source tree.

This was created in order to automate builds/deployments of `headless_shell`
for use with the Docker [`chromedp/headless-shell`][headless-shell] image.

Note: you will need to have the chromium source tree already on disk.

## Running

You can use this Docker image in the usual way:

```sh
# updated to latest version of chromium-builder
$ docker pull chromedp/chromium-builder

# build latest chrome version
$ docker run -it -v /path/to/chromium:/chromium -v /path/to/build:/build --rm chromedp/chromium-builder /build/build.sh
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
[headless-shell]: https://github.com/chromedp/docker-headleess-shell
[docker-hub]: https://hub.docker.com/r/chromedp/chromium-builder/
