# This Makefile assumes you have Bikeshed and DocToc installed.
#
# Bikeshed can be installed with pip:
#
#     pip3 install bikeshed && bikeshed update
#
# DocToc can be installed via NPM:
#
#     npm install -g doctoc

specs   = $(patsubst %.bs,build/%.html,$(wildcard *.bs))

.PHONY: all clean
.SUFFIXES: .bs .html

all: $(specs) update-explainer-toc

update-explainer-toc:
	doctoc README.md --title "## Table of Contents" > /dev/null

clean:
	rm -rf build *~

build:
	mkdir -p build

build/%.html: %.bs Makefile build
	bikeshed --die-on=warning spec $< $@
