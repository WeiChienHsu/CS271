.data
	n DWORD ?  
.code
main PROC
		push n  ;[ebp + 8]
		call factorial  
		mov answer, eax 
main ENDP

Factorial PROC 
		push ebp 
		mov ebp, esp 
		mov ecx, 0 
		mov eax, [ebp+8] 
		add ecx, eax
    cmp eax, 12 ; limitation 
    ja Error_factorial 
		cmp eax, 0 
		je zero 
		cmp eax, 0 
		jl ngtve 
    
faLoop: 
    cmp ecx, 1 
		je ex 
		dec ecx 
		mul ecx 
		jmp faLoop 

zero:   
    inc eax 
		jmp ex 
ngtve:  
    mov eax, 0 
    jmp ex 

Error_factorial:
    mov edx, OFFSET factorialError ; or [ebp + 12]
	  call WriteString
	  jmp ex

ex:	    
    pop ebp 
		ret 4 ; or 8
Factorial ENDP

END main
