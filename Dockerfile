FROM debian:stretch
MAINTAINER slegs

#environment variables
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV MONGO_HOST ${MONGO_HOST:-127.0.0.1}
ENV CGRATES_LOG_LEVEL ${CGRATES_LOG_LEVEL:-1}

#Set Timezone
ENV TZ=${CONTAINER_TZ:-Europe/Dublin}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install dependencies
RUN apt-get -y update && apt-get -y install git sudo wget nano mongodb-clients rsyslog ngrep curl

# install cgrates
RUN wget -O /tmp/cgrates.deb http://www.cgrates.org/tmp_pkg/cgrates_0.9.1~rc8_amd64.deb
RUN dpkg -i /tmp/cgrates.deb

#tidy up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Copy cgrates.json into image
COPY cgrates.json /etc/cgrates/cgrates.json

#Copy startfile into image
COPY start.sh /opt/start.sh
RUN chmod +x /opt/start.sh

#Expose ports
EXPOSE 2012 
EXPOSE 2013
EXPOSE 2080

# set start command
ENTRYPOINT ["/opt/start.sh"]
