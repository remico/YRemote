#!/bin/bash
set -e

# build initial image
DOCKERFILE=${1:-$(find . -name "connectiq.dockerfile")}
TAG=${2:-connectiq}
CONTEXT=${3:-$(dirname $DOCKERFILE)}

docker build --rm -f ${DOCKERFILE} -t ${TAG}:base ${CONTEXT}

# setup sdk & simulator
docker run -e 'DISPLAY' -v '/tmp/.X11-unix:/tmp/.X11-unix:rw' -it ${TAG}:base

NEWEST_CONTAINER=$(docker ps -lq)
docker commit ${NEWEST_CONTAINER} ${TAG}:sdk


# =============================================================
# extra: build eclipse executable image

echo -n "Setup runnable eclipse container? [y/N]: "
read

if [[ "${REPLY}" != "y" ]]; then
    exit 0
fi

docker run -e 'DISPLAY' -v '/tmp/.X11-unix:/tmp/.X11-unix:rw' -it ${TAG}:sdk eclipse
NEWEST_CONTAINER=$(docker ps -lq)
docker commit ${NEWEST_CONTAINER} ${TAG}:eclipse
