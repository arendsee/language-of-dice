%{

int yylex(void);
void yyerror (char* s);
#include <ctype.h>
#include <stdio.h>

%}

%define api.value.type {int}
%token NUM

%left '+' '-'
%left '*' '/'
%precedence NEG

%%

input
  : %empty
  | input line
;

line
  : '\n'
  | exp '\n'  { printf ("%d\n", $1); }
;

exp
  : NUM               { $$ = $1;      }
  | exp '+' exp       { $$ = $1 + $3; }
  | exp '-' exp       { $$ = $1 - $3; }
  | exp '*' exp       { $$ = $1 * $3; }
  | exp '/' exp       { $$ = $1 / $3; }
  | '-' exp %prec NEG { $$ = -$2;     }
  | '(' exp ')'       { $$ = $2;      }
;

%%

int yylex(){
  int c;
  while ((c = getchar()) == ' ' || c == '\t') ;
  if (isdigit (c)) {
    ungetc (c, stdin);
    scanf ("%d", &yylval);
    c = NUM;
  }
  if (c == EOF){
    c = 0;
  }
  return c;
}

void yyerror (char* s){
  printf ("%s\n", s);
}

int main (void){
  yyparse ();
}
