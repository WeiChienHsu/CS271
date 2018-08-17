TITLE Program Assignment4 -  Random Numbers Sorting  (Assignment4.asm)
; Author: Wei-Chien Hsu
; Last Modified: 07/26/18
; OSU email address: hsuweic@oregonstate.edu
; Course number/section: CS 271 Summer 2018
; Assignment Number: Programming Assignment #4  Due Date: 08/05/18
;
; Get a user request in the range 10 to 200 and generate request random integers
; in range 100 to 999, stroing them in consecutive elements of an array.
; Display the list of integers "before sorting, 10 numbers per line."
; Sort the list in descending order and Calculate and display the medium value, 
; rounded to the nearest integer. 
; Display the sorted list, 10 numbers per line.
; Requirements: 
; 1. The title, programmer's name, and brief instructions must be displayed on the screen.
; 2. The program must validate the user’s request.
; 3. min, max, lo, and hi must be declared and used as global constants. 
;    Strings may be declared as global variables or constants.
;
; 4. The program must be constructed using procedures. At least the following procedures are required:
;    Main / Introduction / GetData {para: request(reference)} / FillArray {para: request(value), array(reference)} /
;    SortList {para: array(reference), request(value)} :
;       exchange elements (for most sorting algorithms): 
;       {para: array[i] (reference), array[j] (reference), 
;         where i and j are the indexes of elements to be exchanged.
;    DisplayMedian {para: array(reference), request(value)}
;    DisplayList (only one) {para: array(reference), request(value), title(reference)}
;
; 5. Parameters must be passed by value or by reference on the system stack as noted above. 
;
; 6. There must be just "one" procedure to display the list. This procedure must be called twice: 
;    once to display the unsorted list, and once to display the sorted list.
;
; 7. Procedures (except main) should not reference .data segment variables by name. 
;    request, array, and titles for the sorted/unsorted lists should be declared in the .data segment, 
;    but procedures must use them as parameters. Procedures may use local variables when appropriate. 
;    Global constants are OK.
;
; 8. The program must use appropriate addressing modes for array elements.
; 9. The two lists must be identified when they are displayed (use the title parameter for the display procedure).
; 
; Extra Credit 2 :: Use a recursive sorting algorithm
; Extra Credit 3 :: Implement the program using floating-point numbers and the floating-point processor
; Extra Credit 5 :: Other: Added alignment procedure for displaying

INCLUDE Irvine32.inc

  MAX_INPUT = 200
  MIN_INPUT = 10
  HI_RANGE = 999
  LO_RANGE = 100 
  RANGE    = HI_RANGE - LO_RANGE + 1

.data
; Introduction
intro_1   BYTE  " -- Sorting Random Numbers -- ", 0
intro_2   BYTE  " -- Programmed by Wei-Chien Hus -- ", 0
intro_3   BYTE  "This program generates a list of random numbers from 100 to 999, ", 0
intro_4   BYTE  "displays the original list, sorted list, and calculates the median.", 0
intor_EC1  BYTE  " Extra Credit :: Use a recursive sorting algorithm - Merge Sort ", 0
intor_EC2  BYTE  " Extra Credit :: Implement the program using floating-point numbers and the floating-point processor ", 0
intor_EC3  BYTE  " Extra Credit :: Created procedures to change text color and continue until user quits  ", 0

; User Instruction
instruct_1    BYTE  " Now, we're going to create a list of random numbers. ", 0
prompt        BYTE  " Please ENTER the total number of random digits between [10 and 200]: ", 0
error_msg     BYTE  " Input number is out of the RANGE. ", 0

; Titles
sortedTitle     BYTE  ":: Sorted Array : ",13, 10, 0
unsortedTitle   BYTE  ":: Unsorted Array : ",13, 10, 0
medianTitle     BYTE  ":: Median Number : ", 0

; Array
random_arr    WORD  200 DUP(?)
userInput     DWORD  ?

; EXIT message
again_title   BYTE  "Run the program again? ", 0
again_msg     BYTE  "PRESS yes to again the program or no to leave", 0
good_bye      BYTE  "Results credited by Wei-Chien Hsu. Goodbye! Enjoy coding.", 0

.code
main PROC

  ; Intorduction
  push  OFFSET intro_1    ; [ebp + 36]
  push  OFFSET intro_2    ; [ebp + 32]
  push  OFFSET intro_3    ; [ebp + 28]
  push  OFFSET intro_4    ; [ebp + 24]
  push  OFFSET intor_EC1  ; [ebp + 20]
  push  OFFSET intor_EC2  ; [ebp + 16]
  push  OFFSET intor_EC3  ; [ebp + 12]
  push  OFFSET instruct_1 ; [ebp + 8]
  call Introduction

Redo:
  ; GetData
  push  OFFSET  error_msg ; [ebp + 16]
  push  OFFSET  prompt    ; [ebp + 12]
  push  OFFSET  userInput ; [ebp + 8]
  call  GetData

  ; Fill random numbers into the Array
  call  Randomize          ; Procedure provided by Irvine32
  push  RANGE              ; [ebp + 20]
  push  LO_RANGE           ; [ebp + 16]
  push  userInput          ; [ebp + 12]
  push  OFFSET random_arr  ; [ebp + 8]
  call  FillArray

  ; Display the unsorted Array and marked the color as Blue
  call  SetTextBlue
  push  OFFSET  unsortedTitle ; [ebp + 16]
  push  userInput             ; [ebp + 12]
  push  OFFSET  random_arr    ; [ebp + 8]
  call  DisplayList       
  call  CrLf
  call  CrLf  

  ; Sort Array 
  push userInput          ; [ebp + 12]
  push OFFSET random_arr  ; [ebp + 8]
  call SortList

  ; Dispaly Median and marked the color as Green
  call  SetTextGreen
  push  OFFSET medianTitle    ; [ebp + 16]
  push  userInput             ; [ebp + 12]
  push  OFFSET random_arr     ; [ebp + 8]
  call  displayMedian   
  call  CrLf 

  ; Display the sorted Array and marked the color as Purple
  call  SetTextPurple
  call  CrLf
  push  OFFSET sortedTitle      ; [ebp + 16]
  push  userInput               ; [ebp + 12]
  push  OFFSET random_arr       ; [ebp + 8]
  call  DisplayList
  call  CrLf
  call  CrLf

  ; Ask user for continue
  mov   eax, 600
  call  delay
  mov   ebx, OFFSET again_title
  mov   edx, OFFSET again_msg
  call  msgboxAsk
  cmp   eax, IDYES      ;6 for yes, 7 for no
  je    Redo

  push OFFSET good_bye
  call FareWell


	exit	; exit to operating system
main ENDP


;--------------------------------------------------------------------
PrintString MACRO string
; Make the variable in .data section passed as reference not name.
;--------------------------------------------------------------------
  mov   edx, string
  call  writeString
ENDM

;--------------------------------------------------------------------
Introduction PROC
; Displays program name, my name, program description and extra credits.
; Pre conditions: progName, author, and instruct shoud be defined.
; Receives: Those strings at [ebp + 8] [ebp + 12] [ebp + 16] [ebp + 20]
; [ebp + 24] [ebp + 28] [ebp + 32] [ebp + 36]
; Returns: Nothing
;--------------------------------------------------------------------
  ;; Set Stack Frame and Push Registers
  push  ebp
  mov   ebp, esp
  push  edx

  call SetTextGrey
  PrintString [ebp + 36] ; intro_1
  call CrLf
  PrintString [ebp + 32] ; intro_2 
  call CrLf  
  PrintString [ebp + 28] ; intro_3
  call CrLf
  PrintString [ebp + 24] ; intro_4
  call CrLf
  PrintString [ebp + 20] ; EC_1
  call CrLf
  PrintString [ebp + 16] ; EC_2
  call CrLf
  PrintString [ebp + 12] ; EC_3
  call CrLf  
  call CrLf
  PrintString [ebp + 8] ; instruct_1
  call CrLf
  call CrLf
  
  pop    edx
  pop    ebp
  
  ret 32
Introduction ENDP



;--------------------------------------------------------------------
GetData PROC
; Get abd Store user's valid input around 10 to 200.
; Pre conditions: Push address of user input into the stack before called
; Receives: Address of UserInput variable [ebp + 8] (need to be updated), strings of
; error message [ebp + 16] and strings of prompt to user [ebp + 12].
; Returns: User input Stroed in the variable UserInput already
;--------------------------------------------------------------------
  ; Set Stack Frame and Push Registers
  push  ebp
  mov   ebp, esp
  push  edx
  push  eax

AskForUser:
  call SetTextWhite
  printString [ebp + 12] ; prompt
  call readInt           ; Read User input and store into EAX Register
  call CrLf
  cmp eax, MAX_INPUT      ; Data Validation
  jg   Invalid
  cmp eax, MIN_INPUT
  jge  Valid

Invalid:
  call SetTextRed
  printString [ebp + 16] ; error message
  call CrLf
  jmp  AskForUser

Valid:
  mov   edx, [ebp + 8] ; Store the address of userInput into edx Register
  mov   [edx], eax     ; Save the User Input into the address of UserInput Variable by dereference

  pop eax
  pop edx
  pop ebp
  ret 12
GetData ENDP


;--------------------------------------------------------------------
FillArray PROC
; Fill in the value in the array by the numbers generated from Randomize procedure
; Pre conditions: Push address of array and value of UserInput into stack
; Receiveds: Value of user input [ebp + 12] and the Address of Array's first element [ebp + 8] 
;            Pass the global variables LO_Range and Range into Stack as well.
; Returns: Need to use ebp combines esp as a counter to fill in the array.
;          Thus, procedure will return the filled array back.
;--------------------------------------------------------------------

  ;; Set Stack Frame and Push Registers
    push ebp
    mov ebp,esp 
    push eax
    push ecx
    push edi
    mov ecx, [ebp + 12]   ; User Input
    mov edi, [ebp + 8]    ; Random Numbers Array

GetNextRandomNumber:
    mov eax, [ebp + 20]
    call RandomRange
    add eax, [ebp + 16]     ; Generate the number by adding LOW limitation
    
    mov WORD PTR [edi], ax ; store the result
    add edi, 2
    loop GetNextRandomNumber  ; Loop until counter equal to 0

    pop edi
    pop ecx
    pop eax
    pop ebp   
    ret 16
FillArray ENDP

;--------------------------------------------------------------------
SortList PROC
; Implementaion of Merge Sort, split the array to left and right and 
; sort them seperately. Store them in a temporary array in ordered and
; move the result into our pushed array in the stack.
; Receives: Value of array size [ebp + 12] and Random numbers array [ebp + 8]
;--------------------------------------------------------------------
    ;; Set Stack Frame and Push Registers
    push ebp
    mov ebp,esp 
    push edi
    push esi
    push edx
    push ecx
    push eax
    push ebx

  
    mov dx, [ebp + 12]  ; User Input (Array Size)
    cmp dx, 1           ; When the last Merge Sort called only has one element
    je BaseCase

    ; if onlt 2 elements exchange and return
    cmp dx, 2
    jne CreateAndFillTempArray

    mov esi, DWORD PTR [ebp + 8]
    mov bx, word ptr [esi]
    cmp bx, word ptr [esi+ TYPE WORD] ; Compare Previous value and Next Value
    ja BaseCase                       ; No need to Swap
    
    push esi                ; Previous Index [ebp + 8]
    add esi, TYPE WORD
    push esi                ; Next Index  [ebo + 12]
    call Swap

    jmp BaseCase

  CreateAndFillTempArray:
	  sub esp, DWORD PTR [ebp + 12]
    sub esp, DWORD PTR [ebp + 12]
    mov esi, DWORD PTR [ebp + 8]
    mov edi, esp

    cld
    mov ecx, DWORD PTR [ebp + 12]
    rep movsw


    ; Sort Left
    mov esi, esp
    mov edx, DWORD PTR [ebp + 12]
    shr edx, 1
    push edx
    push esi
    call SortList


    ; Sort Right
    mov ecx, DWORD PTR [ebp + 12]
    and ecx, 0FFFFFFFEh             ; clear LSB
    add ecx, esp

    mov edx, DWORD PTR [ebp + 12]
    shr edx, 1
    jc isOdd
    jmp isEven

isOdd:    
    inc edx

isEven:
    push edx
    push ecx
    call SortList


    ; ecx points to mid list and will serve as sentinal for left
    ; edx will serve as alternate source pointer from right list
    ; eax will serve as sentinal for right list

    mov eax, edi 
    mov edx, ecx
    mov esi, esp 
    mov edi, DWORD PTR [ebp + 8]
    cld

Merge:
    cmp esi, ecx
    je Sorted_Right

    cmp edx, eax
    je Sorted_Left

    mov bx, word ptr [esi]
    cmp bx, [edx]

    ja AppendFromLeft

AppendFromRight:
    xchg edx, esi
    movsw
    xchg edx, esi
    jmp Merge               ; Append right part to the temp array

AppendFromLeft:
    movsw
    jmp Merge                 ; Append left part to the temp array

Sorted_Right:
    mov ecx, eax
    mov esi, edx              ; Sort right side

Sorted_Left:
    sub ecx, esi              ; Sort left side
    shr ecx, 1
    rep movsw

RemoveTempArray:    
    add esp, DWORD PTR [ebp + 12]	   
    add esp, DWORD PTR [ebp + 12]


BaseCase:
    ; End the sorting Procese
    pop ebx
    pop eax
    pop ecx
    pop edx
    pop esi
    pop edi
    pop ebp    
    ret 8
SortList ENDP


;--------------------------------------------------------------------
Swap PROC
; Swap two different vlaues from stack [ebp + 8] and [ebp + 12]
;--------------------------------------------------------------------
    push ebp
    mov ebp,esp 
    push eax
    push ebx
    push esi
    push edi

    mov esi, DWORD PTR [ebp + 8]    ; First Index
    mov edi, DWORD PTR [ebp + 12]   ; Second Index

    mov ax, WORD PTR [esi]  ; Make a temperory variable
    mov bx, WORD PTR [edi]

    mov [esi], bx           ; Assign the exchanged value
    mov [edi], ax

    pop edi
    pop esi
    pop ebx
    pop eax
    pop ebp  
    Ret 8
Swap ENDP



;--------------------------------------------------------------------
DisplayMedian PROC
; Determines median of array and print it out
; Pre conditions: push User Input and Sorted Array.
;--------------------------------------------------------------------
    push ebp
    mov ebp,esp 
    push eax
    push ecx
    push edx
    push esi

    mov ecx, [ebp + 12]   ; UserInput
    mov esi, [ebp + 8]    ; OFFSET of random numbers array

    PrintString [ebp + 16]   ; Output title


    ; ODD NUM ELEMENTS:   median adress + 1 BYTE
    ; EVEN NUM ELEMENTS:  first element of second half

    btr ecx, 0
    jc isOdd

    movzx eax, WORD PTR [esi + ecx ]
    add ax, WORD PTR [esi + ecx - TYPE WORD]
    shr eax, 1              ;div by 2 to find average
    jc  Round               ;carry bit indicates result of xx.5
    jmp Result

Round:
    inc eax
    jmp Result

isOdd:
    movzx eax, WORD PTR [esi + ecx]

Result:
    call WriteDec
    call crlf
    pop esi
    pop edx
    pop ecx
    pop eax

    pop ebp     ;restore callers stack frame
    ret 
DisplayMedian ENDP

;--------------------------------------------------------------------
DisplayList PROC
; Receives: Strings of displaying array [ebp + 16], user input as array size
;           [ebp + 12] and Address of first element in random number array [ebp + 8]
; Pre conditions: push the values which need to be swap in both eax and ecx
;--------------------------------------------------------------------
  ;; Set Stack Frame and Push Registers
    push ebp
    mov ebp,esp 
    push eax
    push ecx
    push esi
    push edx
    push ebx

    mov ecx, [ebp + 12]   ; num values requested
    mov esi, [ebp + 8]    ; array adress
    PrintString [ebp + 16]

    mov ebx, 10           ; Number in each Raw

GetNextNumber:

    movzx eax, WORD PTR [esi]
    call WriteDec

    push ecx
    mov ecx, 4             ; Space added 4 times
    mov al, ' '

    space: 
    call WriteChar
    loop space
    pop ecx

    dec ebx
    jz RenewLine        ; numbers per line reached
    jmp NoNeedForNewLine  ; else

  RenewLine:
    call crlf      ; Change Line
    mov ebx, 10    ; reset numbers line count

  NoNeedForNewLine:
    add esi, 2
    loop GetNextNumber

    pop ebx
    pop edx
    pop esi
    pop ecx
    pop eax
    pop ebp     
    Ret 12
DisplayList ENDP


;--------------------------------------------------------------------
FareWell PROC
; Make the text blue, prvided by Irvine-32 Library
;--------------------------------------------------------------------
  push  ebp
  mov   ebp, esp
  push  eax
  push  edx
  call  SetTextGreen
  printString [ebp + 8]
  call  CrLf
  pop   edx
  pop   eax
  pop   ebp

  ret   4
FareWell ENDP


;--------------------------------------------------------------------
SetTextBlue PROC
; Make the text blue, prvided by Irvine-32 Library
;--------------------------------------------------------------------
  push      eax
  mov       eax, 11
  call      setTextColor
  pop       eax

  ret
SetTextBlue ENDP

;--------------------------------------------------------------------
SetTextGreen PROC
; Make the text green, prvided by Irvine-32 Library
;--------------------------------------------------------------------
  push      eax
  mov       eax, 10
  call      setTextColor
  pop       eax

  ret
SetTextGreen ENDP

;--------------------------------------------------------------------
SetTextGrey PROC
; Make the text grey, prvided by Irvine-32 Library
;--------------------------------------------------------------------
  push      eax
  mov       eax, 7
  call      setTextColor
  pop       eax

  ret
SetTextGrey ENDP

;--------------------------------------------------------------------
SetTextPurple PROC
; Make the text purple, prvided by Irvine-32 Library
;--------------------------------------------------------------------
  push      eax
  mov       eax, 13
  call      setTextColor
  pop       eax

  ret
SetTextPurple ENDP

;--------------------------------------------------------------------
SetTextRed PROC
; Make the text red, prvided by Irvine-32 Library
;--------------------------------------------------------------------
  push      eax
  mov       eax, 12
  call      setTextColor
  pop       eax

  ret
SetTextRed ENDP

;--------------------------------------------------------------------
SetTextWhite PROC
; Make the text normal, prvided by Irvine-32 Library
;--------------------------------------------------------------------
  push      eax
  mov       eax, 15
  call      setTextColor
  pop       eax

  ret
SetTextWhite ENDP

END main
