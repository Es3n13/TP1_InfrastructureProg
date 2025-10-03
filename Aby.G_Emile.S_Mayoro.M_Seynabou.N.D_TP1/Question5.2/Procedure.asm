option casemap:none
includelib ucrt.lib
includelib legacy_stdio_definitions.lib
extern printf:proc

.data
    header db "==== TRI DU TABLEAU PAR SELECTION ====", 10, 0
    start_msg db "Avant : ", 0
    end_msg db "Apres : ", 0
    format_output db "%d ", 0
    format_line db 10, 0
    cycle_msg db "Nombre de cycles du CPU pour le tri : %llu cycles", 10, 0

    array dd 64, 25, 12, 22, 11, 8, 45, 33, 18, 7
    size_array dd 10

.code

; RCX = array, RDX = start, R8 = end
; Retour: RAX = index_min
FindMinIndex PROC
    mov r9, rdx                 ; r9 = index_min = start
    mov r10d, [rcx + rdx*4]     ; r10d = val_min
    inc rdx                     ; start++
    
FindLoop:
    cmp rdx, r8
    jg FindEnd
    mov r11d, [rcx + rdx*4]     ; Valeur courante
    cmp r11d, r10d
    jge Continue ; Si >= continuer

    mov r10d, r11d              ; Nouveau minimum
    mov r9, rdx                 ; Nouveau index_min

Continue: inc rdx
    jmp FindLoop
    
FindEnd:
    mov rax, r9
    ret
FindMinIndex ENDP

; Tri par sélection - RCX=array, RDX=size
SortSelection PROC
    push rbx
    push rsi
    push rdi
    
    mov rsi, rcx ; rsi = array
    mov edi, edx ; edi = size
    xor rbx, rbx  ; rbx = i = 0
    dec edi ; edi = size - 1
    
SortLoop:
    cmp ebx, edi
    jge EndSort
    
    ; Trouver le minimum
    mov rcx, rsi
    mov rdx, rbx
    mov r8d, edi
    call FindMinIndex ; RAX = index_min
    
    ; Échanger si nécessaire
    cmp rax, rbx
    je NoSwap

    mov ecx, [rsi + rbx*4] ; temp = array[i]
    mov r8d, [rsi + rax*4] ; r8d = array[index_min]
    mov [rsi + rbx*4], r8d ; Échange
    mov [rsi + rax*4], ecx
    
NoSwap: inc rbx
    jmp SortLoop
    
EndSort:
    pop rdi
    pop rsi
    pop rbx
    ret
SortSelection ENDP

; RCX = array, RDX = size
ShowArray PROC
    push rbx
    push rsi
    push rdi
    
    mov rsi, rcx ; rsi = array
    mov edi, edx ; edi = size
    xor rbx, rbx ; rbx = index
    
ShowLoop:
    cmp ebx, edi
    jge EndShow
    
    sub rsp, 32
    lea rcx, format_output
    mov edx, [rsi + rbx*4]
    call printf
    add rsp, 32
    
    inc rbx
    jmp ShowLoop
    
EndShow:
    sub rsp, 32
    lea rcx, format_line
    call printf
    add rsp, 32
    
    pop rdi
    pop rsi
    pop rbx
    ret
ShowArray ENDP

; Fonction pour lire le Time Stamp Counter
; Retour: RAX = nombre de cycles
GetCycles PROC
    rdtsc
    shl rdx, 32
    or rax, rdx
    ret
GetCycles ENDP

main PROC
    sub rsp, 40
    
    ; Afficher l'en-tête
    lea rcx, header
    call printf
    
    ; Tableau avant tri
    lea rcx, start_msg
    call printf
    lea rcx, array
    mov edx, [size_array]
    call ShowArray
    
    ; Mesurer les cycles et trier le tableau
    call GetCycles ; nombre de cycles avant le tri
    mov rbx, rax ; Sauvegarder début
    
    lea rcx, array
    mov edx, [size_array]
    call SortSelection
    
    call GetCycles ; nombre de cycles après le tri
    sub rax, rbx ; Cycles utilisés (après - avant exécution )
    mov rbx, rax
    
    ; Tableau après tri
    lea rcx, end_msg
    call printf
    lea rcx, array
    mov edx, [size_array]
    call ShowArray
    
    ; Afficher les cycles
    lea rcx, cycle_msg
    mov rdx, rbx
    call printf
    
    add rsp, 40
    xor eax, eax
    ret
main ENDP

END