FROM python:3.7.9-slim-stretch

ARG ARG_NODAEMON=true
ARG ARG_LOG_LEVEL=info
ARG ARG_CONF_BASEDIR=/etc/supervisor
ARG ARG_CONF_INCLUDES_DIR=conf.d
ARG ARG_LOG_DIR=/var/log/supervisor

ARG ARG_INTERNAL_HTTP_IP=127.0.0.1
ARG ARG_INTERNAL_HTTP_PORT=80
ARG ARG_UNIX_SOCKET_PAH=/tmp/supervisor.sock

RUN apt-get update -y &&  apt-get -y install supervisor && mkdir -p ${ARG_CONF_BASEDIR} ${ARG_CONF_BASEDIR}/${ARG_CONF_INCLUDES_DIR} ${ARG_LOG_DIR}

VOLUME [ ${ARG_CONF_BASEDIR}/${ARG_CONF_INCLUDES_DIR} ${ARG_LOG_DIR} ]

ENV INTERNAL_HTTP_IP_PORT ${ARG_INTERNAL_HTTP_IP}:${ARG_INTERNAL_HTTP_PORT}
ENV UNIX_SOCKET_PAH ${ARG_UNIX_SOCKET_PAH}
ENV NODAEMON ${ARG_NODAEMON}
ENV CONF_DIR ${ARG_CONF_BASEDIR}
ENV CONF_INCLUDES_DIR ${ARG_CONF_INCLUDES_DIR}
ENV LOG_LEVEL ${ARG_LOG_LEVEL}
ENV LOG_DIR ${ARG_LOG_DIR}

COPY supervisor.conf ${ARG_CONF_BASEDIR}/

HEALTHCHECK --interval=30s --timeout=30s --start-period=15s --retries=3 CMD [[ ! "$(supervisorctl -c ${CONF_DIR}/supervisor.conf version)" == "unix://${UNIX_SOCKET_PAH} no such file" ]]

CMD supervisord -c ${CONF_DIR}/supervisor.conf
