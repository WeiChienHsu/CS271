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

