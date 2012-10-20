all: build $(patsubst %.coffee,build/%.js,$(shell echo *.coffee))

build/%.js:: %.coffee
	coffee -bc -o build $<

.PHONY: init clean

clean:
	rm -rf build

build:
	mkdir -p build
