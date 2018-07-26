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
intor_EC1  BYTE  " Extra Credit :: Created procedures to change text color and continue until user quits  ", 0

; User Instruction
instruct_1    BYTE  "Now, we're going to create a list of random numbers, between 10 and 200, ", 0
prompt        BYTE  "Please ENTER the total number of random digits you would like to generate: ", 0
error_msg     BYTE  "Input number is out of the RANGE [10 - 200], please ENTER again: ", 0

; Titles
sortedTitle     BYTE  ":: Sorted Array : ", 0
unsortedTitle   BYTE  ":: Unsorted Array : ", 0
medianTitle     BYTE  ":: Median Number : ", 0

; Array
random_arr    DWORD  200 DUP(?)
arrSize       DWORD  ?

; EXIT message
good_bye      BYTE  "Results credited by Wei-Chien Hsu. Goodbye! Enjoy coding.", 0
again_mes     BYTE  "Want to play again? ", 0

.code
main PROC
  ; Procedures

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
; Returns: Nothing
;--------------------------------------------------------------------
  ;; Set Stack Frame and Push Registers
  push  ebp
  mov   ebp, esp
  push  edx


Introduction ENDP



;--------------------------------------------------------------------
GetData PROC
; Get abd Store user's valid input around 10 to 200.
; Pre conditions: Push address of user input into the stack before called
; Returns: User input Stroed in the variable UserInput already
;--------------------------------------------------------------------
  ;; Set Stack Frame and Push Registers
  push  ebp
  mov   ebp, esp
  push  edx
  push  eax

GetData ENDP


;--------------------------------------------------------------------
FillArray PROC
; Fill in the value in the array by the numbers generated from Randomize procedure
; Pre conditions: Push address of array and value of UserInput into stack
; Returns: Need to use ebp combines esp as a counter to fill in the array.
;          Thus, procedure will return the filled array back.
;--------------------------------------------------------------------

  ;; Set Stack Frame and Push Registers
    push      ebp
    mov       ebp, esp
    push      eax
    push      ebx
    push      ecx
    push      edx
    push      esi
    push      edi



FillArray ENDP


;--------------------------------------------------------------------
SortList PROC
; Sort the list by the implementation of "Quick Sort"
; Pre conditions: push zero, filled array and UserInpur decreasement by 1. 
; Returns: A sorted array begins with the largest number.
;--------------------------------------------------------------------

SortList ENDP


;--------------------------------------------------------------------
QuickSortHelper PROC
; To sort an array in descending order
; pre conditions:
; receiveds: Array's OFFSET [ebp + 8] and size or Array at [ebp + 12]
; registers changed:
; return:
;--------------------------------------------------------------------

  ret
QuickSortHelper ENDP



;--------------------------------------------------------------------
DisplayMedian PROC
; Determines median of array and print it out
; Pre conditions: push User Input and Sorted Array.
;--------------------------------------------------------------------

DisplayMedian ENDP

;--------------------------------------------------------------------
DisplayList PROC
; 
; Pre conditions: push the values which need to be swap in both eax and ecx
;--------------------------------------------------------------------
  ;; Set Stack Frame and Push Registers
  ; push      ebp
  ; mov       ebp, esp
  ; push      esi
  ; push      ecx
  ; push      edx

  ret

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
; Make the text green, prvided by Irvine-32 Library
;--------------------------------------------------------------------
  push      eax
  mov       eax, 7
  call      setTextColor
  pop       eax

  ret
SetTextGrey ENDP

;--------------------------------------------------------------------
SetTextPurple PROC
; Make the text green, prvided by Irvine-32 Library
;--------------------------------------------------------------------
  push      eax
  mov       eax, 13
  call      setTextColor
  pop       eax

  ret
SetTextPurple ENDP

END main
