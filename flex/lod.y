%{
    #include <stdio.h>
    #include <stdlib.h>
    void yyerror (char const *);
    int roll (int s, int n);
%}

%define api.value.type {int}

%token NUM
%left '+' '-'
%left '*' '/'
%left DIE

%%

input: input line;

line:
      '\n'
    | exp '\n' { printf("%d\n", $1); }
;

exp:
    NUM         { $$ = $1; }
  | NUM DIE NUM { $$ = roll($1, $2); }
  | exp '+' exp { $$ = $1 + $2; }
  | exp '-' exp { $$ = $1 - $2; }
  | exp '*' exp { $$ = $1 * $2; }
  | exp '/' exp { $$ = $1 / $2; }
;

%%

int roll (int s, int n){
    int sum = 0
    for (i = 0; i < $1; ++i) {
        sum += (rand() % $2) + 1;
    }
    return sum;
}

void yyerror(char const *s){
    fprintf(stderr, "%s\n", s);
}

int main(void){
    return yyparse();
}
