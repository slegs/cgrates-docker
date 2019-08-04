#!/bin/bash

#Show the current directory
echo "Directory=$PWD"

#DEFAULT TO DEV
TYPE="DEV"
VERSION_TYPE="patch"

# GET OPTIONS
while getopts ":u:i:v:p" opt; do
  case $opt in
    u) USERNAME="$OPTARG"
    ;;
    p) TYPE="PROD"
    ;;
    v) VERSION_TYPE="$OPTARG"
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

echo "Parameters passed to release -u $USERNAME -i $IMAGE -v $VERSION_TYPE -p $TYPE"

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

# bump version
docker run --rm -v "$PWD":/app treeder/bump $VERSION_TYPE 

VERSION_NO=`cat VERSION`
echo "version: $VERSION_NO"

# run build
./dbuild.sh -u $USERNAME -i $IMAGE -t $TYPE -v $VERSION_NO

if [ $? -eq 0 ]
then

	# tag it
	git add -A
	git commit -m "version $VERSION_NO"
	git tag -a "$VERSION_NO" -m "version $VERSION_NO"
	git push
	git push --tags


	# if release then push stable and latest else dev
	if [ "$TYPE" == "PROD" ] ; then

		docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$VERSION_NO
		# push it
		docker push $USERNAME/$IMAGE:latest

	        docker tag $USERNAME/$IMAGE:stable-$VERSION_NO $USERNAME/$IMAGE:$VERSION_NO
	        # push it
	        docker push $USERNAME/$IMAGE:stable-$VERSION_NO

	else
                docker tag $USERNAME/$IMAGE:test $USERNAME/$IMAGE:$VERSION_NO
                # push it
                docker push $USERNAME/$IMAGE:test

	        docker tag $USERNAME/$IMAGE:dev-$VERSION_NO $USERNAME/$IMAGE:$VERSION_NO
	        # push it
	        docker push $USERNAME/$IMAGE:dev-$VERSION_NO

	fi

fi

exit 0
