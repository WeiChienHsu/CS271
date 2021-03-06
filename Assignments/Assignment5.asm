TITLE Program Assignment5 OptionA -  low-level I/O procedures  (Assignment5.asm)

; Author: Wei-Chien Hsu
; Last Modified: 08/04/18
; OSU email address: hsuweic@oregonstate.edu
; Course number/section: CS 271 Summer 2018
; Assignment Number: Programming Assignment #5  Due Date: 08/12/18
; Program Definition:
; 1. Implement and test "ReadVal" and "WriteVal" procedures for unsigned integers.
; 2. Implement macros getString and displayString. 
; 3. The macros may use Irvine’s ReadString to get input from the user, 
;    and WriteString to display output.
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
;; Do not Copy and Paste - WeiChien Hsu
; 5. Used registers must be saved and restored by the called procedures and macros.
;; Do not Copy and Paste - WeiChien Hsu
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
intro_EC1         BYTE  "**Extra Credit 1:: number each line of user input and display a running subtotal of the user’s numbers.", 0
intro_EC2         BYTE  "**Extra Credit 3:: make your ReadVal and WriteVal procedures recursive.", 0

prompt            BYTE  ". Please ENTER an unsigned integer: ", 0
error_message     BYTE  "The number you ENTERED was not an unsigned integer or it was too large.", 0

comma_sign        BYTE  ", ", 0
goodbye           BYTE  "Results credited by Wei-Chien Hsu. goodbye, enjoy coding! ", 0
UserInput_message BYTE  "The number you ENTERED is: ", 0
Subtotal_message  BYTE  "The running subtotal is: ", 0
Sum_message       BYTE  "The total number you ENTERED is: ", 0
Average_message   BYTE  "The average number is: ", 0

UserInput         BYTE  MAX_STRING DUP(?)
CurrentNumber     BYTE  MAX_STRING DUP(?)
ArraySize         SDWORD  10
count             DWORD 1
arr               SDWORD  10 DUP(?)
Subtotal_number   SDWORD  0

; Do not Copy and Paste - WeiChien Hsu
.code
;-------------------------------------------------------------------
; Main Procedure
;-------------------------------------------------------------------
main PROC
; Introduction
  push    OFFSET  intro_EC2 ; ebp + 28
  push    OFFSET  intro_EC1 ; ebp + 24
  push    OFFSET  intro_4 ; ebp + 20
  push    OFFSET  intro_3 ; ebp + 16
  push    OFFSET  intro_2 ; ebp + 12
  push    OFFSET  intro_1 ; ebp + 8
  call    Introduction
; User Input
  push    count                     ; ebp + 36
  push    ArraySize                 ; ebo + 32
  push    OFFSET Subtotal_message   ; ebp + 28
  push    Subtotal_number           ; ebp + 24
  push    OFFSET error_message      ; ebp + 20
  push    OFFSET prompt             ; ebp + 16
  push    OFFSET arr                ; ebp + 12
  push    OFFSET UserInput          ; ebp + 8
  call    readVal

; Display the value
  push    OFFSET  CurrentNumber     ; ebp + 24
  push    OFFSET  UserInput_message ; ebp + 20
  push    OFFSET  comma_sign        ; ebp + 16
  push    LENGTHOF  arr             ; ebp + 12
  push    OFFSET    arr             ; ebp + 8
  call    WriteVal        
  
; Display the final results (sum and average)
  push    OFFSET  CurrentNumber     ; ebp + 24
  push    OFFSET  Average_message   ; ebp + 20
  push    OFFSET  Sum_message       ; ebp + 16
  push    OFFSET  arr               ; ebp + 12
  push    Subtotal_number           ; ebp + 8
  call    DisplaySumAndAvg


  ; Farewell Bye
  push    OFFSET goodbye            ; ebp + 8
  call    Farewell
  exit

main ENDP

;-------------------------------------------------------------------
; Introduction Procedure
; Description: Print the program introduction and instruction.
; Receives: Strings for introduction and instruction.
; Returns: None.
; Registers Changed: None.
;-------------------------------------------------------------------
Introduction PROC
  push    ebp
  mov     ebp, esp
  push    edi

  mov     edi, [ebp + 8]    ; Intro_1
  DisplayString  edi     
  call  CrLF

  mov     edi, [ebp + 12]   ; Intro_2
  DisplayString  edi
  call  CrLF

  mov     edi, [ebp + 16]   ; Intro_3
  DisplayString  edi
  call  CrLF

  mov     edi, [ebp + 20]   ; Intro_4
  DisplayString  edi
  call  CrLF

  mov     edi, [ebp + 24]   ; Intro_EC1
  DisplayString  edi
  call  CrLF

  mov     edi, [ebp + 28]   ; Intro_EC2
  DisplayString  edi
  call  CrLF
  call  CrLF
  call  CrLF
  pop   edi
  pop   ebp
  ret   24
Introduction ENDP

;-------------------------------------------------------------------
; ReadVal Procedure
; Description: Recevie the user input to validate and transfer to decimal value.
; Receives: Prompt for user input, user input, array, Array Size and error message.
; Returns: None
; Registers Changed: eax, ecx, edx, ebx
;-------------------------------------------------------------------
ReadVal PROC
  push  ebp
  mov   ebp, esp
  pushad
  jmp   BeginStringVal

InvalidStringVal:
  displayString [ebp + 20] ; Display Error message
  call CrLF

BeginStringVal:
  mov   ebx, [ebp + 32]    ; Check the Array Size
  cmp   ebx, 0             ; If the Array Size met 0
  je    EndStringVal       ; End the recursive procedure

  mov   eax, [ebp + 36]    ; Count variable for tracking the subtotal
  call  WriteDec
  getString [ebp + 16], [ebp + 8] ; Used the prompt for asking user input and store the value
  
  cmp   eax, INPUT_SIZE    ; Check the count
  jge   InvalidStringVal    

  mov   ecx, eax           ; Set the length of String
  mov   esi, [ebp + 8]     ; UserInput
  mov   edi, [ebp + 12]    ; Array
  mov   ebx, 10            ; 10 for conversion purpose
  mov   edx, 0             ; Default EDX as 0
  cld                      ; Set a flag for moving forward

StringLoop:
  lodsb
  cmp     al, MAX_ASCII
  jg      InvalidStringVal
  cmp     al, MIN_ASCII
  jl      InvalidStringVal

  sub     al, 48            ; Convert into digit
	movzx		eax, al					  ; extends to fill the size of SWODR
	add			eax, edx				  ; Add the value in to current one
	mul			ebx						    ; move forward by multipling by 10
	mov			edx, eax				  ; store the value
  loop    StringLoop

  ; EDX: Converted digit from User Input String

  mov     eax, edx
  mov     edx, 0
  div     ebx

  ; Deal with subtotal

  DisplayString   [ebp + 28]  ; Print the subtotal message
  push    eax
  add     [ebp + 24], eax     ; Add the current value into subtotal
  mov     eax, [ebp + 24]     ; Move the new subtotal back to eax
  mov     [ebp +  24], eax    ; Update the subtotal
  call    WriteDec            ; Dusplay new Subtotal
  call    CrLF
  call    CrLF
  pop     eax

  ; Store the subtotal into array
  push    eax                 ; ebp + 12  -> subtotal
  push    edi                 ; ebp + 8 -> array
  call    StoreInput

  mov     ebx, [ebp + 32] ; After adding element into array
  dec     ebx             ; Decrease the number of array size by 1
  mov     [ebp + 32], ebx ; Update the array size in the stack

  add     edi, 4          ; Move to the next element in the array
  mov     eax, [ebp + 36] ; Increase the count variable
  add     eax, 1
  mov     [ebp + 36], eax

  ; Push the current varaibles into the stack for recursive purpose
  ; Need to push those variables in the same order

  push    eax         ; count
  push    ebx         ; Array Size
  push    [ebp + 28]  ; Subtotal message
  push    [ebp + 24]  ; Subtotal number
  push    [ebp + 20]  ; Error message
  push    [ebp + 16]  ; Prompt
  push    edi         ; Array (Updated to the next element)
  push    [ebp + 8]   ; UserInput
  call    readVal 

EndStringVal:
  popad
  pop ebp
  ret 32
ReadVal ENDP

;------------------------------------------------------------------
; StroeInput Procedure
; Description: Process the value storing into the Array
; Receives: UserInput, array
; Returns:  None
; Registers Changed: eax, edi
;------------------------------------------------------------------
StoreInput PROC
  push ebp
  mov ebp, esp
  pushad

  mov   edi, [ebp + 8]    ; array
  mov   eax, [ebp + 12]   ; subtotal
  mov   [edi], eax        ; Store the subtatal 

  popad
  pop ebp
  ret 8
StoreInput ENDP


;------------------------------------------------------------------
; WriteVal Procedure (Recursive)
; Description: Call DisplayString
; Receives: @array, number of elements in the array
; Returns: None
; Registers Changed: eax, ebx, ecx, edx
;------------------------------------------------------------------
WriteVal PROC
  push    ebp
  mov     ebp, esp
  pushad  
  ; Check the first call need to
  mov     ebx, [ebp + 12]
  cmp     ebx, 10
  jl      BeginWriteVal
  DisplayString [ebp + 20]  ; Display the input at first time

BeginWriteVal:
	mov		  edi, 0  ; Init the edi
	mov		  ebx, 0	; Init the ebx

	mov		ecx, [ebp + 12]	; Set the counter equal to Array Size
	mov		esi, [ebp + 8]	; Pass Array into the esi for converting next number

	push	[ebp  + 24]		
	push	[esi]			
	call	ConvertIntToString

	
	cmp		ecx, 1			
	je		EndWriteVal ; If the number is last digit, no comma needed

	displayString	[ebp + 16]  ; Print comma
	add		esi,4			          ; Point to the next element

	mov		ecx, [ebp + 12]     ; Update the counter
	dec		ecx

; For the recursion call
; Push the same vairables in the same order
	push	[ebp + 24]	; current
	push	[ebp + 20]	; UserUserInput_message
	push	[ebp + 16]	; comma_sing
	push	ecx			    ; Updated Length of Array
	push	esi			    ; Updated Array
	call	WriteVal 


EndWriteVal:
  popad
  pop   ebp
  ret   20
WriteVal ENDP


;----------------------------------------------------------
; DisplaySumAndAvg Procedure
; Description: Calculates the average number and sum of the elements in the array and display them.
; Receives: UserInput, Subtotal and Sum messsage, array and current 
; Returns: None
; Registers Changed: eax, ebx, ecx, edx, edi and ebp
;----------------------------------------------------------
DisplaySumAndAvg PROC
  push  ebp
  mov  ebp, esp
  pushad
  ; Display the sum of user input
  call  CrLF
  displayString [ebp + 16]  ; sum message
  mov   eax, 10
  mov   edx, 0
  mov   ebx, 0
  mov   ecx, eax            ; Counter sets for 10 times
  mov   eax, 0
  mov   edi, [ebp + 12]     ; array

GetSum:
  add eax, [edi]            ; Dereference the array and add into eax
  add edi, 4                ; Increment the pointer for the next element in array
  
  loop GetSum               ; Display 10 times

  push  [ebp + 24]          ; Current sum [ebp + 12]
  push   eax                ; Current index [ebp + 8]
  call   ConvertIntToString

  call CrLF

  DisplayString [ebp + 20]  ; Display average message
  mov   ebx, 10
  div   ebx

  push  [ebp + 24]
  push  eax
  call   ConvertIntToString

  popad
  pop   ebp
  ret   20
DisplaySumAndAvg ENDP


;---------------------------------------------
; ConvertIntToString Procedure
; Description: Convert Userinput into String
; Receives: Array, current
; Returns: None
; Registers Changed: eax, ebx, ecx, edi and ebp
;---------------------------------------------
ConvertIntToString PROC
	push	ebp
	mov		ebp, esp
	pushad
	mov		ecx, 0				  
	mov		eax, [ebp + 8]		; current
	mov		edi, [ebp + 12]	  ; sum

ToEngDigit:
  mov		edx, 0			
	mov		ebx, 10
	div		ebx           ; Round the number to integer
	cmp		eax, 0
	je		EndDigit			; Meet the last element in array
	add		ecx, 1  
	jmp		ToEngDigit

EndDigit:
	add		ecx, 1				; Increments last digit and places null terminator
	add		edi, ecx
	std
	mov		eax, 0
	mov		al,	0				  ; terminates string with null
	stosb
	mov		eax, [ebp + 8]	

DigitString:
	mov		edx, 0			
	div		ebx					  ; remaind to take next digit
	add		edx, 48				; adds 48 to set to ASCII
	push	eax					  ; saves value to use stosb
	mov		al, dl				
	stosb
	
  pop		eax					  ; pops for next digit
	loop	DigitString
	displayString	[ebp + 12]

	popad
	pop ebp
	ret		8

ConvertIntToString ENDP


;---------------------------------------------
; Farewell Procedure
; Description: Sya goodbye
; Receives: String of goodbye
; Returns: None
; Registers Changed: edx
;---------------------------------------------
Farewell PROC
  push  ebp
  mov  ebp, esp
  mov   edx, [ebp + 8]

  call  CrLF
  call  WriteString
  call  CrLF
  
  pop   ebp
  ret   4
Farewell ENDP


END main
