option casemap:none
includelib ucrt.lib
includelib legacy_stdio_definitions.lib

.data
;Tableau initiaux
public array1
public array2

array1 db 1, 2, 3, 4
array2 dd 10, 20, 30, 40

array_size = 4

.code

;Proceudre pour inverse et multiplier le tableau par 10
;RCX = adresse du tableau, TDX = taille
public ReverseAndMultiplyByteArray
ReverseAndMultiplyByteArray PROC

    push rsi
    push rdi
    push rbx
    push r12

    mov rsi, rcx ; RSI = d�but du tableau
    mov rdi, rcx ; RDI = d�but du tableau
    mov r12, rdx ; r12 = taille
    dec r12 ; r21 = index du dernier �k�ment

    ;calculer la fin du tableau
    mov r8, rsi
    add r8, r12 ; r8 = fin du tableau

    xor r9, r9 ; r9 = compteur

ByteTransformLoop:
    cmp rsi, r8
    jg ByteTransformEnd

    ; Charger les �l�ments de d�but et de fin
    movzx eax, byte ptr [rsi] ;�l�ment du d�ut
    movzx ebx, byte ptr [r8] ; �l�ment de fin

    ;Multiplier par 10
    imul eax, eax, 10 ; d�but x10
    imul ebx, ebx, 10 ; fin x10

    ;�changer les valeurs transform�es
    mov [rsi], bl ; stock valeur de fin multipli�e au d�but
    mov [r8], al ; stock valeur de d�but multipli�e � la fin

    ;Bouger les pointeurs
    inc rsi
    dec r8
    jmp ByteTransformLoop

ByteTransformEnd:
	pop r12
	pop rbx
	pop rdi
	pop rsi

	ret

ReverseAndMultiplyByteArray ENDP

;Procedure pour inverser et diviser par 10 un tableau de dwords
;RCX = adresse du tableau, RDX = taille
public ReverseAndDivideDwordArray
ReverseAndDivideDwordArray PROC
    push rsi
    push rdi
    push rbx
    push r12
    
    mov rsi, rcx ; RSI = d�but du tableau
    mov r12, rdx ; R12 = taille
    mov rdi, rdx ; taille pour calculer la fin
    dec rdi ; index du dernier �l�ment
    shl rdi, 2 ; multiplier par 4 (taille du dword)
    add rdi, rsi  ; RDI = fin du tableau

DwordTransformLoop:
    cmp rsi, rdi
    jge DwordTransformEnd

    ; Charger les �l�ments de d�but et de fin
    mov eax, [rsi] ; Dword du d�but
    mov ebx, [rdi] ; Dword de fin

    ; Diviser par 10 - CORRECTION MAJEURE
    mov ecx, 10 ; diviseur = 10
    
    ; Diviser le d�but
    xor edx, edx ; IMPORTANT: EDX doit �tre � 0 avant division
    div ecx  ; EAX = EAX / 10, EDX = reste
    mov r8d, eax  ; sauvegarde le r�sultat du d�but

    ; Diviser la fin
    mov eax, ebx ; charger la valeur de fin
    xor edx, edx ; EDX � 0
    div ecx ; EAX = EAX / 10, EDX = reste  
    mov r9d, eax ; sauvegarde le r�sultat de fin

    ; �changer les valeurs transform�es - CORRIG�
    mov [rsi], r9d ; stock valeur de fin divis�e au d�but
    mov [rdi], r8d 

    ; Bouger les pointeurs - CORRIG�
    add rsi, 4
    sub rdi, 4 
    jmp DwordTransformLoop

DwordTransformEnd:
    pop r12
    pop rbx
    pop rdi
    pop rsi

    ret

ReverseAndDivideDwordArray ENDP

END