%{

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "lod.tab.h"
#include "lex.yy.h"

int yylex(void);
void yyerror (char* s);
int roll(int n, int s);

%}

%define api.value.type {int}
%token NUM LPAR RPAR EOL

%left ADD SUB
%left MUL DIV
%left RLL

%%

input
  : %empty
  | input line
;

line
  : EOL
  | exp EOL  { printf ("%d\n", $1); }
;

exp
  : NUM               { $$ = $1;          }
  | exp ADD exp       { $$ = $1 + $3;     }
  | exp SUB exp       { $$ = $1 - $3;     }
  | exp MUL exp       { $$ = $1 * $3;     }
  | exp DIV exp       { $$ = $1 / $3;     }
  | exp RLL exp       { $$ = roll($1,$3); }
  | LPAR exp RPAR     { $$ = $2;          }
;

%%

int roll(int n, int s){
    int sum = 0;
    for(int i = 1; i <= n; i++){
        sum += rand() % s + 1; 
    }
    return sum;
}

void yyerror (char* s){
  printf ("%s\n", s);
}

int main (void){
  srand(time(NULL));
  yyparse();
}
