Language of Dice
================

## Goals

 * succinctly express simple, discrete probability events

 * build complex events from simple events

 * easily calculate distributions of outcomes for complex events

 * abstract the math away from the user

## Language description

lod is a grammar for describing random events. A lod script describes a single
event that yields a single outcome. Every time the executable is called, a
random value is emitted.

## Language usage

The simplest use of the lod language is to simulate outcomes for immediate
consumption (if you like to eat outcomes). Of course, if you are interested in
the statistical distribution of outcomes, you can simulate an enormous number
of outcomes and then analyze them with the tools of your choice. You might want
to tweak the compiler to simulate many outcomes every time the executable is
called, this will be faster than simply called the executable many times.

## Compiler

I will not attempt to implement a good compiler. Rather I am interested in a
merely functional one. My main interest is developing the syntax and semantics
of the language itself.

There are several fancy optimizations that can be added to the compiler.
Mainly, the distribution of many events can be solved exactly. Since lod deals
exclusively with discrete outcomes, an event can be expressed exactly as a
probability vector, which will require infinite memory only in occasional
cases. This compiler optimization step will require a decent mathematician.

## Language Overview

### Hello World

A lod script yields as its outcome the value of the final expression:

```
'Hello World'
```

lod makes no distinction between single and double quotes.

### Declaring variables and arithmetic

All of this is pretty standard except that all numbers are integers in lod.

```
x = 5 + 2
y = x + 5
```

All division is integer division

```
5 / 2  # yields 2
```

All the arithmetic operators can be used with '='
```
x = 7
x /= 2  # x becomes 3 
```

### Dice

As the name 'Language of Dice' implies, dice are important in lod and have
their own builtin syntax, which follows DnD conventions, e.g.

```
4d6  # yields the sum of 4 rolled 6-sided dice
```

A dice roll will sum the rolled dice when appropriate. However the rolls are
internally a vector. So you can say

```
min(4d6)  # yield the lowest of 4, 6-sided dice
```

### Random and non-random variables

There are two types of variables in lod, random and non-random. A non-random
variable is exactly like variables in any other programming language. A random
variable, however, is yields random results every time it is referenced. A
non-random variable may hold the number resulting from rolling a die. A random
variable represents the die itself.

```
x ~ 2d6   # create the random variable 'x' which represents rolling 2d6
a = x     # assign 'a' to an outcome 'x'
b = x     # assign 'b' to a different outcome
y ~ x + 4 # create the random variable 'y' which calls 'x' and adds 4 to the outome
```

### Array 

```
x = [1d6, 1d6, 1d6, 1d6]
```

is identical to
```
x = 4d6
```

Arrays are indexed from 1

```
x = [1,2]
x[1]      # yield first value
```

The functions *min*, *max*, and *sum* work on arrays.

### Sets

Sets contain mutually exclusive events.

```
y ~ {'a', 'b'} # y is assigned to a random variable that emits 'a', 'b'
A = y          # 'A' is randomly assigned to one of y's values
y[1]           # yield the first element of vector y
```

In the example above, 'a' and 'b' are emitted with equal probability. If you
wish one to be more likely than the other, the vector can be weighted. E.g.

### Comparison between arrays and sets

```
x = [1,2,3] # x is assigned to tuple of 3 values
x = {1,2,3} # x is randomly assigned to one of 3 values
```

```
y ~ {1:'a', 3:'b'}  # now 'b' will be emitted 3/4 times and 'a' 1/4
y[1]  # 'a'
y[2]  # 'b'
y[3]  # 'b'
y[4]  # 'b'
y[5]  # ERROR, variable 'y' has only 4 states
```

Here the numbers in brackets are NOT indices, but rather numbers. It is as if a
1d4 is rolled and the numbers 2 and higher yield 'b'. The number is brackets
corresponds to the 1d4 roll outcome.

Note, the weighting does not increase memory requirement. Writing `y ~
[100:'a', 300:'b']` allocates space equivalent to `y ~ [1:'a', 3:'b']`.

### Structures

Sometimes the output of a lod script will not be a single number, but rather a
complex state involving many variables. These composite entities can be
expressed as below

```
y ~ {
     hp   = 5d6
     name = 'unset'
     atk  ~ [19:1d6, 1:2d6]
    }
bob = y
bob.name = 'bob'
alice = t
alice.name = 'alice'
```

The syntactic difference between a *set* and a *structure* is that every
element of a set must yield an outcome and a structure must not. For example:

```
s ~ {1, 1d4}     # valid set
s ~ {x=1, 1d4}   # ERROR - first element returns nothing
s ~ {x=1, y=1d4} # ERROR - if it is meant to be a set, nothing is returned;
                 #         if it is meant to be a structure, it has too many elemnts
s ~ {x=1 y=1d4}  # valid structure
```

The structure can be thought of as a code block that returns access to the
variables it contains.

### Passing arguments to sets, structures and trials

```
# set with parameters
s ~ (a,b){1d6 + a, 1d8 + b}
```

```
# structure with parameters
s ~ (a,b){
          atk = 1d4 + a
          con = b * (1d10 / 2) + 10
         }

a = s(1,2)
```

```
# event with parameters
s ~ (a,b){a * 1d10 + b}
```

The general syntax is ( PAR ) { BLOCK THAT USES PARAMETERS }


### while-do-done

fairly standard syntax

```
i = 0
while
    i > 1  # some expression that evaluates to a boolean
    i++    # arbitrary block of code, may contain 'break' and 'continue'
done
```

### if-elif-else-done

pretty self-explanatory

```
if
    x < 5
    1
elif
    x < 10
    2
else
    3
done
```

Often if-elif-else syntax can be replaced with smart use of weighted sets.

## Examples

```
# executing this will return a single result
dc   = 15          # assign a constant value
dmg  ~ 1d6 + 3     # assign to a random variable (each usage rolls a die)
crit ~ dmg + dmg   # assign to an event
1d20
    (_ == 20) crit  # the '_' carries the value of the initial event
    (_ >  dc) dmg
# every event yields 0 by default
```


```
dmg  ~ 1d6 + 3
crit ~ dmg + dmg
hp = 100
turns = 0
while hp > 0
    turns += 1 
    1d20
        (_ == 20) {hp -= crit}
        (_ > dc)  {hp -= dmg}
done
# yield is necessary when the value returned by the last event is not the value of interest
yield turns
```

```
# using vector forms of rolls
top3 ~ max(4d6, 3) # take the three highest  
dis  ~ min(2d20)
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
