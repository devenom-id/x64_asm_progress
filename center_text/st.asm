section .data
  msg1 db "Window size",10,0
  len1 equ $-msg1
  fmt3 db 27,"[2J",27,"[%d;%df",0
  TIOCGWINSZ dw 21523

section .text
  global main
  extern printf
  extern fflush
  extern stdout

main:
  mov rbp, rsp  ;; set stack
  sub rsp, 8 ;; allocate 8 bytes on stack

  mov rax,16  ;; ioctl
  mov rdi,1
  mov rsi, [TIOCGWINSZ]
  mov rdx, rsp
  syscall

  ; division row
  mov ax, [rsp]
  inc rdi
  mov rdx, 0
  div rdi
  mov [rsp], ax

  ; division col
  mov ax, [rsp+2]
  mov rdx, 0
  div rdi
  mov [rsp+2], ax

  sub rsp, 2
  mov word [rsp], len1
  mov ax, [rsp]
  mov rdx, 0
  div rdi
  sub [rsp+4], ax
  add rsp, 2


  ; printf
  mov rdi, fmt3
  mov si, [rsp]
  mov dx, [rsp+2]
  call printf

  mov rdi, [stdout]
  call fflush

  mov rax,1  ;; write
  mov rdi,1
  mov rsi,msg1
  mov rdx,len1
  syscall

exit:
  mov rax,60  ;; exit
  mov rdi,0
  syscall
