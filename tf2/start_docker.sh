xhost +local:docker
docker run -it --gpus all -v $HOME/Workspace:$HOME/Workspace -v /media/dh/HDD/:/media/dh/HDD  --net=host --ipc host -e DISPLAY=unix$DISPLAY  --privileged -v /dev/:/dev/ tf2.2
