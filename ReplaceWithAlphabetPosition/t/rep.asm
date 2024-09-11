section .text
  global main
  extern printf
  extern strlen
  extern stpcpy

digcount_1:
  mov rsi, 10
  mov rdx, 0
  div rsi
  inc rcx
  cmp rax, 0
  jne digcount_1
  ret
digcount:
  ; (int n) -> (char*)
  ; rcx,rsi,rdx
  mov rcx,0
  mov rax,rdi
  call digcount_1
  mov rax,rcx
  ret

itoa_1:
  mov rdx,0
  mov rcx,10
  div rcx
  add rdx, 48
  mov byte [rbp], dl
  dec rbp
  cmp rax,0
  jne itoa_1
  ret
itoa:
  ; (int n) -> (char*)
  ; rcx,rsi,rdx
  push rbp

  ; get number of digits
  call digcount
  mov rsi,rax

  ; allocate space for variables
  inc rsi
  sub rsp, rsi  ; char* buffer;

  ; stack ops (rbp,rsp,func,buffer)
  mov rcx, qword [rsp+rsi]
  mov qword [rsp], rcx
  mov rcx, qword [rsp+rsi+8]
  mov qword [rsp+8], rcx
  mov rbp, rsp
  add rbp, 16

  ; null terminate the buffer
  dec rsi
  mov byte [rbp+rsi], 0

  ; call for loop
  mov rax,rdi
  mov rcx,rsi
  mov rsi, rbp
  dec rcx
  add rbp, rcx
  call itoa_1
  mov rbp, rsi
  
  mov rax, rbp
  pop rbp
  ret

zerobuff:
  ; (char* s, int size) -> (void)
  ; rsi
  mov byte [rbp+10+rsi], 0
  cmp rsi, 0
  jne zerobuff
  ret

alph_1:
  mov rax, [rbp]
  mov r8b, byte [rax]
  mov r10,0
  mov r11,0
  cmp r8b, 65
  cmovge r10, r9
  cmp r8b, 90
  cmovle r11, r9
  and r10, r11
  jnz alph_2
  add r8b, 32
alph_2:
  mov r10, 0
  mov r11, 0
  cmp r8b, 97
  cmovge r10, r9
  cmp r8b, 122
  cmovle r11, r9
  and r10, r11
  jnz alph_3
  sub r8b, 96
  ;; CONTINUE HERE!! on:  prt=strcpy(ptr, itoa(ch));
alph_3:
  inc rcx
alph_x:
  cmp rcx, rsi
  jl alph_1
  ret
alph:
  ; (char* s) -> (char*)
  ; rsi,rcx,r8,r9,r10,r11
  ; saving register
  push rbp

  ; length of s
  mov rax,0
  call strlen
  mov rsi,rax

  ; allocate space for variables
  mov rcx, 3
  mul rcx
  inc rax
  sub rsp, rax ; buffer
  sub rsp, 10  ; char* ptr; int size;

  ; reorder stack (rbp,rsp,main,size,ptr,buffer)
  mov rcx, qword [rsp+rax+10]
  mov qword [rsp], rcx
  mov rcx, qword [rsp+rax+10+8]
  mov qword [rsp+8], rcx
  mov rbp, rsp
  add rbp, 16

  ; assign strlen to size
  mov word [rbp], si

  ; move rbp to ptr
  add rbp, 2

  ; assign buffer address to ptr
  add rbp,8
  mov rcx, rbp
  sub rbp,8
  mov qword [rbp], rcx

  ; zero the buffer
  push rdi
  mov rdi, [rbp]
  inc rsi
  call zerobuff
  pop rdi
  mov si, word [rbp-2]  ; recover rsi

  ; for loop
  dec rsi
  mov rcx, 0
  mov r9, 1
  call alph_x

  ; restoring registers
  pop rbp

main:
  ; aligning stack
  mov rbp,rsp
  sub rsp,24

  mov rdi, 334
  call itoa
  mov rdi, fmt
  mov rsi, rax
  mov rax, 0
  call printf
  jmp _exit

  ; calling alph
  mov rdi, msg
  call alph

_exit:
  mov rax,60
  mov rdi,0
  syscall

section .data
  fmt db "%s",10,0
  msg db "Hello world",10,0
  tst db "%d",10,0

