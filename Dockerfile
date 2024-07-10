#FROM --platform=linux/amd64 registry-jpe2.r-local.net/caas-trial/nginxinc/nginx-unprivileged:1.18
#COPY /kerberos-config ./
#
#ENV DEBIAN_FRONTEND=noninteractive
#
#USER root
#RUN apt-get -qq update && \
#    apt-get -yqq install krb5-user libpam-krb5 && \
#    apt-get -yqq clean
# FROM registry-jpe1.r-local.net/ccbd-sens-sandbox-kafka-test/docker-container/nginx@sha256:fe7f7e35feba542b400bb982fabcbd8d73bf0d5c4a391009f19d1406c53bff59

# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# FROM openjdk:11

# ENV DEBIAN_FRONTEND=noninteractive
# ENV KAFKA_VERSION=3.3.1
# ENV KAFKA_HOME=/opt/kafka

# RUN apt-get update -qq && \
#     apt-get install -yqq wget && \
#     apt-get clean

# RUN wget -q https://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_2.13-$KAFKA_VERSION.tgz -O /tmp/kafka.tgz && \
#     tar xfz /tmp/kafka.tgz -C /opt && \
#     mv /opt/kafka_2.13-$KAFKA_VERSION $KAFKA_HOME && \
#     rm /tmp/kafka.tgz

# ENV PATH=$PATH:$KAFKA_HOME/bin

# COPY /kerberos-config ./

# ENV DEBIAN_FRONTEND=noninteractive

# USER root
# RUN apt-get -qq update && \
#    apt-get -yqq install krb5-user libpam-krb5 && \
#    apt-get -yqq clean

# FROM registry-jpe1.r-local.net/ccbd-sens-sandbox-kafka-test/docker-container/kafka3.3.1:1.1

# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# FROM --platform=linux/amd64 registry-jpe2.r-local.net/caas-trial/nginxinc/nginx-unprivileged:1.18

# USER root

# RUN mkdir -p /usr/share/man/man1

# RUN apt-get update && \
#     apt-get install -y openjdk-11-jre-headless && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# ENV DEBIAN_FRONTEND=noninteractive
# ENV KAFKA_VERSION=3.3.1
# ENV KAFKA_HOME=/opt/kafka

# RUN apt-get update -qq && \
#     apt-get install -yqq wget && \
#     apt-get clean

# RUN wget -q https://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_2.13-$KAFKA_VERSION.tgz -O /tmp/kafka.tgz && \
#     tar xfz /tmp/kafka.tgz -C /opt && \
#     mv /opt/kafka_2.13-$KAFKA_VERSION $KAFKA_HOME && \
#     rm /tmp/kafka.tgz

# ENV PATH=$PATH:$KAFKA_HOME/bin

# COPY /kerberos-config ./

# RUN apt-get -qq update && \
#    apt-get -yqq install krb5-user libpam-krb5 && \
#    apt-get -yqq clean
# FROM registry-jpe1.r-local.net/ccbd-sens-sandbox-kafka-test/docker-container/kafka3.3.1@sha256:867b40bde737dd78f651bb73eefbfbee26650a615dd64c232df7b74b69ceb4b2

# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# FROM --platform=linux/amd64 registry-jpe2.r-local.net/caas-trial/nginxinc/nginx-unprivileged:1.18

# USER root

# RUN mkdir -p /usr/share/man/man1

# RUN apt-get update && \
#     apt-get install -y openjdk-11-jre-headless && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# RUN apt-get update && \
#     apt-get install -y vim

# ENV DEBIAN_FRONTEND=noninteractive
# ENV KAFKA_VERSION=3.3.1
# ENV KAFKA_HOME=/opt/kafka

# RUN apt-get update -qq && \
#     apt-get install -yqq wget && \
#     apt-get clean

# RUN wget -q https://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_2.13-$KAFKA_VERSION.tgz -O /tmp/kafka.tgz && \
#     tar xfz /tmp/kafka.tgz -C /opt && \
#     mv /opt/kafka_2.13-$KAFKA_VERSION $KAFKA_HOME && \
#     rm /tmp/kafka.tgz

# ENV PATH=$PATH:$KAFKA_HOME/bin

# COPY /kerberos-config ./

# RUN apt-get -qq update && \
#    apt-get -yqq install krb5-user libpam-krb5 && \
#    apt-get -yqq clean
FROM registry-jpe1.r-local.net/ccbd-sens-sandbox-kafka-test/docker-container/kafka3.3.1@sha256:abcf21dc9e6f7ed8eb37a2793af16047db7ac87a6d0d1604fe8fc3ab83f64ef9