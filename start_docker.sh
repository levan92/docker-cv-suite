#!/bin/bash
export WORKSPACE=$HOME/Workspace
export DATA=/media/dh/HDD/

if [ -n "$1" ]; then
    docker_image=$1
else
    docker_image="levan92/cv-suite:latest"
fi
echo "Running" $docker_image

xhost +local:docker
docker run -it --gpus all -w $WORKSPACE -v $WORKSPACE:$WORKSPACE -v $DATA:$DATA --net=host --ipc host -e DISPLAY=unix$DISPLAY  --privileged -v /dev/:/dev/ $docker_image