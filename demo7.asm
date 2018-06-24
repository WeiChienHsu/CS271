TITLE Macros     (demo7.asm)

; Author: Paulson
; CS271	        9/17/2012
; Description:  This program demonstrates how macros are defined and invoked
;				with parameters.
; Implementation note: When a macro is "called", the complete code is substituted
;				for the macro name, and the macro parameters are replaced
;				with the actual arguments in the macro "call".
INCLUDE Irvine32.inc

myWriteString	MACRO	buffer
	push	edx				;Save edx register
	mov	edx, OFFSET buffer
	call	WriteString
	pop	edx				;Restore edx
ENDM

seq	MACRO	low, high
	LOCAL	test, quit	;Note local labels to avoid duplicate labels
						;	if seq is called more than once
	push	eax			;save registers
	push	ebx
	mov	eax,low
	mov	ebx,high
test:
	cmp	eax,ebx
	jg	quit			;Quit if we've reached last number
	push	eax			;Save eax, so we can print a space
	call	WriteDec
	mov	al,' '
	call	WriteChar		;Print space
	pop	eax			;Restore eax
	inc	eax			;next integer
	jmp	test
quit:
	call	CrLf
	pop	ebx			;restore registers
	pop	eax
ENDM

.data
a		DWORD	?		;lower limit
b		DWORD	?		;upper limit
rules1	BYTE		"Enter a lower limit and an upper limit, and I'll print",10,13,0
rules2	BYTE		"the integer sequence from lower to upper.",0
rules3	BYTE		"Here are some examples:",10,13,0
prompt1	BYTE		"Lower limit: ",0
prompt2	BYTE		"Upper limit: ",0

.code
main PROC
	myWriteString	rules1	;Note the "short" way to print a string
	myWriteString	rules2
	call CrLf
	myWriteString	rules3
 	seq	1,10				;"Call" seq with immediate values
	mov	ecx,10
	mov	edx,20
	seq	ecx,edx			;"Call" seq with register contents
	myWriteString	prompt1
	call	ReadInt
	mov	a,eax
	myWriteString	prompt2
	call	ReadInt
	mov	b,eax
	seq	a,b				;"Call" seq with memory contents
	exit				;exit to operating system
main ENDP

END main
