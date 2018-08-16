Instruction Execution Cycle: Fetch next instruction into IR -> Increment IP to point to the next instruction -> Decode instruction in IR -> If Required memory access: Determine memory address, Fetch Operand from memory into CPU register or Sent out -> Execute micro-program -> Halt, go Step 1.
32 bits’ general purpose registers: EAX (Integer Multiplication Division instruction)/EBX/ECX (counter for looping)/EDX, Multipurpose Registers: EBP / ESP / ESI / EDI, Special Purpose Registers: EFL / EIP (protected mode)
AX- refers to least significant 16 bits of EAX, AL- refers to least significant 8 bits of AX, AH- most significant 8 bits of AX.
BYTE: 1 (Character/String – End with zero terminate), WORD: 2, DWORD: 4, QWORD: 8, REAL4: 4(Floating Point), REAL8: 8.
ReadInt: Post- Value entered in EAX. Call WriteInt, WriteDec: Pre – value in EAX, Post- Value displayed
ReadString: Pre: OFFSET of memory destination in EDX & size of memory destination in EXC Post- String entered in memory, Length of string entered is in EAX. WriteString: Post- OFFSET of memory location in EDX, Post – String displayed.
Signed Integer: 0: 0000, 1: 0001, -1: 1111, -2: 1110. Positive to Negative: Convert all digits and plus 1.
Little endian: 0x2EFBFFFF -> 數字: FFFFFB2E -> (Binary) 11111111 11111111 11111011 00101110 = Singned Integer -1234
FPU: 6.25d = 110.01b = 1.1001 * 2^2 b. Sign = 0, Biased = 2 + 127 = 129, normalized = 1001.  
0 1000 0001 100100000 = 0100 0000 1100 1000 0000 = 0 x 40C80000
CALL: push the OFFSET of next instruction in the calling procedure (current address in EIP) onto the system stack. Copies the address of the called procedure into EIP. Executes the called procedure until RET
RET: pops the top of stack into EIP. (Which is the address of return value) 
RET n: Optional operand n causes n to be added to the stack pointer after EIP is assigned a value.
Stack: point to the address of stack segment. ESP: Always point to the top of stack. (Contains address of the stack top)
PUSH: Decrement the ESP by 4 -> Copies a value into the location pointed to by the stack pointer. push ecx | [esp], 25 
POP: Copies value at ESP into a register or variable -> Increments the stack pointer by 4. pop eax
EIP: Points to the next instruction. CALL: ESP – 4, EIP: @ return put in stack. RET: EIP = @ return, ESP + 4.
			Array Addressing Mode
push x	; [ebp + 16]	     Indexed		Base-Indexed 			 Register Indirect        ArrayFill Proc
push y	; [ebp + 12]	     mov edi, 0		push OFFSET array		 push OFFSET array
push OFFSET z  ; [ebp + 8]     mov list[edi], eax	mov edx, [ebp + 8]		 mov esi, [ebp + 8]
call Sum	 Sum PROC	     add	edi, 4		mov ecx, 20			 mov eax, [esi]
push ebp		     mov	list[edi], ebx	mov eax, [edx + ecx] ; get list [5]	 add esi, 4
mov ebp, esp	      	     if BYTE add 1		mov ebx, 4			 add eax. [esi]
mov eax, [ebp + 16]	     if WORD add 2	add eax, [edx + ebx]		 add esi, 16
add eax, [ebp + 12]	     if QWORD add 8	mov [edx + ecx], eax		 mov [esi], eax
mov ebx, [ebp + 8]				EAX: list[5] + list[1]
mov [ebx], eax					EDX: @ first ele in array	
pop ebp    ret 12		    list DWORD MAX_SIZE DUP(?)	Address of list[k] = address of list + (k * size of element)
Randomize Procedure: RandomRange Procedure: Accepts N > 0 in EAX returns integer in [0 – N-1], range = hi – lo + 1
OFFSET: return the distance in bytes, from the beginning of its enclosing segment.
PTR: Access partly. Override the Default TYPE of label. | 78 | 56 | 34 | 12 | take first two.
myDouble DWORD 12345678h   mov ax, myDouble -> SIZE MISMATCH   mov ax, WORD PTR myDouble (load 5678h)
mov al, BYTE PTR myDouble (78h) | mov al, BYTE PTR [myDouble + 2] (34h) | mov ax, WORD PTR [myDouble + 2] (1234h)
mtBytes BYTE 12h, 34h, 56h, 78h mov ax, WORD PTR myBytes (3412h)  mov ax, WORD PTR [myBytes + 2] (7856h)
TYPE: return sizes in Bytes of single element of a data declaration. 
LENGTHOF: How many elements in a single data declaration. byte1 BYTE 10,20,30 (3) digitStr BYTE “12345”, 0 (6)
SIZEOF: LENGTHOF * TYPE (Size in Bytes) list1 WORD 30 DUP(?) (60) list2 DWORD 1, 2, 3, 4(16)
listB BYTE 1, 2, 3, 4, 5, 6, 7 listD DWORD 11, 12, 13, 14, 15,16 mov | esi, 5 | mov al, listB[esi * TYPE listB] (6) -> listD(16)
POINTER: initList DWORD 100h, 200h, 300h |  ptrD DWORD initList | mov esi, ptrD  | mov ecx, LENGTHOF initList 
mov eax, 0 | count:  | add eax, [esi] |  add esi, TYPE initList | loop count
Matrix DWORD 5DUP(3DUP(?)) : 5 row and 3 columns -> Matrix[row - 1][col - 1]  (4 * [ 3 * 3 + 1 ]) = 20A0h + 28h = 20C8h
Matrix[3][1] Address: Start Address (20A0h) + Sizeof DWORD * [(row index * column number) + col index] 
String Primitives: A string is an array of BYTE.			mov eax, sLength		Reverse:
lodsb(esi): mov al, [esi] (flag == 0 : inc esi) (flag == 1: dec esi) 	mov esi, OFFSET inString		   std ; (Flag = 1)
stosb(edi): mov [edi], al (flag == 0: inc edi) (flag == 0: dec edi)	add  esi, ecx			   lodsb ; (dec esi)
cld: Clear direction flag = 0 std: Set direction flag = 1.		dec  esi				   cld; (Flag = 0)
								mov edi, OFFSET outString	   stosb (inc edi)
FLD memVar: push ST(i) down to ST(I + 1) for I = 0 … 6		---- mov edx, OFFSET outString	   loop Reverse
FST memVar: move top of stack to memory leave result in ST(0)	      FINIT	FLD vary    FMUL   FSTP RESULT
FSTP memVar: pop top of stack to memory move ST(i) up to ST(I – 1)     FLD varX	FLD varZ    FADD    -> (Z * Y) + X
RPN (6.0 * 2.0) + (4.5 * 3.2) -> 6.0 2.0 * 4.5 3.2 * +  || (: Left || Operand: Insert || Operator: up/insert/right || ) : Right 
MACRO: During assembly, entire code is substituted for each call. May have parameter. Once defined, it can be invoked once or more times. Use name only. Similar to a CONSTANT invisible to the programmer. Not RET/Stack manipulation.
Program’s data execution require 1024 bytes. 84 times various values. MACRO require 95 bytes. Procedure requires 154 bytes each call requires 6 bytes. MACRO = 95 *84 + 1024 = 9004 PROCEDURE = 154 + 84 * 6 + 1024 
PROCEDURE: Translated Once, can be called many times. Having a calling mechanism involving EIP. May have parameter. During execution, control is transferred to the procedure at each call.| push a		mov eax, [ebp+16]   inc eax
mWriteString MACRO buffer 	 mReadString MACRO varName      | push b		mov ebx, [ebp+12]  push eax
push edx			 push ecx			   |push OFFSET result      mov, edx, [ebp + 8] push ebx
mov edx, OFFSET buffer		 push edx			   | call SUM	   	add [edx], eax	     push edx
call WriteString		 	 mov edx, OFFSET varName	   | SUM PROC		cmp eax, ebx	     call SUM
pop edx				 mov ecx, (SIZEOF varName) -1	   | push ebp		je EndLoop       EndLoop:
ENDM			call ReadString  pop edx   pop ecx  ENDM	   |mov ebp, esp    Recursive:     pop ebp ret 12  ENDP
Boolean: AB (A & B) | A + B (A or B) | A o+ B (A XOR B) A 和 B不同output 1 | OR, AND, XOR加N結果相反
Half ADDER: AB = Carry A XOR B = Sum || Full ADDER: (AB) + C(A XOR B) = Carry Out, C XOR (A XOR B) = Sum


