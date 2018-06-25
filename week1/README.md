# Week 1: Computer Architecture Assembly Basics

-[Introduction to hardware, software and languages](#introduction-to-hardware-software-and-languages)

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




*** 
## Required Reading

Textbook: Irvine
Chapter 1
Chapter 2.1, 2.2, 2.3
Chapter 3.1, 3.2, 3.3 (pg 71 only), 3.4, 3.5