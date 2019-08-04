set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=slegs
# image name
IMAGE=cgrates-docker

# ensure we're up to date
git pull

# bump version
docker run --rm -v "$PWD":/app treeder/bump patch
version=`cat VERSION`
echo "version: $version"

# run build
./dbuild.sh $1

# tag it
git add -A
git commit -m "version $version"
git tag -a "$version" -m "version $version"
git push
git push --tags


# if release then push stable and latest else dev
if [ "$1" = "RELEASE"] ; then

	docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$version
	# push it
	docker push $USERNAME/$IMAGE:latest

        docker tag $USERNAME/$IMAGE:stable $USERNAME/$IMAGE:$version
        # push it
        docker push $USERNAME/$IMAGE:stable

else
        docker tag $USERNAME/$IMAGE:dev $USERNAME/$IMAGE:$version
        # push it
        docker push $USERNAME/$IMAGE:dev
fi

docker push $USERNAME/$IMAGE:$version
