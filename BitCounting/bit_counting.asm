section .text
  global main
  extern printf

_count_set_bits2:
  mov rsi,rdi
  and rsi,1
  add rax,rsi
  shr rdi, 1
_count_set_bits1:
  cmp rdi, 0
  jne _count_set_bits2
  ret
count_set_bits:  ; args (int n)
  mov rax,0
  push rdi
  call _count_set_bits1
  pop rdi
  ret

main:
  mov rbp, rsp
  sub rsp, 24
  mov rdi, 3333
  call count_set_bits
  mov rdi,fmt
  mov rsi,rax
  call printf

_exit:
  mov rax,60
  mov rdi,1
  syscall
section .data
  fmt db "%d",10,0
