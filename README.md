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
called, this will be faster than simply calling the executable many times.

## Compiler

I will not attempt to implement a good compiler. Rather I am interested in a
merely functional one. My main interest is developing the syntax and semantics
of the language itself.

There are several fancy optimizations that can be added to the compiler.
Mainly, the distribution of many events can be solved exactly. Since lod deals
exclusively with discrete outcomes, an event can be expressed exactly as a
probability vector, which will require infinite memory in certain cases. This
compiler optimization step will require a decent mathematician.

When exact solutions are not tractable, certain events can be replaced by their
simulated probability mass functions. This will be expecially simple for events
that take no arguments.

## Language Overview

### Hello World

A lod script yields as its outcome the value of the final expression:

```
'Hello World'
```

lod makes no distinction between single and double quotes.

### Comments

Comments in lod will be the same as in C

```
// This is a comment
/*
This is a
multi-line comment
*/
```

### Declaring variables and arithmetic

All of this is pretty standard except that all numbers are integers in lod.

```
x = 5 + 2
y = x + 5
```

All division is integer division

```
5 / 2  // yields 2
```

All the arithmetic operators can be used with '='
```
x = 7
x /= 2  // x becomes 3 
```

### Dice

As the name 'Language of Dice' implies, dice are important in lod and have
their own builtin syntax, which follows DnD conventions, e.g.

```
4d6 // yields the 4 outcomes of 4 rolled 6-sided dice
```

The rolls are internally a vector. So you can say

```
sum(4d6) // yields the sum of the 4 dice
min(4d6) // yield the lowest of 4, 6-sided dice
```

### Random and non-random variables

There are two types of variables in lod, random and non-random. A non-random
variable is exactly like variables in any other programming language. A random
variable, however, yields random results every time it is referenced. A
non-random variable may hold the number resulting from rolling a die. A random
variable represents the die itself.

A random variable is similar to a generator in python. It may be better to
think of it as a function. Indeed, it can take arguments.

```
x ~ 2d6   // create the random variable 'x' which represents rolling 2d6
a = x     // assign 'a' to an outcome 'x'
b = x     // assign 'b' to a different outcome
y ~ x + 4 // create the random variable 'y' which calls 'x' and adds 4 to the outome
```

The '\*' operator draws mutiple instances from the generator. So `2 * 1d6` is
equivalent to `2d6`. Rather than multiplying the outcome of the event, you run
the event multiple times.

Similarly adding dice simply concatenates the events.

### Array 

```
x = [1d6, 1d6, 1d6, 1d6]
```

This is identical to all of the following
```
x = 4d6
x = 4 * 1d6
x = 2 * 2d6
x = 1d6 + 1d6 + 2d6
```

Arrays are indexed from 1

```
x = [1,2]
x[1]      // yield first value
```

The functions *min*, *max*, and *sum* work on arrays.

*min* and *max* both take an optional integer parameter specifying how many
elements to take. For example, `max(4d6, 2)` returns an array holding the two
highest rolls.

### Sets

Sets contain mutually exclusive events.

```
y ~ {'a', 'b'} // y is assigned to a random variable that emits 'a', 'b'
A = y          // 'A' is randomly assigned to one of y's values
```

In the example above, 'a' and 'b' are emitted with equal probability. If you
wish one to be more likely than the other, the set can be weighted. E.g.


```
w ~ {1:'a', 3:'b'}  // now 'b' will be emitted 3 or 4 times and 'a' 1 of 4
// Indexing for sets is based on the sum of the weights
w[1]  // 'a'
w[2]  // 'b'
w[3]  // 'b'
w[4]  // 'b'
w[5]  // ERROR, variable 'w' has onlw 4 states
```

```
// multiplying a set results in multiple draws with replacement
B = sum(4 * {1:1d6, 3:1d4})
```

Here the numbers in brackets are NOT indices, but rather numbers. It is as if a
1d4 is rolled and the numbers 2 and higher yield 'b'. The number in brackets
corresponds to the 1d4 roll outcome.

Note, the weighting should not increase memory requirement. Writing `y ~
[100:'a', 300:'b']` allocates space equivalent to `y ~ [1:'a', 3:'b']`.

### Comparison between arrays and sets

```
x = [1,2,3] // x is assigned to tuple of 3 values
x = {1,2,3} // x is randomly assigned to one of 3 values
```

### Structures

Sometimes the output of a lod script will not be a single number, but rather a
complex state involving many variables. These composite entities can be
expressed as below

```
y ~ {
     hp   = 5d6
     name = 'unset'
     atk  ~ {19:1d6, 1:2d6}
    }
bob = y
bob.name = 'bob'
alice = t
alice.name = 'alice'
```

The syntactic difference between a *set* and a *structure* is that every
element of a set must yield an outcome and a structure must not yield an
outcome. For example:

```
s ~ {1, 1d4}     // valid set
s ~ {x=1, 1d4}   // ERROR - first element returns nothing
s ~ {x=1, y=1d4} // ERROR - if it is meant to be a set, nothing is returned;
                 //         if it is meant to be a structure, it has too many elements
s ~ {x=1 y=1d4}  // valid structure
```

The structure can be thought of as a code block that returns access to the
variables within its scope.

### Passing arguments to sets, structures and trials

```
// set with parameters
s ~ par(a,b){1d6 + a, 1d8 + b}
```

```
// structure with parameters
s ~ par(a,b){
          atk = 1d4 + a
          con = b * (1d10 / 2) + 10
         }

a = s(1,2)
```

```
// event with parameters
s ~ par(a,b){a * 1d10 + b}
```

The general syntax is def ( PAR ) { BLOCK THAT USES PARAMETERS }

Whenever a parameterized generator is called, arguments must be given in parentheses.

### while-do-done

fairly standard syntax

```
i = 0
while
    i > 1  // some expression that evaluates to a boolean
    i++    // arbitrary block of code, may contain 'break' and 'continue'
done
```

### if-elif-else-done

pretty self-explanatory

```
if 1d20 < 5
    1
elif . < 10
    2
else
    3
done
```

Often if-elif-else syntax can be replaced with smart use of weighted sets. For example:

```
{4:1, 5:2, 11:3}
```

## Examples

 1. Advantage and disadvantage on a 1d20 roll

```
radv ~ max(2d20)
rdis ~ min(2d20)
```

Dice rolls are stored as an integer array. When their values are used in a
context expecting an integer, their sum is used.


 1. Simulate sum of 4 d6's after dropping the lowest

```
x ~ { sum(4d6) - min(.) }
x ~ max(4d6, 3)
```

'.' stores the result of the last calculated value within the current block and
is returned at the end of an event (unless explicitely stated otherwise via the
*yield* keyword). The above code could be rewritten as

```
x ~ {
        a = 4d6
        b = sum(a) - min(a)
        b
    }
```

 1. If 1d20 is less than 10, set to 10

```
x ~ if (1d20 < 10) 10 else .
```

 1. a single attack

```
// executing this will return a single result
dc   = 15          // assign a constant value
dmg  ~ 1d6 + 3     // assign to a random variable (each usage rolls a die)
crit ~ dmg + dmg   // assign to an event
{dc:0, (20-dc-1):dmg, 1:crit}
// every event yields 0 by default
```

```
dmg  ~ 1d6 + 3
crit ~ dmg + dmg
hp = 100
turns = 0
while hp > 0
    turns += 1 
    hp -= {15:0, 4:dmg, 1:crit}
done
// the last lone expression in a block is yielded
turns
```

```
// using vector forms of rolls
top3 ~ max(4d6, 3)  // take the three highest  
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

Formal specification
====================

 1. datatypes 

digit -> 0 | ... | 9

int -> *digit* *digit* | *digit*

roll -> *int***d***int*

string -> '[^']\*' | "[^"]\*"

array -> [ *expr*, *expr* ] | [ *expr*, *expr*, *expr* ] | ...

array -> [ *int* : *expr*, *int* : *expr* ] | [ *int* : *expr*, *int* : *expr* , *int* : *expr* ] | ...

array -> par(*var*) *array* | par(*var*, *var*) *array*

set -> { *expr*, *expr* } | { *expr*, *expr*, *expr* } | ...

set -> { *int* : *expr*, *int* : *expr* } | { *int* : *expr*, *int* : *expr*, *int* : *expr* } | ...

set -> par(*var*) *set* | par(*var*, *var*) *set*

struct -> { *stmt* } | { *stmt* *stmt* } | ...

struct -> par(*var*) *struct* | par(*var*, *var*) *struct*

struct-access -> *struct***.id**

 2. builtin functions

 func -> **max** ( *array* [, *int*] )

 func -> **min** ( *array* [, *int*] )

 func -> **sum** ( *array* )

 3. expressions

factor -> int | roll | array | set | struct | ( *expr* ) | ( *cond* )

term -> term / factor | term * factor | term % factor | factor

expr -> term + factor | term - factor | term

COP -> < | <= | \> | >= | == | !=

cond -> *cond* COP *factor*

cond -> *cond* **and** *cond* | *cond* **or** *cond* | **not** *cond*

cond -> *factor*

 4. statements

decl-stmt -> **id** = *expr*

gen-stmt -> **id** ~ *expr*

if-stmt -> **if** *cond* *block* **done**

if-stmt -> **if** *cond* *block* **else** *block* **done**

if-stmt -> **if** *cond* *block* [**elif** *cond* *block*]+ **done**

if-stmt -> **if** *cond* *block* [**elif** *cond* *block*]+ **else** *cond* *block* **done**

while-stmt -> **while** *cond* *block* **done**

 5. non-generator statements

stmt -> *decl-stmt* | *gen-stmt* | *if-stmt* | *while-stmt*

block -> *expr* | *stmt* | *block* *expr* | *block* *stmt*

non-gen-stmt-if-stmt -> **if** *cond* *non-gen-block* **done**

non-gen-stmt-if-stmt -> **if** *cond* *non-gen-block* **else** *non-gen-block* **done**

non-gen-stmt-if-stmt -> **if** *cond* *non-gen-block* [**elif** *cond* *non-gen-block*]+ **done**

non-gen-while-stmt -> **while** *cond* *non-gen-block* **done**

non-gen-stmt -> *decl-stmt* | *gen-stmt* | *non-gen-if-stmt* | *non-gen-while-stmt*

non-gen-block -> *non-gen-stmt* | *non-gen_stmt* + *non-gen-stmt*


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
OR       :=  or
YIELD    :=  yield
MAX      :=  max(*array* [, N])
MIN      :=  min(*array* [, N])
SUM      :=  sum(*array*)
```
