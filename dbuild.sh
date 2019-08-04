set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=slegs
# image name
IMAGE=cgrates-docker

if [ "$1" = "RELEASE"] ; then

	docker build -t $USERNAME/$IMAGE:stable -t $USERNAME/$IMAGE:latest .

else

        docker build -t $USERNAME/$IMAGE:dev  .

fi

