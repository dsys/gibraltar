# Refer to http://caffe.berkeleyvision.org/installation.html

# The following variables are set via gibraltar's Makefile:
# CPU_ONLY, CUDA_DIR, CUDA_ARCH, USE_CUDNN, TEST_GPU

CUSTOM_CXX := clang++

BUILD_DIR := build
DISTRIBUTE_DIR := distribute

# Enable pretty builds.
Q ?= @

# Use OpenBLAS because OS X's Accelerate Framework is buggy.
BLAS ?= atlas

# Use homebrew's python and numpy.
WITH_PYTHON_LAYER := 1
PYTHON_INCLUDE := $(shell brew --prefix python)/Frameworks/Python.framework/Versions/2.7/include/python2.7/ \
	$(shell brew --prefix numpy)/lib/python2.7/site-packages/numpy/core/include
PYTHON_LIB := $(shell brew --prefix python)/Frameworks/Python.framework/Versions/2.7/lib

# Whatever else you find you need goes here.
INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include
LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib
