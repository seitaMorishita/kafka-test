FROM node:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-key list

RUN apt-get update && \
    apt-get install -y gnupg && \
    apt-key adv --keyserver pgp.mit.edu --recv-keys 0E98404D386FA1D9 6ED0E7B82643E131 F8D2585B8783D481 54404762BBB6E853 BDE6D2B9216EC7A8


RUN apt-get -qq update && \
    apt-get -yqq install krb5-user libpam-krb5 && \
    apt-get -yqq clean

COPY / ./

EXPOSE 3000

CMD ["npm", "start"]