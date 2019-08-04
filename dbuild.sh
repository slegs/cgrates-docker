set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=slegs
# image name
IMAGE=cgrates-docker

docker build -t $USERNAME/$IMAGE:latest .
