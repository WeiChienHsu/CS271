TITLE Summation     (demo4.asm)

; Author: Paulson
; CS271	        9/10/2012
; Description:  This program gets two integers from the user,
;	and calculates the summation of the integers from the
;	first to the second.  For example, if the user enters
;	1 and 10, the program calculates 1+2+3+4+5+6+7+8+9+10.

;	Note: This program does not perform any data validation.
;	If the user gives invalid input, the output will be
;	meaningless.

; Implementation note: The parameters are passed on the system stack.
;	In this version, strings are used as global variables.

INCLUDE Irvine32.inc

.data
a			DWORD		?		;lower limit
b			DWORD		?		;upper limit
sum			DWORD		?		;sum of integers from a to b
rules1		BYTE		"Enter a lower limit and an upper limit, and I'll show",0
rules2		BYTE		"the summation of integers from lower to upper.",0
prompt1		BYTE		"Lower limit: ",0
prompt2		BYTE		"Upper limit: ",0
out1		BYTE		"The summation of integers from ",0
out2		BYTE		" to ",0
out3		BYTE		" is ",0

.code
main PROC
	call	intro		;introduce the program

	push	OFFSET a	;pass a and b by reference
	push	OFFSET b
	call	getData		;get values for a and b

	push	OFFSET sum	;pass sum by reference
	push	a			;pass a and b by value
	push	b
	call	calculate	;calculate the sum
	
	push	a			;pass a, b, and sum by value
	push	b
	push	sum
	call	showResult	;display the result
	
	exit				;exit to operating system
main ENDP


;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx

intro	PROC
  ;Display instructions line 1
	mov		edx,OFFSET rules1
	call	WriteString
	call	Crlf
  ;Display instructions line 2
	mov		edx,OFFSET rules2
	call	WriteString
	call	Crlf
	call	Crlf
	
	ret
intro	ENDP

;Procedure to get lower and upper limits from the user.
;Implementation note: This procedure accesses its parameters by setting up a
;	"stack frame" and referencing parameters relative to the top of the 
;	system stack.  
;receives: addresses of parameters on the system stack
;returns: user input values for lower limit and upper limit
;preconditions:  none
;registers changed: eax, ebx, edx

getData	PROC
	push	ebp				;Set up stack frame
	mov		ebp,esp
  ;get an integer for lower limit
	mov		ebx,[ebp+12]		;Get address of lower limit into ebx.
	mov		edx,OFFSET prompt1	;   (add 24 to skip ebp,eax,ebx,edx, return 
	call	WriteString			;    address,and offset of upper limit)
	call	ReadInt
	mov		[ebx],eax			;Store user input at address in ebx
  ;get an integer for upper limit
	mov		ebx,[ebp+8]			;Get address of upper limit into ebx.
	mov		edx,OFFSET prompt2	;   (add 16 to skip ebp,eax,ebx,edx, and
	call	WriteString			;    return address)
	call	ReadInt
	mov		[ebx],eax			;Store user input at address in ebx
	pop		ebp					;Restore stack
	ret		8
getData	ENDP

;Procedure to calculate the summation of integers from x to y.
;Implementation note: this procedure's documentation specifies that
;	certain registers are changed. This means that the registers are
;	NOT saved and restored.
;receives: values of x and y, address of result ... on the system stack
;returns: sum = x+(x+1)+ ... +y
;preconditions:  x <= y
;registers changed: eax,ebx,ecx,edx

calculate	PROC
	push	ebp			;Set up stack frame
	mov		ebp,esp
	
	mov		eax,0		;initialize accumulator
	mov		ecx,[ebp+8]	;upper limit in ecx
	mov		ebx,[ebp+12]	;lower limit in ebx
	sub		ecx,ebx		
	inc		ecx			;loop executes y-x+1 times
top:
	add		eax,ebx		;add current integer to accumulator
	inc		ebx			;add 1 to current integer
	loop	top

	mov		ebx,[ebp+16]	;address of result in ebx
	mov		[ebx],eax		;return the result
	
	pop		ebp
	ret		12
calculate	ENDP

;Procedure to display the result. 
;receives: x, y, result
;returns: none
;preconditions:  result has been calculated
;registers changed: eax, edx

showResult	PROC
	push	ebp				;Set up stack frame
	mov		ebp,esp

  ;identify output
	mov		edx,OFFSET out1
	call	WriteString		;"The summation of integers from "
	mov		eax,[ebp+16]
	call	WriteDec		;display lower limit
	mov		edx,OFFSET out2
	call	WriteString		;" to "
	mov		eax,[ebp+12]	
	call	WriteDec		;display the upper limit
	mov		edx,OFFSET out3
	call	WriteString		;" is "
	mov		eax,[ebp+8]	
	call	WriteDec		;display result
	call	Crlf
	
	pop		ebp
	ret		12
showResult	ENDP

END main
