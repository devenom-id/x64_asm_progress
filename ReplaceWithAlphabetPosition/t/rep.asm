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
  ; rcx,rsi
  mov rcx,0
  mov rax,rdi
  call digcount_1
  mov rax,rcx
  ret
itoa:
  ; (int n) -> (char*)
  ; rcx,rsi
  push rsp
  push rbp
  ; get number of digits
  call digcount
  mov rsi,rax

  ; stack ops
  inc rsi
  sub rsp, rsi
  mov rcx, qword [rsp+rsi]
  mov qword [rsp], rcx
  mov rcx, qword [rsp+rsi+8]
  mov qword [rsp+8], rcx
  mov rcx, qword [rsp+rsi+16]
  mov qword [rsp+16], rcx
  mov rbp, rsp
  add rbp, 24

  ; call for loop      ;;;;;; CONTINUE

  pop rbp
  pop rsp
zerobuff:
  ; (char* s, int size) -> (void)
  ; rsi
  mov byte [rbp+10+rsi], 0
  cmp rsi, 0
  jne zerobuff
  ret

alph_x:
alph:
  ; (char* s) -> (char*)
  ; rsi,rcx
  ; saving register
  push rsp
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
  mov rcx, qword [rsp+rax+10+16]
  mov qword [rsp+16], rcx
  mov rbp, rsp
  add rbp, 24

  ; assign strlen to size
  mov word [rbp], si

  ; assign buffer address to ptr
  mov rcx, qword [rbp+10]
  mov qword [rbp+2], rcx

  ; zero the buffer
  mov rdi, [rbp+10]
  inc rsi
  call zerobuff
  mov si, word [rbp]  ; recover rsi

  ; for loop
  call alph_x

  ; restoring registers
  pop rbp
  pop rsp

main:
  ; aligning stack
  mov rbp,rsp
  sub rsp,24

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

