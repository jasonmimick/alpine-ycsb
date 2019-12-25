FROM rijalati/alpine-zulu-jdk8:latest-mini
MAINTAINER ritchie@selectstar.io

ENV YCSB_VERSION=0.17.0 \
    PATH=${PATH}:/usr/bin

RUN apk --update --no-cache add python3 mksh 
RUN pip3 install --upgrade pip

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
