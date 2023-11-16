[![Docker Build](https://github.com/t2-project/docker-jmeter/actions/workflows/docker.yml/badge.svg)](https://github.com/t2-project/docker-jmeter/actions/workflows/docker.yml)

# docker-jmeter

Docker image for [Apache JMeter](http://jmeter.apache.org).

Forked from https://github.com/justb4/docker-jmeter.

## T2-Project Usage

`jmeter-docker` is used to execute JMeter test plans in energy measurement scenarios with the [Green Metrics Tool](https://github.com/green-coding-berlin/green-metrics-tool) (GMT).
Because GMT executes `jmeter` during the `flow` execution (defined in `usage_scenario.yml`), the container must run all the time. Therefore a different entrypoint is needed.

Custom changes:
* upgrade JMeter version
* change entrypoint: just run the container, don't execute `jmeter` immediately → let GMT execute `jmeter` inside the `flow` (part of `usage_scenario.yml`)

## Image on Docker Hub

Find images of this repo on [Docker Hub](https://hub.docker.com/r/t2project/jmeter).
Docker builds/pushes are automatically [executed via a GitHub workflow](.github/workflows/docker.yml).
