TAGS := bvlc faster-rcnn

.PHONY: all build $(TAGS)

all: build

build: $(TAGS)

$(TAGS):
	cd $@ && docker build -t pavlov/caffe-$@ .
