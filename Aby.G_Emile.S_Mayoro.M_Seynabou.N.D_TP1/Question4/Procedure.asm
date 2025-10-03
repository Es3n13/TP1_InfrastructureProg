option casemap:none
includelib ucrt.lib
includelib legacy_stdio_definitions.lib


.code
;===Recherche du premier caract�re===
;RCX = pointeur vers la chaine
;RDX = pointeur vers les 3 caract�res � rechercher et remplacer
;R8 = pointeur vers le caract�res touv�
;R9 = pointer vers l'index trouv�
;Retour : RAX = 1 si trouv�, 0 si non trouv�

FindFirstChar PROC
	xor rax, rax ; RAX = index courant
	mov r10, rdx ; R10 = pointeur vers les caract�res recherch�s

SearchLoop:
	mov r11b,[rcx + rax] ; R11b = caract�re courant de la chaine
	test r11b, r11b ; Fin de chaine ?
	jz NotFound

	;Comparer avec le premier caract�re
	mov dl, [r10]
	cmp r11b, dl
	je Found

	;Comparer avec le deuxi�me caract�re
	mov dl, [r10 +1]
	cmp r11b, dl
	je Found

	;Comparer avec le troisi�me caract�re
	mov dl, [r10 +2]
	cmp r11b, dl
	je Found

	inc rax ; Saute au prochaine caract�re de la chaine
	jmp SearchLoop

Found :
	;Stock� le caract�re trouv�
	mov [r8], r11b
	;Stock� l'index
	mov dword ptr [r9], eax
	mov rax, 1 ;Retour = 1 (trouv�)
	ret

NotFound : 
	mov rax, 0 ; retour = 0  (non trouv�)
	ret

FindFirstChar ENDP

;===Remplacement cyclique des caract�res===
;RCX = pointeur vers la chaine
;RDX = pointeur vers les 3 caract�res (C1, C2, C3)

ReplaceChars PROC
	mov rsi, rcx ; RSI = pointeur vers la chaine
	mov rdi, rdx ; RDI = pointeur vers les 3 carat�res

ProcessLoop:
	mov al, [rsi] ; AL = Caract�re courant
	test al, al ; Fin de la chaine ?
	jz Done

	;Comparer avec C1
	mov bl, [rdi] ; Bl = C1
	cmp al, bl
	je ReplaceWithC2

	;Comparer avec C2
	mov bl, [rdi + 1] ; Bl = C2
	cmp al, bl
	je ReplaceWithC3

	;Comparer avec C3
	mov bl, [rdi + 2] ; Bl = C3
	cmp al, bl
	je ReplaceWithC1

	jmp NextChar ; Aucun match, passer au caract�re suivant

ReplaceWithC2:
	mov bl, [rdi + 1] ; BL = C2
	mov [rsi], bl ; Remplacer par C2
	jmp NextChar

ReplaceWithC3:
	mov bl, [rdi + 2] ; BL = C3
	mov [rsi], bl ; Remplacer par C3
	jmp NextChar

ReplaceWithC1:
	mov bl, [rdi ] ; BL = C1
	mov [rsi], bl ; Remplacer par C1

NextChar:
	inc rsi ; Caract�re suivant
	jmp ProcessLoop

Done:
	ret

ReplaceChars ENDP


END