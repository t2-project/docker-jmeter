#!/bin/sh
# Inspired from https://github.com/hhcordero/docker-jmeter-client
# Basically runs jmeter, assuming the PATH is set to point to JMeter bin-dir (see Dockerfile)
# 
# This script expects the standdard JMeter command parameters.
# If no arguments are given, the container waits.
#

# Install jmeter plugins available on /plugins volume
if [ -d $JMETER_CUSTOM_PLUGINS_FOLDER ]
then
    for plugin in ${JMETER_CUSTOM_PLUGINS_FOLDER}/*.jar; do
        cp $plugin ${JMETER_HOME}/lib/ext
    done;
fi

# Execute JMeter command
set -e
freeMem=`awk '/MemAvailable/ { print int($2/1024) }' /proc/meminfo`

[[ -z ${JVM_XMN} ]] && JVM_XMN=$(($freeMem/10*2))
[[ -z ${JVM_XMS} ]] && JVM_XMS=$(($freeMem/10*8))
[[ -z ${JVM_XMX} ]] && JVM_XMX=$(($freeMem/10*8))

export JVM_ARGS="-Xmn${JVM_XMN}m -Xms${JVM_XMS}m -Xmx${JVM_XMX}m"

echo "START Running Jmeter on `date`"
echo "JVM_ARGS=${JVM_ARGS}"

if [ $# -eq 0 ]; then
    echo "No arguments provided. Waiting..."
    touch /jmeter.log
    exec tail -f /jmeter.log
else
    echo "Arguments provided: $@"
    EXTRA_ARGS=-Dlog4j2.formatMsgNoLookups=true
    echo "jmeter ALL ARGS=${EXTRA_ARGS} $@"
    jmeter ${EXTRA_ARGS} $@

    echo "END Running Jmeter on `date`"
fi
