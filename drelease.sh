#Show the current directory
echo "Directory=$PWD"

#DEFAULT TO DEV
TYPE="DEV"

# GET OPTIONS
while getopts ":u:i:v:s" opt; do
  case $opt in
    u) USERNAME="$OPTARG"
    ;;
    v) NEW_VERSION="$OPTARG"
    ;;
    s) TYPE="RELEASE"
    ;;
    i) IMAGE="$OPTARG"
    ;;
    \?) echo "An invalid option has been entered: $OPTARG"
        exit 1
    ;;
    :)  echo "The additional argument for option $OPTARG was omitted."
        exit 1
    ;;
  esac
done

#Check Mandatory Options
if [ "x" == "x$USERNAME" ]; then
  echo "-u docker username is required"
  exit 1
fi

if [ "x" == "x$IMAGE" ]; then
  echo "-i docker image name is required"
  exit 1
fi


# ensure we're up to date
git pull

if [ -z "$NEW_VERSION" ];  then
	# bump version
	docker run --rm -v "$PWD":/app treeder/bump patch
else
	echo "$NEW_VERSION" > VERSION
fi

VERSION_NO=`cat VERSION`
echo "version: $VERSION_NO"

# run build
./dbuild.sh -u $USERNAME -i $IMAGE -t $TYPE -v $VERSION_NO

# tag it
git add -A
git commit -m "version $VERSION_NO"
git tag -a "$VERSION_NO" -m "version $VERSION_NO"
git push
git push --tags


# if release then push stable and latest else dev
if [ "$TYPE" == "RELEASE" ] ; then

	docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$VERSION_NO
	# push it
	docker push $USERNAME/$IMAGE:latest

        docker tag $USERNAME/$IMAGE:stable-$VERSION_NO $USERNAME/$IMAGE:$VERSION_NO
        # push it
        docker push $USERNAME/$IMAGE:stable-$VERSION_NO

else
        docker tag $USERNAME/$IMAGE:dev-$VERSION_NO $USERNAME/$IMAGE:$VERSION_NO
        # push it
        docker push $USERNAME/$IMAGE:dev-$VERSION_NO
fi

docker push $USERNAME/$IMAGE:$VERSION_NO
