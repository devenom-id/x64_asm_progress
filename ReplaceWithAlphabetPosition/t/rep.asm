section .text
  global main
  extern printf
  extern stpcpy
  extern strlen

digcount_1:
  mov rdx, 0
  div rdi
  inc rcx
  cmp rax, 0
  jne digcount_1
  ret
digcount:
  ; args: int n
  ; returns: int
  ; modifies: rcx,rdi
  mov rax,rdi
  mov rdi,10
  mov rcx,0
  call digcount_1
  mov rax,rcx
  ret

itoa_1:
  dec r10
  mov rdx,0
  div r9
  add rdx,48
  mov byte [rbp+r10], dl
  cmp r10,0
  jg itoa_1
  ret
itoa:
  ; args: int n
  ; returns: char*
  ; modifies: r9,r10,rbp
  push rdi
  call digcount
  pop rdi

  mov r9, qword [rsp]
  mov r10,rax ; r10 = digcount(n)
  sub rsp, r10
  dec rsp
  mov qword [rsp], r9
  sub rsp,8  ; push rbp
  mov qword [rsp], rbp
  mov rbp,rsp
  add rbp,16
  mov byte [rbp+r10], 0

  mov r9,10
  mov rax,rdi
  call itoa_1
  mov rax,rbp
  pop rbp
  ret

zerobuff:
  ; args: void* ptr, int nmemb
  ; returns: void
  ; modifies:
  mov [rdi+rsi], 0
  dec rsi
  cmp rsi, 0
  jne zerobuff


alph_1:
  cmp byte [rdi+rcx],65
  cmovge r10,r9
  cmp byte [rdi+rcx],90
  cmovle r11,r9
  and r10,r11
  jz alph_2
  add byte [rdi+rcx], 32
alph_2:
  ret

alph:
  ; args: char* s
  ; returns: char*
  ; modifies: rdi, rsi, rdx
  mov rax,0
  call strlen  ; rax=strlen(s);
  mov rsi,3
  mul rsi  ;rax*=3;
  inc rax  ;rax++;

  mov rdx, qword [rsp]
  sub rsp,rax  ; char* buff = alloca(rax);
  sub rsp,8  ; char* ptr = buff;
  mov qword [rsp], rdx
  sub rsp,8
  mov qword [rsp], rbp ; push rbp
  mov rbp,rsp
  add rbp,16

  mov rdi,rbp
  add rdi,8
  mov qword [rbp], rdi  ; ptr=buff;
  mov rsi,rax
  mov rdx,rax  ; rdx=rax:strlen(s);
  call zerobuff  ; zerobuff(rdi, rsi);
  dec rdx  ;rdx--;
  mov rcx, 0
  mov r9, 1
  mov r10,0
  mov r11,0
  call alph_1


main:
  mov rbp,rsp
  sub rsp,24
  mov rdi,333
  call itoa
  mov rsi,rax
  mov rdi,fmt
  mov rax,0
  call printf
_exit:
  mov rax,60
  mov rdi,0
  syscall

section .data
  msg db "Hello world",10,0
  fmt db "%s",10,0
