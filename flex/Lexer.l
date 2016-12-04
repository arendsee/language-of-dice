%{
    #include "Parser.h"
%}

%option outfile="Lexer.c" header-file="Lexer.h"

%x number

num [1-9][0-9]*
spc [ \t]
eol \n
die d

%%

{num}         { BEGIN(number); sscanf(yytext, "%d", &yylval); return NUM; }
<number>{spc} { BEGIN(INITIAL); }
<number>{eol} { BEGIN(INITIAL); }
<number>{die} { BEGIN(INITIAL); return DIE; }
