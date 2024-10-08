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
  dec rsi
  mov byte [rdi+rsi], 0
  cmp rsi, 0
  jne zerobuff
  ret

alph_1:
  xor r8,r8
  mov r8b, byte [rdi]
  mov r10, 0
  mov r11, 0
  cmp r8b, 65
  cmovge r10, r9
  cmp r8b, 90
  cmovle r11, r9
  and r10, r11
  jz alph_2
  add r8b, 32
alph_2:
  mov r10, 0
  mov r11, 0
  cmp r8b, 97
  cmovge r10, r9
  cmp r8b, 122
  cmovle r11, r9
  and r10, r11
  jz alph_3
  sub r8b, 96

  mov rbx, rdi  ; Stack is a mess, so I'll be storing it on a preserved register instead.
  mov r12, rsi
  mov r13, rsp
  mov rdi, 0
  mov dil, r8b
  mov r10, rcx
  call itoa
  mov rdi, [rbp]
  mov rsi, rax
  call stpcpy
  mov rdi, rbx
  mov rsi, r12
  mov rsp, r13
  mov rcx, r10
  mov byte [rax], 32
  inc rax
  mov [rbp], rax
alph_3:
  inc rcx
  inc rdi
alph_x:
  cmp rcx, rsi
  jl alph_1
  ret
alph:
  ; (char* s) -> (char*)
  ; rsi,rcx,r8,r9,r10,r11
  ; saving register
  push rbp
  push rdi

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

  ; reorder stack (rdi,rbp,main,size,ptr,buffer)
  mov rcx, qword [rsp+rax+10]
  mov qword [rsp], rcx
  mov rcx, qword [rsp+rax+10+8]
  mov qword [rsp+8], rcx
  mov rcx, qword [rsp+rax+10+16]
  mov qword [rsp+16], rcx
  mov rbp, rsp
  add rbp, 24

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
  mov rsi,rax
  call zerobuff
  pop rdi
  mov si, word [rbp-2]  ; recover rsi

  ; for loop
  dec rsi
  mov rcx, 0
  mov r9, 1
  call alph_x

  add rbp, 8
  mov rax, rbp
  ; restoring registers
  pop rdi
  pop rbp
  ret

main:
  ; aligning stack
  mov rbp,rsp
  sub rsp,24

  mov rdi, msg
  call alph

  mov rdi, fmt
  mov rsi, rax
  mov rax, 0
  call printf

_exit:
  mov rax,60
  mov rdi,0
  syscall

section .data
  fmt db "%s",10,0
  msg db "Hello world",10,0
