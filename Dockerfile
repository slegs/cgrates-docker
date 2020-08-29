FROM debian:stretch
MAINTAINER slegs

#environment variables

# Important! Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like 'apt-get update' won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT 2020-05-12

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV MONGO_HOST ${MONGO_HOST:-127.0.0.1}
ENV MONGO_STORDB ${MONGO_STORDB:-cgrates}
ENV MONGO_DATADB ${MONGO_DATADB:-10}
ENV CGRATES_CONFIG ${CGRATES_CONFIG:-RAL}
ENV CGRATES_KAMAILIO_ENABLED ${CGRATES_KAMAILIO_ENABLED:-false}
ENV CGRATES_KAMAILIO_EVAPI_HOST ${CGRATES_KAMAILIO_EVAPI_HOST:-127.0.0.1}
ENV CGRATES_KAMAILIO_EVAPI_PORT ${CGRATES_KAMAILIO_EVAPI_PORT:-8448}
ENV CGRATES_LOG_LEVEL ${CGRATES_LOG_LEVEL:-1}
ENV CGRATES_LOGGER ${CGRATES_LOGGER:-*stdout}
ENV CGRATES_DISPATCHER_ENABLED ${CGRATES_DISPATCHER_ENABLED:-false}
ENV CGRATES_SESSION_ENABLED ${CGRATES_SESSION_ENABLED:-false}
ENV CGRATES_CONNS ${CGRATES_CONNS}
ENV CGRATES_NAME ${CGRATES_NAME}

#Label description into image
LABEL description="Runs CGRATES in a Docker container with option to copy in config and adjust via environment valriables and sed"

#Set Timezone
ENV TZ=${CONTAINER_TZ:-Europe/Dublin}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install dependencies
RUN apt-get -y update && apt-get -y install git sudo wget nano mongodb-clients rsyslog ngrep curl

#Download latest STABLE CGRATES
RUN wget http://pkg.cgrates.org/deb/v0.10/cgrates_current_amd64.deb \
&& dpkg -i cgrates_current_amd64.deb

#tidy up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm cgrates_current_amd64.deb

#Copy our config files into image
RUN mkdir -p /opt/cgrates-cfg-files
COPY config/cgrates*.json /opt/cgrates-cfg-files/

#Copy startfile into image
COPY start.sh /opt/start.sh
RUN chmod +x /opt/start.sh

#Expose ports
EXPOSE 2012
EXPOSE 2013
EXPOSE 2080

# set start command
ENTRYPOINT ["/opt/start.sh"]
