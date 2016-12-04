%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "Parser.h"
    #include "Lexer.h"
    int yylex(void);
    void yyerror(const char *);
    int roll (int s, int n);
%}

%output "Parser.c"
%defines "Parser.h"

%define api.value.type {int}

%token NUM
%left '+' '-'
%left '*' '/'
%left DIE

%%

input
  : %empty
  | input line
;

line
  : '\n'
  | exp '\n' { fprintf(stdout, "%d\n", $1); }
;

exp
  : NUM         { $$ = $1; }
  | exp '+' exp { $$ = $1 + $3; }
  | exp '-' exp { $$ = $1 - $3; }
  | exp '*' exp { $$ = $1 * $3; }
  | exp '/' exp { $$ = $1 / $3; }
  | exp DIE exp { $$ = roll($1, $3); }
;

%%

int roll (int s, int n){
    int sum = 0;
    for (int i = 0; i < n; ++i) {
        sum += (rand() % s) + 1;
    }
    return sum;
}

void yyerror(char const *s){
    fprintf(stderr, "Awww fuck! Got an errror: %s\n", s);
}

int main(void){
    return yyparse();
}
