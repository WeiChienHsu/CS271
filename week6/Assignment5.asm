TITLE Program Assignment5 OptionA -  low-level I/O procedures  (Assignment5.asm)

; Author: Wei-Chien Hsu
; Last Modified: 08/04/18
; OSU email address: hsuweic@oregonstate.edu
; Course number/section: CS 271 Summer 2018
; Assignment Number: Programming Assignment #5  Due Date: 08/12/18
;
; Program Definition:
; 1. Implement and test "ReadVal" and "WriteVal" procedures for unsigned integers.
; 2. Implement macros getString and displayString. 
; 3. The macros may use Irvine’s ReadString to get input from the user, 
;    and WriteString to display output.
;
; getString: Should display a prompt, then get the user’s keyboard input 
;            into a memory location.
; displayString: Should the string stored in a specified memory location. 
; readVal: Should invoke the getString macro to get the user’s string of 
;          digits. It should then convert the digit string to numeric, 
;          while validating the user’s input.
; writeVal: Should convert a numeric value to a string of digits, and invoke 
;           the displayString macro to produce the output. 
;
; A small test program that gets 10 valid integers from the user and stores 
; the numeric values in an array. The program then displays the integers, 
; their sum, and their average.
;
; Requirements:
; 1. User’s numeric input must be validated the hard way: Read the user's input 
;    as a string, and convert the string to numeric form. 
;    If the user enters non-digits or the number is too large for 32-bit registers, 
;    an error message should be displayed and the number should be discarded. 
;
; 2. Conversion routines must appropriately use the lodsb and/or stosb operators.
;
; 3. All procedure parameters must be passed on the system stack.
;
; 4. Addresses of prompts, identifying strings, and other memory locations 
; should be passed by address to the macros. 
;
; 5. Used registers must be saved and restored by the called procedures and macros.
;
; 6. The stack must be "cleaned up" by the called procedure.

INCLUDE Irvine32.inc

MAX_STRING EQU  15
INPUT_SIZE EQU  10
MAX_ASCII  EQU  57
MIN_ASCII  EQU  48

;---------------------------------------------
; Take buffer and put it into EDX and then 
; writeString to Display the buffer
;---------------------------------------------
DisplayString MACRO stringMessage 
  push edx
  mov  edx, stringMessage
  call WriteString
  pop  edx
ENDM

;---------------------------------------------
; Display prompts and then read the user
; input in a string.
;---------------------------------------------
GetString MACRO stringPrompt, stringAddress 
  push edx
  push ecx

  mov edx, stringPrompt ; Display the instruciotn
  call  WriteString

  mov edx, stringAddress; To stroe the input string
  mov ecx, MAX_STRING   ; Set a max size
  call     ReadString   ; read user input and save into input

  pop ecx
  pop edx

ENDM


.data

intro_1           BYTE  "", 0
intro_2           BYTE  "", 0
intro_3           BYTE  "", 0
intro_4           BYTE  "", 0
intro_EC          BYTE  "", 0
intro_EC          BYTE  "", 0

prompt            BYTE
error_message     BYTE

comma_sing        BYTE  "", 0
goodbye           BYTE  "", 0
UserInput_message BYTE  "", 0
Subtotal_message  BYTE  "", 0
Sum_message       BYTE  "", 0
Average_message   BYTE  "", 0

UserInput         BYTE
CurrentNumber     BYTE
ArraySize         SDWORD  10
count             DWORD 1
arr             SDWORD  10(DUP) ?
Subtotal_number   SDWORD  0


.code

  main PROC

  main ENDP




END main
