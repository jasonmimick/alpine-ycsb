FROM alpine:3.10
MAINTAINER jmimick@gmail.com

RUN apk add --update \
    openjdk8-jre \
    mksh \
  && rm -rf /var/cache/apk/*
#FROM rijalati/alpine-zulu-jdk8:latest-mini
#MAINTAINER ritchie@selectstar.io
# This hack is widely applied to avoid python printing issues in docker containers.
# See: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/pull/13
ENV PYTHONUNBUFFERED=1

RUN echo "**** install Python ****" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

ENV YCSB_VERSION=0.17.0 \
    PATH=${PATH}:/usr/bin

#RUN apk --update --no-cache add python3.7 mksh 
#RUN pip3 install --upgrade pip

COPY ycsb-mongodb-binding-${YCSB_VERSION}.tar.gz /opt
RUN cd opt && tar -xvf ycsb-mongodb-binding-${YCSB_VERSION}.tar.gz

COPY requirements.txt /requirements.txt
COPY connstring-helper.py /connstring-helper.py
RUN python3 -m pip install -r /requirements.txt
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENV ACTION='' DBTYPE='' WORKLETTER='' DBARGS='' RECNUM='' OPNUM=''

WORKDIR "/opt/ycsb-${YCSB_VERSION}"

ENTRYPOINT ["/start.sh"]
