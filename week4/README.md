# Modularization

- Team Environment
- Incremental testing in sections
- Reliability 
- Debugging
- Maintenance
- Re-usable code


## MASM Procedures

The sections of your main


## The System Stack

Data Structure/ Last-in, First-out / All operations reference the top of the stack.

Applictaion:
- Activation stack
- Iterative implementation of recursive algorithm 
- Base conversion
- Expression Evaluation

The operating system maintains a stack 
- Implemented in memory 
- LIFO structure

Managed by the CPU, using two registers
- SS: address of stack segment
- ESP: Stack pointer (Always points to "top" of stack)

### Push syntax : Push r/m32 Push immred
- decrements the stack pointer by 4.
- copies a value into the location pointed to by the stack pointer.
- Actual decrement depends on the size of the operand.

Supose that ecx contains 317 and esp contains 0200h.

In this case, [esp] is 25. Means contents of memory at the address in esp is 25.

```
esp: 0200h
[esp] : 25

```

The next instruction is "push ecx"

Executr push exc

```
esp : O1FCh (Current top of the Stack)
[esp]: 317
```

### POP syntax : POP r/m32

Copies value is ESP into a register or variable.
increments the stack pointer by 4.

pop eax

Take the value of top of the stack into eax

```
esp: 0200h
[esp] : 25
```

## Stack is useful for the nested loop in asembly language

```
  mov ecx, 100 ; set outer loop count
L1:            ; begin the outer loop
  push ecx     ; save outer loop count

  mov ecx, 20   ; set innter loop count
L2:             ; begin the inner loop
  ;
  ;
  loop L2       ; repeat the inner loop till inner count equal to zero

  pop ecx       ; restore outer loop count
  loop L1       ; repeat the outer loop
```

## CALL and RET Instructions
The CALL instruction calls a procedure: Push the offset of the next instruction onto the stack and copies the address of the called procedure into EIP.

The RET instruciton returns from a procedure and pops top of the stack into EIP.

***

## EIP, ESP and System Stack Changes during running the program

```
0000    main    PROC
0000            call  intro
0005            call  getData

000A    ; ... more implementation code for main

                exit
001B    main    ENDP

001B    intro   PROC

; ... more implementation code for intro

003E            ret 
003F    intro   ENDP

003F    getData PROC

0058            call validate

005D    ; ... more implementation code for getData

0067            ret
0068    getData ENDP

0068    validate  PROC

; ... more implementation code for validate

008A              ret
008B    validate  ENDP
```

### System Stack

| Memory Address | Memory Contents |
|:--------------:|:---------------:|
| 03F4           | -----           |
| 03F8           |  005D           |
| 03FC           |  0005 -> 000A   |
| 0400           | xxxx            |

ret 的時候，會將當時的 EIP，存入當時的 Stack 當中。


### EIP and ESP

| Address / Instruction | EIP before | EIP after | ESP before | ESP after |
|:---------------------:|:----------:|:---------:|:----------:|:---------:|
| 0000 call intro       | 0000       | 001B      |  0400      | 03FC      |
| 003E ret (in intro)   | 001B       |0005(放O3FC)|  03FC     | 0400      |
| 0005 call getData     | 0005       | 003F      |  0400      | 03FC      |
| 0058 call validate    | 0058       | 0068      |  03FC      | 03F8      |
| 008A ret (in validate)| 008A       |005D(放03F8)|  03F8     | 03FC      |
| 0000 ret(in getData)  | 0067       |000A(放O3FC)|  03FC      | 0400     |


***

## Beware in MASM procedures

### Avoid duplicate labels
- labels are global identifiers
- Don't use the same label names in different procedures

### Preconditions
Be sure to set required registers before calling library procedures.

### Be aware of registers changed in procedures

### Only invoked by excuting a CALL statement.

### Should terminate by executing a ret statement

### Nested procedure calls
- Any procedure might CALL another procedure
- Return addresses are "stacked" (LIFO)
- RET instructions must follow the order on the stack (Not to jump into or out of a procedure!)

## Documenting Procedures
- Description: Task accomplished by the procedure.
- Receives: List of input parameters, state usage and requirement.
- Retures: Value returned by the procedure.
- Preconditions: Must be satisfied before the procedure is called.
- Registers changed: List of registers that may have different values than they had when the procedure was called.

```
; Procedure to calculate the summation of integers from a to b
; receives: a and b are global variables.
; returns : global sum = a + (a+1) + ... + b
; precondtions: a <= b
; registers changed :eax, ebx, ecx

calculate PROC

  ret
calculate ENDP
```

***

## Saving registers

If a procedure changes any registers, the calling procedure might lose important data.

### So, there are two ways to save data:

1. By the calling procedure: Registers may be saved before call, and restored after return

2. By the called procedure: Register may be saved at the beginning of the procedure, and restore before the return 

### Methods

1. Move register contents to named memory locations, then restore after procedure retruns.

2. Us push and pop : Option1 : calling procedure pushes before call, pops after return || Option2: called procedure pushes at beginning, and pops before return.

3. Slelcted registers on the system stack by push and pop. (General used by high level language)


### Example (in main... aReg, bReg declated in .data)

#### Method1 :Save register contents in memory

```asm
mov   aReg, eax     ; save registers
mov   bReg, ebx

mov   eax,  count   ; set parameters
mov   ebx,  OFFSET val

mov   eax, aReg     ; restore registers
mov   ebx, bReg 
```

#### Method2 : Save all registers on the system stack

```
pushad pushes the 32-bit general-purpose registers onto the stack
- order: EAX, ECX, EDX, EBX, ESP, EBP, ESI, EDI

popad pops the same registers off the stack in reverse order

pusedas   ; save registers
call    somePROC
popad     ; restore registers
```

```
calcSum   PROC
  pushad    ; save registers
  ...
; procedure body
  ...
  popad     ; restore registers
  ret
calcSum   ENDP

```

#### Method3 : Save selected registers on the system stack

```
push eax ; pushes the contents of eax onto the system stacl
pop eax  ; pops the top of the system stack into eax
```

***

## Generating a "listing" file

- At Assembled Code Listing File -> $(InputName).lst
- Lising file shows (hex) offsets of Labels in .data and Instruction and labels in .code
- Also show (hex) opcodes and oprand offsets

***

## Parameter Passing Intoduction

### Definitions:

#### Arguument (Actual parameter)
is a value or reference passed to a procedure.

#### Parameter (Formal parameter)
is a value or refernce received by a procedure.

#### Return value
is a value determined by the procedure, and communicated back to the calling procedure.

***

# Parameter Classifications

### Input Parameter
An input parameter is data passed by a calling program to a procedure. The called procedure is not expected to modify the corresponding argument variable, and even if it does, the modification is confined to the procedure itself.

### Output Parameter (Value will not be used but will assign new Value)
An output parameter is created by passing the address of an argument variable when a procedure is called. The address of a variable is the same as a pointer to or a reference to the variable. In MASM, we use OFFSET.

The procedure does not use any existing data from the variable, but it fills in new contents before it returns.

### Input - Output parameter
Is the address of an argument variable which contains input that will be both used and modified by the procedure. The content is modified at the memory address.


## Method
### 1. Use shared memory (global variables - BAD)

Set up memory contents before call and/or before return.

Generally it's a bad idea to use global variables.

Procedure might change memory contents needed by other procedures.(Unwanted side-effects)

### 2. Pass parameter in registers

Set up registers before call and/or before return.

Generally it;s not a good idea to pass parameters in registers, Procedure might change register contents.

### 3. Pass parameters on the system stack

Push parameter onto the system stack before the call

Two ways to use the parameters:

- Procedure moves parameters from the stack into registers/variables
- Set up a "set frame", and reference parameters directly on the stack.

Remove parameters and return to the calling program.

***
## Registers and Stack Parameters

### Register parameters require dedicating a register to each parameter.

- Require register management.
- They's only one set of registers, if a called procedure changes any registers, the calling producre might lose important data.

```
pushad ; save registers
mov ebx, low
mov ecx, high
call Summation
mov sum, eax
popad  ; restore registers

```

### Stack parameters make better use of system resources.

- Require Stack managment.

```
push low
push high
push OFFSET sum ; place want result to be stored
call Summation
```
***

