
%include "io.asm"
section .bss
sinput: resb 255
section .text
global _start
ccarre:
	pop ebx
	pop eax
	imul eax
	push eax
	push ebx
	ret

_start: mov eax, sinput
	call readline
	call atoi
	push eax
	call ccarre
	pop eax	
	call iprintLF
	mov eax, 1
	int 0x80

