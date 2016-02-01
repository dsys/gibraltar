## Refer to http://caffe.berkeleyvision.org/installation.html

# The following variables are set via Gibraltar's Makefile:
# BLAS_DIR, CPU_ONLY, CUDA_DIR, CUDA_ARCH, USE_CUDNN

CUSTOM_CXX := g++

BLAS := atlas

# We need to be able to find Python.h and numpy/arrayobject.h.
WITH_PYTHON_LAYER := 1
PYTHON_INCLUDE := /usr/include/python2.7 \
/usr/local/lib/python2.7/dist-packages/numpy/core/include/ \
		/usr/lib/python2.7/dist-packages/numpy/core/include
PYTHON_LIB := /usr/lib

# Whatever else you find you need goes here.
INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include
LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib

BUILD_DIR := build
DISTRIBUTE_DIR := distribute

# The ID of the GPU that 'make runtest' will use to run unit tests.
TEST_GPUID := 0

# enable pretty build (comment to see full commands)
Q ?= @
