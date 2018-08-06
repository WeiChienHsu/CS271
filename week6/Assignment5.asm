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

intro_1           BYTE  "- Design low level I/O procedures -", 0
intro_2           BYTE  "- Programed by Wei-Chien Hsu -", 0
intro_3           BYTE  "Please provide 10 unsigned decimal integers which is fit in 32 bit register.", 0
intro_4           BYTE  "The Program will display the integers, their sum and average value. ", 0
intro_EC          BYTE  "**Extra Credit 1:: number each line of user input and display a running subtotal of the user’s numbers.", 0
intro_EC          BYTE  "**Extra Credit 3:: make your ReadVal and WriteVal procedures recursive.", 0

prompt            BYTE  "Please ENTER an unsigned integer: ", 0
error_message     BYTE  "The number you ENTERED was not an unsigned integer or it was too large.", 0

comma_sing        BYTE  ",", 0
goodbye           BYTE  "Results credited by Wei-Chien Hsu. goodbye, enjoy coding! ", 0
UserInput_message BYTE  "The number you ENTERED is: ", 0
Subtotal_message  BYTE  "The running subtotal is: ", 0
Sum_message       BYTE  "The total number you ENTERED is: ", 0
Average_message   BYTE  "The average number is: ", 0

UserInput         BYTE  MAX_STRING DUP(?)
CurrentNumber     BYTE  MAX_STRING DUP(?)
ArraySize         SDWORD  10
count             DWORD 1
arr             SDWORD  10(DUP) ?
Subtotal_number   SDWORD  0


.code
;-------------------------------------------------------------------
; Main Procedure
;-------------------------------------------------------------------
main PROC

main ENDP

;-------------------------------------------------------------------
; Introduction Procedure
; Description: Print the program introduction and instruction.
; Receives: Strings for introduction and instruction.
; Returns: None.
; Registers Changed: None.
;-------------------------------------------------------------------
Introduction PROC

Introduction ENDP

;-------------------------------------------------------------------
; ReadVal Procedure
; Description: Recevie the user input to validate and transfer to decimal value.
; Receives: Prompt for user input, user input, array, Array Size and error message.
; Returns: None
; Registers Changed: eax, ecx, edx, ebx
;-------------------------------------------------------------------
ReadVal PROC

ReadVal ENDP

;------------------------------------------------------------------
; StroeInput Procedure
; Description: Process the value storing into the Array
; Receives: UserInput, array
; Returns:  None
; Registers Changed: eax, edi
;------------------------------------------------------------------
StoreInput PROC

StoreInput ENDP


;------------------------------------------------------------------
; WriteVal Procedure (Recursive)
; Description: Call DisplayString
; Receives: @array, number of elements in the array
; Returns: None
; Registers Changed: eax, ebx, ecx, edx
;------------------------------------------------------------------
WriteVal PROC

WriteVal ENDP


;----------------------------------------------------------
; DisplaySumAndAvg Procedure
; Description: Calculates the average number and sum of the elements in the array and display them.
; Receives: UserInput, Subtotal and Sum messsage, array and current 
; Returns: None
; Registers Changed: eax, ebx, ecx, edx, edi and ebp
;----------------------------------------------------------
DisplaySumAndAvg PROC

DisplaySumAndAvg ENDP


;---------------------------------------------
; ConvertIntToString Procedure
; Description: Convert Userinput into String
; Receives: Array, current
; Returns: None
; Registers Changed: eax, ebx, ecx, edi and edp
;---------------------------------------------
ConvertIntToString PROC

ConvertIntToString ENDP


;---------------------------------------------
; Farewell Procedure
; Description: Sya goodbye
; Receives: String of goodbye
; Returns: None
; Registers Changed: edx
;---------------------------------------------
Farewell PROC

Farewell ENDP


END main
