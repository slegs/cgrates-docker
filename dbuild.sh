#!/bin/bash

#set -ex

#Show the current directory
echo "Directory=$PWD"

#DEFAULT TO DEV WITH NO RUN
TYPE="DEV"
RUN_BUILD="NO"

while getopts ":u:v:t:i:r" opt; do
  case $opt in
    u) USERNAME="$OPTARG"
    ;;
    v) VERSION="$OPTARG"
    ;;
    t) TYPE="$OPTARG"
    ;;
    i) IMAGE="$OPTARG"
    ;;
    r) RUN_BUILD="YES"
    ;;
    \?) echo "An invalid option has been entered: $OPTARG"
        exit 1
    ;;
    :)  echo "The additional argument for option $OPTARG was omitted."
        exit 1
    ;;
  esac
done

echo "-u $USERNAME -v $VERSION -t $TYPE -i $IMAGE -r $RUN_BUILD"

#Check Mandatory Options
if [ "x" == "x$USERNAME" ]; then
  echo "-u docker username is required"
  exit 1
fi

if [ "x" == "x$IMAGE" ]; then
  echo "-i docker image name is required"
  exit 1
fi

if [ "x" == "x$VERSION" ]; then
  echo "-i docker version is required"
  exit 1
fi


if [ "$TYPE" == "PROD" ] ; then

	docker build -t $USERNAME/$IMAGE:stable-$VERSION -t $USERNAME/$IMAGE:latest .

	if [ "$RUN_BUILD" == "YES" ] ; then
        	docker run $USERNAME/$IMAGE:stable-$VERSION 
	fi

else

        docker build -t $USERNAME/$IMAGE:dev-$VERSION  -t $USERNAME/$IMAGE:test .
        if [ "$RUN_BUILD" == "YES" ] ; then
	        docker run $USERNAME/$IMAGE:dev-$VERSION
	fi

fi

exit 0
