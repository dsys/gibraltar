FROM nvidia/cuda:7.0-cudnn4-devel
MAINTAINER Alex Kern <alex@pavlovml.com>

ENV CAFFE_GIT_REMOTE https://github.com/BVLC/caffe.git
ENV CAFFE_GIT_COMMIT master
ENV PATH /usr/local/caffe/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/caffe/lib:$LD_LIBRARY_PATH
ENV PYTHONPATH /usr/local/caffe/python:$PYTHONPATH

RUN apt-get update && \
    apt-get install -y \
      git make g++ libhdf5-serial-dev protobuf-compiler libgflags-dev \
      libgoogle-glog-dev libprotobuf-dev libleveldb-dev libsnappy-dev \
      libopencv-dev liblmdb-dev libatlas-base-dev gfortran && \
    apt-get install -y --no-install-recommends libboost-all-dev && \
    apt-get install -y python-dev python-pip python-numpy python-scipy && \
      python-opencv cython libboost-python-dev && \
    git clone $CAFFE_GIT_REMOTE caffe && \
    cd caffe && \
    git checkout $CAFFE_GIT_COMMIT

COPY Makefile.config caffe/Makefile.config

RUN cd caffe && \
    make all -j$(nproc) && \
    pip install --upgrade -r python/requirements.txt && \
    make pycaffe distribute && \
    mv distribute /usr/local/caffe && \
    cd /usr/local/caffe && \
    mv bin/caffe.bin bin/caffe && \
    for f in bin/*.bin; do mv $f bin/caffe_$(basename $f .bin); done && \
    rm -rf /caffe /var/lib/apt/lists/*
