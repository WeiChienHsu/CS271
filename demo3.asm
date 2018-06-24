TITLE Summation     (demo3.asm)

; Author: Paulson
; CS271	in-class demo        2/7/2012
; Description:  This program gets two integers from the user,
;	and calculates the summation of the integers from the
;	first to the second.  For example, if the user enters
;	1 and 10, the program calculates 1+2+3+4+5+6+7+8+9+10.
;
;	Note: This program does not perform any data validation.
;	If the user gives invalid input, the output will be
;	meaningless.

; Implementation notes: 
;	This program is implemented using procedures.
;   All variables are global ... no parameter passing

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
	call	intro
	call	getData
	call	calculate
	call	showResults

	exit	; exit to operating system
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

;Procedure to get values for a and b from the user.
;receives: none
;returns: user input values for global variables a and b
;preconditions:  none
;registers changed: eax,edx
getData	PROC

;get an integer for a
	mov		edx,OFFSET prompt1
	call	WriteString
	call	ReadInt
	mov		a,eax
;get an integer for b
	mov		edx,OFFSET prompt2
	call	WriteString
	call	ReadInt
	mov		a,eax

	ret
getData	ENDP

;Procedure to calculate the summation of integers from a to b.
;receives: a and b are global variables
;returns: global variable sum = a+(a+1)+ ... +b
;preconditions:  a <= b
;registers changed: eax,ebx,ecx
calculate	PROC

;initialize parameters
	mov		eax,0		;accumulator
	mov		ebx,a		;lower limit
	mov		ecx,b		;upper limit
	sub		ecx,a		
	inc		ecx			;loop executes b-a+1 times
top:
	add		eax,ebx		;add current integer to accumulator
	inc		ebx			;add 1 to current integer
	loop	top

	mov		sum,eax		;save the result in sum

	ret
calculate	ENDP

;Procedure to display the results (a, b, and sum) 
;receives: a, b, and sum are global variables
;returns: none
;preconditions:  sum has been calculated
;registers changed: eax,edx
showResults	PROC

;identify output
	mov	edx,OFFSET out1
	call	WriteString		;"The summation of integers from "
	mov		eax,a	
	call	WriteDec		;display a
	mov		edx,OFFSET out2
	call	WriteString		;" to "
	mov		eax,b	
	call	WriteDec		;display b
	mov		edx,OFFSET out3
	call	WriteString		;" is "
	mov		eax,sum	
	call	WriteDec		;display sum
	call	Crlf

	ret
showResults	ENDP

END main
