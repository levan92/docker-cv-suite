FROM nvcr.io/nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

ENV cwd="/home/"
WORKDIR $cwd

RUN apt-get -y update

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
    wget \
    gfortran \
    sudo \
    apt-transport-https \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    dbus-x11 \
    vlc \
    iputils-ping \
    python3-dev \
    python3-pip

# some image/media dependencies
RUN apt-get install -y \
    libjpeg8-dev \
    libpng-dev \
    libtiff5-dev \
    libtiff-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libdc1394-22-dev \
    libxine2-dev

# dependencies for FFMPEG build
RUN apt-get install -y libchromaprint1 libchromaprint-dev frei0r-plugins-dev gnutls-bin ladspa-sdk libavc1394-0 libavc1394-dev libiec61883-0 libiec61883-dev libass-dev libbluray-dev libbs2b-dev libcaca-dev libgme-dev libgsm1-dev libmysofa-dev libopenmpt-dev libopus-dev libpulse-dev librsvg2-dev librubberband-dev libshine-dev libsnappy-dev libsoxr-dev libspeex-dev libtwolame-dev libvpx-dev libwavpack-dev libwebp-dev libx265-dev libx264-dev libzmq3-dev libzvbi-dev libopenal-dev libomxil-bellagio-dev libcdio-dev libcdio-paranoia-dev libsdl2-dev libmp3lame-dev libssh-dev libtheora-dev libxvidcore-dev

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

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata python3-tk
ENV TZ=Asia/Singapore
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get clean && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* && apt-get -y autoremove

### APT END ###

RUN pip3 install --no-cache-dir --upgrade pip 

RUN pip3 install --no-cache-dir \
    setuptools==41.0.0 \
    protobuf==3.13.0 \
    numpy==1.15.4 \
    cryptography==2.3

RUN pip3 install --no-cache-dir --ignore-installed pyxdg==0.26

RUN pip3 install --no-cache-dir jupyter==1.0.0
RUN echo 'alias jup="jupyter notebook --allow-root --no-browser"' >> ~/.bashrc

RUN pip3 install --no-cache-dir \
    GPUtil==1.4.0 \
    tqdm==4.50.0 \
    requests==2.24.0 \
    python-dotenv==0.14.0

RUN pip3 install --no-cache-dir  \
    scipy==1.0.1 \
    matplotlib==3.3.2 \
    Pillow==7.1.2 \
    scikit-image==0.17.2 \
    scikit-learn==0.23.2 \
    pandas==1.1.2 \
    seaborn==0.11.0 \
    tables==3.6.1 \
    numba==0.51.2

RUN pip3 install --no-cache-dir opencv-python==4.4.0.44

RUN pip3 install --no-cache-dir \
    torch==1.4.0 \
    torchvision==0.5.0

RUN pip3 install --no-cache-dir \
    tensorflow==1.15.4   \
    tensorflow-gpu==1.15.4   \
    Keras==2.2.4
RUN pip3 install --no-cache-dir efficientnet

# DETECTRON2 DEPENDENCY: PYCOCOTOOLS 
RUN pip3 install --no-cache-dir cython==0.29.21
RUN git clone https://github.com/pdollar/coco
RUN cd coco/PythonAPI \
    && python3 setup.py build_ext install \
    && cd ../.. \
    && rm -r coco

# INSTALL DETECTRON2
RUN git clone https://github.com/facebookresearch/detectron2.git /detectron2
# RUN pip3 install --no-cache-dir Pillow==6.2.0
RUN cd /detectron2 &&\
    git checkout 185c27e4b4d2d4c68b5627b3765420c6d7f5a659 &&\
    python3 -m pip install -e .
# RUN rm -r detectron2

# INSTALL VLC
RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git &&\
    cd nv-codec-headers &&\
    make install &&\
    cd .. && rm -r nv-codec-headers
RUN pip3 install --no-cache-dir python-vlc

# INSTALL FFMPEG
RUN git clone https://git.ffmpeg.org/ffmpeg.git &&\
    cd ffmpeg &&\
    # git checkout n3.4.7 &&\
    git checkout n3.4.8 &&\
    ./configure --enable-cuda --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp --extra-cflags="-I/usr/local/cuda/include -I/usr/local/include" --extra-ldflags=-L/usr/local/cuda/lib64 --prefix=/usr --extra-version=0ubuntu0.2 --toolchain=hardened --libdir=/usr/lib/x86_64-linux-gnu --incdir=/usr/include/x86_64-linux-gnu --enable-gpl --disable-stripping --enable-avresample --enable-avisynth --enable-ladspa --enable-libass --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libfontconfig --enable-libfreetype --enable-libfribidi --enable-libgme --enable-libgsm --enable-libmp3lame --enable-libmysofa --enable-libopenmpt --enable-libopus --enable-libpulse --enable-librubberband --enable-librsvg --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libssh --enable-libtheora --enable-libtwolame --enable-libvorbis --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx265 --enable-libxml2 --enable-libxvid --enable-libzmq --enable-libzvbi --enable-omx --enable-openal --enable-opengl --enable-sdl2 --enable-libdc1394 --enable-libdrm --enable-libiec61883 --enable-chromaprint --enable-frei0r --enable-libx264 --enable-shared &&\
    make -j8 &&\
    make install &&\
    cd .. && rm -r ffmpeg
RUN pip3 install --no-cache-dir ffmpeg-python 

RUN pip3 install --no-cache-dir \
    hikvisionapi==0.2.1 \
    simple-pid 
