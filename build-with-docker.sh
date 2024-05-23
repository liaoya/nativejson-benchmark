#!/bin/bash
# Usage: env GIT_PROXY=http://10.245.91.190:9080 ./build-with-docker.sh
# Or
# Usage: ./build-with-docker.sh

declare -a DOCKER_BUILD_OPTS=()
export DOCKER_BUILD_OPTS

function concat_docker_build_arg() {
    if [[ $# -eq 1 ]]; then
        if [[ -n ${!1+x} ]]; then
            export DOCKER_BUILD_OPTS+=(--build-arg "${1}=${!1}")
        fi
    elif [[ $# -eq 2 ]]; then
        export DOCKER_BUILD_OPTS=(--build-arg "${1}=${2}")
    fi
}

for key in http_proxy https_proxy no_proxy HTTP_PROXY HTTPS_PROXY NO_PROXY GIT_PROXY; do
    concat_docker_build_arg "${key}"
done

docker build --force-rm "${DOCKER_BUILD_OPTS[@]}" -t nativejson-benchmark .