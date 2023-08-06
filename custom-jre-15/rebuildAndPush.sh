#!/bin/bash

# Example local: ./rebuildAndPush localhost:5000 apps-template latest
# Example production: ./rebuildAndPush 1234567890123.ecr.us-west-2.amazonaws.com apps-template 1.2

REGISTRY=$1
SERVICE=${PWD##*/}
NAMESPACE=$2
VERSION=$3

# delete existing containers/images on local docker registry.
if echo "$1" | grep -q "localhost:"; then
  docker rmi $(docker images -qa $REGISTRY'/'$NAMESPACE'-'$SERVICE)
  echo ">>> Existing Images/Containers Deleted"
fi

docker build --no-cache -t $REGISTRY'/'$NAMESPACE'-'$SERVICE':'$VERSION .
echo ">>> New Docker Image Built"

docker push $REGISTRY'/'$NAMESPACE'-'$SERVICE':'$VERSION
echo ">>> New Docker Image Pushed to Docker Hub"
