org 0x7c00        ;endereço de memória em que o programa será carregado
jmp 0x0000:start  ;far jump - seta cs para 0
 
 
start:
    xor ax, ax  ;zera ax, xor é mais rápido que mov
    mov ds, ax  ;zera ds (não pode ser zerado diretamente)
    mov es, ax  ;zera es

    mov al, 13
    push ax

    pilhando:
    mov ah, 0
    int 16h
    cmp al, 13
    je printando
    push ax
    jmp pilhando

    printando:
    pop ax
    mov ah, 0xe
    mov bh, 0
    mov bl, 0xf
    int 10h
    cmp al, 13 
    jne printando
    jmp done

done:
    hlt
 
times 510 - ($ - $$) db 0
dw 0xaa55       ;assinatura de boot