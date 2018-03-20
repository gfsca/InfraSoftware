org 0x7c00		  ; endereço de memória em que o programa será carregado
jmp 0x0000:start  ; far jump - seta cs para 0

; write string
%macro print 1
	; reset cursor
	xor dx, dx 	  ; dh [cursor row] & dl [cursor column] <- 0
	xor ax, ax	  ; ax <- 0
	xor bh, bh    ; [video page] bh <- 0 
	mov ah, 0x03  ; [10h 03 interrupt] -> read cursor and store in dh, dl
	int 10h		  ; [video interrupt]

	mov edi, %1 ; scasb requires string to be on edi register
	call strlen

	mov ah, 0x13 ; [write string]
	mov al, 0x01 ; [write mode] al <- character only

	xor bh, bh   ; [video page] bh <- 0 
	mov bl, 0xa  ; [attribute] bl <- white
	
	; cx specifies the number of characters,
	; but it's already defined by strlen

	mov bp, %1 ; [string to be written]

	int 10h    ; [video interrupt]
%endmacro

; remainder is stored in dx
%macro modulo 1
	xor dx, dx    ; [zero dx] dx <- 0
	mov ax, cx	  ; [current number] ax <- counter
	mov bx, %1	  ; [divisor] b <- divisor
	div bx		  ; dx:ax <- ax/bx
%endmacro


; input is stored in >al<
read_input:
	cld		   ; clear >si< dir flag
	xor si, si ; clear >s1<
	xor bx, bx ; clear >bx<
	mov cx, 1  ; set initial decimal place
	jmp .read
.read:
	mov ah, 0  ; [int 16h -> read next keystroke]
	int 16h    ; [16h keyboard services]
	cmp al, 13 ; if input is return, end input
	je .next
	xor ah, ah ; clear high bytes, so we only have num
	sub al, 48 ; subtract ASCII zero value, so we have pure digit number
	push ax    ; push >ax< to stack
	inc si	   ; inc number of digits
	jmp .read
.next:
	cmp si, 0   ; if we're done scanning the stack
	je exit
	dec si	    ; we counted another digit
	pop ax	    ; get ax back from stack
	imul ax, cx ; multiply by >cx<, which holds the decimal place for the digit
	add bx, ax  ; >bx< stores out actual number
	imul cx, 10 ; go to next decimal place in >cx<
	jmp .next
exit:
	ret  		; go back to macro

; reads number input and saves it in var
%macro save_input 1
	call read_input
	mov word [%1], bx ; store our final number in our variable	
%endmacro

; compares (a + b, c)
%macro compare_add 3
	xor bx, bx
	add bx, word [%1]
	add bx, word [%2]
	cmp bx, word [%3]
%endmacro

%macro comp_xor 2
	mov ax, word [%1]
	mov bx, word [%2]
	xor ax, bx
	cmp ax, 0
%endmacro

start:
	xor ax, ax	; ax <- 0
	mov cx, ax	; cx <- 0
	mov es, ax	; es <- 0

	print Instructions

	save_input lado_a
	save_input lado_b
	save_input lado_c

	compare_add lado_a, lado_b, lado_c
	jle .not_triangle
	compare_add lado_a, lado_c, lado_b
	jle .not_triangle
	compare_add lado_b, lado_c, lado_a
	jle .not_triangle

	; it is a triangle!

	comp_xor lado_a, lado_b
	je .iso_or_eq	   ; a == b, c can be same (eq.) or dif (iso.)

	comp_xor lado_a, lado_c
	je .isosceles	   ; a != b == c
	jmp .escaleno 	   ; a != b != c

	.iso_or_eq:
		comp_xor lado_c, lado_b
		je .equilatero ; a == b == c
		jmp .isosceles ; a == b != c

	.isosceles:
		print Isosceles
		jmp .exit
		
	.equilatero:
		print Equilatero
		jmp .exit
		
	.escaleno:
		print Escaleno
		jmp .exit

	.not_triangle:
		print Not_Triangle
		jmp .exit

	.exit:
		hlt

print_space: ; prints a space
	mov ah, 0xe  ; [int 10h -> write instruction]
	mov al, 0x20 ; [al <- space character]
	xor bh, bh   ; [bh <- 0, page number]
	mov bl, 0xa  ; [bl <- 0xa, foreground]
	int 10h  	 ; [10h video interrupt]
	ret

strlen:
	xor ecx, ecx ; ecx <- 0 [counter]
	xor al, al   ; al <- 0  [scasb search value. in this case, NUL, which would be EOL]
	not ecx		 ; ecx = -1 [we set ecx to max value so we can count down]
	cld			 ; clear direction flag for rep
	repne scasb  ; decreases 'ecx' until it finds 'al' (EOL)
	not ecx		 ; here, ecx = -strlen - 2. by reversing the bits we get strlen + 1
	dec ecx		 ; ecx = strlen
	ret			 ; return to print

lado_a dw 0
lado_b dw 0
lado_c dw 0

Instructions db 'Digite cada numero seguido de um ENTER: ', 0
Not_Triangle db 'Nao e triangulo', 0
Escaleno db 'Escaleno', 0
Isosceles db 'Isosceles', 0
Equilatero db 'Equilatero', 0

times 510 - ($ - $$) db 0
dw 0xaa55		; assinatura de boot