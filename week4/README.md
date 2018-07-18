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