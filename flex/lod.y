%{

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int yylex(void);
void yyerror (char* s);
int roll(int n, int s);

%}

%define api.value.type {int}
%token NUM

%left '+' '-'
%left '*' '/'
%precedence NEG
%left 'd'

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
  : NUM               { $$ = $1;          }
  | exp '+' exp       { $$ = $1 + $3;     }
  | exp '-' exp       { $$ = $1 - $3;     }
  | exp '*' exp       { $$ = $1 * $3;     }
  | exp '/' exp       { $$ = $1 / $3;     }
  | exp 'd' exp       { $$ = roll($1,$3); }
  | '-' exp %prec NEG { $$ = -$2;         }
  | '(' exp ')'       { $$ = $2;          }
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
