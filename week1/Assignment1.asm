TITLE Program Assignment1 -  Easy Arithmetic   (Assignment1.asm)

; Author: Wei-Chien Hsu
; Last Modified: 07/06/18
; OSU email address: hsuweic@oregonstate.edu
; Course number/section: CS 271 Summer 2018
; Assignment Number: Programming Assignment #1  Due Date: 07/08/18
; Description: Write and test a MASM program to perform the following tasks:
; 1. Display my name and program title on the output screen.
; 2. Display instructions for the user.
; 3. Prompt the user to enter two numbers.
; 4. Calculate the sum, difference, product, (integer) quotient and remainder of the numbers.
; 5. Display a terminating message. 
; 6. Extra-credit: Program will Validate the second number to be less than the first. 
; 7. Calculate and display the quotient as a floating-point number, rounded to the nearest .001
; 8. Repeat until the user chooses to quit. 

INCLUDE Irvine32.inc

.data

; Users Insruction and Introduction

firstNum        DWORD	?		; First User Integer Input
secondNum       DWORD	?		; Second User Integer Input
intro           BYTE	"Easy Arithmetic by Wei-Chien Hsu", 0
instruction	    BYTE	"Please enter two numbers to see their sum, difference, product, quotient, and remainder. ", 0

; Extra Credit :: Instruction

Extra_intro1    BYTE		"**EC Program will Validate the second number to be less than the first.", 0
Extra_intro2	  BYTE		"**EC Program will repeat until the user chooses to quit.", 0
Extra_intro3	  BYTE		"**EC Program will calculate and shows quotient to the nearest .001.", 0

; User Arithmetic Display

firstDisplay    BYTE    "First Number: ", 0
secondDisplay   BYTE    "Second Number: ", 0

; Result Display

sumResult		    DWORD	?		; result of sum
diffResult		  DWORD	?		; result of difference
prodResult		  DWORD	?		; result of product
quotResult		  DWORD	?		; result of quotient
remResult		    DWORD	?		; result of remainder

sumDisplay		  BYTE		" + ", 0
diffDisplay		  BYTE		" - ", 0
prodDisplay		  BYTE		" * ", 0
quotDisplay		  BYTE		" / ", 0
remDisplay		  BYTE		"Remainder(integer): ", 0
floatDisplay	  BYTE    "Extra Credit :: Quotient as a floating-point number: ", 0
equalDisplay	  BYTE		" = ", 0

; End or Restart Program

rptInpt 	      DWORD   ?
whileLoop_1     BYTE    "Enter 0 to quit the exection and 1 to restart.", 0
whileLoop_2     BYTE    ? ; Get user option
endProg		      BYTE		"BYE BYE! Enjoying coding! ", 0

; Extra Credit :: Convert To Float Point

Floatremainder  DWORD	?			
dot             BYTE	".",0				; Decimal place for float 
FloatingPoint   REAL4	?	          ; Real single precision floating point variable
ConvertToRound  DWORD	1000		    ; convert an int to a floating point number rounded to .001
floatMyThousand DWORD	0				    ; represents the float multiplied by 1000
front           DWORD	?					  ; First part of the quotient
back            DWORD	?				    ; Second part after decimal place
temp            DWORD	?						

errorMessage    BYTE	"Error Message: Your first number must be larger than the second number.", 0	


.code
main PROC

; Introduction and Instruction

    mov edx, OFFSET intro
    call  WriteString
    call  CrLF

    mov edx, OFFSET instruction
    call  WriteString
    call  CrLF

    mov edx, OFFSET Extra_intro1
    call  WriteString
    call  CrLF

    mov edx, OFFSET Extra_intro2
    call  WriteString
    call  CrLF

    mov edx, OFFSET Extra_intro3
    call  WriteString
    call  CrLF
    call  CrLF


WhileLoop:  ; Start the Program

; Get First number
    mov   edx, OFFSET firstDisplay
    call  WriteString
    call  ReadInt
    mov   firstNum, eax

; Get second number
    mov   edx, OFFSET secondDisplay
    call  WriteString
    call  ReadInt
    mov   secondNum, eax
    call  CrLF

; Present Numbers
    mov   eax, firstNum
    mov   ebx, secondNum
    cmp   eax, ebx
    jl    Error				; if input invalid, send user to the Error Session

; Calculation and Output 

; Sum: num1 + num2
    mov   eax, firstNum
    mov   ebx, secondNum		
    add   eax, ebx			
    mov   sumResult, eax

    mov   eax, firstNum
    call  WriteDec
    mov   edx, OFFSET sumDisplay
    call  WriteString
    mov   eax, secondNum
    call  WriteDec
    mov   edx, OFFSET equalDisplay
    call  WriteString
    mov   eax, sumResult
    call  WriteDec
    call  CrLF


; Difference: num1 - num2
    mov   eax, firstNum
    mov   ebx, secondNum		
    sub   eax, ebx			
    mov   diffResult, eax

    mov   eax, firstNum
    call  WriteDec
    mov   edx, OFFSET diffDisplay
    call  WriteString
    mov   eax, secondNum
    call  WriteDec
    mov   edx, OFFSET equalDisplay
    call  WriteString
    mov   eax, diffResult
    call  WriteDec
    call  CrLF

; Product: num1 * num2
    mov   eax, firstNum
    mov   ebx, secondNum		
    mul   ebx	              ; eax multipled	by ebx	
    mov   prodResult, eax

    mov   eax, firstNum
    call  WriteDec
    mov   edx, OFFSET prodDisplay
    call  WriteString
    mov   eax, secondNum
    call  WriteDec
    mov   edx, OFFSET equalDisplay
    call  WriteString
    mov   eax, prodResult
    call  WriteDec
    call  CrLF

; With Extra Credit ::
; Quotients (quotResult -> eax , remResult -> edx)
    mov   eax, firstNum
    mov   ebx, secondNum	
    mov   edx, 0
    div   ebx					; divides eax by ebx, edx becomes remainder.
    mov   quotResult, eax		
    mov   remResult, edx

; Extra Credit :: Float Number transforms

    fld   firstNum    ; load first number into ST(0) register
    fdiv  secondNum  ; divided by secondNumber
    fimul ConvertToRound
    frndint
    fist  floatMyThousand
    fst   FloatingPoint ; pops the register stack and take value off stack


; Quotients Output
    mov   eax, firstNum
    call  WriteDec
    mov   edx, OFFSET quotDisplay
    call  WriteString
    mov   eax, secondNum
    call  WriteDec
    mov   edx, OFFSET equalDisplay
    call  WriteString
    mov   eax, quotResult
    call  WriteDec
    call  CrLF

    mov   edx, OFFSET remDisplay
    call  WriteString
    mov   eax, remResult
    call  WriteDec
    call  CrLF
    call  CrLF

    mov   edx, OFFSET floatDisplay
    call  WriteString
    call  CrLF
    mov   eax, firstNum
    call  WriteDec
    mov   edx, OFFSET quotDisplay
    call  WriteString
    mov   eax, secondNum
    call  WriteDec
    mov   edx, OFFSET equalDisplay
    call  WriteString

    mov   edx, 0
    mov   eax, floatMyThousand
    cdq
    mov   ebx, 1000
    cdq
    div   ebx
    mov   front, eax
    mov   Floatremainder, edx
    mov   eax, front
    call  WriteDec
    mov   edx, OFFSET dot
    call  WriteString

; Calculate remainder
    mov   eax, front
    mul   ConvertToRound
    mov   temp, eax
    mov   eax, floatMyThousand
    sub   eax, temp
    mov   back, eax
    call  WriteDec

    call  CrLF
    call  CrLF

; While loop break point - Ask user to end or restart

  mov   edx, OFFSET whileLoop_1		; Ask for restrating the program
  call  WriteString
  call  ReadInt
  mov   rptInpt, eax
  cmp   rptInpt, 1
  je    WhileLoop

; terminate progeam
  mov   edx, OFFSET endProg		; output the goodbye message
  call  WriteString		
  call  CrLF					
  exit	                      ; exit to operating system

Error:
  mov   edx, OFFSET errorMessage
  call  WriteString
  call  CrLF
  jmp   WhileLoop


main ENDP
END main
