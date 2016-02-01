# ==============================================================================
# config

.PHONY: all build clean clean-all clean-links deps download link test

all: build link

export CPU_ONLY   ?= 0
export USE_CUDNN  ?= 1
export TEST_GPU   ?= 0

export CUDA_DIR   ?= /usr/local/cuda
export CUDA_ARCH  ?= -gencode arch=compute_30,code=sm_30

UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
CONFIG ?= config/OS\ X.make
BUILD_FLAGS ?= -j$(shell sysctl -n hw.ncpu)
else ifeq ($(UNAME), Linux)
CONFIG ?= config/Linux.make
BUILD_FLAGS ?= -j$(shell nproc)
endif

COMMIT            ?= master
GITHUB_REPO       ?= BVLC/caffe

GIT_REMOTE        ?= https://github.com/$(GITHUB_REPO).git
VERSION_DIR       ?= versions/$(GITHUB_REPO)/$(COMMIT)

BREW_DEPS         ?= glog gflags hdf5 lmdb leveldb szip snappy python numpy opencv
BREW_INSTALL_ARGS ?= --fresh -vd

# ==============================================================================
# phony targets

build: $(VERSION_DIR)/distribute

clean: clean-links
	@- rm -rf $(VERSION_DIR)

clean-all: clean-links
	@- rm -rf versions/*

clean-links:
	@- rm -f bin lib include python

deps:
ifeq ($(UNAME), Darwin)
	@- echo 'P.S. - Remember to run `brew update`.'
	brew tap homebrew/science
	brew install                                   $(BREW_ARGS) $(BREW_DEPS)
	brew install --build-from-source --with-python $(BREW_ARGS) protobuf
	brew install --build-from-source               $(BREW_ARGS) boost boost-python
	brew cask install cuda
else
	@- echo 'Only for OS X, for now.'
endif

download: $(VERSION_DIR)

install:
	# TODO

link: clean-links
	@ ln -s $(VERSION_DIR)/distribute/lib lib
	@ ln -s $(VERSION_DIR)/distribute/bin bin
	@ ln -s $(VERSION_DIR)/distribute/include include
	@ ln -s $(VERSION_DIR)/distribute/python python
	@ ln -fs $(CUDA_DIR)/lib/libcudart.dylib lib/libcudart.dylib
	@- echo 'Using caffe at $(VERSION_DIR)'

test: build
	cd $(VERSION_DIR) && $(MAKE) test $(BUILD_FLAGS)
	cd $(VERSION_DIR) && $(MAKE) runtest
	cd $(VERSION_DIR) && $(MAKE) pytest

# ==============================================================================
# file targets

$(VERSION_DIR):
	git clone $(GIT_REMOTE) $(VERSION_DIR)
	cd $(VERSION_DIR) && git checkout $(COMMIT)

$(VERSION_DIR)/Makefile.config: | $(VERSION_DIR)
	cp $(CONFIG) $(VERSION_DIR)/Makefile.config

$(VERSION_DIR)/distribute: $(VERSION_DIR)/Makefile.config
	cd $(VERSION_DIR) && $(MAKE) all $(BUILD_FLAGS)
	cd $(VERSION_DIR) && $(MAKE) pycaffe
	cd $(VERSION_DIR) && $(MAKE) distribute
	for f in $(VERSION_DIR)/distribute/bin/*.bin; do mv $$f $${f%.*}; done
