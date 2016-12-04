%{

#define YYSTYPE int
int yylex(void);
void yyerror (char* s);
#include <ctype.h>
#include <stdio.h>

%}

%token NUM

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
  : NUM             { $$ = $1;      }
  | exp exp '+'     { $$ = $1 + $2; }
  | exp exp '-'     { $$ = $1 - $2; }
  | exp exp '*'     { $$ = $1 * $2; }
  | exp exp '/'     { $$ = $1 / $2; }
;

%%

int yylex(){
  int c;
  /* skip white space  */
  while ((c = getchar()) == ' ' || c == '\t')
    ;
  /* process numbers   */
  if (isdigit (c))
    {
      ungetc (c, stdin);
      scanf ("%d", &yylval);
      return NUM;
    }
  /* return end-of-file  */
  if (c == EOF)
    return 0;
  /* return single chars */
  return c;
}

void yyerror (char* s){
  printf ("%s\n", s);
}

int main (void){
  yyparse ();
}
