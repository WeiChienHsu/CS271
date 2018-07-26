TITLE Program Assignment4 -  Composite Numbers Printer  (Assignment3.asm)

; Author: Wei-Chien Hsu
; Last Modified: 07/19/18
; OSU email address: hsuweic@oregonstate.edu
; Course number/section: CS 271 Summer 2018
; Assignment Number: Programming Assignment #3  Due Date: 07/24/18
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

.data
; Introduction
intro_1   BYTE  " -- Sorting Random Numbers -- ", 0
intro_2   BYTE  " -- Programmed by Wei-Chien Hus -- ", 0
intro_3   BYTE  "This program generates a list of random numbers from 100 to 999, ", 0
intro_4   BYTE  "displays the original list, sorted list, and calculates the median.", 0
intor_EC1  BYTE  " Extra Credit :: Use a recursive sorting algorithm ", 0
intor_EC2  BYTE  " Extra Credit :: Implement the program using floating-point numbers and the floating-point processor ", 0
intor_EC3  BYTE  " Extra Credit :: Created procedures to change text color and continue until user quits  ", 0

; User Instruction
instruct_1    BYTE  " Now, we're going to create a list of random numbers. ", 0
prompt        BYTE  " Please ENTER the total number of random digits between [10 and 200]: ", 0
error_msg     BYTE  " Input number is out of the RANGE. ", 0

; Titles
sortedTitle     BYTE  ":: Sorted Array : ", 0
unsortedTitle   BYTE  ":: Unsorted Array : ", 0
medianTitle     BYTE  ":: Median Number : ", 0

; Array
random_arr    DWORD  200 DUP(?)
userInput     DWORD  ?

; EXIT message
good_bye      BYTE  "Results credited by Wei-Chien Hsu. Goodbye! Enjoy coding.", 0
again_mes     BYTE  "Want to play again? ", 0

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
; Repeat:
  ; GetData
  push  OFFSET  error_msg ; [ebp + 16]
  push  OFFSET  prompt    ; [ebp + 12]
  push  OFFSET  userInput ; [ebp + 8]
  call GetData

  ; Fill random numbers into the Array
  call  Randomize          ; Procedure provided by Irvine32
  push  HI_RANGE           ; [ebp + 20]
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

  ; Sort Array 
  push userInput          ; [ebp + 12]
  push OFFSET random_arr  ; [ebp + 8]
  call SortList

  ; Dispaly Median and marked the color as Green


  ; Display the sorted Array and marked the color as Purple


  ; Ask user for continue



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
  PrintString [ebp + 24] ; EC_1
  call CrLf
  PrintString [ebp + 20] ; EC_2
  call CrLf
  PrintString [ebp + 16] ; EC_2
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
  cmp eax, MAX_INPUT ; Data Validation
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
; Receiveds: HI and LO of default Range to random numbers [ebp + 20] and [ebp + 16] 
;            Value of user input [ebp + 12] and the Address of Array's first element [ebp + 8] 
; Returns: Need to use ebp combines esp as a counter to fill in the array.
;          Thus, procedure will return the filled array back.
;--------------------------------------------------------------------

  ; Set Stack Frame and Push Registers
    push      ebp
    mov       ebp, esp
    push      eax     
    push      ebx   
    push      ecx   ; Will be use as Counter from user input
    push      edx   ; Hight Boundry
    push      esi   ; Low Boundry
    push      edi   ; Record the OFFSET of our random array

  ; Build up the Loop
    mov       ecx, [ebp + 12] ; User Input as Counter
    mov       edi, [ebp + 8]  ; OFFSET of random number array
    mov       edx, [ebp + 20] ; HI
    inc       edx             ; Deal with the corner case
    mov       esi, [ebp + 16] ; LO
    sub       edx, esi        ; Get the difference between HI and LO and store in edx
    mov       ebx, 0

Filling:
    mov       eax, edx        ; Set the Range for randomRange procedure
    call      randomRange
    add       eax, esi          ; Modify the value at least larger than LO
    mov       [edi + ebx], eax  ; Indexing by the ebx Register
    add       ebx, 4            ; Increase 4 bit each time since we store the integer number
    loop      Filling

    pop       edi
    pop       esi
    pop       edx
    pop       ecx
    pop       ebx
    pop       eax
    pop       ebp
    ret       16

FillArray ENDP


;--------------------------------------------------------------------
SortList PROC
; Sort the list by the implementation of "Quick Sort"
; Pre conditions: push zero, filled array and UserInpur decreasement by 1. 
; Receives: User input [ebp + 12] and Address of random number array [ebp + 8].
; Returns: A sorted array begins with the largest number.
;--------------------------------------------------------------------
    push      ebp
    mov       ebp, esp
    push      eax         ; Record the size of array
    push      ebx         ; Record the high index starts at array size * 4
    push      esi         ; Record the array Offset
    push      edi         
    push      ecx         ; Used to multify array size by 4

    ; Build up the Registers for quickSortHelper 
    ; eax, ebx, exc, esi
    mov       esi, [ebp + 8]  ; Stored the array
    mov       eax, [ebp + 12] ; Init the array Size
    mov       ecx, 4
    mul       ecx             ; Array Size * 4
    mov       ecx, eax        ; ecx will now be the last addess of the array

    xor       eax, eax        ; eax equals to low index starts at 0
    mov       ebx, ecx        ; ebx equals to high index starts at arraySize * 4

    call      QuickSortHelper

    pop       ecx
    pop       edi
    pop       esi
    pop       ebx
    pop       eax
    pop       ebp   

    ret       8
SortList ENDP


;--------------------------------------------------------------------
QuickSortHelper PROC
; To sort an array in descending order
; receiveds: eax- low index starts at 0 ecx- high index starts at last element 
;            ebx- high index start at arraySize * 4  esi- OFFSET of array
; return: No return value. But the array has been sorted at this moment.
;--------------------------------------------------------------------

  cmp eax, ebx            ; Compare the lowest and hieght index
  jge End
  
  push  eax               
  push  ebx
  add   ebx, 4            ; high + 1

  mov   edi, [esi + eax]  ; Set the lowIndex in the current array as the Pivot and stroed in edi

Looping:
  LowerIncrease:
      add   eax, 4            ; low ++ (Since we put integers in the array, used 4)
      cmp   eax, ebx          ; compare low and high
      jge   EndOfLowerIncrease

      cmp   [esi + eax], edi  ; Compare array[low] and Pivot (if less than pivot, do nothing)
      jl    EndOfLowerIncrease
      jmp   LowerIncrease     ; Keep finding the next element which need to be swap
  EndOfLowerIncrease:

  HigherDecrease:
      sub   ebx, 4            ; end -- (Since we put integers in the array, used 4)
      cmp   [esi + ebx], edi  ; Compare array[high] and Pivot (if larger than Pivot, do nothing )
      jg    EndOfHigherDecrease
      jmp   HigherDecrease    ; Keep finding the previous element which need to be swap
  EndOfHigherDecrease:

  cmp    eax, ebx             ; compare low and high
  jge    EndOfLooping         ; No need to be swap

  ; Swapping
  push   [esi + eax]
  push   [esi + ebx]
  pop    [esi + eax]
  pop    [esi + ebx]

  jmp Looping

EndOfLooping:
  pop   ecx                   ; Restore Lower Index
  pop   edi                   ; Restore Higher Index
  
  cmp   ecx, ebx              ; if lower index equal to our previous lower index 
  je    EndOfSwap             ; No need to swap

  ; Swapping lower index and privous lower index
  push   [esi + ecx]
  push   [esi + ebx]
  pop    [esi + ecx]
  pop    [esi + ebx]

EndOfSwap:

  mov    eax, ecx

  push   edi
  push   ebx

  sub    ebx, 4

  call  QuickSortHelper       ; Pass argument as array, lowIndex and previous lower index - 1

  pop   eax
  add   eax, 4

  pop   ebx
  call  QuickSortHelper       ; Pass arguemtn as array, highIndex and previous higher index + 1


End:                      ; low index >= high index, end the sorting
  ret
QuickSortHelper ENDP



;--------------------------------------------------------------------
DisplayMedian PROC
; Determines median of array and print it out
; Pre conditions: push User Input and Sorted Array.
;--------------------------------------------------------------------

  ret
DisplayMedian ENDP

;--------------------------------------------------------------------
DisplayList PROC
; Receives: Strings of displaying array [ebp + 16], user input as array size
;           [ebp + 12] and Address of first element in random number array [ebp + 8]
; Pre conditions: push the values which need to be swap in both eax and ecx
;--------------------------------------------------------------------
  ; Set Stack Frame and Push Registers
  push      ebp
  mov       ebp, esp
  push      esi
  push      ecx
  push      edx

  mov       ecx, [ebp + 12] ; UserInput (Size)
  mov       esi, [ebp + 8]  ; Random Number array
  printString    [ebp + 16] ; Display Title
  call CrLf
  mov       edx, 1          ; Init the column

Looping:
  mov       eax, [esi]      ; Start looping through array
  call      WriteDec
  mov       eax, 9
  call      WriteChar       ; Add a Space
  add       esi, 4          ; Move to the next element in the array

  cmp       edx, 10         ; Limit the displayed value in 10 columns
  jl        ShowOnSameRaw
  call      CrLf            ; Out of the Range, change LINE
  mov       edx, 0          ; Init the column number

  ShowOnSameRaw:
  inc       edx             ; Increment the number of display column
  loop      Looping         ; Looping until Count equal to 0

  pop       edx
  pop       ecx
  pop       esi
  pop       ebp
  ret       12

DisplayList ENDP


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
