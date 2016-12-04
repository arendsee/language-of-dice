TARGET=lod

all:
	bison -d ${TARGET}.y
	gcc lod.tab.c lod.tab.h -o lod

.PHONY: clean
clean:
	rm -f lod.tab.c lod.tab.h *.gch lod 
