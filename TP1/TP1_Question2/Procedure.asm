option casemap:none
includelib ucrt.lib
includelib legacy_stdio_definitions.lib
extern printf:proc
extern gets:proc

.data
	prompt db "Entrez un mot : ", 0
	isPalindrome db "Le mot '%s' est un palindrome", 10 , 0
	notPalindrome db "Le mot '%s' n'est pas un palindrome", 10, 0
	buffer db 100 dup(0)

.code

main PROC
	sub rsp, 40

	;Afficher l'invitation � entrer le mot
	lea rcx, prompt
	call printf

	;Lire l'entr�e
	lea rcx, buffer
	call gets

	;Trouver la longueur du mot
	lea rcx, buffer  ; pointe au d�but du buffer
	xor r8, r8 ; compteur de la longueur (s'assurer qu'il est vide)

FindLength:
	mov al, [rcx + r8] ; Lire le caract�re
	test al, al ; V�rifier si c'est la fin de la chaine (0)
	jz LengthFound ; Si z�ro, la fin trouv�e
	inc r8 ; Sinon incr�menter la longueur
	jmp FindLength ; Continuer

LengthFound:
	;R8 contient la longueur du mot
	test r8, r8 ; V�rifier si la chaine est vide
	jz NotPal

	;Initialiser les pointeurs
	lea rcx, buffer ; Pointeur de d�but
	lea rdx, buffer ; Pointeur de fin
	add rdx, r8
	dec rdx ; rdx pointe sur le dernier caract�re

	mov r9, r8 ; R9 = longueur
	shr r9, 1 ; Shift Right x1 cr�er une division par 2. Donc R9 = longueur /2

CheckLoop:
	mov al, [rcx]
	mov bl, [rdx]
	cmp al, bl ; comparer les deux caract�res
	jne NotPal ; Si diff�rent = pas un palindrome

	;Bouger les pointeurs
	inc rcx ; Avance de pointeur de d�but
	dec rdx ; Recule le pointeur de fin

	;D�cr�menter le compteur
	dec r9
	jnz CheckLoop ;Si le compteur n'est pas � z�ro, on recomment le loop

	;Si on passe les �tapes pr�c�dentes, mot = un palindrome
	lea rcx, isPalindrome
	lea rdx, buffer
	call printf
	jmp EndProg

NotPal:
	lea rcx, notPalindrome
	lea rdx, buffer
	call printf

EndProg:
	add rsp, 40
	ret

main ENDP

END
