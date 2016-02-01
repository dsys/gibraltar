## Refer to http://caffe.berkeleyvision.org/installation.html

# The following variables are set via gibraltar's Makefile:
# CPU_ONLY, CUDA_DIR, CUDA_ARCH, USE_CUDNN, TEST_GPU

CUSTOM_CXX := clang++

BUILD_DIR := build
DISTRIBUTE_DIR := distribute

# Enable pretty builds.
Q ?= @

# Use Atlas by default.
BLAS ?= atlas

# We need to be able to find Python.h and numpy/arrayobject.h.
WITH_PYTHON_LAYER := 1
PYTHON_INCLUDE := /usr/include/python2.7 \
/usr/local/lib/python2.7/dist-packages/numpy/core/include/ \
		/usr/lib/python2.7/dist-packages/numpy/core/include
PYTHON_LIB := /usr/lib

# Whatever else you find you need goes here.
INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include
LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib
