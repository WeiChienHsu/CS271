# How Computer Works
- Assembly language has a 1-1 relationship with machine language.
- High Level language have one-to-many relationship with assembly or machine instructions.
- High-Level/Assembly/Instruction set architecture/Digital logic

## Instruction Exection Cycle
1. CPU fetch the instruction from an area of memory called the instruction queue. Increment the instruction pointer.

2. CPU decode the instruction by looking at its binary bit pattern. The bit pattern might reveal that the instruction has operands (input value).

3. If operands are involved, the CPU fetches the operands from registers and memory. Sometimes, it involves address calculations.

4. CPU executes the instruction, using any operand values it fetched during the eariler steps. Updates a few status flags such as Zero, Carry and Overflow.

5. If an output operand was part of the instruction, the CPU stroes the result of its execution in the operand.


## 32-bit General-Purpose Registers
EAX EDX: used by multiplication and division instrucion. Extended Accumulator Register.
EBX 
ECX: Loop Counter
EBP : Used by high-level languages to reference funcitno parameters and local variables on the stack.

ESP : address data on stack (a system stack memory structrue). Rarely used for ordinary arithmetic or data transfer. Extended Stack Pointer Register.

ESI EDI : Used by high-speed memory transfer instructions.

EIP: (instruction pointer) contains the address of the next instruction to be executed. Causing the program to branch to a new location.  

## CISC Instruction
1. Copy contents of R1 to ALU Operand_1
2. Move address mem1 to MAR
3. Singal memory fetch (get contents of memory address currently in MAR into MDR)
4. Copy contents of MDR into ALU Operand_2
5. Singal ALU addition
6. Set Status Register and Copy contents of ALU Result to register R1

## MASM Instruction
- Mark beginning of program segments: .data / .code
- Mark special labels: main proc / varName DWORD

### Addressing modes
Permitted for the operands associated with each code.

- Immediate: Constant, Literal, Absolute address
- Register : Content of register
- Direct   : Contents of referenced memory address
- Offset   : Memory address; may be calculated

## Operands

### Mul

```
mov eax, 10
mov ebx, 12
mul ebx			; result is in eax (120), with possible overflow in edx (now edx is changed)
```

### Div

```
mov eax, 100
cdq 					; extend the sign into edx
mov ebx, 9
div ebx				; quotient is in eax (11) ; remainder is in edx 1
```

```
mov   eax, firstNum
mov   ebx, secondNum	
mov   edx, 0
div   ebx					; divides eax by ebx, edx becomes remainder.
mov   quotResult, eax		
mov   remResult, edx
```

## Irvine Library
ReadString - Reads a string from keyborad, terminated by the Enter Key.(Precondition: OFFSET of memory destination in EDX, SIZE of memory destinaiton in ECX)
WriteInt, WriteDex - Writes an integer to the screen(Precondition: value in EAX)
WriteString - Writes a null-terminated string to the screen (Precondition: OFFSET of memory location in EDX)

***

## Repetition Structures

### Pre-test loop (While)

```
    mov   eax, x      ; initialize accumulator
dbLoop:               ; Double x while x <= 1000 (When s is positive)
    cmp   eax, 1000
    jg    endLoop
    add   eax, eax
    jmp   dblLoop
endLoop: 
    mov   x, eax
```

### Post-test loop (do-while)

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

## Binary form of negative

-13 in 16-bit two-complement

```
| -13 | = 13 =    0000 0000 0000 1101
one complement is 1111 1111 1111 0010
add 1 to get      1111 1111 1111 0011 = -13
```

## Character and control codes

ASCII 256 codes (1-byte)
- 'A' ... 'Z' are codes 65 - 90
- '0' ... '9' are codes 48 - 57
