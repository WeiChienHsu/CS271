TITLE Summation     (demo2.asm)

; Author: Paulson
; CS271	in-class demo        1/28/2011
; Description:  This program gets two integers from the user,
;	and calculates the summation of the integers from the
;	first to the second.  For example, if the user enters
;	1 and 10, the program calculates 1+2+3+4+5+6+7+8+9+10.

;	Note: This program performs rudimentary data validation.
;	If the user enters a second number that is less than the
;	first number, the numbers will be switched.

INCLUDE Irvine32.inc

.data
a	DWORD	?		;lower limit
b	DWORD	?		;upper limit
sum	DWORD	?		;sum of integers from a to b
rules1	BYTE	"Enter a lower limit and an upper limit, and I'll show",0
rules2	BYTE	"the summation of integers from lower to upper.",0
prompt1	BYTE	"Lower limit: ",0
prompt2	BYTE	"Upper limit: ",0
out1	BYTE	"The summation of integers from ",0
out2	BYTE	" to ",0
out3	BYTE	" is ",0

.code
main PROC
;Display instructions line 1
	mov	edx,OFFSET rules1		;set up for call to WriteString
	call	WriteString
	call	Crlf
;Display instructions line 2
	mov	edx,OFFSET rules2
	call	WriteString
	call	Crlf
	call	Crlf

;get an integer for a
	mov	edx,OFFSET prompt1
	call	WriteString
	call	ReadInt
	mov	a,eax
;get an integer for b
	mov	edx,OFFSET prompt2
	call	WriteString
	call	ReadInt
	mov	b,eax
;validate the input
	mov	ebx,a	;a is in ebx, b is in eax
	cmp	ebx,eax
	jbe	inputOK
;if a > b, swap a and b values
	mov	a,eax
	mov	b,ebx
	
inputOK:
;initialize accumulator and loop control
	mov	eax,0		;accumulator = 0
	mov	ebx,a		;lower limit in ebx
	mov	ecx,b		;calculate number of times to execute the loop
	sub	ecx,a
	inc	ecx		;loop count is b - a + 1
;add each integer in [a .. b] to the accumulator
top:
	add	eax,ebx	;add current integer to accumulator
	inc	ebx		;add 1 to current integer
	loop	top		; repeat until ecx is 0

;save the result in sum
	mov	sum,eax

;identify and display the result
	mov	edx,OFFSET out1
	call	WriteString		;"The summation of integers from "
	mov	eax,a	
	call	WriteDec		;display a
	mov	edx,OFFSET out2
	call	WriteString		;" to "
	mov	eax,b	
	call	WriteDec		;display b
	mov	edx,OFFSET out3
	call	WriteString		;" is "
	mov	eax,sum	
	call	WriteDec		;display sum
	call	Crlf
	exit				;exit to operating system
main ENDP

END main
