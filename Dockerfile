FROM centos:7

MAINTAINER Wes Lambert
RUN yum -y update && \
    yum clean all

RUN curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | python

RUN pip install elasticsearch-curator
RUN useradd -ms /bin/bash curator
RUN chown -R curator: /usr/bin/curator*
USER curator

ENTRYPOINT ["/bin/bash"]
