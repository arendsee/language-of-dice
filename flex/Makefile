TARGET=lod
FILES=Lexer.c Parser.c

CC=gcc
CFLAGS=-lfl

${TARGET}: ${FILES}
	${CC} ${CFLAGS} ${FILES} -o ${TARGET}

Lexer.c: Lexer.l
	flex Lexer.l

Parser.c: Parser.y Lexer.c
	bison Parser.y

clean:
	rm -f *.gch *.o *~ Lexer.c Lexer.h Parser.c Parser.h ${TARGET}
