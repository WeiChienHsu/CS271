TITLE SquareList     (demo5.asm)

; Author: Paulson
; CS271	in-class demo        9/13/2012
; Description:  This program asks the user how many squares are required
;	and puts that many squares into an array so they can be displayed
;	in reverse order.

; Implementation note: Parameters are passed on the system stack.

INCLUDE Irvine32.inc
MAXSIZE	= 100
.data
squareArray	DWORD	MAXSIZE DUP(?)
count		DWORD	?
prompt1		BYTE		"How many squares ",0
.code
main PROC
	push	OFFSET count
	call	getCount			;Get the user's number
	push	OFFSET squareArray
	push	count
	call	fillArray			;Put that many squares into the array
	push	OFFSET squareArray
	push	count
	call	showRevList		;Print the array in reverse order
	exit			;exit to operating system
main ENDP

; ***************************************************************
; Procedure to get the user's input. Note: input not validated.
; receives: address of count on system stack
; returns: user input in global count
; preconditions: none
; registers changed: eax, ebx, edx
; ***************************************************************
getCount	PROC
	push	ebp
	mov	ebp,esp
	mov	edx,OFFSET prompt1
	call	WriteString		;prompt user
	call	ReadInt			;get user's number
	mov	ebx,[ebp+8]		;address of count in ebx
	mov	[ebx],eax			;store in global variable
	pop	ebp
	ret	4
getCount	ENDP

; ***************************************************************
; Procedure to put count squares into the array.
; receives: address of array and value of count on system stack
; returns: first count elements of array contain consecutive squares
; preconditions: count is initialized, 1 <= count <= 100
; registers changed: eax, ebx, ecx, edi
; ***************************************************************
fillArray	PROC
	push	ebp
	mov	ebp,esp
	mov	ecx,[ebp+8]		;count in ecx
	mov	edi,[ebp+12]		;address of array in edi
	
	mov	ebx,0
again:
	mov	eax,ebx			;calculate squares and store in consecutive array elements
	mul	ebx
	mov	[edi],eax
	add	edi,4
	inc	ebx
	loop	again
	
	pop	ebp
	ret	8
fillArray	ENDP

; ***************************************************************
; Procedure to display array in reverse order.
; receives: address of array and value of count on system stack
; returns: first count elements of array contain consecutive squares
; preconditions: count is initialized, 1 <= count <= 100
;                and the first count elements of array initialized
; registers changed: eax, ebx, edx, esi
; ***************************************************************
showRevList	PROC
	push	ebp
	mov	ebp,esp
	mov	edx,[ebp+8]		;count in edx
	mov	esi,[ebp+12]		;address of array in esi
	dec	edx				;scale edx for [count-1 down to 0]

more:
	mov	eax,edx			;display n
	call	WriteDec
	mov	al,'.'
	call	WriteChar
	mov	al,32
	call	WriteChar
	call	WriteChar
	mov	eax,[esi+edx*4]	;start with last element
	call	WriteDec			;display n-squared
	call	CrLf
	dec	edx
	cmp	edx,0
	jge	more
	
	pop	ebp
	ret	8
showRevList	ENDP

END main
