FROM ubuntu:noble as download

ARG TARGETARCH
ENV TARGETVARIANT=${TARGETVARIANT}

RUN apt-get update && apt-get install -y \
    bash \
    aria2 \
    jq \
    curl  \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY ./download.sh download.sh
RUN chmod +x download.sh && \
  ./download.sh && \
  rm download.sh

FROM ubuntu:noble

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && apt-get install -y \
    libgtk-3-0 \
    libnotify4 \
    libnss3 \
    libxss1 \
    libxtst6 \
    xdg-utils \
    'libatspi2.0-0' \
    libsecret-1-0 \
    libasound2 \
    novnc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=download /app/baidunetdisk.deb baidunetdisk.deb
RUN dpkg -i baidunetdisk.deb  && rm baidunetdisk.deb

ENTRYPOINT /opt/baidunetdisk/baidunetdisk --disable-gpu-sandbox --no-sandbox

#
## Download and extract noVNC, then remove the version number in directory name.
#RUN wget ${NOVNC_PACKAGE} -O novnc.tar.gz && \
#  mkdir -p /root/novnc && \
#  tar -xzf novnc.tar.gz -C /root/novnc && \
#  rm novnc.tar.gz websockify.tar.gz -f && \
#  mv /root/novnc/noVNC-* /root/novnc/noVNC
#
## Remove cap_net_admin capabilities to avoid failing with 'operation not permitted'.
#RUN setcap -r `which i3status`
#
#COPY supervisord.conf /root/supervisord.conf
#COPY i3_config /root/.config/i3/config
#
#EXPOSE 5900
#EXPOSE 6080
#
#CMD echo "VNC (vnc://localhost:5900) password is $VNC_SERVER_PASSWD" && \
#  /usr/bin/x11vnc -storepasswd $VNC_SERVER_PASSWD ~/.vnc/passwd && \
#  /usr/bin/supervisord -c /root/supervisord.conf && \
#  /usr/bin/tail -f /dev/null
