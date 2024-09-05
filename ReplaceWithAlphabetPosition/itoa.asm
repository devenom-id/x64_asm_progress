section .text
  global _start

digcount_1:
  div 10
  inc rcx
  cmp rdi,0
  jne digcount_1
  ret

digcount:
  mov rax,rdi
  mov rcx,0
  cmp rdi,0
  call digcount_1
  ret

itoa_2:
  mov rcx,0
  div rax,10
  mov [rsp+16+rsi-1], cl
  cmp rsi,0
  jne itoa_2
  ret
itoa:  ; args: (int n)
  call digcount
  mov rsi,rax  ; rsi: digcount
  inc rsi
  mov rcx, qword [rsp]
  sub rsp, rsi
  dec rsi
  mov [rsp], rcx
  mov rax,rdi
  call itoa_2
  mov [rsp+16+rsi], 0
  ret

strlen_1:
  cmp [rdi+rax],0
  inc rax
  jne strlen_1
  ret
strlen:
  mov rax,0
  call strlen_1
  dec rax
  ret

_start:
  mov rdi,35
  call itoa
  mov rsi,rax
  mov rdi,rax
  call strlen
  mov rdx,rax

  mov rax,1
  mov rdi,1
  syscall
  mov rax,60
  mov rdi,0
  syscall
