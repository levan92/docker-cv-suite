# FROM nvcr.io/nvidia/tensorflow:18.06-py3
# FROM nvcr.io/nvidia/tensorflow:18.10-py3
# FROM nvcr.io/nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
FROM nvcr.io/nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

ENV cwd="/home/"
WORKDIR $cwd

RUN apt-get -y update
# RUN apt-get -y upgrade

RUN apt-get install -y \
    software-properties-common \
    build-essential \
    checkinstall \
    cmake \
    pkg-config \
    yasm \
    git \
    vim \
    curl \
    gfortran \
    libjpeg8-dev \
    libpng-dev \
    libtiff5-dev \
    libtiff-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libdc1394-22-dev \
    libxine2-dev \
    sudo \
    apt-transport-https \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    dbus-x11 \
    vlc \
    iputils-ping \
    python3-dev \
    python3-pip

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

# INSTALL BAZEL
RUN curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
RUN echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
RUN apt update && apt install -y bazel

RUN apt-get clean && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* && apt-get -y autoremove

### APT END ###

RUN pip3 install --no-cache-dir --upgrade pip 

# INSTALL VLC
RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git &&\
    cd nv-codec-headers &&\
    make install &&\
    cd .. && rm -r nv-codec-headers
RUN pip3 install --no-cache-dir python-vlc

# INSTALL FFMPEG
RUN git clone https://git.ffmpeg.org/ffmpeg.git &&\
    cd ffmpeg &&\
    git checkout n3.4.7 &&\
    ./configure --enable-cuda --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 &&\
    make -j8 &&\
    make install &&\
    cd .. && rm -r ffmpeg
RUN pip3 install --no-cache-dir ffmpeg-python 

RUN pip3 install --no-cache-dir \
    numpy==1.15.3 \
    hikvisionapi==0.2.1 \
    simple-pid \
    GPUtil \
    tqdm \
    requests \
    protobuf

RUN pip3 install --no-cache-dir  \
    scipy==1.0.0 \
    matplotlib \
    Pillow==5.3.0 \
    opencv-python
RUN pip3 install --no-cache-dir \
    # tensorflow==1.9.0 \
    # tensorflow-gpu==1.9.0 \
    # Keras==2.2.4 \
    torch==1.3.0 \
    torchvision==0.4.1

# ENV PYTHON_BIN_PATH="/usr/bin/python3" \
#     USE_DEFAULT_PYTHON_LIB_PATH=1 \
#     TF_NEED_JEMALLOC=1 \
#     TF_NEED_GCP=0 \
#     TF_NEED_HDFS=0 \
#     TF_NEED_S3=0 \
#     TF_NEED_KAFKA=0 \
#     TF_ENABLE_XLA=0 \
#     TF_NEED_GDR=0 \
#     TF_NEED_OPENCL_SYCL=0 \
#     TF_NEED_CUDA=1 \
#     TF_CUDA_VERSION=10.0 \
#     CUDA_TOOLKIT_PATH=/usr/local/cuda \
#     TF_CUDNN_VERSION=7.0 \
#     CUDNN_INSTALL_PATH=/usr/loca/cuda \
#     TF_NEED_TENSORRT=1 \
#     TENSORRT_INSTALL_PATH=/usr/lib/x86_64-linux-gnu

