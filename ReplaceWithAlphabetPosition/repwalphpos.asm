section .text
  global main
  extern strlen

func_2:
  cmp [rdi+rsi], 65
  cmovge r10, r9
  cmp [rdi+rsi], 90
  cmovle r11, r9
  and r10, r11
  cmp r10, 1
  jne func_3
  add [rdi+rsi], 32
func_3:
  cmp [rdi+rsi], 97
  cmovge r10, r9
  cmp [rdi+rsi], 122
  cmovle r11, r9
  and r10, r11
  cmp r10, 1
  jne func_1
  ; append str(ord(s[i])) to buffer
func_1:
  cmp rsi, rdx
  jne func2
  ret

func:  ; args: (char* s)
  call strlen
  mov rdx, rax
  mul rax, 3
  inc rax
  sub rsp, rax  ; allocate buffer
  mov rsi, 0
  mov r9, 1  ; set bit
  mov r10, 0 ; and
  mov r11, 0 ; and
  call func_1
  ret

main:
  mov rbp, rsp
  sub rsp, 24
  mov rdi, msg
  call func

section .data
  msg db "Hello world",0
