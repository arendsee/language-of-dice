Language of Dice
================

## Goals

 * complex events can be built up from simple events

 * can succinctly express concepts such as advantage and disadvantage

 * can easily get the expected outcomes

 * can easily get the distribution of a complex event

 * calculations of distributions and expectations as abstracted away from the
   user (the are in the purview of the interpreter)

## Examples

```
# executing this will return a single result
dc    = 15          # assign a constant value
dmg  := 1d6 + 3     # assign to a random variable (each usage rolls a die)
crit := dmg + dmg   # assign to an event
1d20
    (. == 20) crit  # the '.' carries the value of the initial event
    (. >  dc) dmg
# every event yields 0 by default
```


```
dmg  := 1d6 + 3
crit := dmg + dmg
hp = 100
turns = 0
while hp > 0
    turns += 1 
    1d20
        (. == 20) {hp -= crit}
        (. > dc)  {hp -= dmg}
done
# yield is necessary when the value returned by the last event is not the value of interest
yield turns
```

Precedence
==========

Level | operators
----- | ---------
1     | ( ) { }
2     | \+ \-
3     | / \* %
4     | < <= \> \>=
5     | == !=
6     | and or
7     | = := \*= += -= /= %=

Tokens
======

```
LAST_RESULT := '.'

L_RPAR   :=  '('
R_RPAR   :=  ')'
L_CPAR   :=  '{'
R_CPAR   :=  '}'
QUOTE    :=  '\''

INT      :=  [1-9][0-9]*
DICE     :=  [1-9][0-9]*d[1-9][0-9]*
BOOL     :=  true | false

INCR     :=  '++'
DECR     :=  '--'

ADD    :=  '+'
SUB    :=  '-'
DIV    :=  '/'
MUL    :=  '*'
MOD    :=  '%'

VAR      :=  [A-Za-z_][A-Za-z0-9_]*

DEC_CON  :=  '=' 
DEC_RAN  :=  ':='

ASSIGN_ADD    :=  '+='
ASSIGN_SUB    :=  '-='
ASSIGN_DIV    :=  '/='
ASSIGN_MUL    :=  '*='
ASSIGN_MOD    :=  '%='

GT     :=  '>'
LT     :=  '<'
EQ     :=  '=='
NE     :=  '!='
GE     :=  '>='
LE     :=  '<='

WHILE    :=  while
DONE     :=  done
BREAK    :=  break
CONTINUE :=  continue
AND      :=  and
NOT      :=  not
YIELD    :=  yield
```


Structures
==========

```
ARITHMETIC_OPERATOR := [+-/*%]
COMPARISON_OPERATOR := [=!]=|[><][=]?
ASSIGNMENT_OPERATOR := ARITHMETIC_OPERATOR?=

INT     := [0-9]+
DICE    := [0-9]*d[0-9]+
BOOL    := true | false
VARNAME := [A-Za-z_][\w]+
            
PRIMATIVE   := INT | DICE | BOOL
NUMERIC     := INT | DICE
EXPRESSION  := NUMERIC ARITHMETIC_OPERATOR EXPRESSION | NUMERIC 
CONDITION   := EXPRESSION COMPARISON_OPERATOR EXPRESSION | BOOL
DECLARATION := VARNAME = EXPRESSION
EVENT       := EVENT [CONDITION EVENT]+
```
