org 0x7c00        ;endereço de memória em que o programa será carregado
jmp 0x0000:start  ;far jump - seta cs para 0
 
 
start:
    xor ax, ax  ;zera ax, xor é mais rápido que mov
    mov ds, ax  ;zera ds (não pode ser zerado diretamente)
    mov es, ax  ;zera es

    mov ah, 0
    mov al, 13h
    int 10h 

    mov ax, 0

    push ax


    pilhando:
    mov ah, 0
    int 16h
    cmp al, 0
    mov ah,0xe
    mov dx, ax
    mov bh, 0
    mov bl, 0xf
    int 10h
    je printando
    mov ah, 0
    push ax

    jmp pilhando

    printando:
    mov ah,0xe
    pop ax
    mov dx, ax
    mov bh, 0
    mov bl, 0xf
    int 10h
    cmp dx, 0 
    jne printando

done:
    jmp $       ;$ = linha atual
 
times 510 - ($ - $$) db 0
dw 0xaa55       ;assinatura de boot