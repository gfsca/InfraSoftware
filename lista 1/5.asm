org 0x7c00        ;endereço de memória em que o programa será carregado
jmp 0x0000:start  ;far jump - seta cs para 0

fizz db 
buzz db 
fizzbuzz db

start:
    xor ax, ax  ;zera ax, xor é mais rápido que mov
    mov ds, ax  ;zera ds (não pode ser zerado diretamente)
    mov es, ax  ;zera es

    mov ah, 0
    mov al, 13h
    int 10h 
 	
 	mov ah, 0xb	; alterar cor de fundo da tela
 	mov bh, 0
 	mov bl, 4	
 	int 10h 
    mov dh, 0
    mov cx, 100
    counter:
    inc dh
    mov ax, dh
    div 3
    cmp ah, 0
    je printFizz
    mov ax, dh
    div 5
    cmp ah, 0
    je printBuzz
    ;printa o numero normal
    volta:
    loop counter

    jmp done 
    
 	printFizz:
    mov ax, dh
    div 5
    cmp ah, 0
    je printFizzBuzz
    ;printa fizz
    jmp volta
    
    printBuzz:
    
    jmp volta
   
    printFizzBuzz:
    
    jmp volta

    done:
    jmp $       ;$ = linha atual
 
times 510 - ($ - $$) db 0
dw 0xaa55       ;assinatura de boot