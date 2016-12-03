%{
    enum yytokentype { NUM = 0 };
%}

%x number

num [1-9][0-9]*
spc [ \t]
eol \n
die d

%%

{num}         BEGIN(number); return NUM;
<number>{spc} BEGIN(INITIAL);
<number>{eol} BEGIN(INITIAL);
<number>{die} BEGIN(INITIAL);
