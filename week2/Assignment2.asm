TITLE Program Assignment2 -  Fibonacci Number Printer  (Assignment2.asm)

; Author: Wei-Chien Hsu
; Last Modified: 07/14/18
; OSU email address: hsuweic@oregonstate.edu
; Course number/section: CS 271 Summer 2018
; Assignment Number: Programming Assignment #2  Due Date: 07/15/18
;
; Requirements: 
; 1. The programmer’s name and the user’s name must appear in the output.
; 2. The loop that implements data validation must be implemented as a post-test loop.
; 3. The main procedure must be modularized into at least the following sections:
; a. introduction  b. userInstructions  c. getUserData  d. displayFibs  e. farewell
; 4. The upper limit should be defined and used as a constant.
;
; Problem Definition:
; 1. Display the program title and programmer’s name. 
; 2. Ask the user’s name, and greet the user
; 3. Prompt the user to enter the number of Fibonacci terms to be displayed. 
; 4. Advise the user to enter an integer in the range [1 .. 46].
; 5. Get and validate the user input (n). 
; 6. Calculate and display all of the Fibonacci numbers up to and including the nth term. 
; 7. The results should be displayed 5 terms per line with at least 5 spaces between terms.
; 8. Display a parting message that includes the user’s name, and terminate the program.
; Extra-Credit : Display the numbers in aligned columns.

INCLUDE Irvine32.inc

; Constant Number declaration 
UPPER_LIMIT = 46
LOWER_LIMIT = 1
TAB = 9
NUMBERS_PER_ROW = 5

.data

; Messages
intro_1           BYTE  " - Fibonacci Number Printer - ", 0
intro_2           BYTE  " Programmed by Wei-Chien Hsu", 0
extra_message     BYTE  " Extra Credit:: Display the numbers in aligned columns. ", 0
prompt_1          BYTE  " Please Enter your name: ", 0
prompt_2          BYTE  " Please enter a number as an integer in the range 1 to 46, ", 0
prompt_3          BYTE  " the program will display the Fibonacci terms: ", 0
greet_message     BYTE  " Hello, how are you ", 0
error_outOfRange  BYTE  " Out of the range [1,46]. Please enter a number again: ", 0
exit_message      BYTE  " Program credited by Wei-Chien Hsu. GoodBye! Enjoy coding. ", 0

; Numbers - For counting FIB numbers
currentFibNumber  DWORD 1   ; Record current Fib Number
prevFibNumber     DWORD 0   ; Record previous Fib Number to count the new one
userInputInt      DWORD ?   ; Record a valid user input
rowCounter        DWORD 0   ; Record the current Row number, meet 5 to renew

; User Info
userName          BYTE  21 DUP(0)
byteCount         DWORD ?

.code
main PROC

  call Introduction
  call UserInstructions
  call GetUserData
  call DisplayFibs
  call Farewell

	exit	; exit to operating system

main ENDP
; Introduction ---------------------------------------------------------
; Display the program title and programmer’s name and ask user's name.
; ----------------------------------------------------------------------

Introduction PROC
  mov   edx,  OFFSET intro_1
  call  WriteString
  call  CrLf
  mov   edx,  OFFSET  intro_2
  call  WriteString
  call  CrLf
  mov   edx,  OFFSET  extra_message
  call  WriteString
  call  CrLf
  call  CrLf
  
  mov   edx,  OFFSET  prompt_1 ; Ask user's name
  call  WriteString

  mov   edx,  OFFSET  userName
  mov   ecx,  SIZEOF  userName
  call  ReadString
  mov   byteCount, eax          ; Store user's name
  ret
Introduction ENDP

; UserInstructions -----------------------------------------------------
; Prompt the user to enter the number of Fibonacci terms to be displayed. 
; Advise the user to enter an integer in the range [1 .. 46].
; ----------------------------------------------------------------------

UserInstructions PROC
  mov   edx,  OFFSET  greet_message ; greet user
  call  WriteString
  mov   edx,  OFFSET  userName
  call  WriteString
  call  CrLf
  
  mov   edx,  OFFSET  prompt_2
  call  WriteString
  call  CrLf
  call  CrLf
  ret

UserInstructions ENDP

; GetUserData -----------------------------------------------------------------------------------
; Get and validate the user input (n).
; Used a Do-While logic, let user to input their first option. If the input value is invalid
; Go the the ERROR section to ask for a new number, if the input is valid, skip the ERROR section.
; -----------------------------------------------------------------------------------------------

GetUserData PROC
  DO:
        mov   edx,   OFFSET prompt_3
        call  WriteString
        call  ReadInt
        mov   userInputInt, eax   ; Store user input into userInputInt

        cmp   userInputInt, UPPER_LIMIT ; Compare user input with upper limit
        jg    ERROR
        cmp   userInputInt, LOWER_LIMIT ; Compare user input with lower limit
        jl    ERROR
        jmp   VALIDINPUT                ; If user input is valid, jump to VALIDINPUT section

        ; Ask user re-enter integer in the range
        ERROR:
                mov  edx,  OFFSET error_outOfRange
                call  WriteString
                call  CrLf
                jmp   DO
  ; Do nothing, just receive the user input
  VALIDINPUT:
  call  CrLf
  ret
GetUserData ENDP


; DisplayFibs -----------------------------------------------------------------------------------
; 
; 
; 
; -----------------------------------------------------------------------------------------------


DisplayFibs PROC
  mov   ecx, userInputInt ; Load user input
  FibSequence:
                mov   eax, currentFibNumber ; Load current Fib starts from 1
                call  WriteDec
                cmp   currentFibNumber, 14930352 ; n = 36, n = 35 -> 9227465 smaller than 8 digits
                jge   needMoreTab
                mov   al, TAB                    ; Inorder to Display the numbers in aligned columns
                call  WriteChar
  needMoreTab: 
                mov   al, TAB
                call  WriteChar
                mov   eax, currentFibNumber ; Record current Fib Number for the nwe value
                mov   ebx, currentFibNumber ; Record current Fib Number for the previous value
                add   eax, prevFibNumber    ; Sum current and previous number
                mov   prevFibNumber, ebx    ; Used the temporay stored number in the ebx for previous number
                mov   currentFibNumber, eax ; Assign the result of sum in eax to current Value
                inc   rowCounter            ; Finished count one single number, row counter plus one

                cmp   rowCounter, NUMBERS_PER_ROW ; Check if the new row is needed which is equal to limit number 5
                jne   NoNeedForNewRow
                mov   rowCounter, 0
                call  CrLf

                NoNeedForNewRow:
                loop  FibSequence
  call  CrLf
  call  CrLf
  ret

DisplayFibs ENDP

; Farewell -------------------------
; Say Good BYE ~~~~
; ----------------------------------

Farewell PROC
  mov   edx,  OFFSET exit_message
  call  WriteString
  call  CrLf
  ret
Farewell ENDP

END main
