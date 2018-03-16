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
	je red
	cmp al, "g"
	je green
	cmp al, "b"
	je blue
	cmp al, "c"
	je cyan
	cmp al, "y"
	je yellow
	cmp al, "m"
	je magenta


	red:
	mov bh, 4
	jmp nextKey
	green:
	mov bh, 2
	jmp nextKey
	blue:
	mov bh, 1
	jmp nextKey
	cyan:
	mov bh, 3
	jmp nextKey
	yellow:
	mov bh, 14
	jmp nextKey
	magenta:
	mov bh, 5
	jmp nextKey


	nextKey:
	mov ah, 0 ;ler um caractere
 	int 16h   ;caractere armazenado em al
 	
 	mov cx, 10
    mov dx, 10

 	cmp al, "t"
 	je triangle
 	cmp al, "q"
 	je square
 	cmp al, "T"
 	je trapeze
 
 	triangle:
	mov ah, 0ch	;imprime um pixel na tela 
    mov al, 0ah
    int 10h 
    jmp done

 	square:
 	mov ah, 0ch	;imprime um pixel na tela
 	inc cx
 	inc dx 
    mov al, 0ah
    int 10h
    cmp cx, 50
    jb square
    jmp done

 	trapeze:
 	mov ah, 0ch	;imprime um pixel na tela 
    mov al, 0ah
    int 10h
    jmp done
    
    done:
    jmp $       ;$ = linha atual
 
times 510 - ($ - $$) db 0
dw 0xaa55       ;assinatura de boot