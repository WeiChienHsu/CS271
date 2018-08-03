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

In memory: 78h | 56h | 34h | 12h

```
mov al, BTYE PTR myDouble       ; AL = 78h
mov al, BYTE PTR [myDouble + 1] ; AL = 56h
mov al, BYTE PTR [myDouble + 2] ; AL = 34h
mov ax, WORD PTR myDouble       ; AL = 5678h
mov ax, WORD PTR [myDouble + 2] ; AL = 1234h
```

- PTR can also be used to combine elements of a smaller data type and move them into a larger operand. The IA-32 CPU will automatically reverse the bytes.

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

; We coudn't deference ptr directly

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
| 1 |20A0| 20A4| 20A8 |
| 2 |20AC| 20B0| 20B4 |
| 3 |20B8| 20BC| 20C0 |
| 4 |20C4| 20C8| 20CC |

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
- Move byte at [esi] into the AL register
- Increments esi if direction flag is 0
- Decrements esi if direction flag is 1

### stosb
- Moves byte in the AL register to memory at [edi]
- Increments edi if direction flag is 0
- Decrements edi if direction flag is 1

### cld
- Sets direction flag to 0
- Causes esi and edi to be incremented by lodsb and stosb
- Used for moving forward through an array

### std
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


***