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

    mov rsi, rcx ; RSI = début du tableau
    mov rdi, rcx ; RDI = début du tableau
    mov r12, rdx ; r12 = taille
    dec r12 ; r21 = index du dernier ékément

    ;calculer la fin du tableau
    mov r8, rsi
    add r8, r12 ; r8 = fin du tableau

    xor r9, r9 ; r9 = compteur

ByteTransformLoop:
    cmp rsi, r8
    jg ByteTransformEnd

    ; Charger les éléments de début et de fin
    movzx eax, byte ptr [rsi] ;élément du déut
    movzx ebx, byte ptr [r8] ; élément de fin

    ;Multiplier par 10
    imul eax, eax, 10 ; début x10
    imul ebx, ebx, 10 ; fin x10

    ;Échanger les valeurs transformées
    mov [rsi], bl ; stock valeur de fin multipliée au début
    mov [r8], al ; stock valeur de début multipliée à la fin

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
    
    mov rsi, rcx ; RSI = début du tableau
    mov r12, rdx ; R12 = taille
    mov rdi, rdx ; taille pour calculer la fin
    dec rdi ; index du dernier élément
    shl rdi, 2 ; multiplier par 4 (taille du dword)
    add rdi, rsi  ; RDI = fin du tableau

DwordTransformLoop:
    cmp rsi, rdi
    jge DwordTransformEnd

    ; Charger les éléments de début et de fin
    mov eax, [rsi] ; Dword du début
    mov ebx, [rdi] ; Dword de fin

    ; Diviser par 10 - CORRECTION MAJEURE
    mov ecx, 10 ; diviseur = 10
    
    ; Diviser le début
    xor edx, edx ; IMPORTANT: EDX doit être à 0 avant division
    div ecx  ; EAX = EAX / 10, EDX = reste
    mov r8d, eax  ; sauvegarde le résultat du début

    ; Diviser la fin
    mov eax, ebx ; charger la valeur de fin
    xor edx, edx ; EDX à 0
    div ecx ; EAX = EAX / 10, EDX = reste  
    mov r9d, eax ; sauvegarde le résultat de fin

    ; Échanger les valeurs transformées - CORRIGÉ
    mov [rsi], r9d ; stock valeur de fin divisée au début
    mov [rdi], r8d 

    ; Bouger les pointeurs - CORRIGÉ
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