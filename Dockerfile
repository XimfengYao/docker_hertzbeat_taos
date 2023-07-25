FROM tancloud/hertzbeat AS builder
ENV TDENGINE_VERSION=3.0.7.1
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak \
   && sed -i "s@http://deb.debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list \
   && rm -rf /var/lib/apt/lists/* \
   && apt-get update -y && apt-get install -y wget \
   && export TDENGINE_VERSION=3.0.7.1 \
   && wget -c https://www.taosdata.com/assets-download/3.0/TDengine-server-${TDENGINE_VERSION}-Linux-`arch | sed 's|86_||g' | sed 's|aarch64|arm64|g'`.tar.gz \
   && tar xvf TDengine-server-${TDENGINE_VERSION}-Linux-`arch | sed 's|86_||g' | sed 's|aarch64|arm64|g'`.tar.gz \
   && cd TDengine-server-${TDENGINE_VERSION} \
   && ./install.sh -e no \
   && cd ../ \
   && rm -rf TDengine-server-${TDENGINE_VERSION}-Linux-`arch | sed 's|86_||g' | sed 's|aarch64|arm64|g'`.tar.gz TDengine-server-${TDENGINE_VERSION} \
   && rm -rf /opt/hertzbeat/config/sureness.yml /opt/hertzbeat/config/application.yml \
   && apt-get autoremove -y wget && rm -rf /var/lib/apt/lists/*
COPY ./entrypoint /entrypoint
RUN chmod +x /entrypoint/start.sh
ENV TAOS_ROOT_PASSWORD=taosdata
ENV TAOS_HERTZ_TIMELIFE=365
ENV HERTZ_ADMIN_ID=admin
ENV HERTZ_ADMIN_PASSWORD=hertzbeat
ENV HERTZ_JWT_SCRETS="CysFv0bwq2Eik0jdrKUtsA6bx3sDJeFV643RLnfKefTjsIfJLBa2YkhEqEGtcHDTNe4CU6+98tVt4bisXQ13rbN0oxhUZR73M6EByXIO+SV5dKhaX0csgOCTlCxq20yhmUea6H6JIpSE2Rwp"
ENV TZ=Asia/Shanghai
ENV LANG=zh_CN.UTF-8

ENTRYPOINT /entrypoint/start.sh
