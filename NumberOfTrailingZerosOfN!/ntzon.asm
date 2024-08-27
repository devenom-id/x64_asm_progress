section .text
  global main
  extern printf
  extern atoi
zeros_2:
  xor rdx,rdx
  mov rax,rdi
  div rsi  ; rsi / rax
  add rcx,rax
  push rax
  mov rax,rsi
  mov rsi,5
  mul rsi  ; rsi *= 5
  mov rsi,rax
  pop rax
zeros_1:
  cmp rax,0
  jne zeros_2  ; jump if (rax)
  ret
zeros:  ; args: (long long n)
  mov rax,rdi
  mov rsi,5
  xor rcx,rcx
  call zeros_1
  mov rax,rcx
  ret

is_num_2:
  mov rax, 0
  ret
is_num_1:
  cmp byte [rdi], 48
  jl is_num_2
  cmp byte [rdi], 57
  jg is_num_2
  inc rdi
is_num:  ; args: (char* n, size_t len)
  cmp byte [rdi], 0
  jne is_num_1
  mov rax,1
  ret


main:  ; args: (int argc, char** argv)
  mov rbp, rsp
  sub rsp,24  ; stack alignment (required by printf) 

  cmp rdi,2
  jne _exit_error

  mov rdi, [rsi+8]
  push rdi ; save rdi
  call is_num
  cmp rax,0
  je _exit_error
  pop rdi
  call atoi

  mov rdi, rax
  call zeros
  mov rdi,fmt
  mov rsi,rax
  call printf

_exit:
  mov rax,60
  mov rdi,0
  syscall

_exit_error:
  mov rax,1
  mov rdi,1
  mov rsi,msgerr
  mov rdx,lenerr
  syscall
  mov rax,60
  mov rdi,1
  syscall

section .data
  fmt db "%d",10,0
  msgerr db "Error: el programa esperaba recibir un string numérico",10
  lenerr equ $-msgerr
