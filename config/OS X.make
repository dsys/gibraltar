# Refer to http://caffe.berkeleyvision.org/installation.html

# The following variables are set via Gibraltar's Makefile:
# BLAS_DIR, CPU_ONLY, CUDA_DIR, CUDA_ARCH, USE_CUDNN

CUSTOM_CXX := clang++

# Use OpenBLAS because OS X's Accelerate.framework is buggy.
BLAS := open
BLAS_INCLUDE := $(BLAS_DIR)/include
BLAS_LIB := $(BLAS_DIR)/lib

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
