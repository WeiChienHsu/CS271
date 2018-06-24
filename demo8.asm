TITLE Summation     (demo8.asm)

; Author: Paulson
; CS271	        9/19/2012
; Description:  This program gets two integers from the user,
;	and calculates the summation of the integers from the
;	first to the second.  For example, if the user enters
;	1 and 10, the program calculates 1+2+3+4+5+6+7+8+9+10.
;	Note: This program does not perform any data validation.
;	If the user gives invalid input, the output will be
;	meaningless.

; Implementation note: The summation procedure is recursive.

INCLUDE Irvine32.inc

mWriteString	MACRO	buffer
	push	edx				;Save edx register
	mov	edx, OFFSET buffer
	call	WriteString
	pop	edx				;Restore edx
ENDM

.data
a		DWORD	?		;lower limit
b		DWORD	?		;upper limit
sum		DWORD	?		;sum of integers from a to b
rules1	BYTE		"Enter a lower limit and an upper limit, and I'll show",0
rules2	BYTE		"the summation of integers from lower to upper.",0
prompt1	BYTE		"Lower limit: ",0
prompt2	BYTE		"Upper limit: ",0
out1	BYTE		"The summation of integers from ",0
out2	BYTE		" to ",0
out3	BYTE		" is ",0

.code
main PROC
	call	intro		;introduce the program

	push	OFFSET a		;pass a and b by reference
	push	OFFSET b
	call	getData		;get values for a and b

	mov		sum,0			;initialize sum
	push	a			;pass a and b by value
	push	b
	push	OFFSET sum	;pass sum by reference
	call	summation		;calculate the sum
	
	push	a
	push	b
	push	sum
	call	showResult	;display the result
	exit				;exit to operating system
main ENDP


;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions:  none
;registers changed: none

intro	PROC
  ;Display instructions line 1
	mWriteString	rules1
	call	Crlf
  ;Display instructions line 2
	mWriteString	rules2
	call	Crlf
	call	Crlf
	ret
intro	ENDP

;Procedure to get lower and upper limits from the user.
;Implementation note: This procedure accesses its parameters by setting up a
;	"stack frame" and referencing parameters relative to the top of the 
;	system stack.  The USES directive pushes the used registers onto the stack
;	at the beginning of the procedure, and pops them back before the return.
;receives: addresses of parameters on the system stack
;returns: user input values for lower limit and upper limit
;preconditions:  none
;registers changed: none

getData	PROC
	push	eax
	push	edx				;Save used registers
	push	ebp				;Set up stack frame
	mov		ebp,esp
  ;get an integer for lower limit
	mov		ebx,[ebp+20]		;Get address of lower limit into ebx.
								;   (add 20 to skip ebp, eax, edx, return 
								;    address,and offset of upper limit)
	mWriteString	prompt1
	call	ReadInt
	mov		[ebx],eax			;Store user input at address in ebx
  ;get an integer for upper limit
	mov		ebx,[ebp+16]		;Get address of upper limit into ebx.
								;   (add 16 to skip ebp, eax, edx, and
								;    return address)
	mWriteString	prompt2
	call	ReadInt
	mov		[ebx],eax			;Store user input at address in ebx
	
	pop		ebp				;Restore stack
	pop		edx
	pop		eax
	ret		8
getData	ENDP

;RECURSIVE procedure to calculate the summation of integers from x to y.
;Implementation note: This procedure implements the following
;	recursive algorithm:
;	if (x == y)
;		return x
;	else
;		return x + summation(x+1,y)
;receives: values of x and y, address of result ... on the system stack
;returns: sum = x + sum of (x+1)+ ... +y
;preconditions:  x <= y
;registers changed: eax,ebx,edx

summation	PROC
	push	ebp
	mov		ebp,esp
	
	mov		eax,[ebp+16]	;eax = x
	mov		ebx,[ebp+12]	;ebx = y
	mov		edx,[ebp+8]		;@sum in edx
	
	add		[edx],eax		;add current value of x
	cmp		eax,ebx
	je		quit			;base case: sum = x
recurse:
	inc		eax				;recursive case
	push	eax
	push	ebx
	push	edx
	call	summation
quit:
	pop		ebp
	ret		12
summation	ENDP

;Procedure to display the result. 
;receives: x, y, result
;returns: none
;preconditions:  result has been calculated
;registers changed: none

showResult	PROC
	push	eax				; Save registers
	push	edx
	push	ebp
	mov		ebp,esp
	
  ;identify output
	mWriteString	out1	;"The summation of integers from "
	mov		eax,[ebp+24]	
	call	WriteDec		;display x
	mWriteString	out2	;" to "
	mov		eax,[ebp+20]	
	call	WriteDec		;display y
	mWriteString	out3	;" is "
	mov		eax,[ebp+16]	
	call	WriteDec		;display result
	call	Crlf
	
	pop		ebp				;Restore stack
	pop		edx
	pop		eax
	ret		12
showResult	ENDP

END main
