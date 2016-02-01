# Refer to http://caffe.berkeleyvision.org/installation.html

# USE_CUDNN := 1
# CPU_ONLY := 1

# To customize your choice of compiler, uncomment and set the following.
# The default for Linux is g++ and the default for OSX is clang++.
CUSTOM_CXX := clang++

# CUDA directory contains bin/ and lib/ directories that we need.
# CUDA_DIR := /usr/local/cuda

# CUDA architecture setting: going with all of them.
# CUDA_ARCH := -gencode arch=compute_30,code=sm_30

# BLAS choices: atlas, mkl, open
BLAS := open
BLAS_INCLUDE := /usr/local/opt/openblas/include
BLAS_LIB := /usr/local/opt/openblas/lib

# We need to be able to find Python.h and numpy/arrayobject.h.
WITH_PYTHON_LAYER := 1
PYTHON_INCLUDE := /usr/local/Cellar/python/2.7.10_2/Frameworks/Python.framework/Versions/2.7/include/ \
	/usr/local/Cellar/python/2.7.10_2/Frameworks/Python.framework/Versions/2.7/include/python2.7/ \
	/usr/local/Cellar/numpy/1.10.1/lib/python2.7/site-packages/numpy/core/include
PYTHON_LIB := /usr/local/Cellar/python/2.7.10_2/Frameworks/Python.framework/Versions/2.7/lib

# Whatever else you find you need goes here.
INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include
LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib

BUILD_DIR := build
DISTRIBUTE_DIR := distribute

# The ID of the GPU that 'make runtest' will use to run unit tests.
TEST_GPUID := 0

# enable pretty build (comment to see full commands)
Q ?= @
