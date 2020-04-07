FROM ubuntu:19.04

MAINTAINER Frederic Auberson <fauberso@dxc.com>

ARG ARCHI_CHECKSUM=78ef89ac08f
ARG ARCHI_VERSION=4.6.0
ARG ARCHI_GIT_PLUGIN_VERSION=0.6.2.202004031233
ARG ARCHI_USER=archi

RUN apt-get update && apt-get install -y sudo curl unzip libgtk2.0-0 libxtst6 xvfb git && apt-get clean

RUN curl -o /archi.tar.gz https://www.archimatetool.com/downloads/$ARCHI_CHECKSUM/Archi-Linux64-$ARCHI_VERSION.tgz
RUN tar -zxvf /archi.tar.gz
RUN rm /archi.tar.gz

RUN curl -o /archi-git.zip https://www.archimatetool.com/downloads/plugins/org.archicontribs.modelrepository_$ARCHI_GIT_PLUGIN_VERSION.archiplugin
RUN unzip /archi-git.zip -d /Archi/plugins
RUN rm /archi-git.zip

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/$ARCHI_USER && \
    echo "$ARCHI_USER:x:${uid}:${gid}:$ARCHI_USER,,,:/home/$ARCHI_USER:/bin/bash" >> /etc/passwd && \
    echo "$ARCHI_USER:x:${uid}:" >> /etc/group && \
    echo "$ARCHI_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$ARCHI_USER && \
    chmod 0440 /etc/sudoers.d/$ARCHI_USER && \
    chown ${uid}:${gid} -R /home/$ARCHI_USER

COPY archi.sh /usr/local/bin/archi
RUN chmod +x /usr/local/bin/archi

USER $ARCHI_USER
ENV HOME /home/$ARCHI_USER

WORKDIR /home/$ARCHI_USER

CMD ["archi", "--help"]
