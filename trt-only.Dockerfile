FROM nvcr.io/nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

# INSTALL TENSORRT
ARG TENSORRT=nv-tensorrt-repo-ubuntu1804-cuda10.0-trt7.0.0.11-ga-20191216_1-1_amd64.deb
# From Tensort installation instructions
ARG TENSORRT_KEY=/var/nv-tensorrt-repo-cuda10.0-trt7.0.0.11-ga-20191216/7fa2af80.pub
# custom Tensorrt Installation
ADD $TENSORRT /tmp
# Rename the ML repo to something else so apt doesn't see it
RUN mv /etc/apt/sources.list.d/nvidia-ml.list /etc/apt/sources.list.d/nvidia-ml.list.bkp && \
    dpkg -i /tmp/$TENSORRT && \
    apt-key add $TENSORRT_KEY && \
    apt-get update && \
    apt-get install -y tensorrt
RUN apt-get install -y python3-libnvinfer-dev uff-converter-tf
