org 0x7c00        ;endereço de memória em que o programa será carregado
jmp 0x0000:start  ;far jump - seta cs para 0

; ntr db 
; esc db 
; equi db
; isos db

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

 	mov ah, 0 ;ler um caractere
 	int 16h   ;caractere armazenado em al
			  ;push em al pode ajudar a simplificar a operação (push1 -> primeira letra push2 -> segunda letra)
	
	cmp al,0

	je print
	jmp done

	; mov dl, al
 ;    mov ah, 0
 ;    int 16h

 ;    mov dh, al
 ;    mov ah, 0
    ;int 16h

    print:
    mov ah, 0xe
	mov al, "a"
	mov bh, 0 
	mov bl, 0xf
	int 10h
    done:
    jmp $       ;$ = linha atual
 
times 510 - ($ - $$) db 0
dw 0xaa55       ;assinatura de boot