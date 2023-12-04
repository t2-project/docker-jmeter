#!/bin/bash

IMAGE_TIMEZONE=${IMAGE_TIMEZONE:-"Europe/Amsterdam"}
IMAGE_NAME="t2project/jmeter"

build() {

  echo "Found new version, building the image ${IMAGE_NAME}:${tag}"
  docker build --build-arg JMETER_VERSION=${tag} --build-arg TZ=${IMAGE_TIMEZONE} -t "${IMAGE_NAME}:${tag}" .
}

push() {

  echo "Update latest image with latest release"
  latest=$(echo $latest | xargs -n1 | sort -Vr | head -1)
  echo $latest

  docker push ${IMAGE_NAME}:${tag}
  docker tag ${IMAGE_NAME}:${tag} ${IMAGE_NAME}:latest
  docker push ${IMAGE_NAME}:latest
}

latest=$(curl -sL https://archive.apache.org/dist/jmeter/binaries/ | grep -oP '(?<=href=\")[^"]*' | grep tgz$ | cut -d \- -f3 | sed 's/\.tgz//' | sort -rn | head -1) # head -1 = Only use the newest latest version

echo "latest: ${latest}"
for tag in ${latest}; do
  status=$(curl -sL https://hub.docker.com/v2/repositories/${IMAGE_NAME}/tags/${tag})
  echo "status: ${status}"
  # if [[ "${status}" =~ "not found" ]]; then
  build
  push
  # fi
done
