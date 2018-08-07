# Macros, Recursion, and Digital Logic

## Macros 

### Precdure
- May have parameters
- Calling mechanism
- Return mechanism
- During assembly, procedure code is translated once.
- During execution, control is transferred to the procedrue at each call(activation record, etc) May be called amny times.

### Macro
- Separate, named section of code (May have parameters but are optional)
- Once defined, it can be invoked one or more times (Use name only not CALL)
- During assembly, entire macro code is substituted for each call (expansion)
- Similar to a CONSTAN and Invisible to the prgrammer

```
macroname MACRO [param-1, param-2, ...]
  statement-list
ENDM
```

### Invoking Macros
- To invoke a macro, just give the name and the arguments.
- Each argument matches a decalred parameter.
- Each parameter is replaced by its corresponding argument when the macro is expanded.
- When a macro expands, it generates assembly language source code.

```
mWriteStr MACRO buffer
  push edx
  mov  edx, OFFSET buffer
  call WriteString
  pop  edx
ENDM

.data
str1  DWORD "abc", 0
str2  DWORD "bcd", 0

.code

  mWriteStr str1
  mWriteStr str2
```

```
mReadStr  MACRO  varName
  push  ecx
  push  edx
  mov   edx, OFFSET varName
  mov   exc, (SIZEOF varName) - 1 
  call  ReadString
  pop   edx
  pop   ecx
ENDM

.data
firstName BYTE 30 DUP(?)

.code 

mReadStr  firstName
```
### Deal with Duplicate labels

- Specify labels are LOCAL
- MASM handles the problem by appending a unqiue number to the label

```
Seq MACRO   a, b
  LOCAL test
  LOCAL quit

  mov   eax, a
  mov   ebx, b
test:
  cmp   eax, ebx
  jg    quit
quit:

```

### Parameters
- Arguments are subsitiuted exactly as entered, so any valid argument can be used.
- There is no checking for memory, registers or literals.
- If someone call "cmp eax, ebx", This macro would always print one number.

### Comparsion Macor and Procedure
- Macros are very convenient, easu to understand
- Macros actually execute faster than procedures (No return address, stack manipulation, etc)
- Macors are invoked by name and does not have a ret statement
- If the Macro is called many times, the assembler produces "fat code"
- Use a macro for short code that is called a few fimes and uses only a few registers
- For both: Save Registers.

***

# Recursion

```
summation	PROC
	push	ebp
	mov		ebp,esp
	
	mov		eax,[ebp+16]	; eax = x
	mov		ebx,[ebp+12]	; ebx = y
	mov		edx,[ebp+8]		; @sum in edx
	
	add		[edx],eax		; add current value of x
	cmp		eax,ebx
	je		quit			  ; base case: sum = x
recurse:
	inc		eax				;recursive case
	push	eax				; eax = x
	push	ebx				; ebx = y
	push	edx				; edx = @sum
	call	summation
quit:
	pop		ebp
	ret		12
summation	ENDP
```

- Using Stack Frame for recursion is essential.
- Pass all 3 parameters even 2 of them nerver change, since we could use ebp pointer to get the values we need.

***

## Digital Logic Boolean Logic

### Internal (electirc) representation of binary codes

Gates (the building block with defined functionality)

- Made of one or more transistors
- Only 2 voltages are permitted
- Low represents binary 0
- High represents binary 1
- Can convert Low <-> High using gates

#### Digital Circuits
- For any set of inputs, gates (NOT, AND, OR) can be combined to produce specified output.
- NAND, NOR (opposite of AND and OR)
- XOR (different get 1) <-> XNOR (opposite of XOR)


### Simplification
- Multiple-input gates
- Equivalent gates
- Use Boolean Logic to simplify the function before implementing the circuit.

***

## Digital Logicc Circuits

### Half Adder

AB -> Carry
A XOR B -> Sum

| A | B | Sum | Carry |
|:-:|:-:|:---:|:-----:|
| 0 | 0 |  0  |   0   |
| 0 | 1 |  1  |   0   |
| 1 | 0 |  1  |   0   |
| 1 | 1 |  0  |   1   |


### Full Adder

AB + (A XOR B) and C -> Carry Out
(A XOR B) XOR C -> Sum


| A | B | Carry In | Sum   | Carry Out |
|:-:|:-:|:--------:|:-----:|:---------:|
| 0 | 0 |    0     |   0   |     0     |
| 0 | 1 |    0     |   1   |     0     |
| 1 | 0 |    0     |   1   |     0     |
| 1 | 1 |    0     |   0   |     1     |
| 0 | 0 |    1     |   1   |     0     |
| 0 | 1 |    1     |   0   |     1     |
| 1 | 0 |    1     |   0   |     1     |
| 1 | 1 |    1     |   1   |     1     |


### Ripple Carray Adder

***