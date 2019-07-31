FROM debian:stretch
MAINTAINER slegs

# install dependencies
RUN apt-get -y update && apt-get -y install git sudo wget mongodb-clients rsyslog ngrep curl

# install cgrates
RUN wget http://www.cgrates.org/tmp_pkg/cgrates_0.9.1~rc8_amd64.deb
RUN dpkg -i cgrates_0.9.1~rc8_amd64.deb

