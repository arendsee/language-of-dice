TARGET=lod

all:
	flex lod.l
	bison -d ${TARGET}.y
	gcc -lfl lex.yy.c lod.tab.c -o lod

.PHONY: clean
clean:
	rm -f lex.yy.* lod.tab.* *.gch lod a.out
