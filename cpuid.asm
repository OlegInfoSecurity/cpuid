section .data
      msg1: db " The CPU type is  :"
      len1: equ $-msg1
      msg2: db " The FPU (Coprocessor) is  :"
      len2: equ $-msg2
      msg3: db " 8087/ 80287", 0ah
      len3: equ $-msg3
      msg4: db " 80387", 0ah
      len4: equ $-msg4
      msg5: db "   ", 0ah
      len5: equ $-msg5

%macro display 2
      mov eax, 4
      mov ebx, 1
      mov ecx, %1
      mov edx, %2
      int 80h
%endm

section .bss
      var1 resd 1
      var2 resd 1
      var3 resd 1
      var4 resd 1

section .data
      global _start

_start:
      CPUID
      mov [var1], ebx
      mov [var2], edx
      mov [var3], ecx

      display msg1, len1

      display var1, 4
      display var2, 4
      display var3, 4
      display msg5, len5
      display msg2, len2
       
		;FPU
	SMSW eax						;load the machine status word		
      mov [var4], eax
      mov edx, [var4]
      bt edx, 4
      mov [var4], edx

      jc not
      display msg3, len3
      call ext

not:
      display msg4, len4
      display msg5, len5
ext:
      mov eax, 1
      mov ebx, 0
      int 80h