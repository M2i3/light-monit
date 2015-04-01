FROM centos:5
MAINTAINER Jean-Marc Lagace <jean-marc@m2i3.com>

RUN yum install -y make curl sendmail

ADD ./ /srv/

WORKDIR /srv
