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

	; Afficher les �l�ments du tableau
	lea rbx, tab ; pointeur du d�but du tableau
	mov r12, LENGTHOF tab ; nombre d'�l�ments dans le tableau
	xor r13, r13 ; vider l'accumulateur des �l�ments

PrintArray:
	lea rcx, fmElement
	mov rdx, [rbx + r13 * 8]
	call printf
	inc r13 ; incr�mente le compteur d'�l�ment
	cmp r13, r12 ; compare le nombre d'�l�ment affich� avec la longueur du tableau 
	jl PrintArray ; si le nombre d'�l�ment est inf�rieur � la longueur du tableau, on recommence l'op�ration

	;Nouvelle ligne
	lea rcx, fmNewLine
	call printf


;Calcul du r�sultat

	;RAX = accumulateur du r�sultat
	xor rax, rax ; on s'assure que l'accumulateur est vide

	;RCX = pointeur du d�but du tableau
	lea rcx, tab

	;RDX = point de la fin du tableau
	lea rdx, tab
	add rdx, (LENGTHOF tab - 1)*8 ; Va chercher la longueur du tableau et multiplier par 8 octets par qword

	;R8 = compteur pour les paires (n/2)
	mov r8, LENGTHOF tab / 2

LoopNumbers:
	; Charger le premier �l�ment (d�but)
	mov r9, [rcx]

	; Charger le dernier �l�ment (fin)
	mov r10, [rdx]

	; Calcul (d�but - fin)
	sub r9, r10

	;Ajouter au r�sultat
	add rax, r9

	;Avancer le pointeur du d�but (+8 octets)
	add rcx, 8 

	;Reculer le pointeur de fin (-8 octets)
	sub rdx, 8

	;D�cr�menter le compteur
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