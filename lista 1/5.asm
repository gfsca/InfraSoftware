org 0x7c00        ;endereço de memória em que o programa será carregado
jmp 0x0000:start  ;far jump - seta cs para 0

fizz db 'Fizz'
buzz db 'Buzz'
fizzbuzz db 'FizzBuzz'

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
    mov al, dh
    mov ah, 0eh
    int 10h

    volta:
    loop counter

    jmp done 
    
 	printFizz:
    mov ax, dh
    div 5
    cmp ah, 0
    je printFizzBuzz
    mov si, fizz
    lodsb
    cmp al, 0 
    je volta
    
    printBuzz:
    mov si, buzz
    lodsb
    cmp al,0
    je volta
   
    printFizzBuzz:
    mov si, fizzbuzz
    lodsb
    cmp al, 0
    je volta


    done:
    jmp $       ;$ = linha atual
 
times 510 - ($ - $$) db 0
dw 0xaa55       ;assinatura de boot