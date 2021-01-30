#!/bin/bash

SDK=${HOME}/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-3.2.4-2021-01-05-1bf53aeed/bin
# SDK=${HOME}/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-3.2.3-2020-10-13-c14e609bd/bin
SDK_VERSION=3.1.0
DKEY=${HOME}/Downloads/garmin_developer_key
DEVICE=vivoactive3m

workspaceFolder="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/.."

# 2nd arg - ${relativeFileDirname}
# workspaceFolder=$(dirname $(find ${workspaceFolder} -name manifest.xml) | grep ${2%%/*})

PRJ_NAME=$(cat ${workspaceFolder}/.project | grep -m 1 -oP "(?<=<name>).*(?=</name>)")


if [[ $1 == "release" ]]; then
    BUILD_DIR=build
    BUILD_TYPE="-r"
    EXT="prg"
elif [[ $1 == "publish" ]]; then
    BUILD_DIR=build
    BUILD_TYPE="-e -r"
    EXT="iq"
elif [[ $1 == "debug" ]]; then
    BUILD_DIR=build
    BUILD_TYPE=""
    EXT="prg"
else  # simulator
    BUILD_DIR=bin
    [[ $1 == "simulator_release" ]] && BUILD_TYPE="-r"
    EXT="prg"
    SIMULATOR=1
fi


TARGET=${workspaceFolder}/${BUILD_DIR}/${PRJ_NAME}.${EXT}

java -Dfile.encoding=UTF-8 -Dapple.awt.UIElement=true -jar ${SDK}/monkeybrains.jar -o ${TARGET} -w -y ${DKEY} -d ${DEVICE} ${BUILD_TYPE} -f ${workspaceFolder}/monkey.jungle

if [[ $? -eq 0 ]] && [[ ${SIMULATOR} ]]; then
    ${SDK}/connectiq &
    sleep 1
    ${SDK}/monkeydo ${TARGET} ${DEVICE}
fi
