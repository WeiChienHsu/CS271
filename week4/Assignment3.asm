TITLE Program Assignment3 -  Composite Numbers Printer  (Assignment3.asm)

; Author: Wei-Chien Hsu
; Last Modified: 07/19/18
; OSU email address: hsuweic@oregonstate.edu
; Course number/section: CS 271 Summer 2018
; Assignment Number: Programming Assignment #3  Due Date: 07/24/18
; First, the user is instructed to enter the number of composites to be displayed, 
; and is prompted to enter an integer in the range [1 .. 400].
; If n is out of range, the user is reprompted until s/he enters a value in the specified range. 
; The program then calculates and displays all of the composite numbers up to and including the 
; nth composite. The results should be displayed 10 composites per line with at least 3 spaces 
; between the numbers.
;
; Requirements: 
; 1. The programmer’s name and the user’s name must appear in the output.
; 2. The counting loop (1 to n) must be implemented using the MASM loop instruction.
; 3. The main procedure must consist (mostly) of procedure calls. 
;    It should be a readable “list” of what the program will do.
; 4. Each procedure will implement a section of the program logic, i.e., each procedure will specify
;    how the logic of its section is implemented. The program must be modularized into at least the
;    following procedures and sub-procedures:
; introduction / getUserData / validate / showComposites / isComposite / farewell
; 5. The upper limit should be defined and used as a constant.
; 6. Data validation is required. If the user enters a number outside the range [1 .. 400] an error 
;    message should be displayed and the user should be prompted to re-enter the number of composites.
; Extra Credit1:: Align the output columns.
; Extra Credit2:: Display more composites, but show them one page at a time. The user can “Press any key to
;                 continue …” to view the next page. Since length of the numbers will increase, it’s OK to
;                 display fewer numbers per line. 
; Extra Credit3:: One way to make the program more efficient is to check against only prime divisors, which
;                 requires saving all of the primes found so far (numbers that fail the composite test)


INCLUDE Irvine32.inc

LOWER_LIMIT = 1
UPPER_LIMIT = 400
MAX_NUMBER_PER_PAGE = 50
MAX_NUMBER_PER_COLUMN = 10

.data

; Inrtoduction and promption
intro_1           BYTE    " - Composite Numbers Printer - ", 0
intro_2           BYTE    " - Programmed by Wei-Chien Hsu - ", 0
prompt_1          BYTE    "Please ENTER the number of composite numbers you would like to show on screen. ", 0
prompt_2          BYTE    "Enter the number of composite to display [1 ... 400]: ", 0
prompt1_EC		    BYTE	  "EC:: Aligns the output columns.", 0	
prompt2_EC		    BYTE	  "EC:: Displays the composites one page at a time.", 0	
prompt3_EC		    BYTE	  "EC:: Uses prime divisors to find composite numbers.", 0 
userInputNumber   DWORD   ?

; Error message
error_message     BYTE    " Please enter the number in range [1 ... 400] again: ", 0 

; Calculation of composite numbers
firstComposite   DWORD    4                      ; The number for testing
numberCount       DWORD    ?                      ; Record the total composite number
primesNumber      DWORD    2, 3, 5, 7, 0          ; Prime number as a divisor


; Extra Credits
prompt_NEXT       BYTE   "Press any key to continue... ", 0
columns           DWORD  0        ; Determines the number of composite numbers printed in single line
pageCount         DWORD  ?        ; Format the output in sigle page
threeSpaces       BYTE   "   ", 0 ; Align three digit numbers
twoSpaces         BYTE   "  ", 0  ; Align two digit numbers
singleSpace       BYTE   " ", 0   ; Align one digit numbers

; Fareware
say_goodbye_1     BYTE  "Results credited by Wei-Chien Hsu." , 0
say_goodbye_2     BYTE  "Enjoy ecoing! Bye!", 0

.code
main PROC
  call Introduction
  call GetUserData
  call ShowComposites
  call Farewell
	exit	; exit to operating system
main ENDP

;------------------------------------
; Inteoduction Procedure
; Introduction of the program. 
;------------------------------------
Introduction PROC
  mov     edx, OFFSET intro_1
  call    WriteString
  call    CrLf
  mov     edx, OFFSET intro_2
  call    WriteString
  call    CrLf
  mov     edx, OFFSET prompt1_EC
  call    WriteString
  call    CrLf
  mov     edx, OFFSET prompt2_EC
  call    WriteString
  call    CrLf
  mov     edx, OFFSET prompt3_EC
  call    WriteString
  call    CrLf
  call    CrLf
  ret
Introduction ENDP

;------------------------------------------------
; GetUserData Procedure
; Promots the user to enter number of composites
; they would like to display on screen. 
; Limits the user to input a number in the range,
; checks until the number is verified and store 
; the number into userInputNumber variable.
;------------------------------------------------

GetUserData PROC
  mov     edx, OFFSET prompt_2      ; Ask user to enter a number
  call    WriteString
  call    ReadInt
  mov     userInputNumber, eax
  call    Validate                  ; Call Validate procedure to check the validation 
  ret
GetUserData ENDP


;-------------------------------------------------------------
; Validate Procedure
; Check the user input number with UPPER Limit and LOWER limit
;-------------------------------------------------------------
Validate PROC
  cmp     eax, UPPER_LIMIT     ; Compare the user input with Upper limit (has been stroed in eax register)
  jg      OutOfRange           ; Input could not larger than UPPER LIMIT
  cmp     eax, LOWER_LIMIT     ; Compare the user input with Lower limit (has been stroed in eax register)  
  jl      OutOfRange           ; Input could not less than LOWER LIMIT
  jmp     InputValidated

OutOfRange: ; Ask user to ENTER another number
  mov     edx, OFFSET error_message
  call    WriteString
  call    CrLf
  call    GetUserData          ; Back to GetUserData for asking input 

InputValidated: ; User's input is valid, continue to set up variables to display
  mov     numberCount, 0       ; Init number counter for the results
  mov     columns, 0           ; Init columns to 0
  mov     pageCount, 0         ; Init page number to 0
  ret
Validate ENDP

;---------------------------------------------------------
; ShowComposites Procedures
; Chekc if the number of composites found will exceed
; the number that could be fit in the page by comparing
; MAX_NUMBER_PER_PAGE variable.
;---------------------------------------------------------
ShowComposites PROC

Display:
  mov     eax, pageCount                ; Counter is used to record the current nunmber in this page
  cmp     eax, MAX_NUMBER_PER_PAGE  
  je      GetNewPage
  mov     eax, userInputNumber          ; Compare the number user input with the current displayed number
  cmp     eax, numberCount
  je      exitLoop                      ; Exit the Loop when displayed number equal to user's requests

  call    IsComposite                   ; Check the current number
  inc     firstComposite                ; Increment the Recorded Composite number when we got return value form isComposite
  mov     eax,  columns                 
  cmp     eax,  MAX_NUMBER_PER_COLUMN   ; Compare current column to make sure the display is valid
  je      GetNewLine                    ; Jump to the new Linke
  jmp     Display                       ; Back to the loop, to check the next number

GetNewLine:   ; Display a new line for formatting.
  call    CrLf
  mov     column, 0                     ; Renew the column
  jmp     Display

GetNewPage:   ; Ask user to continue.
  mov     edx, OFFSET prompt_NEXT       ; Ask user to press ENTER 
  call    WriteString

WaitForUser:  ; Wait until user press ENTER to contunue. 
  mov     eax, 50                       ; 
  call    Delay                         ; Delay the OS to time slice for waiting user input
  call    WaitForUser                   ; Still not press ENTER

  mov     pageCount, 0                   ; Reset the number in the page since we have already changed the page
  call    CrLf
  call    Credit1
  jmp     Display

exitLoop:   ; When the number of compositrs displayed equal to user's input
  ret

ShowComposites ENDP

;------------------------------------
;
;------------------------------------
IsComposite PROC


  ret
IsComposite ENDP

;------------------------------------
;
;------------------------------------
Formatting PROC

  ret
Formatting ENDP

;------------------------------------
;
;------------------------------------
Farewell PROC
  mov     edx, OFFSET say_goodbye_1
  call    WriteString
  call    CrLf
  mov     edx, OFFSET say_goodbye_2
  call    WriteString
  call    CrLf  
  ret
Farewell ENDP


END main
