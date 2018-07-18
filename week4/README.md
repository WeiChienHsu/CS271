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

