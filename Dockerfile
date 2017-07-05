FROM    centos:7

MAINTAINER      Wes Lambert
RUN yum -y update && \
    yum clean all && \
    yum -y install cronie

RUN curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | python

RUN pip install elasticsearch-curator
ADD curator-cron.sh /curator-cron.sh
RUN chmod 755 /curator-cron.sh

ENTRYPOINT ["/curator-cron.sh"]
