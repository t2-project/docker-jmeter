#!/bin/bash

JMETER_VERSION=${JMETER_VERSION:-"5.6.2"}
IMAGE_TIMEZONE=${IMAGE_TIMEZONE:-"Europe/Amsterdam"}
IMAGE_NAME="t2project/jmeter"

docker build --build-arg JMETER_VERSION=${JMETER_VERSION} --build-arg TZ=${IMAGE_TIMEZONE} -t "${IMAGE_NAME}:${JMETER_VERSION}" .
