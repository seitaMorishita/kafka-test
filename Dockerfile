FROM node:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -yqq install krb5-user libpam-krb5 && \
    apt-get -yqq clean

COPY / ./

EXPOSE 3000

CMD ["npm", "start"]