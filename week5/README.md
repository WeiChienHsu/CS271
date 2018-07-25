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
A procedure can explicity access stack paramenters using constant offsets from EBP. (ex [ebp + 8] to get first parameter)

EBP is often called the base pointer or frame pointer because it is set to the base address of the stack frame.

EBP should not change value during the procedure. Must be restored to its original value when the procedure returns.


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
|[ESP+8]  |   %z     |
|[ESP+12] |  37      |
|[ESP+16] | 175      |

- After ret 12

Pop out all ESP + 4 - ESP + 16

***

## Why dont we just use ESP instead of EBP

- Pushes and Pops inside the procedure might cause us to lose the base of the stack frame.

## Trouble Avoidance Tips

Save and Restore registers when they are modified by a procedure. Exception: A Register that returns a function result.

***

# Introduction to Arrays




***

# Displaying Arrays & Using Random Numbers