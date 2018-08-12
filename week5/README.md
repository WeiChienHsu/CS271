# Passing Parameter into Stack

## RET Instruction
Pops stack into the instruction pointer (EIP)

### RET n 
Optional operand n causes n to be added to the stack pointer after EIP is assigned a value. Equivalent to popping the return address and n additional bytes off the stack.

## Stack Frame
Alos known as an activation record. Area of the stack used for a procedure's return address, passed parameters, saved registers, and local variables.


### Created by the following steps:
1. Calling program pushes arguments onto the stack and calls the procedure.
2. The called procedure pushes EBP onto the stack, and sets EBP to ESP.

## Addressing modes
- Immediate: Constant, literal, absolute address
- Direct: Contents of referenced memory address
- Register: Contents of register
- Register indirect: Access memory through address in a register
- Indexed: Aray name using element "distance" in register
- Base-indexed: Start address in one register; offset in another, add and access memory
- Stack: Memory area specified and maintained as a stackl stack pointer in ESP register
- Offset: Memory Address, may be computed


## Register Indirect Mode (Memory Reference)

[reg] means 'contents of memory at the address in reg'. We have used register indirect with esp to reference the value at the top of the system stck.

```
mov [edx + 12], eax
WRONG -> [eax], [edx]
```

### Explicit Access to Stack Parameters
- A procedure can explicity access stack paramenters using constant offsets from EBP.(ex [ebp + 8] to get first parameter)

- EBP is often called the base pointer or frame pointer because it is set to the base address of the stack frame.

- EBP should not change value during the procedure. 

- Must be restored to its original value when the procedure returns.


## ebp esp eip的几个特性：

1. 主流编译器在函数调用的caller里，执行call指令会让eip(用来存储CPU要读取指令的地址) 入栈

2. 被调函数(callee)里头两句一定是：
push ebp
mov ebp, esp

最后一句一定是：
mov esp, ebp
pop ebp

3. ebp在函数内部是不会改变的，入栈出栈动作只改变esp，于是通过ebp就能反推出整个调用栈了。

反推栈帧的方法：当前的ebp就是当前函数入口时的esp；入口时的[esp-4]就是前一个函数的ebp；入口时的[esp-8]就是前一个函数的eip值；拿到前一个函数的ebp值继续反推就能获得整个调用栈的ebp esp eip，这就是stack frame。

### Example of using EBP and ESP

```
作者：hanjie zou
链接：https://www.zhihu.com/question/284579060/answer/438718205
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

;;---------------------------------------------;;
;;          某个 正经函数 的实现 ('_>')
;;---------------------------------------------;;
func:
    ;;--(1)-- 用 ebp 代理 esp
    push  ebp       ;;-- 将 ebp 原有值存入 函数栈帧
    mov   ebp, esp  ;;-- 将 esp 的值 赋予 ebp。
                    ;;-- 现在，ebp 成为 esp 的代理人。通过 ebp 来获得参数

        ;;--(2)-- 以下 3个寄存器 将会在函数中用到，我们先将它们原有的数据压入函数栈中
        ;;    等函数正文执行完毕了, 再回来取。
        push  ebx   
        push  esi   
        push  edi   

            ;;--(3)-- 通过 ebp 来找到 函数的 参数
            mov  edi, [ebp + 8]  ;;-- 参数 1
            mov  esi, [ebp + 12] ;;-- 参数 2
            mov  ebx, [ebp + 16] ;;-- 参数 3

            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            ;;          ...
            ;; 函数的 正文部分。实现函数的功能
            ;;          ...
            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        ;;--(4)-- 取回 3个寄存器的 原有数据。 pop的次序 和 当初push的次序 是相反的。
        pop  edi
        pop  esi
        pop  ebx

    ;;--(5)-- 原样 恢复 ebp 与 esp 的值。
    mov  esp,  ebp
    pop  ebp

    ;;--(6)-- 正式从 本函数 返回。
    ret
```

esp 是动态的，只要出现 push/pop 动作，esp的值就会改变。在函数正文中我们可是要通过 esp 来寻找 函数参数的。一个动态的 esp显然不可靠。也许你会说，为什么不在函数开始处，就通过 esp找到参数，并将这些参数 存入 寄存器（edi, esi, ebx）中？  是的，这么做没问题，但是如果 寄存器 edi, esi, ebx 已经存有重要数据呢 ？如何 保护这些数据的安全。如果优先 push 这些寄存器，esp的值也将发生改变。于是，我们用一个 通用寄存器 ebp 来充当代理人。在函数实现的一开始就让 ebp == esp，并且在整个函数周期内，ebp的值都不发生改变。  现在，ebp成了一个信标，它稳稳地站在那，为后续所有指令提供指引。

所以，使用ebp压栈，并把此时esp传递给ebp后，一是为了安全，在子过程和父过程的栈之间有ebp，二是方便操作，在子过程里不用考虑esp在哪，都可以始终用ebp+8（这里描述的是32位处理器模式）来引用第一个参数，ebp+12引用第二个参数等，从子过程返回时，直接ebp赋值给esp，然后弹出恢复原ebp，此时esp指向父过程的返回地址，子过程正常返回

***


## Stack Frame Example

```
.data
x DWORD 175
y DWORD 37
z DWORD ?
.code
main PROC
  push x
  push y
  push OFFSET z
  call SumTwo

```

|         |          |
|:-------:|:--------:|
| [ESP]   |  return@ |
|[ESP+4]  |   %z     |
|[ESP+8]  |  37      |
|[ESP+12] | 175      |


```
SumTwo PROC
  push ebp
  mov  ebp, esp
  mov  eax, [ebp + 16] ; 175 in eax
  add  eax, [ebp + 12] ; add 37 in stack, push 212 in eax
  mov  ebx, [ebp + 8]  ; Address of z in ebx
  mov  [ebx], eax      ; store 212 in z
  pop  ebp
  ret  12
Sum ENDP
```
- After mov ebp, esp

|         |          |
|:-------:|:--------:|
| [ESP]   | old EBP  |
|[ESP+4]  |  return@ |
|[ESP+8]  |   %z     |
|[ESP+12] |  37      |
|[ESP+16] | 175      |

- After pop ebp

|         |          |
|:-------:|:--------:|
|[ESP+4]  |  return@ |
|[ESP+8]  |   @z     |
|[ESP+12] |  37      |
|[ESP+16] | 175      |

- After ret 12

Pop out all ESP + 4 (ret) - ESP + 16 (12)

***

## Why dont we just use ESP instead of EBP

ESP 永遠指向 Stack Frame 的 Top，利用 mov ebp, esp 讓ebp來處理所有 Address access 操作。

- Pushes and Pops inside the procedure might cause us to lose the base of the stack frame.

## Trouble Avoidance Tips

- Save and Restore registers when they are modified by a procedure. Exception: A Register that returns a function result.

- Do not pass an immediate value or variable contents to a procedure that expect a reference parameter. (Dereferencing it as an address will likely cause a genral-protection fault)

***


# Introduction to Arrays

## Declaration (in data segment)

```
MAX_SIZE = 100
.data
list DWORD   MAX_SIZE DUP(?)
count DWORD  0
```

- Defines an uninitialized array named list with space for 100 32-bit integers.
- Array elements are in contiguous memory.
- count to track how many spaces are used. 
- Array declaration defines a name for the first element only.

- All other elements are accessed by calculating the actual address. (Without of starting from beginning and count it from start)
- General formula for array address calculation:

```
address of list[k] = address of list + (k * sizeof element)
```

### If we reference list[100] 
In assembly language, we didin't get any compile-time error. So, it's not easy to predict. 

***

# Indexed & Registered Indirect & Base-indexed

## Indexed Addressing

Only using array for global array references (Not used in Program # 5)

```
mov   edi, 0            ; high-level notation 
mov   list[edi], eax    ; list[0]
add   edi, 4      
mov   list[edi], ebx    ; list[1]
```

We add the value in the [] to address of list.

## Register Indirect Addressing

Actual address of array element in register, used for referencing array elements in procedures.

- In calling procedure

```
push   OFFSET list
```

- In called procedure

```
mov   esi, [ebp + 8]  ; get address of list into esi
mov   eax, [esi]      ; get list[0] into eax
add   esi, 4 
add   eax, [esi]      ; add list[1] to eax
add   esi, 16  
mov   [esi], eax      ; send result to list[5]
```

## Base-Indexing

Starting address in one register, offset in another; add and access memory. Used for referencing array elements in procedures.

- In calling procedure

```
push   OFFSET list
```

- In called procedure

```
mov   edx, [ebp + 8]    ; get address of list into edx
mov   ecx, 20      
mov   eax, [edx + ecx]  ; get list[5] into eax
mov   ebx, 4
add   eax, [edx + ebx]  ; add list[1] to eax
mov   [edx + ecx]. eax  ; send result in eax to list[5]
```

## Passing arrays by reference

Suppose that an ArrayFill procedure fills an array with 32-bit integers

The calling program passes the address of the array, along with count of the number of array elements.

```
COUNT = 100
.data
  list DWORD COUNT DUP(?)
.code
  ...
  push OFFSET list
  push COUNT
  call ArrayFill
```

### Register indirect addressing

eid points to the beginning of the array, so it's easy to use a loop to access each array element.

```
ArrayFill PROC
  push ebp
  mov ebp, esp
  mov edi, [ebp + 12] ; @list in edi
  mov ecx, [ebp + 8]  ; value of count in ecx
more:
  ; Code to generate a random number in eax gose here.
  mov [edi], eax      ; put value into array
  add edi, 4          ; increment start pointer by 4
  loop more

  pop ebp
  ret 8
ArrayFill ENDP
```

### Base Indexing

```
ArrayFill PROC
  pushad                  ; save all registers
  mov  ebp, esp
  mov  edx, [ebp + 40]    ; @list in edx
  mov  ebx, 0             ; "index" in ebx
  mov  ecx, [ebp + 36]    ; value of count in ecx
more:
  ; Code to generate a random number in eax gose here.
  mov [edx + ebx], eax      
  add ebx, 4          
  loop more

  popad                   ; restore all registers
  ret 8
```

***

# Displaying Arrays & Using Random Numbers

## ArrayFill Procedure

```
main

push OFFSET list    ; Address of first element in the list
push count          ; Number of elements in the list
call ArrayFill

ArrayFill PROC
  push ebp
  mov  ebp, esp     ; Make the Stack Frame

  mov edi, [ebp + 12] ; Put the Address of first element in list into edi
  mov ecx, [ebp + 8]  ; Put the count variable in to ecx for Looping

RandomLoop:
  ; Code for generating the Random number and store into EAX
  mov [edi], eax      ; Deference the address stored in EDI and put the value from EAX
  add edi, 4          ; Increase the number of edi to point to next element in list
  loop  RandomLoop

; Pop out the original ebp and return the return address and additional elements
  pop  ebp
  ret  8
ArrayFill ENDP
```


## Problem

### Registers Indirect Addressing

```
Given the following register states, and using Register Indirect Addressing, which of the following lines of code will move the 11th element of the list array (of DWORDs) to the EAX register?

EDX register contans the address of the first element of list.
ESI register contains the address of the eleventh element of list.
EBX register contains the value 40,
```

- mov eax, [esi]


### Stack Frame (with not only DWORD 4 bytes)

Suppose that you are given the following program. After the instruction "mov ebp, esp", which of the following is referenced by each of the following?


```
.data
x   DWORD  153461
y   WORD   37
z   WORD   90


.code
main PROC
   push  x
   push  y
   push  z
   call  someProcedure
   ...
   exit
main ENDP

someProcedure PROC
   push ebp
   mov ebp, esp
   ...

   pop ebp
   ret 8
someProcedure ENDP
END MAIN
```


| Address | Content       |
|:-------:|:-------------:|
| ebp     | Original ebp  |
| ebp + 4 | The return Address from called Procedure  |
| ebp + 8 | Value of z (2 bytes)   |
| ebp + 10 | Value of y (2 bytes)   |
| ebp + 12 | Value of x (4 bytes)    |


### List access

Given the following partial data segment, what value would I put in the brackets in list4 4  to access the 7th element of list? (Ignore the .0000 that Canvas may append to your answer).

```
.MAX = 50
.data
list  DWORD    MAX   DUP(0)
a     DWORD    25
b     DWORD    15
```

- 24