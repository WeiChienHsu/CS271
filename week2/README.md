# Conditions, Controls, Constants, and Data Representation

Sometimes it is necessary to interrupt sequential instruction exection.

EIP is changed (But should not be changed directly)
- Skip ahead (skip the else block)
- Jump backward (repeat a section of code)
- Call a procedure

Conditional / Unconditional branching

Label required (Memory Address)

## MASM Labels
Same rule as other identifiers
Lavel definition ends with colon :
Specifies the memory address of the associated instruciton

## Unconditional Branching
Instruction format is "jmp label"

Meaning is Set EIP to label and continue execution. (Label is a name that has been set equibalent to memory address)

Label should be iniside the same procedure.

## Conditional branching
- if Structure(decisiotn, alternation)
- loop structures (repetion, iteration)

MASM provides some "advance" conditional directives(.repeat, .if, .else... etc)

***


## CMP Instruciton
```
CMP destinaiton , source
```

Compares the destination operand to the source operand
- Non-destructive subtraction: source - destinaion (destinaiton is not changed)
- Sets specific bits in the status register
- Status bits indicate how source compares to destination (<,>,=,<=,>=, overflow, zero, error etc)
- Porgram can conditionally jump to a label based on status bits

## Jcond Instruciton
A conditional jump instruciton checks the status register and branches to a label depending on status of specific flags (Usually the next instruction after cmp)

Jcond label 

- There are many cond froms that can be checked
- label is defined by the programmer

```
cmp eax, 100
jle notGreater  ;if exa <= 100, go to notGreater section
```

Meaning: if the value in register eax is less than or equal to 100, jump to the label notGreater


## Common Jcond instructions

Conditions for signed integers
  
JE: = 
JL: <
JG: >
JLE: >=
JGE: <=
JNE: !=

## Block structued IF statements

```c
if( op1 == op2)
  x = 1
else
  x = 2
```

```
  mov eax, op1
  cmp eax, op2
  jne L1 ; not equal
  mov x, 1
  jmp L2 ; equal and skip L1
L1:
  mov x, 2
L2: 
```

## Assembly Language Control Structures

### If Then
```
chekch the condition using CMP
  if condition is FALSE, jump to endThen
    code For TRUE block
  endThen
```

### If Then Else
```
chekch the condition using CMP
  if condition is FALSE, jump to endThen
    code For TRUE block
    jump to endThen
  falseBlock
    code For FALSE block
  endThen
```
```
  mov eax, op1  
  cmp eax, op2  ; test condition
  jne fBlock    ; if op1 != op2, jump to the fBlock
  mov x, 1      ; TRUE code
  jmp done      ; Skip fBlock
fBlock:
  mov x, 2      ; FASLE code
done:
```

### If-THEN-Else IF- ELSE
```
chekch the condition1 using CMP
if condition1 is TRUE, jump to trueBlock1
chekch the condition2 using CMP
if condition2 is TRUE, jump to trueBlock2

  code For FALSE block
  jump to endBlock

trueBlock1
  code For TRUE block
  jump to endBlock

trueBlock2
  code For TRUE block   ; no need to jump

endBlock

```

### Compound conditions (AND)

```
chekch the condition1 using CMP
if condition1 is FALSE, jump to falseBlock
chekch the condition2 using CMP
if condition2 is FALSE, jump to falseBlock

  code For TRUE block
  jump to endBlock

falseBlock
  code For FLASE block   ; no need to jump

endBlock
```


### Compound conditions (OR)

```
chekch the condition1 using CMP
if condition1 is TRUE, jump to trueBlock
chekch the condition2 using CMP
if condition2 is TRUE, jump to trueBlock

  code For FALSE block
  jump to endBlock

trueBlock
  code For TRUE block   ; no need to jump

endBlock
```

***

# Repetition Structures

## Pre-test loop (While)

```
initialize loop control variable(s)
top:
chekch condition using CMP
if condition is FALSE, jump to endWhile
  code for LOOP BODY
  (including loop control update)
  jump to top(unconditinal jump)
endWhile
```

```
; initialize accumulator
    mov   eax, x
dbLoop: ; Double x while x <= 1000 (When s is positive)
    cmp   eax, 1000
    jg    endLoop
    add   eax, eax
    jmp   dblLoop
endLoop: 
    mov   x, eax
```


### Post-test loop (do-while)

```
; initialize accumulator
    mov   eax, x
dblLoop:  ; Double x while x <= 1000
    add   eax, eax
    cmp   eax, 1000
    jle   dblLoop

    mov   x, eax

```

### Counted loop (For)

```
initialize ecx to loop count
top:  
  code  for LOOP BODY
  loop statement decrements exc and
    - jumps to top if exc is not equal to 0
    - continues to next statement if exc = 0
```
* Warning - Note what happens if ecx is changed inside the loop body
* Warning - Note what happens if ecx statrs at 0, or ecx becomes negative

```acm
; initialize accumulator, first number, and loop control
  mov   eax, 0  ; accumularor
  mov   ebx, 1  ; increment each time when going through loop
  mov   ecx, 10 ; loop control

sumLoop:  ; add integers from 1 to 10
  add   eax, ebx
  inc   ebx         ; add 1 to ebx
  loop  sumLoop     ; subtract 1 from ecx
                    ; if ecx != 0, go to sumLoop
  call  WriteDec
```

```acm
; initialize accumulator, first number, and loop control
    mov   eax, 0
    mov   ecx, 10
sumLoop:  ; add integers from 10 to 1
    add  eax, exc
    loop  sumLoop
; Print result
    call WriteDec
```

***