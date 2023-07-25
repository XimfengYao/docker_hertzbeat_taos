#!/bin/bash

# 当前目录
dir=`cd $(dirname $0);pwd`

# 启动taosd
nohup /usr/local/taos/bin/taosd &
nohup /usr/local/taos/bin/taosadapter &

# 是否初始化taos
if [ ! -f "/usr/local/taos/taos_init" ] ;then
        sleep 3
        taos -h 127.0.0.1 -s "show databases;CREATE DATABASE hertzbeat KEEP ${TAOS_HERTZ_TIMELIFE} DURATION 10 BUFFER 16;"
        taos -h 127.0.0.1 -s "alter user root PASS '${TAOS_ROOT_PASSWORD}';"
        echo "init by `date '+%Y-%m-%d %H:%M:%S'`" > /usr/local/taos/taos_init;
fi
# 是否替换配置
if [ ! -f "/opt/hertzbeat/config/application.yml" ] ;then
        sed -i "s|{HERTZ_ADMIN_ID}|${HERTZ_ADMIN_ID}|g" ${dir}/sureness.yml
        sed -i "s|{HERTZ_ADMIN_PASSWORD}|${HERTZ_ADMIN_PASSWORD}|g" ${dir}/sureness.yml
        cp -r ${dir}/*.yml /opt/hertzbeat/config
fi

# 启动hetzbeat
/opt/hertzbeat/bin/entrypoint.sh
