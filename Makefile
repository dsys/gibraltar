# ==============================================================================
# config

.PHONY: default build download test use

default: use

BUILD_FLAGS ?= -j8
COMMIT ?= 4115385deb3b907fcd428ac0ab53b694d741a3c4
CONFIG ?= config/OS\ X.make # OS X only, for now.
CUDA_DIR ?= /usr/local/cuda
REPOSITORY ?= https://github.com/rbgirshick/caffe-fast-rcnn.git

# ==============================================================================
# phony targets

build: versions/$(COMMIT)/distribute

download: versions/$(COMMIT)

test: build
	cd versions/$(COMMIT) && $(MAKE) test $(BUILD_FLAGS)
	cd versions/$(COMMIT) && $(MAKE) runtest
	cd versions/$(COMMIT) && $(MAKE) pytest

use: build
	@- rm -f current
	@- ln -s versions/$(COMMIT)/distribute current
	@- echo "Using commit $(COMMIT) from $(REPOSITORY)"

# ==============================================================================
# file targets

versions/$(COMMIT):
	git clone $(REPOSITORY) versions/$(COMMIT)
	cd versions/$(COMMIT) && git checkout $(COMMIT)

versions/$(COMMIT)/distribute: versions/$(COMMIT)
	cp $(CONFIG) versions/$(COMMIT)/Makefile.config
	cd versions/$(COMMIT) && $(MAKE) all $(BUILD_FLAGS)
	cd versions/$(COMMIT) && $(MAKE) pycaffe
	cd versions/$(COMMIT) && $(MAKE) distribute
	for f in versions/$(COMMIT)/distribute/bin/*.bin; do \
		install_name_tool -add_rpath $(CUDA_DIR)/lib $$f; \
		mv $$f $${f%.*}; \
	done
	install_name_tool -add_rpath versions/$(COMMIT)/distribute/lib versions/$(COMMIT)/distribute/python/caffe/_caffe.so
