TITLE DemoString     (demo6.asm)

; Author: Paulson
; CS271	in-class demo        9/15/2012
; Description:  This program asks the user to enter a string,
;               and then displays the string in all caps.
;               Finally, the string is displayed backwards.

INCLUDE Irvine32.inc
MAXSIZE	= 100
.data
inString	BYTE		MAXSIZE DUP(?)		; User's string
outString	BYTE		MAXSIZE DUP(?)		; User's string capitalized
prompt1	BYTE		"Enter a string: ",0
sLength	DWORD	0

.code
main PROC
; Get user input:
	mov	edx,OFFSET prompt1
	call	WriteString						; 
	mov	edx,OFFSET inString
	mov	ecx,MAXSIZE
	call	ReadString						; pre - EDX: OFFSET of inString, ECX: length limit. post - String in memory, EAX - length
	call	WriteString						; print contents of address in EDX
	call	CrLf
	
; Set up the loop counter, put the string addresses in the source 
; and index registers, and clear the direction flag:
	mov	sLength,eax							; Move length of String into sLength
	mov	ecx,eax
	mov	esi,OFFSET inString			; ESI - store the address of first element input string 
	mov	edi,	OFFSET outString	; EDI - store the address of first element output string 
	cld													; FLAG == 0

; Check each character to determine if it is a lower-case letter.
; If yes, change it to a capital letter.  Store all characters in
; the converted string:
counter:
	lodsb											; mov al, [esi] (Flag == 0, inc esi)
	cmp	al,97									; 'a' is character 97
	jb	notLC
	cmp	al,122								; 'z' is character 122
	ja	notLC
	sub	al,32									; Convert to Capital Letter									
notLC:
	stosb											; mov [edi], al (Flag == 0, inc edi)
	loop	counter
	
; Display the converted string:
	mov	edx,	OFFSET outString
	call	WriteString
	call	CrLf
	
; Reverse the string
	mov	ecx,sLength
	mov	esi,OFFSET inString
	add	esi,ecx			
	dec	esi					; last byte of inString
	mov	edi,OFFSET outstring	; first byte of outString

reverse:
	std						; get characters from end to beginning (Flag == 1)
	lodsb					; Flag == 1, dec esi
	cld						; store characters from beginning to end (Flag == 0)
	stosb					; Flag == 0, inc edi
	loop	reverse

; Display reversed string
	mov	edx,OFFSET outString
	call	WriteString
	call	CrLf
	
	exit			;exit to operating system
main ENDP

END main
