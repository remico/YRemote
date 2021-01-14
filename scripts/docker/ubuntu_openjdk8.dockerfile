FROM ubuntu:18.04
LABEL Name=ubuntu_openjdk8 Version=0.0.1

RUN apt update -y; \
    # apt install -y software-properties-common; \
    apt install -y wget unzip vim less; \
    apt install -y openjdk-8-jre libswt-gtk-4-java libwebkitgtk-1.0-0 libcurl4

ARG USER_ID=1000
ARG HOME_DIR=/home/user

RUN groupadd --gid ${USER_ID} user || true; \
    useradd --uid ${USER_ID} --gid ${USER_ID} user --home ${HOME_DIR}; \
    mkdir -p ${HOME_DIR} && \
    chown -R ${USER_ID}:${USER_ID} ${HOME_DIR}


ARG SDK_MANAGER_DIR=${HOME_DIR}/sdkmanager
ARG APP_ROOT=${HOME_DIR}/app

RUN ln -s ${HOME_DIR}/eclipse/eclipse /usr/local/bin/; \
    ln -s ${SDK_MANAGER_DIR}/bin/sdkmanager /usr/local/bin/

USER user

RUN mkdir -p ${APP_ROOT}; \
    mkdir -p ${HOME_DIR}/Downloads; \
    mkdir -p ${SDK_MANAGER_DIR};

# RUN cd ${HOME_DIR}/Downloads; \
#     wget -qN http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/2020-06/R/eclipse-java-2020-06-R-linux-gtk-x86_64.tar.gz && \
#     tar xzf eclipse-java-2020-06-R-linux-gtk-x86_64.tar.gz -C ${HOME_DIR}; \
#     rm eclipse-java-2020-06-R-linux-gtk-x86_64.tar.gz;

ADD eclipse-java-2020-06-R-linux-gtk-x86_64.tar.gz ${HOME_DIR}/

RUN cd ${HOME_DIR}/Downloads; \
    wget -qN https://developer.garmin.com/downloads/connect-iq/sdk-manager/connectiq-sdk-manager-linux.zip; \
    unzip connectiq-sdk-manager-linux.zip -d ${SDK_MANAGER_DIR}

COPY garmin_developer_key ${HOME_DIR}/Downloads

WORKDIR ${APP_ROOT}
