FROM jboss/wildfly:17.0.1.Final

# 1.7.12a
ARG i2b2_version="76f86b0"

USER root
RUN rm -rf /etc/yum.repos.d/*
COPY centos7.repo /etc/yum.repos.d/cent7.repo
RUN yum install -y ant wget ansible

RUN chown jboss:jboss /etc/pki/ca-trust/extracted/java/cacerts &&\
    chmod 600 /etc/pki/ca-trust/extracted/java/cacerts

# build and install i2b2
USER jboss
RUN mkdir i2b2-core-server &&\
    wget -qO- https://github.com/i2b2/i2b2-core-server/archive/${i2b2_version}.tar.gz \
      | tar --strip-components=1 -C i2b2-core-server -zxvf - &&\
    cd i2b2-core-server/edu.harvard.i2b2.server-common &&\
    ant dist war &&\
    cp dist/i2b2.war ~/wildfly/standalone/deployments/ &&\
    cp lib/jdbc/postgresql-42.2.8.jar ~/wildfly/standalone/deployments/

COPY configure_datasources.yml .
COPY standalone.xml.j2 .
COPY init.sh .
ENTRYPOINT [ "/bin/bash", "init.sh" ]
