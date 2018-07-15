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
# Constants

### name = expression
- Name is called a symobic constant
- expression is a 32-bit integer
- Cannot be redefined in the same program

```
COUNT = 500
...
mov exc, COUNT
```

### EQU Directive 
Define a symbol as numeric or text expression. (Note <...>)
Cannot be redefined in the same program

```
PI EQU <3.1416>
PRESS_KEY EQU <"Press any key to contimue ... " , 0 >

.data

prompt BYTE PRESS_KEY
```

### Calculating the size of a string
Current location in Data segment is $
Subtract address of string - difference is the number of bytes

```
.data
rules_1 BYTE    "Entehr the lower limit: ", 0
SIZE_1  = ($  - rules_1)  ; constant length of rules_1 (24)
```

## Boolean constants

Doesn't have a Boolean data type, 0 for FALSE 1 for TRUE.

## Data Validation

Try to verify that the user's input can be handled by the program.

Try to keep the program from crashing on invalud input

Try to infor user if there is an input data error.

- Simple range checking
- One form of interactive data validation

```
repeat
  valid = true
  get value
  if value is not in range
    valid = false
    give error message
  until valid

```

***

# Data Representation

## Internal Representaion
Just like everything eles in a computer, the representation of data is implemented electrically.

- switches set to off or on
- with open/closed gates.

There are two states for each gate

The binary number system usses two digits

In order to simplify discussion, we use the standard external representation to transcribe the computer's internal representation 

- off is written as digit 0
- on is written as digit 1

## External Representation
Binary Number System
- has 2 digits: 0 and 1 (binary digit)

### In theory 
can uniquely represent any integer value. A binary representation is just another way of writing a number that we are accustomed to seeing in decimal form.

### In practice
inside the computer representation is finite.

***

# Representing Negative integers

Separate the codes so that half of them represent negative numbers. (Note that exactly half of the codes have 1 in the "leftmost" bit.)

## Binary form of negative

-13 in 16-bit twos-complement

```
| -13 | = 13 =    0000 0000 0000 1101
one complement is 1111 1111 1111 0010
add 1 to get      1111 1111 1111 0011 = -13
```

## Signed numbers using 4-bit tows-complement form

| Number | Two-complement digits |
|:------:|:---------------------:|
|-8 | 1000 |
|-7 | 1001 |
|-6 | 1010 |
|-5 | 1011 |
|-4 | 1100 |
|-3 | 1101 |
|-2 | 1110 |
|-1 | 1111 |
|0  | 0000 |
|1  | 0001 |
|2  | 0010 |
|3  | 0011 |
|4  | 0100 |
|5  | 0101 |
|6  | 0110 |
|7  | 0111 |

The 2^n possible codes give

- Zero (All bits are zero)
- (2^n-1  - 1) psitive numbers
- (2^n-1) negative number

Note there is one 'weird' number -> 
0111 111 + 1 = 1000 0000 127 + 1 = -128

## Signed or Unsigned
A 16-bit representation could be used for signed or unsigned numbers
- 16-bit unsigned range is 0 - 65535
- 16-bit signed range is -32768 ... + 32768

Programs tell the computer which form is being used.

## Negative hex (signed integers)
Recall that a 16-bit signed integer is negatie if the leftmost bit is 1.

- 0x7a3e is positove (Looking if it is smaller than 7)
- 0x8a3e is negative
- 0xFFFF is negative


## Character and control codes

ASCII 256 codes (1-byte)
- 'A' ... 'Z' are codes 65 - 90
- '0' ... '9' are codes 48 - 57

Unicode 65,536 codes (2-byte)

Device controllers translate codes (device dependent)



***

# Practice

#### After executing the following instruction sequence, what is the value of AL, in binary:
```
mov al,00111100b
or  al,82h
```

1011 1110

#### After executing the following instruction sequence, what is the value of AL, in binary:
```
mov al,4Bh
and al,6Ch
```

01001000

#### Which of the following selections contain instructions that jump to label L4 only if bits 1, 2, and 3 are all set in the DL register?

```
and dl,0Eh
cmp dl,0Eh
je  L4
```


#### After the following instruction sequence, show the values of the Carry  
```
mov al,6
cmp al,5
```

0, Zero  0 , and Sign 0 flags

#### Suppose EAX, EBX, and ECX contained three unsigned integers. Which of the following code excerpts would display the largest of the three integers?

```
    cmp eax,ebx
    jae L1
    mov eax,ebx
L1: cmp eax,ecx
    jae L2
    mov eax,ecx
L2: call WriteInt
```

#### After executing the following instruction sequence, what is the value of AL, in binary:
```
mov al,94h
xor al,37h
```
10100011

#### After the following instruction sequence, show the values of the Carry  

```
mov al,00110011b
test al,2
```

0, Zero  0 , and Sign 0 flags

#### After executing the following instruction sequence, what is the value of AL, in binary:
```
mov al,11001111b
and al,00101011b
```

00001011

#### After executing the following instruction sequence, what is the value of AL, in hexadecimal
```
mov al,9Ch
not al
```

63h

#### After the following instruction sequence, show the values of the 
```
mov al,5
cmp al,7
```

Carry  1, Zero  0 , and Sign 1 flags

#### Where is the result of the following operation stored?
```
MUL EBX
```
EDX:EAX

#### In what register will the quotient of the following instruction be found?
```
DIV EBX
```

eax

#### Unlike the MUL instruction, IMUL preserves the sign of the product.

TRUE

#### Identify which of the following are correct formats for the DIV instruction. (Check all that apply)

- DIV mem8
- DIV mem32
- DIV mem16
- DIV reg

#### In what register will the remainder of the following instruction be found?
```
DIV EBX
```

edx

#### What is the value of the Carry flag after the following instructions?
```
mov al,5h
mov bl,10h
mul bl
```

0.000

#### Identify which of the following are correct formats for the IMUL instruction. (Check all that apply)
- IMUL reg16,reg/mem16
- IMUL reg16,imm8
- IMUL reg32,reg/mem32,imm8
- IMUL reg16,reg/mem16,imm16
- IMUL reg32,imm8
- IMUL reg32,imm32
- IMUL reg32,reg/mem32
- IMUL reg16,reg/mem16,imm8
- IMUL reg16,imm16
- IMUL reg32,reg/mem32,imm32


#### Identify which of the following are allowed formats for the MUL instruction. (Check all that apply)

- MUL mem16
- MUL mem32
- MUL reg
- MUL mem8

#### The Irvine32 library call GetMseconds returns

number of system milliseconds that have elapsed since midnight 

#### Even in older x86 processors, there was an insignificant difference in performance between multiplication by bit shifting versus multiplication using the MUL and IMUL instructions.

False


#### Fill in
Identify the sizes of the sign  1 , exponent  8 , and significand  23 for a Single Precision x86 floating point number.

#### In the x86 Floating-Point, a decimal number contains three components: a sign, a significand, and an exponent.

True

#### Select the correct EVEN parity 12 bit Hamming code value for the unsigned integer value 202

0011  1000  1010 

#### 1001  0011  0111 is an ODD parity 12 bit Hamming code that contains a single-bit error. What is the corresponding uncorrupted Hamming code?

1001  0010  0111 

#### 0111  0110  1011 is an EVEN parity 12 bit Hamming code that contains a single-bit error. What is the corresponding uncorrupted Hamming code?

0111  0110  1111 


#### Select the correct EVEN parity 12 bit Hamming code value for the unsigned integer value 55

 0001  0111  0111 




***

# Debuging MASM

Set Breakpoints by clicking in the left margin

Debug -> Start Debugging

Debug, Window, Registers -> To view register contents, Register contents are shown in window