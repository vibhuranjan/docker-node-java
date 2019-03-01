# pre-configured node/npm enabled image based on Alpine Linux
FROM mhart/alpine-node:8.14.0

# Declare maintainer
MAINTAINER Markus Nicks <markus.nicks@eon.com>

# Timezone to be set
ENV TIMEZONE Europe/Berlin

# 1. install bash, git & timezone stuff

# 2. set timezone

# 3. add 'npm' user
RUN	apk update && \
	apk upgrade && \
	apk add --update tzdata bash git && \
	cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
	echo "${TIMEZONE}" > /etc/timezone && \
	rm -rf /var/cache/apk/* && \
	adduser -S -h /home/npm -s /bin/bash -D npm && \
	cd /home/npm && \
	mkdir -p .node_modules_global && \
	chown -R npm:nogroup /home/npm

# move global node_modules to 'npm' users home and re-install NPM
USER npm

RUN cd /home/npm && \
	npm config set prefix=$HOME/.node_modules_global && \
	npm install npm --global

ENV HOME=/home/npm PATH=$HOME/.node_modules_global/bin:$PATH

# cleanup not needed binaries installed in the steps before
USER root
RUN apk del tzdata

# Set Workdir and default login user 'npm'
USER npm
WORKDIR /home/npm