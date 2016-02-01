# ==============================================================================
# config

.PHONY: all build download link test deps

all: build link

export CPU_ONLY     ?= 0
export USE_CUDNN    ?= 1

export BLAS_DIR     ?= /usr/local/opt/openblas
export BLAS_INCLUDE ?= $(BLAS_DIR)/include
export BLAS_LIB     ?= $(BLAS_DIR)/lib

export CUDA_DIR     ?= /usr/local/cuda
export CUDA_ARCH    ?= -gencode arch=compute_30,code=sm_30

BUILD_FLAGS         ?= -j8
COMMIT              ?= master
CONFIG              ?= OS\ X
GITHUB_REPO         ?= BVLC/caffe

GIT_REMOTE          ?= https://github.com/$(GITHUB_REPO).git
VERSION_DIR         ?= versions/$(GITHUB_REPO)/$(COMMIT)

BREW_DEPS           ?= openblas glog gflags hdf5 lmdb leveldb szip snappy numpy opencv
BREW_INSTALL_ARGS   ?= --fresh -vd

# ==============================================================================
# phony targets

build: $(VERSION_DIR)/distribute

download: $(VERSION_DIR)

link:
	rm -f bin lib include python
	ln -s $(VERSION_DIR)/distribute/lib lib
	ln -s $(VERSION_DIR)/distribute/bin bin
	ln -s $(VERSION_DIR)/distribute/include include
	ln -s $(VERSION_DIR)/distribute/python python
	ln -fs $(CUDA_DIR)/lib/libcudart.dylib lib/libcudart.dylib

test: build
	cd $(VERSION_DIR) && $(MAKE) test $(BUILD_FLAGS)
	cd $(VERSION_DIR) && $(MAKE) runtest
	cd $(VERSION_DIR) && $(MAKE) pytest

# OS X only, for now
deps:
	@- echo 'P.S. - Remember to run `brew update`.'
	brew install                                   $(BREW_ARGS) $(BREW_DEPS)
	brew install --build-from-source --with-python $(BREW_ARGS) protobuf
	brew install --build-from-source               $(BREW_ARGS) boost boost-python
	brew cask install cuda

# ==============================================================================
# file targets

$(VERSION_DIR):
	git clone $(GIT_REMOTE) $(VERSION_DIR)
	cd $(VERSION_DIR) && git checkout $(COMMIT)

$(VERSION_DIR)/distribute: $(VERSION_DIR)
	cp config/$(CONFIG).make $(VERSION_DIR)/Makefile.config
	cd $(VERSION_DIR) && $(MAKE) all $(BUILD_FLAGS)
	cd $(VERSION_DIR) && $(MAKE) pycaffe
	cd $(VERSION_DIR) && $(MAKE) distribute
	for f in $(VERSION_DIR)/distribute/bin/*.bin; do mv $$f $${f%.*}; done
