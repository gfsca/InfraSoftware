org 0x7c00		  ;endereço de memória em que o programa será carregado
jmp 0x0000:start  ;far jump - seta cs para 0
string times 40 db 0
string2 times 40 db 0
print:
    mov ah,0xe
    mov bh,0
    mov bl,0xf
    int 10h
    ret
printString:
  while2:
    pop ax
    call print
  loop while2
  ret
lerString:
  while:
    mov ah,0x0
    int 16h
    cmp al,13
    je printString
    push ax
    inc cx
    jmp while
  ret
start:
    xor ax, ax    ;zera ax, xor é mais rápido que mov
    mov ds, ax    ;zera ds (não pode ser zerado diretamente)
    mov es, ax    ;zera es
    mov cx,ax
    call lerString
    ;call printString
    ;call print
    jmp $         ;$ = linha atual

times 510 - ($ - $$) db 0
dw 0xaa55