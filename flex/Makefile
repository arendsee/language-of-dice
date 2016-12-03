TARGET=lod

all:
	bison -d lod.y
	flex lod.l
	cc -o ${TARGET} lod.tab.c lex.yy.c -lfl

.PHONY: clean
clean:
	rm -f lex.yy.c ${TARGET}
