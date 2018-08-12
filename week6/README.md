# MASM Data-Related Operators and the IA-32 Floating Point Unit

## Data-Related Operators

### OFFSET Operator
- OFFSET returns the distance in bytes, of a label from the beginning of its enclosing segment.
- The operating system adds the segment address. (from the segment register)

Assume that the data segment begins at 00404000h.

```
.data
bVal  BYTE  ?
wVal  WORD  ?
dVal  DWORD ?
dVal2 DWORD ?

.code
...
mov esi, OFFSET bVal  ; ESI = 00404000 the beginning of bVal -> First element
mov esi, OFFSET wVal  ; ESI = 00404001
mov esi, OFFSET dVal  ; ESI = 00404003
mov esi, OFFSET dVal  ; ESI = 00404007
```

### PTR Operator
- Override the default type of a label (variable)
- Provides the flexibility to access part of a variable.

```
.data
myDouble DWORD  12345678h
.code
...
mov ax, myDouble  ; error : Size mismatch

mov ax, WORD PTR myDouble   ; loads 5678h (Will match the SIZE of WORD)

mov WORD PTR myDouble, 1357h ; saves 1357h
```

Recall that little endian order is used when storing data in memory.

- In memory: 78h | 56h | 34h | 12h

```
mov al, BTYE PTR myDouble       ; AL = 78h
mov al, BYTE PTR [myDouble + 1] ; AL = 56h
mov al, BYTE PTR [myDouble + 2] ; AL = 34h
mov ax, WORD PTR myDouble       ; AL = 5678h
mov ax, WORD PTR [myDouble + 2] ; AL = 1234h
```

### PTR Operator (Cont)

PTR can also be used to combine elements of a smaller data type and move them into a larger operand. The IA-32 CPU will automatically reverse the bytes.

```
.data
myBytes BYTE  12h, 34h, 56h, 78n 
; Notice the array declaration: Specify a comma-separated list of element values
.code
mov ax, WORD PTR  myBytes             ; AX = 3412h
mov ax, WORD PTR  [myBytes + 2]       ; AX = 7856h
mov eax, DWORD PTR  myBytes           ; EAX = 78563412h
```

### TYPE Operator

定義的 Variable 佔了多少 Bytes

The TYPE operator returns the size, in bytes, of a single element of a data declaration.

```
.data
var1  BYTE ?
var2  WORD ?
var3  DWORD ?
var4  QWORD ?

.code

mov eax, TYPE var1 ; 1
mov eax, TYPE var2 ; 2
mov eax, TYPE var3 ; 4
mov eax, TYPE var4 ; 8
```

### LENGTHOF Operator
- Counts the number of elements in a single data declaration.

定義的 Variables 有多少個 Elements？ 或是 String 內有多少 Characters？

```
.data
byte1 BYTE 10, 20, 30         ; 3
list1 WORD 30 DUP(?)          ; 30
list2 DWORD 30 DUP(?)         ; 30
list3 DWORD 1, 2, 3, 4        ; 4
digitStr  BYTE  "1234567", 0  ; 8

.code
mov ecx, LENGTHOF list1       ; ecx contains 30
```

### SIZEOF Operator
- Returns a value that is equivalent to multiplying LENGTHOG by TYPE 

該 Variable 在 Memory 中所佔的總 Bytes數： TYPE * LENGTHOF

```
.data
byte1 BYTE 10, 20, 30         ; 3
list1 WORD 30 DUP(?)          ; 60
list2 DWORD 30 DUP(?)         ; 120
list3 DWORD 1, 2, 3, 4        ; 16
digitStr  BYTE  "1234567", 0  ; 8

.code
mov ecx, LENGTHOF list1       ; ecx contains 60
```

### Spanning Multiple Lines

```
list DWORD    10,20
              ,30,40
              ,50,60
-> LengthOf =  6
-> SIZEOF = 24

list DWORD    10,20
     DWORD    30,40
     DWORD    50,60
-> LengthOf =  2
-> SIZEOF = 8
```

***

## Index Scaling

```
.data
listB BYTE  1,2,3,4,5,6,7
listW WORD  8,9,10,11,12,13
listD DWORD 14,15,16,17,18,19,20,21
.code
mov esi, 5
mov al, listB[esi * TYPE listB]   ; al = 6
mov bx, listW[esi * TYPE listW]   ; bx = 13
mov edx, listD[esi * TYPE listD]  ; edx = 19
```

## Pointers
- We can declare a pointer variable that contains the offset of another varible

```
.data
list    DWORD   100 DUP(?)
ptr     DWORD   list
.code
mov esi, ptr
mov eax, [esi]    ; EAX = @ list

; We coudn't deference ptr directly (No valid memory to memory)

```

- Just Like what we didi in C/C++

```c
int list[100]
int *ptr = list
```

## Summing an Integer Array
The following code calculates the sum of an array of 32-bit integers(register indirect mode)


```
.data
intList   DWORD   100h, 200h, 300h, 400h
ptrD      DWORD   intList

.code

mov esi, ptrD               ; address of intList
mov ecx, LENGTHOF intList   ; loop counter
mov eax, 0                  ; init the accumulator

L1: 
  add eax, [esi]            ; add an integer
  add esi, TYPE intList     ; point to the next integer
  loop L1                   ; repeat until ECX = 0
```

***


# Multi-Dimensional Arrays String Processing

## 2 Dimensional Array (Matrix)

```
Matrix DWORD   5 DUP(3 DUP(?))  ; 15 elements
```

- A matrix is an arrays of arrays
- Row major order: Row index first(5 rows, 3 columns)
- Example HLL reference: Matrix[0][2]
- In assembly language, it's just a set of contiguous memory locations 

### Calculate the Address of 2D Array

An element's address is calculated as the base address plus an offset

```
BaseAddress + elementSize + [(row# * elementsPerRow) + column#]
```

- Suppose Matrix is at address 20A0h
- The address of Matrix[3][1] is at 20A0h + 4 * [3 * 3 + 1] = 20A0h + 40 = 20A0h + 28h = 20C8h


|   | 0  | 1   | 2    |
| 0 |20A0| 20A4| 20A8 |
| 1 |20AC| 20B0| 20B4 |
| 2 |20B8| 20BC| 20C0 |
| 3 |20C4| 20C8| 20CC |

***

## String Primitives

- A string is an array of BYTE
- In most cases, an extra byte is needed for the zero-byte terminator
- MASM has some "String primitives" for manipulating strings byte-by-byte

```
Most important:
lodsb ; load string byte
stosb ; store string byte
cld   ; clear direction flag
std   ; set direction flag
```

### lodsb

esi 指向的 Adress 內 data 取出給 AL, ESI = ESI + 1

- Move byte at [esi] into the AL register
- Increments esi if direction flag is 0
- Decrements esi if direction flag is 1

### stosb

AL內的值取出，賦予 edi 指向的 Address, EDI = EDI + 1

- Moves byte in the AL register to memory at [edi]
- Increments edi if direction flag is 0
- Decrements edi if direction flag is 1

### cld

從頭到尾

- Sets direction flag to 0
- Causes esi and edi to be incremented by lodsb and stosb
- Used for moving forward through an array

### std

從尾到頭


- Sets direction flag to 1
- Causes esi and edi to be decremented by lodsb and stosb
- Used for moving backward through an array

```
INCLUDE Irvine32.inc
MAXSIZE	= 100
.data
inString	BYTE		MAXSIZE DUP(?)		; User's string
outString	BYTE		MAXSIZE DUP(?)		; User's string capitalized
prompt1	BYTE		"Enter a string: ",0
sLength	DWORD	0

.code
main PROC
; Get user input:
	mov	edx,OFFSET prompt1
	call	WriteString
	mov	edx,OFFSET inString
	mov	ecx,MAXSIZE
	call	ReadString
	call	WriteString
	call	CrLf
	
; Set up the loop counter, put the string addresses in the source 
; and index registers, and clear the direction flag:
	mov	sLength,eax
	mov	ecx,eax
	mov	esi,OFFSET inString
	mov	edi,	OFFSET outString
	cld

; Check each character to determine if it is a lower-case letter.
; If yes, change it to a capital letter.  Store all characters in
; the converted string:
counter:
	lodsb
	cmp	al,97	; 'a' is character 97
	jb	notLC
	cmp	al,122	; 'z' is character 122
	ja	notLC
	sub	al,32
notLC:
	stosb
	loop	counter
	
; Display the converted string:
	mov	edx,OFFSET outString
	call	WriteString
	call	CrLf
	
; Reverse the string
	mov	ecx,sLength
	mov	esi,OFFSET inString
	add	esi,ecx
	dec	esi					; last byte of inString
	mov	edi,OFFSET outstring	; first byte of outString

reverse:
	std						; get characters from end to beginning
	lodsb
	cld						; store characters from beginning to end
	stosb
	loop	reverse

; Display reversed string
	mov	edx,OFFSET outString
	call	WriteString
	call	CrLf
	
	exit			;exit to operating system
main ENDP

END main
```



***

## Lower-Level Programming

All keyboard input is character
- Digits are character codes 48 - 57
- '0' is character number 48
- '1' is 49 ... '9' is 57

Cannot do arithmetic with string representations.

### ReadString (Irvine's Library)
- Get a string of digits(characters)
- Converts digits to numeric values.

### ReadString Implementaion 
```
get string
x = 0
for k = 0 to (len(str) - 1)
  if 48 <= str[k] <= 57
    x = 10 * x + (str[k] - 48)
  else
    break
```

```
"2475", 0

x = 0

ch '2' : value 50, x = 2
ch '4' : value 52, x = 24
ch '7' : value 55, x = 247
ch '5' : value 53, x = 2475
```

***

# Reverse Polish Notation (RPN) Expression Evaluation

```
Infix : a + (b-c) * (d+e)
Postfix (RPN): a bc-  de+ * +
```

- Notice how operator precedence is preserved
- Notice how order of operands is preserved
- Notice how order of operators is NOT preserved
- RPN does not require parentheses


## Conversion infix -> Postfix(RPN) 

### Binary Tree Method
- Fully parenthesize infix
- Dont parenthesize postfix
- Operands: are always in the original order
- Operators: may apprear in different order

### Pare the expression left to right constructing a binary Tree
- ( : go left
- Operand : insert
- Operator : go up, insert, go right
- ) : go up
- Post-order traversal gives RPN


### Example ((a+b) * (c+d)) + e -> ab+cd+*e+

```
          [+]
          /  \
       [*]   [e]
      /    \
    [+]    [+]
   /  \    / \
 [a]  [b][c]  [d]

Post-Order Traversal:

      ab+ cd+ * e +
```

## Conversion Postfix(RPN)  -> infix

### Binary Tree Method
- Diagram expression as a binary tree (Last operator is root)
- Do inorder traversal, parenthesizing each subtree

```
          [+]
          /  \
       [*]   [e]
      /    \
    [+]    [+]
   /  \    / \
 [a]  [b][c]  [d]

((a + b) * (c + d)) + e

```
## Evaluation of RPN expressions
Parse expression left to right, creating a stack of operands
- Operand: Push onto stack
- Operator: Pop 2 operands, perform operation, push result onto stack
- The single value remaining on the stack is valeu of expression

## Using RPN in programs : a - b * c
1. Convert to RPN : abc *-
2. Program:

```
push a
push b
push c
mul 
sub
```
***

# Floating-Point Unit

- Runs in parallel with integer processor.
- Circuits designed for fast computation on floating point numbers. (IEEE format)
- Registers implemented as "pushdown" Stack (One register pushed will influce others)
- Usually programmed as a 0-address machine 
- CPU/FPU Exchange data though memory (Converts WORD and DWORD to REAL10)

## Floating-Point Unit Registers (80-bit Register)
- 0: IEEE 754 format
- 1: bit #79: sign bit
- 2: bit #78 - #64: biased exponent
- 3: bit #63 - #0: normalized mantissa

- If push more than 8 values, the bottom of the stack will be lost.
- Operations are defined for the top one or two registers
- Registers may be referenced by name ST(x)

## Programming the FPU
- FPU Registers = ST(0) ... ST(7)
- ST = ST(0) = top of stack
- ST(0) is implied when an poerand is not specifid.
- Instruction Format: OPCODE destination, source
- Restrictions: One register must be ST(0)
- FINIT: initialize FPU register stack (Execute before any other FPU instructions)

## Sample Register Stack Opcodes
### FLD MemVar
- Push ST(i) down to ST(i + 1) for i = 0 - 6
- Load ST(0) with MemVar

### FST MemVar
- Move top of stack to memory
- Leave result in ST(0)

### FSTP MemVar
- Pop top of stack to memory
- Move ST(i) up to ST(i - 1) for i = 1 - 7

```
.data
varX    REAL10   2.5
varY    REAL10   -1.8
varZ    REAL10   0.9
result  REAL10    ?

.code
  FINT
  FLD varX
  FLD varY
  FLD varZ
  FMUL
  FADD
  FSTP result ;   result = varX + varY * varZ
```

### Example (6.0 * 2.0) + (4.5 * 3.2) 
RPN is 6.0 2.0 * 4.5 3.2 * +

```
.data
array       REAL10  6.0, 2.0, 4.5, 3.2
dotProduct  REAL10  ?

main PROC
  finit             ; Initialize FPU
  fld array         ; push 6.0 onto the stack
  fld array + 10    ; push 2.0 onto the stack
  fmul              ; ST(0) = 6.0 * 2.0
  fld array + 20    ; push 4.5 onto the stack
  fld array + 30    ; push 3.2 onto the stack
  fmul              ; ST(0) = 4.5 * 3.2
  fadd              ; ST(0) = ST(0) + ST(1)
  fstp dotProduct   ; pop Stack into memory
  exit


min ENDP
END main

```

***


## Summary Exercise

### Match the string primitive to its purpose
Load String byte: lodsb
Store String byte: stosb
Clear Direction flag: cld
Set Direction flag; std


### For the following segment, what is SIZEOF myChecker

```
.data
myChecker   BYTE   12h
            BYTE   34h
            BYTE   56h
            BYTE   78h
            BYTE   90h
```

1.000


### The _________ operator returns the size, in bytes, of a single element of a data declaration.

TYPE


### The _________ operator returns a count of the number of elements in a single data declaration.

LENGTHOF


### Storing a string byte using string primitives increments/decrements which register?

EDI

### Suppose that you are given the following partial data segment, which starts at address offset 0x1000 :

```
.data
idArray WORD 3546, 1534, 12, 3481, 154, 6423
x DWORD LENGTHOF idArray
y DWORD SIZEOF idArray
z DWORD TYPE idArray
```

- x contains: 6
- y contains: 6 * 4 = 24
- What is the hexadecimal OFFSET of the number 12 in idArray: 0x1004

### Suppose that you are given the following partial data segment, which starts at address 0x0700 :

```
.data
idArray DWORD 1800, 1719, 1638, 1557, 1476, 1395, 1314, 1233, 1152, 1071, 990
u DWORD LENGTHOF idArray
v DWORD SIZEOF idArray
```

What value does EAX contain after the following code has executed? 

```
mov   esi, OFFSET idArray
mov   eax, [esi+8*TYPE idArray]
```

1152 (找第八個 index - 0 開始)

### Assume that your program has access to the following data segment (starting at address 0x310):
```
.data
id       DWORD  7
matrix   WORD   50 DUP(10 DUP(?))
```

What is the hexadecimal address of matrix[7][3] (the 4th element of the 8th row)?

- 0x3A6


### Given the following array declaration, how many bytes of memory does array matrix require? 
```
.data
matrix   WORD   7 DUP(15 DUP(?))
```
- 7 * 2 * 15 = 210


### (5 + 3) * 12 / (3 * 4) + 12
5 3 + 12 * 3 4 * / 12 + 

### 3 3 * 5 4 2 * / -
3 * 3 - 5 / (4 * 2) 


### Which of the following infix notations corresponds to the given FPU manipulations? A B / C D - * E -

```
finit
fld    A
fld    B
fdiv
fld    C
fld    D
fsub
fmul
fld    E
fsub
fstp   Z
```

 Y = A / B * (C - D) - E 

