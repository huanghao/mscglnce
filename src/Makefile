all: $(patsubst %.coffee,build/%.js,$(shell echo *.coffee))

build/%.js:: %.coffee
	coffee -bc -o build $<