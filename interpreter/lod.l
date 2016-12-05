%{
    #include "lod.tab.h"
%}

%option outfile="lex.yy.c" header-file="lex.yy.h"

%option noyywrap

num [1-9][0-9]*
ws  [ \t]*
eol [\r\n]+

add  "+"
sub  "-"
mul  "*"
div  "/" 
rll  "d"  
lpar "(" 
rpar ")" 

%%

{ws}    { }
{num}   { sscanf(yytext, "%d", &yylval); return NUM; } /* printf("|%d|", yylval); */
{add}   { return ADD;  }
{sub}   { return SUB;  }
{mul}   { return MUL;  }
{div}   { return DIV;  }
{rll}   { return RLL;  }
{eol}   { return EOL;  }
{lpar}  { return LPAR; }
{rpar}  { return RPAR; }
