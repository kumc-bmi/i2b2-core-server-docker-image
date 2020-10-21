FROM jboss/wildfly:17.0.1.Final

# 1.7.12a
ARG i2b2_version="76f86b0"

USER root
RUN yum install -y ant wget centos-release-ansible-27
RUN yum install -y ansible

# build and install i2b2
USER jboss
RUN mkdir i2b2-core-server &&\
    wget -qO- https://github.com/i2b2/i2b2-core-server/archive/${i2b2_version}.tar.gz \
      | tar --strip-components=1 -C i2b2-core-server -zxvf - &&\
    cd i2b2-core-server/edu.harvard.i2b2.server-common &&\
    ant dist war &&\
    cp dist/i2b2.war ~/wildfly/standalone/deployments/

RUN cd wildfly/standalone/deployments &&\
    wget https://github.com/i2b2/i2b2-data/raw/master/edu.harvard.i2b2.data/Release_1-7/ojdbc8.jar &&\
    wget https://github.com/i2b2/i2b2-data/raw/master/edu.harvard.i2b2.data/Release_1-7/postgresql-42.2.14.jar &&\
    wget https://github.com/i2b2/i2b2-data/raw/master/edu.harvard.i2b2.data/Release_1-7/mssql-jdbc-8.2.2.jre8.jar

COPY configure_datasources.yml .
COPY standalone.xml.j2 .

COPY init.sh .
ENTRYPOINT [ "/bin/bash", "init.sh" ]
