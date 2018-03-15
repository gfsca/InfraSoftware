org 0x7c00        ;endereço de memória em que o programa será carregado
jmp 0x0000:start  ;far jump - seta cs para 0

 
start:
    xor ax, ax  ;zera ax, xor é mais rápido que mov
    mov ds, ax  ;zera ds (não pode ser zerado diretamente)
    mov es, ax  ;zera es
 	
 	mov ah, 0xb	; alterar cor de fundo da tela
 	mov bh, 0
 	mov bl, 3	
 	int 10h 

 	mov ah, 0 ;ler um caractere
 	int 16h   ;caractere armazenado em al
			  ;push em al pode ajudar a simplificar a operação (push1 -> primeira letra push2 -> segunda letra)
			  
	cmp al, "r"
	cmp al, "g"
	cmp al, "b"
	cmp al, "c"
	cmp al, "y"
	cmp al, "m"

	mov ah, 0 ;ler um caractere
 	int 16h   ;caractere armazenado em al

 	cmp al, "t"
 	cmp al, "q"
 	cmp al, "T"

    mov ah, 0ch	;imprime um pixel na tela 
    mov bh, 0 ;empilhar o que tiver em cx
    mov al, 0ah
    int 10h

    jmp $       ;$ = linha atual
 
times 510 - ($ - $$) db 0
dw 0xaa55       ;assinatura de boot