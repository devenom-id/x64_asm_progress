section .data
  path db "/usr/bin/clear",0
section .text
  global _start

move_to_environ:
  mov rdi,[rbp]
  add rdi, 2
  mov al, 8
  mul rdi
  mov rdi, [rsp]
  mov [rsp-1], rdi
  mov [rsp+7], al  ;; store how many times to add to get to environ
  sub rsp, 1
  ret
  
_start:
  mov rbp, rsp ; prepare stack
  call move_to_environ
  mov al, [rsp]
  inc rsp ;; rsp=rbp
  add spl, al ;;rsp -> environ
  mov rdx, rsp
  sub spl, al

  mov rax,59  ;; execve
  mov rdi,path
  add rsp,8
  mov rsi,rsp
  sub rsp,8
  syscall

  mov rax,60
  mov rdi,0
  syscall
