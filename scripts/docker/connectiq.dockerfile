FROM ubuntu:18.04 AS connectiq
LABEL Name=connectiq Version=0.0.1

RUN apt update -y; \
    apt install -y software-properties-common; \
    apt install -y wget unzip vim less; \
    apt install -y openjdk-8-jre libswt-gtk-4-java libwebkitgtk-1.0-0 libcurl4

# ----------------------  arguments ----------------------------
# can be altered via passing "--build-arg <varname>=<value>"

# default user inside the image
ARG USER=user
ARG USER_ID=1000

ARG HOME=/home/${USER}
ARG SDK_MANAGER_DIR=${HOME}/sdkmanager
ARG APP_ROOT=${HOME}/app
# --------------------------------------------------------------

RUN groupadd --gid ${USER_ID} ${USER} || true; \
    useradd --uid ${USER_ID} --gid ${USER_ID} ${USER} --home ${HOME}; \
    mkdir -p ${HOME} && \
    chown -R ${USER_ID}:${USER_ID} ${HOME}

RUN ln -s ${HOME}/eclipse/eclipse /usr/local/bin/; \
    ln -s ${SDK_MANAGER_DIR}/bin/sdkmanager /usr/local/bin/

USER ${USER}

RUN mkdir -p ${APP_ROOT}; \
    mkdir -p ${HOME}/Downloads; \
    mkdir -p ${SDK_MANAGER_DIR};

# --------------------------------------------------------------
# install eclipse: either download or just extract a local file

# RUN cd ${HOME}/Downloads; \
#     wget -qN http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/2020-06/R/eclipse-java-2020-06-R-linux-gtk-x86_64.tar.gz && \
#     tar xzf eclipse-java-2020-06-R-linux-gtk-x86_64.tar.gz -C ${HOME}; \
#     rm eclipse-java-2020-06-R-linux-gtk-x86_64.tar.gz;

ADD eclipse-java-2020-06-R-linux-gtk-x86_64.tar.gz ${HOME}/
# --------------------------------------------------------------

RUN cd ${HOME}/Downloads; \
    wget -qN https://developer.garmin.com/downloads/connect-iq/sdk-manager/connectiq-sdk-manager-linux.zip; \
    unzip connectiq-sdk-manager-linux.zip -d ${SDK_MANAGER_DIR}

COPY garmin_developer_key ${HOME}/Downloads

WORKDIR ${APP_ROOT}

CMD \
    sdkmanager; \
    PATH=$(ls -d $HOME/.Garmin/ConnectIQ/Sdks/connectiq-sdk-*/bin):$PATH; \
    simulator
