# In this docker

- Ubuntu 18.04
- CUDA 10.0
- cuDNN 7.0
- TensorRT 7.0 (.deb)
- cv2 (opencv-python==4.4.0.44 from pypi)
- PyTorch 1.4.0 (pypi package)
- TensorFlow-gpu 1.15.4 (pypi package)
- Keras 2.2.4 (pypi package)
- Detectron2 (built from source)
- VLC (built from source)
- FFmpeg (built from source with cuda support)
- .. and many more (see Dockerfile for details)

## Installation

### Pull from dockerhub

`docker pull levan92/cv-suite:latest`

### Build from Dockerfile

- Before building, download TensorRT 7 deb file `nv-tensorrt-repo-ubuntu1804-cuda10.0-trt7.0.0.11-ga-20191216_1-1_amd64.deb` from https://developer.nvidia.com/nvidia-tensorrt-download first
`docker build -t cv-suite .`
  - Else, just comment away the lines for Trt installation.
- Run `build.docker.sh`

## Run

Edit environment variables in `start_docker.sh` and run it.

### Using Jupyter

A `jup` alias has been set up in the docker. Running `jup` in the docker container will start a Jupyter session. Copy the link in **full** into your browser on host to interact with the Jupyter session.
