# In this docker
- Ubuntu 18.04
- CUDA 10.0
- cuDNN 7.0
- TensorRT 7.0 (.deb)
- cv2 (pypi package)
- PyTorch 1.3.0 (pypi package)
- TensorFlow-gpu 1.13.1 (pypi package)
- Keras 2.2.4 (pypi package)
- Detectron2 (built from source)
- VLC (built from source)
- FFmpeg (built from source with cuda support)
- .. and many more (see Dockerfile for details)

## Pull from dockerhub
`docker pull levan92/cv-suite:latest`

## Build from Dockerfile
- Before building, download TensorRT 7 deb file `nv-tensorrt-repo-ubuntu1804-cuda10.0-trt7.0.0.11-ga-20191216_1-1_amd64.deb` from https://developer.nvidia.com/nvidia-tensorrt-download first
`docker build -t cv-suite .`