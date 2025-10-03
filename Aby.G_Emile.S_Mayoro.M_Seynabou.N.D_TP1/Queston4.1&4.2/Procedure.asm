option casemap:none
includelib ucrt.lib
includelib legacy_stdio_definitions.lib
extern printf:proc
extern gets:proc

.data
promptStr db "Entrez ne chaine de caracteres : ", 0
promptChars db "Entrez 3 caracteres a rechercher et remplacer : ", 0
foundMsg db "Premier caractere trouve : '%c' a la position %d", 10, 0
notFoundMsg db "Aucun caractere trouve (-1)", 10, 0
beforeMsg db "Chaine avant remplacement  %s", 10 , 0
afterMsg db "Chaine apres remplacement %s", 10, 0
buffer db 100 dup(0)
chars db 4 dup(0) ; Pour stocker les 3 caract�res + null

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
	mov [r9], rax
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
	mov bl, [rdi] ; BL = C1
	mov [rsi], bl ; Remplacer par C1

NextChar:
	inc rsi ; Caract�re suivant
	jmp ProcessLoop

Done:
	ret

ReplaceChars ENDP


main PROC
	sub rsp, 40

	;Demander la chaine de caract�res
	lea rcx, promptStr
	call printf
	lea rcx, buffer
	call gets

	;Demander les 3 caract�res � rechercher
	lea rcx, promptChars
	call printf
	lea rcx, chars
	call gets

Part1:
	; === PARTIE 1: Recherche du premier caract�re ===
	;Pr�paration des variables pour le r�sultat
	sub rsp, 16 ; Allou� espace pour le r�sultat
	mov rbx, rsp ; RBX pointe le premier caract�re trouv�
	lea rbp, [rsp + 8] ; RBP point vers l'index trouv�

	;Appel la proc�dure
	lea rcx, buffer ; Chaine de caract�re
	lea rdx, chars ; Caract�res recherch�s
	mov r8, rbx ; Adresse pour stocker le caract�re trouv�
	mov r9, rbp ; Adresse pour stocker l'index trouv�
	call FindFirstChar

	;V�rifier le r�sultat
	test rax, rax
	jz NotFound

	;Afficher le r�sultat trouv�
	lea rcx, foundMsg
	movzx rdx, byte ptr [rbx]
	mov r8, [rbp]
	inc r8
	call printf
	jmp Part2

NotFound:
	lea rcx, notFoundMsg
	call printf

Part2:
    ; === PARTIE 2: Remplacement cyclique ===
    ; Afficher la cha�ne avant remplacement
    lea rcx, beforeMsg
    lea rdx, buffer
    call printf

    ; Appeler la proc�dure de remplacement cyclique
    lea rcx, buffer     ; Cha�ne
    lea rdx, chars      ; 3 caract�res
    call ReplaceChars

    ; Afficher la cha�ne apr�s remplacement
    lea rcx, afterMsg
    lea rdx, buffer
    call printf

EndProgram:
	add rsp, 56 ; lib�rer l'espace (40 + 16)
	ret

main ENDP

END
