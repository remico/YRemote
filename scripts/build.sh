#!/bin/bash

workspaceFolder="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/.."
SDK=${HOME}/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-3.2.3-2020-10-13-c14e609bd/bin

/usr/lib/jvm/java-8-openjdk-amd64/bin/java -Dfile.encoding=UTF-8 -Dapple.awt.UIElement=true -jar ${SDK}/monkeybrains.jar -o ${workspaceFolder}/build/WatchRemote.prg -w -y ${HOME}/Dvlp/garmin_developer_key -d vivoactive3m -s 3.2.3 -f ${workspaceFolder}/monkey.jungle
