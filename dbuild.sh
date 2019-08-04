#set -ex

#Show the current directory
echo "Directory=$PWD"

#DEFAULT TO DEV WITH NO RUN
TYPE="DEV"
RUN_BUILD="NO"

while getopts ":u:i:v:t:r" opt; do
  case $opt in
    u) USERNAME="$OPTARG"
    ;;
    v) VERSION="$OPTARG"
    ;;
    t) TYPE="RELEASE"
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


if [ "$TYPE" == "RELEASE" ] ; then

	docker build -t $USERNAME/$IMAGE:stable-$VERSION -t $USERNAME/$IMAGE:latest .

	if [ "$RUN_BUILD" == "YES" ] ; then
        	docker run $USERNAME/$IMAGE:stable-$VERSION 
	fi

else

        docker build -t $USERNAME/$IMAGE:dev-$VERSION  .
        if [ "$RUN_BUILD" == "YES" ] ; then
	        docker run $USERNAME/$IMAGE:dev-$VERSION
	fi

fi

