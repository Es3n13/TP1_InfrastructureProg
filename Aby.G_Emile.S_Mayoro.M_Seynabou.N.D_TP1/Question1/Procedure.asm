option casemap:none
includelib ucrt.lib
includelib legacy_stdio_definitions.lib
extern printf:proc

.data
	tab dq 16, 8, 20, 9, 11, 10, 14, 3; tableau de valeur pair
	fmArray db "Tableau : ", 0
	fmElement db "%lld ", 0
	fmNewLine db 10, 0
	fmResultat db "Resultat du calcul : %lld", 10, 0

.code
main PROC

;Affichage du tableau

	sub rsp, 40

	;Afficher "Tableau : "
	lea rcx, fmArray
	call printf

	; Afficher les éléments du tableau
	lea rbx, tab ; pointeur du début du tableau
	mov r12, LENGTHOF tab ; nombre d'éléments dans le tableau
	xor r13, r13 ; vider l'accumulateur des éléments

PrintArray:
	lea rcx, fmElement
	mov rdx, [rbx + r13 * 8]
	call printf
	inc r13 ; incrémente le compteur d'élément
	cmp r13, r12 ; compare le nombre d'élément affiché avec la longueur du tableau 
	jl PrintArray ; si le nombre d'élément est inférieur à la longueur du tableau, on recommence l'opération

	;Nouvelle ligne
	lea rcx, fmNewLine
	call printf


;Calcul du résultat

	;RAX = accumulateur du résultat
	xor rax, rax ; on s'assure que l'accumulateur est vide

	;RCX = pointeur du début du tableau
	lea rcx, tab

	;RDX = point de la fin du tableau
	lea rdx, tab
	add rdx, (LENGTHOF tab - 1)*8 ; Va chercher la longueur du tableau et multiplier par 8 octets par qword

	;R8 = compteur pour les paires (n/2)
	mov r8, LENGTHOF tab / 2

LoopNumbers:
	; Charger le premier élément (début)
	mov r9, [rcx]

	; Charger le dernier élément (fin)
	mov r10, [rdx]

	; Calcul (début - fin)
	sub r9, r10

	;Ajouter au résultat
	add rax, r9

	;Avancer le pointeur du début (+8 octets)
	add rcx, 8 

	;Reculer le pointeur de fin (-8 octets)
	sub rdx, 8

	;Décrémenter le compteur
	dec r8
	jnz LoopNumbers

	;Affichage
	mov rcx, OFFSET fmResultat
	mov rdx, rax ;valeur
	call printf
	add rsp, 40

	ret

main ENDP

END