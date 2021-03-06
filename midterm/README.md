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

***
## Grneral Purpose Registers

```
一般寄存器:AX、BX、CX、DX
AX:累积暂存器，BX:基底暂存器，CX:计数暂存器，DX:资料暂存器

索引暂存器:SI、DI
SI:来源索引暂存器，DI:目的索引暂存器

堆叠、基底暂存器:SP、BP
SP:堆叠指标暂存器，BP:基底指标暂存器
```

EAX、ECX、EDX、EBX：為ax,bx,cx,dx的延伸，各為32位元
ESI、EDI、ESP、EBP：為si,di,sp,bp的延伸，32位元

eax, ebx, ecx, edx, esi, edi, ebp, esp等都是X86 汇编语言中CPU上的通用寄存器的名称，是32位的寄存器。如果用C语言来解释，可以把这些寄存器当作变量看待。

比方说：add eax,-2 ; //可以认为是给变量eax加上-2这样的一个值。



这些32位寄存器有多种用途，但每一个都有“专长”，有各自的特别之处。

- EAX 是"累加器"(accumulator), 它是很多加法乘法指令的缺省寄存器。

- EBX 是"基地址"(base)寄存器, 在内存寻址时存放基地址。

- ECX 是计数器(counter), 是重复(REP)前缀指令和LOOP指令的内定计数器。

- EDX 则总是被用来放整数除法产生的余数。

- ESI/EDI分别叫做"源/目标索引寄存器"(source/destination index),因为在很多字符串操作指令中, DS:ESI指向源串,而ES:EDI指向目标串.

- EBP是"基址指针"(BASE POINTER), 它最经常被用作高级语言函数调用的"框架指针"(frame pointer). 在破解的时候,经常可以看见一个标准的函数起始代码:
```　
push ebp ;保存当前ebp
mov ebp,esp ;EBP设为当前堆栈指针
sub esp, xxx ;预留xxx字节给函数临时变量.
```

这样一来,EBP 构成了该函数的一个框架, 在EBP上方分别是原来的EBP, 返回地址和参数. EBP下方则是临时变量. 函数返回时作 mov esp,ebp/pop ebp/ret 即可.

- ESP 专门用作堆栈指针，被形象地称为栈顶指针，堆栈的顶部是地址小的区域，压入堆栈的数据越多，ESP也就越来越小。在32位平台上，ESP每次减少4字节。


***

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

#### Select the correct EVEN parity 12 bit Hamming code value for the unsigned integer value 202

0011  1000  1010 

#### 1001  0011  0111 is an ODD parity 12 bit Hamming code that contains a single-bit error. What is the corresponding uncorrupted Hamming code?

1001  0010  0111 

#### 0111  0110  1011 is an EVEN parity 12 bit Hamming code that contains a single-bit error. What is the corresponding uncorrupted Hamming code?

0111  0110  1111 


***

# Indirect Addressing
Use a register as a pointer and manipulate the register's value. (EAX,EBX,ECX,EDX,ESI,EDI,EBP,ESP) surrounded by brackets. The register is assumed to contain the address of some data. 

```
.data
byteVal BYRE 10h
.code
mov esi, OFFSET byteVal
mov al, [esi]
```
ESI contains the offset of byteVal. The MOV instruction uses the indirect operand as the source, the offset in ESI is dereferenced, and a byte is moved to AL.

## Arrays
```
.data
arrayW WORD 1000h, 2000h, 3000h
.code
mov esi, OFFSET arrayW
mov ax, [esi]           ; ax = 1000h
add esi 2
mov ax, [esi]           ; ax = 2000h
add esi 2
mov ax, [esi]           ; ax = 3000h
```

```
.data
arrayD DWORD 1000h, 2000h, 3000h
.code
mov esi, OFFSET arrayD
mov eax, [esi]
add esi, 4
add eax, [esi]
add esi, 4
add eax, [esi]
```
## Saving and Restroing Registers

Procedures often save the current contents of registers on the stack before modifying them. Ideally, the registers in question should be pushed on the stack just after setting EBP to ESP, and just before reserving space for local variables. This helps us to avoid changing offsets of existing stack parameters.

***

### Place the stesp for creating a stack frame in the correct order

1) Passed arguments, if any, are pushed on the stack.

2) The subroutine is called, causing the subroutine return address to be pushed on the stack.

3) As the subroutine begins to execute, EBP is pushed on the stack.

4) EBP is set equal to ESP. From this point on, EBP acts as a base reference for all of the subroutine parameters.

5) If there are local variables, ESP is decremented to reserve space for the variables on the stack.

6) If any registers need to be saved, they are pushed on the stack.



***

# Cheat Sheet

ASCII alphabetic letters > than decimal digits |||  Assembly language instructions and machine language instructions: one to one. 
Largest signed integer that may be stored in 32 bits. 2^31 – 1 |||   in 24 bits = 16,777,215
Two's complement of an integer is formed? reversing (inverting) the bits and adding 1  |||  33, 95, 257 -> 21, 5F, 101
Signed 33: 00100001 – 1 -> reverse: 11011111 = -33 -> reverse + 1 = signed 33
1MB memory can be addressed in Real-address mode.  |||  4 parts of a CPU: clock, registers, control unit, arithmetic logic unit
control bus: synchronize actions of all devices attached to the system bus. ||| 4GB memory can be addressed in Protected mode
Time delay in a CPU caused by differences between the speed of the CPU, the system bus, and memory circuits? wait state
instruction execution cycle is the program counter incremented: Fetch  |||   REAL8 defining 64-bit IEEE long reals
List2 begins at offset 2000h. What is the offset of the third value (5)? List2 WORD 3,4,5,6,7 2004h.
A program that combines object files into an executable program is a linker || ESI, EDI: 32-bit registers extended index registers
The three types of buses connected to the CPU are data, address, control.
An array of 500 signed doublewords named myList and initializes each element to the value -1. myList SDWORD 500 DUP (-1)
big endian: The byte-ordering scheme to store large integers in memory with the high-order byte at the lowest address.
.code: directive identifies the part of a program containing instructions.
The following data segment starts at memory address 0x2300 (hexadecimal) dueDate DWORD ? -> 68 -> 0x2344 .data printString BYTE "Assembly is fun",0 = 16 + moreBytes BYTE 48 DUP(0) = 48 + dateIssued DWORD ? = 4 = 68
Instruction Execution Cycle: Fetch/Decode/Fetch Operands/Execute/ Store output operands
 A common programming error is to inadvertently initialize ECX to zero before beginning a loop 
The USES operator, coupled with the PROC directive, lets you list the names of all registers modified within a procedure.

ESI: contains the starting address of data when calling DumpMem? ESP:  always points to the last value to be added to, or pushed on, the top of stack. GetMseconds: procedure returns the number of milliseconds elapsed since midnight
Gotoxy: procedure locates the cursor at a specific row and column on the screen. WriteHex:  writes an unsigned 32-bit integer to standard output in hexadecimal format  EDX: contains the offset of a character array when calling GetCommandTail. 
ReadInt: reads a 32-bit signed decimal integer from standard input. call WriteInt: CALL instructions writes the contents of EAX to standard output as a signed decimal.  IsDigit:sets the Zero flag if the AL register contains the ASCII code for a decimal digit.

EAX / EBX (base) / ECX (count, REP) / EDX (reminder) Speed: Optical Dick -> Main memory -> Cache -> Registers (Fastest)

important uses of runtime stacks in programs: 1) When the CALL instruction executes, the CPU saves the current subroutine’s return address on the stack. 2) The stack provides temporary storage for local variables inside subroutines. 3) When calling a subroutine, you pass input values called arguments by pushing on the stack. 4) A stack makes a convenient temporary save area for registers when they are used for more than one purpose. After they are modified, they can be restored to their original values.
Instructions used to manipulate the ESP register are: RET/ CALL/ PUSH/ POP

Instruction execution cycle: Fetch the instruction at the address in Instruction Pointer into Instruction Register -> Increment the Instruction Pointer to point to next instruction -> Decode the instruction -> If the instruction requires memory access, determine the memory address and fetch the operand from memory into CPU register or send the operand from CPU register -> Execute the instruction -> If the output operand is in memory, the control unit use write operation to store the data
The INC instruction does not affect the Carry flag.   XCHG reg,mem XCHG reg,reg XCHG mem,reg
mov al, 0CFh; and al, 2Bh; -> 0Bh  |||  inverts bits 5 and 6 in BL without changing any other bits: xor bl,1100000b
single instruction that clears bits 0, 3, and 4 in the AL register: and al,11100110b
Single instruction that complements all bits in AL, without using the XOR instruction: not al
DIV/MUL: mem/reg IMUL: reg, imm mem ||| The MUL (unsigned multiply) instruction comes in three versions.
The operand of the MUL (unsigned multiply) instruction can be different sizes.
Identify the sizes of the sign 1, exponent 8, and significand 23 for a Single Precision x86 floating point number.
ODD parity 12 bit Hamming code value for the unsigned integer value 191 1010  0111  1111 |||  EVEN 137 : 0111  0000  1001
0101 0000 1001 is an EVEN parity 12 bit Hamming code -> correct 0101 0000 1000
Hamming Code: 1-> 3,5,7,9,11. 2 -> 3, 6, 7, 10, 11. 4 -> 5, 6, 7, 12. 8 -> 9, 10, 11, 12

In the x86 Floating-Point, a decimal number contains three components: a sign, a significand, and an exponent.
The CALL instruction pushes the address of the next instruction onto the stack and then loads the address of the called procedure into EIP. The JMP instruction has no effect on the system stack.




Sign flag: indicates that an operation produced a negative result. Auxiliary Carry flag: set when a 1 bit carries out of position
Parity flag :Indicates whether or not an even number of 1 bits occurs in the least significant byte of the destination operand, immediately after  an arithmetic or boolean instruction has executed.
Stack parameters are compatible with high­level languages.Stack parameters reduce code clutter because registers do not have  to be saved and restored. A subroutines stack frame always contains the callers return address and the subroutines local variable
arguments pushed on stack procedure called EBP pushed on stack EBP set to ESP.
Which action must take place inside a procedure to reserve space on the stack for two doubleword local variables? after MO EBP,ESP, subtract 8 from the stack pointer (ESP)  ||| Instruction: label, mnemonic, operand(s), comment
when the LOCAL directive is used to declare a doubleword variable push ebp | mov ebp,esp | sub esp,4
a directive is executed at assembly time |  an instruction is executed at runtime 
Carry flag: unsigned integer overflow. Overflow flag: signed integer overflow Zero flag: an operation produced zero
When values are received by a called subroutine, they are called Parameters, passed Arguments
stack frame (Activation record): The area of the stack set aside for passed arguments, subroutine return address, local variables, and saved registers.
Assuming that a procedure contains no local variables, a stack frame is created by which sequence of actions at runtime? arguments pushed on stack; procedure called; EBP pushed on stack; EBP set to ESP
Passing by reference requires dereferencing a parameter’s offset from the stack inside the called procedure.
1.	pass argument, if any, are pushed on the stack
2.	The subroutine is called, causing the subroutine return address to be pushed on the stack
3.	As the subroutine begins to execute, EBP is pushed on the stack
4.	EBP is set equal to ESP. From this point on, EBP acts as base reference for all the subroutine parameters
5.	If there are local variables, ESP is decrement to reverse space for the variables on the stack
6.	If any registers need to be saved, they are pushed on the stack.

In the Intel x86 architecture, the register that always points to the next instruction to be executed is the: EIP
Using the Intel IA32 instruction set please write a program that accepts an unsigned binary integer in the AX register and pushes the decimal ASCII equivalent value onto the system stack. For example, suppose that the AX register initially contains: 0b1001011001101011 (decimal value 38507). After your program has fully executed, the system stack should contain the following numbers

; AX already contains the unsigned integer  MOV BX, 10000 ; I'll use BX to store my divisor  MOV CL, 10 ; Keep dividing the divisor by 10 First the divisor will be 10000, then it will be 1000, ; then 100, then 10  loopAgain:     MOV DX, 0 ; DIV instruction that divides DX:AX by 16 bit number and places the quotient in AX and the remainder in DX. 
   DIV BX ; The quotient is in AX and the remainder is in DX ADD AX, 48 ; Convert the quotient into ASCII 
   PUSH AX ; Push the ASCII value onto the stack If the remainder was 0 then we can quit 
   CMP DX, 0 
  JE finished ; Now we need to calculate the next divisor by dividing the existing divisor by 10 
  MOV AX, BX ; Copy the current divisor into AX 
  DIV CL ;Divide AX (the current divisor) by 10 AL now contains the next divisor 
  MOVZX BX, AL ; Move AL into BX and fill the top byte with zeros Now move the dividend into AX so we can divide it 
  MOV AX, DX ; (DX has the remainder from the first division) 
JMP loopAgain ; Repeat the loop

EAX = 3 (the last prime number that EBX pointed to)  EBX = 257 (the memory location of the last prime number that was used while factoring)  ECX = 3 (a copy of EAX)  EDX = 281 (the memory location of the newLine array)

EAX = 1 (the number than the user initially provided)  EBX = 256 (the memory location of the first prime number in the array) 
ECX = 0 (the code never changes ECX after it is initialized to 0)  EDX = 281 (the memory location of the newLine array)

Yes, we are dividing EAX by the value in the primeNums array pointed to by EBX. AL and AH are portions of the EAX register. EAX was initialized to 0 in all 32 bits at the start of the program. Then, before we perform the division, we set AH to zeros and set AL to the value in the num variable. So everything in EAX is zeros except for the rightmost 8 bits, which are set to the value in the num variable. 

AL is a symbol for a portion of the full EAX register. So if you changed the value in AL and then called WriteDec, WriteDec would print something based on the entire 32 bits in the EAX register, the rightmost 8 of which you just changed by modifying AL. If the other bits in EAX besides AL are not all zeros, it would print something you weren't expecting. That's why this program begins by setting the entire EAX register to 0.

I think this explanation in the solutions document is incorrect, it should have said that ECX is set to the value in primeNums pointed to by EBX.
primeNum's starting address is 100h, which converts to 256 in decimal. Adding 1 to 100h gives 101h, or 257 in decimal.
