section .text
  global _start

digcount_1:
  div rsi
  inc rcx
  cmp rax,0
  mov rdx,0
  jne digcount_1
  ret

digcount:
  mov rax,rdi
  mov rcx,0
  mov rdx,0
  mov rsi,10
  call digcount_1
  mov rax,rcx
  ret

itoa_2:
  mov rdx,0
  div rcx
  add dl,48
  mov [rsp+16+rsi-1], dl
  cmp rax,0
  dec rsi
  jne itoa_2
  ret
itoa:  ; args: (int n)
  call digcount
  mov rsi,rax  ; rsi: digcount
  mov r9,rax
  inc rsi
  mov rcx, qword [rsp]
  sub rsp, rsi
  dec rsi
  mov qword [rsp], rcx
  mov rax,rdi
  mov rcx,10
  call itoa_2
  mov byte [rsp+8+r9], 0
  mov rax, rsp
  add rax,8
  ret

strlen_1:
  inc rax
  cmp byte [rdi+rax],0
  jne strlen_1
  ret
strlen:
  mov rax,-1
  call strlen_1
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
  mov rax,1
  mov byte [rsi], 10
  mov rdx,1
  syscall
  mov rax,60
  mov rdi,0
  syscall
