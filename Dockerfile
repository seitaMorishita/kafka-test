#FROM --platform=linux/amd64 registry-jpe2.r-local.net/caas-trial/nginxinc/nginx-unprivileged:1.18
#COPY /kerberos-config ./
#
#ENV DEBIAN_FRONTEND=noninteractive
#
#USER root
#RUN apt-get -qq update && \
#    apt-get -yqq install krb5-user libpam-krb5 && \
#    apt-get -yqq clean
FROM registry-jpe1.r-local.net/ccbd-sens-sandbox-kafka-test/docker-container/nginx@sha256:fe7f7e35feba542b400bb982fabcbd8d73bf0d5c4a391009f19d1406c53bff59