#!/usr/bin/env bash

# resulting images namespace on docker hub
NAMESPACE=ambiente

# publish the built images
PUBLISH=false

# enabled repositories for the build
REPOSITORIES=$1

# enable all repositories if any specified
if [[ -z $REPOSITORIES ]]; then
    REPOSITORIES="nodejs quasarframework java"
fi

# for returning later to the main directory
ROOT_DIRECTORY=`pwd`

# function for building images
function build_repository {
    # build
    echo $'\n\n'"--> Building $NAMESPACE/$REPOSITORY"$'\n'
    cd $ROOT_DIRECTORY/$REPOSITORY
    docker build -t $NAMESPACE/$REPOSITORY .

    # create the latest tag
    #echo $'\n\n'"--> Aliasing $TAG as 'latest'"$'\n'
    #docker tag $NAMESPACE/$REPOSITORY:$LATEST $NAMESPACE/$REPOSITORY:latest
}

# function for publishing images
function publish_repository {
    # read repository configuration
    source $ROOT_DIRECTORY/$REPOSITORY/buildvars

    # publish all enabled versions
    for TAG in $TAGS; do
      # some verbose
      echo $'\n\n'"--> Publishing $NAMESPACE/$REPOSITORY:$TAG"$'\n'
      # publish
      docker push $NAMESPACE/$REPOSITORY:$TAG
    done

    # create the latest tag
    echo $'\n\n'"--> Publishing $NAMESPACE/$REPOSITORY:latest (from $LATEST)"$'\n'
    docker push $NAMESPACE/$REPOSITORY:latest
}

# for each enabled repository
for REPOSITORY in $REPOSITORIES; do
  # build the repository
  build_repository $REPOSITORY

  # If publishing is enabled
  if [ $PUBLISH == true ]; then
    # Push the built image
    publish_repository $REPOSITORY
  fi
done
