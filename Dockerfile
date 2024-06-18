#FROM node:latest
#FROM --platform=linux/amd64 node:latest
#
#ENV DEBIAN_FRONTEND=noninteractive
#
#RUN apt-get -qq update && \
#    apt-get -yqq install krb5-user libpam-krb5 && \
#    apt-get -yqq clean
#
#COPY / ./
#
#EXPOSE 3000

#CMD ["npm", "start"]
#FROM registry-jpe1.r-local.net/ccbd-sens-sandbox-kafka-test/docker-container/nginx@sha256:5ea4c69f367856a72cb751ce81e374663bdde40e70bc2e6eecf557256d5f1c4a
#ENTRYPOINT ["tail"]
#CMD ["-f","/dev/null"]
FROM registry-jpe1.r-local.net/ccbd-sens-sandbox-kafka-test/docker-container/nginx@sha256:3d97fa52e5a18a03408e7489804db427072a1d412288a91cd5fdf550ff42b336