# Week 1: Computer Architecture Assembly Basics

[Introduction to hardware, software and languages](#introduction-to-hardware-software-and-languages)

[How Computer Hardware Works](#how-computer-hardware-works)


***
# Introduction to hardware software and languages

## Problem-Solving Language View by "Levels"

### Natural Languages
- English, Spainsh
- Used by huamns
- Many Interpretations
- Translated to programming languages by computer programmers
- Word Processors


### High-Level computer programming languages
- Java, C++, Perl, Python
- English-like, protable various architrctures ** 可以跨平台運作
- Strict rule of syntax and semantics
- Translatd to lower levels by  【compilers/translators】
- Text editor, libraries, compiler, linker, loader, debugger
- Eclipse, Visual C++ etc.


### Low-Level computer programming languages
- Intel assembly, Mac assembly
- Mnemonic instructions for specific computer architectures** 必須要針對特殊的電腦架構
- Translated to machine language by 〖assemblers〗
- Text editor, libraries, assembler, linker, loader, debugger
- Any text editor together with MASM, Visual C++, etc.


### Machine-level computer languages
- Intel mahcine instructions, Mac machine instructions
- Actual binary code instructions for specific architecture
- Some way to assign machine instructions directly into computer memory
- Set Individual bits(switches), lader

***

## Computer Languages / Computer hardware (Simplified)

### Level 4: Probelm solution in natural language
- Description of algorithm, solution design
- Programmer translates to

### Level 3: Computer program in high-level computer programming language
- Source code(machine independent)
- Compiler translates to

### Level 2: Program in assembly language
- Machine specific commands to control hardware components
- Assembler translates to

#### Level 1: Program in machine code
- Operating System does partial translation
- The hardware's instruction set architecture(ISA) provides a micro-program for each machine instruction(CISC* ) or direct execution(RISC*)

#### Level 0: Actual computer hardware
- Program in electronic form

***

## Assembly Language(Not a machine language)

### 1. Set of mnemonics for machine instructions
- Opcodes and addressing modes

### 2. Mechanism for naming memory addresses and other constants.
- Noed: a named memory address is usually called a variable

### 3. Other conveniences for developing source code for particular machine architecture.

An assembler is a software system that takes assembly language as input and produces machine language as output.(Object code)

## Opearting System
- Provide interfaces among users, programs, and devices(including the host computer itself).

- Implemented for specific architecture (in the host computer's machine language) and Recognize the machine instructure sets.

***

## Relationshop between Instruction Set and Architecture

A computer's instruction set is defined by the computer's architecture.
(each computer archecture has its own machine language)

- Cross-assemblers(software) can be used to convert a machine language to another machine language.
- Virtual Machine(Software) can be used to simulate anothr computer's architecture.

##### Hardware: Physical devices
#### Software: Instructions that control hardward

Sometimes, the line between hardward and sofrware is not clear since parts of an operating system might be implemented in hardware.

```
Anything that can be implemented in software could be implemented in hardware and it would execute much faster.

## Discussion Question #1

If it's so much faster, why isn't everything implemented in hardware?
```
***

## System Architrctures (From large to tiny)

- Super Computer
- Mainframe
- Multiprocrssor/Parallel(multi-core)
- Server
- Distributed(Collection of Workstations)
- Personal Computer
- Micro-Controller(Real-time/Embedded System)

```
## Discussion Question #2
Try to explain: How big is namometer?

## Discussion Questoin #3
What does Moore's Law mean?
```
***

## Why use assembly language
- Easier than machine code (electrical signals)
- Access to all features of target machine by command codes
- Performance(Maybe) - Higer level language didn't have access to memory 
- Using mixed Languages (Some function with assembly with C language)
- Note that assembly language tends to evolve toward a high-level language

## Common uses of assembly language
- Embedded systems (Efficiency is critical)
- Real-Time applications (Timing is critical)
- Interactive Games(Speed is cirtical)
- Low-Level tasks(Direct control is cirtical)
- Device Drivers

***

# How Computer Hardware Works

## Preliminaries
Inside a computer, information is represented electrically. Smallest unit of information is a "switch".

We Often represent 'off' as 0 and 'on' as 1, so a single switch represents "a binary digit" and is called a 'bit'.

Different combination of switches represent different information. (A group of 8 bits is called a byte)

### A Simple CISC Computer

![CISCC](./images/CISCComputer.png)

### Peripheral Devices (Exernal Devices) 
- Store/Retrieve data(Non-volatile Storage)
- Convert data between human-readable and machine readable froms.


### I/O Unit: Hardware/Software functions
- Communicate between CPU/Memory and peripheral devices.
- Virtual Memory Interface
- Virtual File System Interface
- I/O

### Main memory Unit: Cells with address
- Store programs and data currently being used by the CPU(volatile storage)

### CPU: Central Processing Unit
- Execute machine instructions

***

## Components of CPU

### Bus: Parallel "wires" for transferring a set of electrical signals simultaneously
- Interanl: Transfer signals among CPU components
- Control: Carries signals for memory and I/O operations
- Address: Linkes to specific memory locations
- Data: Carries data CPU <=> memory

### Register 
- Fast local memory inside the CPU

### ALU 
Arithmetic/Logic Unit

### Microprogram
Sequence of micro-instructions (implemented in hardware) required to execute a machine instruction

### Micromemory
The actual hardware circuits that implement the machine instructions as microprograms.

***

## CPU Registers 

- Control Registers: dictates current state of the machine (Which signal goes where)

- Status Registers: indicates status of operation(error, overflow, etc) (Used by Control Regiseter) 

### Addressing Unit

- MAR (Memory Address Register): Hold address of memory location currently referenced

- MDR (Memory Data Register): Holds data being sent to or retrieved from the memory address in the MAR

### Instructions

- IP (Instruction Pointer) : Holds memory address of next instruction

- IR (Instruction Register) : Holds current machine instruction

- Starting Adress Generator (SAG)

- Instruction Decoder

### Arithmetic/Logic Unit (ALU)

- Operand_1, Operand_2, Result: ALU registers (for calculations and comparisons)

### Temporary Stroage

- General: Fast temporary storage

*** 
## Cache
An area of comparatively fast temporary stroage for information copied from slower storage.

- Program instructions are moved from secondary storage to main memory, so they can be accessed more quickely.
- Data is moved from main memory to a CPU register, so it can be accessed instantaneously.

Caching takes place at several levels in a computer system.

***

## Instruction Execution Cycle

- IP (Instruction Pointer)
- IR (Instruction Register)

1. Fetch next instruction (at address in IP) into IR.

2. Increment IP to point to next instruction.

3. Decode instruction in IR

4. If instruction requires memory access,

- Determine memory address.
- Fetch operand from memoyr into a CPU register, or send operand from a CPU register to memory.

5. Execute micro-program for instruction
6. Go step 1 (unless the "halt" instruction has been executed)

```
## Discussion 
In the instruction Execution Cyle, why is it important to change the instruction pointer in step2? Wouldn't it work just as well to change it after step 5?
```
***

## Example CISC Instruction

```asm
ADD R1, mem1 ;Example assembly language instruction
```

1. Copy contents of R1 to ALU Operand_1
2. Move address mem1 to MAR
3. Singal memory fetch (get contents of memory address currently in MAR into MDR)
4. Copy contents of MDR into ALU Operand_2
5. Singal ALU addition
6. Set Status Register and Copy contents of ALU Result to register R1

***
## Conclsion 

Even in the simplest architectures
- Bus Arbitration required
- CPU scheduling required

As architrctures become more complex
- Multi-processor coordination required
- Cache management required

***
## Required Reading

Textbook: Irvine
Chapter 1
Chapter 2.1, 2.2, 2.3
Chapter 3.1, 3.2, 3.3 (pg 71 only), 3.4, 3.5