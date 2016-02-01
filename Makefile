# ==============================================================================
# config

.PHONY: all build download gen-sh link-makefile link-version test deps

all: link-makefile build link-version gen-sh

BUILD_FLAGS       ?= -j8
COMMIT            ?= 4115385deb3b907fcd428ac0ab53b694d741a3c4
CONFIG            ?= OS\ X
CUDA_DIR          ?= /usr/local/cuda
REPOSITORY        ?= https://github.com/rbgirshick/caffe-fast-rcnn.git

BREW_DEPS         ?= openblas glog gflags hdf5 lmdb leveldb szip snappy numpy opencv
BREW_INSTALL_ARGS ?= --fresh -vd

# ==============================================================================
# phony targets

build: versions/$(COMMIT)/distribute

download: versions/$(COMMIT)

gen-sh:
	@- rm -f env.sh
	$(MAKE) env.sh

link-makefile:
	@- rm -f config/current
	$(MAKE) config/current

link-version:
	@- rm -f versions/current
	$(MAKE) versions/current

link-cuda:
	@- mkdir -p lib
	@- rm -f lib/libcudart.dylib
	@- ln -s $(CUDA_DIR)/libcudart.dylib lib/libcudart.dylib

test: build
	cd versions/$(COMMIT) && $(MAKE) test $(BUILD_FLAGS)
	cd versions/$(COMMIT) && $(MAKE) runtest
	cd versions/$(COMMIT) && $(MAKE) pytest

deps:
	@- echo 'P.S. - Remember to run `brew update`.'
	brew install                                   $(BREW_ARGS) $(BREW_DEPS)
	brew install --build-from-source --with-python $(BREW_ARGS) protobuf
	brew install --build-from-source               $(BREW_ARGS) boost boost-python
	brew cask install cuda

# ==============================================================================
# file targets

config/current:
	@- ln -s $(CONFIG).make config/current
	@- echo "Using config $(CONFIG)"

versions/current:
	@- ln -s versions/$(COMMIT)/distribute current
	@- echo "Using commit $(COMMIT) from $(REPOSITORY)"

versions/$(COMMIT):
	git clone $(REPOSITORY) versions/$(COMMIT)
	cd versions/$(COMMIT) && git checkout $(COMMIT)

versions/$(COMMIT)/distribute: versions/$(COMMIT)
	ln -s ../../config/current versions/$(COMMIT)/Makefile.config
	cd versions/$(COMMIT) && $(MAKE) all $(BUILD_FLAGS)
	cd versions/$(COMMIT) && $(MAKE) pycaffe
	cd versions/$(COMMIT) && $(MAKE) distribute
	for f in versions/$(COMMIT)/distribute/bin/*.bin; do mv $$f $${f%.*}; done
