ROLL     [1-9][0-9]*d[1-9][0-9]*
NUM      [1-9][0-9]*
PLUS     "+"
DIST     "~"
STRING   [a-zA-Z][a-zA-Z0-9]*


%%

{ROLL}   { printf("ROLL"); }

{NUM}    { printf("NUM"); }

{PLUS}   { printf("PLUS"); }

{DIST}   { printf("DIST"); }

{STRING} { printf("STRING"); }
