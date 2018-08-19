  mov edx,OFFSET string
  mov ecx,MAXSIZE
  dec ecx
  call ReadString
  mov ecx,eax 
  mov val,0 
  mov esi,OFFSET string
  cld
top:
  mov eax,0
  lodsb
  movzx eax, al
  sub eax,48
  mov ebx,eax
  mov eax,val
  mov edx,10
  mul edx
  add eax,ebx
  mov val,eax
  loop top
done:
  mov eax,val
  call WriteDec