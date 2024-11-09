TITLE Projeto
.model small
sortear4 macro
    mov ah,2ch
    int 21h
    shr dx,1
    and dx, 00000011b
    ;quatro matrizes inicias possíveis
endm

ZerarValor macro
   xor bx,bx
   xor si,si
endm
SortearMacro macro
   call sortear3
   add bx, dx
   call sortear3
   add si, dx
endm
PrintaMsg macro Valor
   mov ah,Valor
   int 21h
endm
PopVMatriz macro
   pop si
   pop bx
endm
PushVMatriz macro
   push bx
   push si
endm
PulaLinha macro
   mov ah,2
   mov dl,10
   int 21h
endm


.stack 200h
.data ;Matriz 20x20 --> 400 de área 
 matriz db 20 dup(20 dup(0h))
 matrizshow db 20 dup(20 dup(30h));mostrar onde os disparos foram
 ma db 'Voce acertou!',10,' Digite D para desistir ou qualquer outra tecla para disparar novamente$'
 me db 'Voce errou!',10,' Digite D para desistir ou qualquer outra tecla para disparar novamente$'
 mj db 'Ja disparou nesse local!',10,' Digite D para desistir ou qualquer outra tecla para disparar novamente$'
 minicial db 10,'Seja bem vindo, digite qualquer tecla para continuar$'
 mossT db ' 0 1 2 3 4 5 6 7 8 910111213141516171819  '
 mossL db 'abcdefghijklmnopqrst'
 menleicord db 10,'Digite a cordenada do disparo',10,'$'
 menleiletra db 'Entre com a letra(somente de A ate T):$'
 menleinum db 'Entre com o numero (2 digitos, exemplo->01) de 00 ate 19:$'
 optroccord db 'Deseja continuar com a sua cordenada? [','$'
 contoptroccord db ']',10,'Digite 1 para trocar ou qualquer outra tecla para confirmar o disparo:$'
 quantungacertungprintungs db 'Quantidade de acertos total:$'
 totaldeposs db '/19$'
 totaldebar1 db '/1$'
 totaldebar2 db '/2$'
 totaldenau db '/6$'
 stringquantnau db 'Quantidade de embarcacoes que naufragaram:$'
 compar db 'a'
 obrigado db 10,'Obrigado por jogar',10,'Encerrando...$'
 extra_s dw 0
 controleEncerrar db 0
 quantidadenaufragios db 6
 quantacertosTotal db 0 
 .code
 ;num 1 -> restricao
 ;1 encouracado -> 4 (tamanho) -> num 2
 ;1 fragata -> 3 -> num 3
 ;2 submarinos -> 2 -> num 4 e 5
 ;2 Hidroavião -> 3 e 1 -> num 5 e 6
 main PROC
    mov ax, @data  ; Configura o segmento de dados ->DS
    mov ds, ax
    
    ZerarValor
    sortear4; devolve 0,1,2 ou 3 em dl

    cmp dl,3
    je config3
    
    cmp dl, 2
    je config2

    cmp dl, 1
    je config1
    
    call mod0
    jmp final_da_definicao

    config3:
    call mod3
    jmp final_da_definicao

    config2:
    call mod2
    jmp final_da_definicao

    config1:
    call mod1

    final_da_definicao:

    call lim_km_prinn
   
    lea dx, minicial
    PrintaMsg 9
    PrintaMsg 1
    call lim_km_prinn
    call in_game


    mov ah,4ch ;encerrando
    int 21h
 main ENDP
 
 ;MOD3
 mod3 PROC
   ZerarValor 
   SortearMacro
   mov cx,4
   mov al, 20
   mul bl
   xchg bx, ax
   encouracado1:
   mov matriz [bx][si], 1
   inc si
   loop encouracado1

   mov bx, 14
   mov si, 17
   SortearMacro
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   fragata1:
   mov matriz [bx][si], 2
   add bx, 20
   loop fragata1 

   mov bx, 10
   mov si, 5
   SortearMacro
   mov cx,2
   mov al, 20
   mul bl
   xchg bx, ax
   submarino1:
   mov matriz [bx][si], 3
   inc si
   loop submarino1

   xor bx,bx
   mov si, 17
   SortearMacro
   mov cx, 2
   mov al,20
   mul bl
   xchg bx, ax
   submarino2:
   mov matriz [bx][si], 4
   add bx, 20
   loop submarino2
  
   mov bx, 3
   mov si, 7
   SortearMacro
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   PushVMatriz; pilha -> si|bx
   add bx, 20
   add si, 1
   mov matriz [bx][si],5
   PopVMatriz
   hidro_aviao1:
   mov matriz [bx][si],5
   add bx, 20
   loop hidro_aviao1

   mov bx, 15
   xor si,si
   SortearMacro
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   PushVMatriz; pilha -> si|bx
   add bx, 20
   add si, 1
   mov matriz [bx][si],6
   PopVMatriz
   hidro_aviao2:
   mov matriz [bx][si],6
   add bx, 20
   loop hidro_aviao2
   

  ret

 mod3 ENDP







 ;MOD2
 mod2 PROC
   xor bx,bx
   mov si, 13
   SortearMacro
   mov cx,4
   mov al, 20
   mul bl
   xchg bx, ax
   encouracado1_2:
   mov matriz [bx][si], 1
   inc si
   loop encouracado1_2

   mov bx, 1
   mov si, 1
   SortearMacro
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   fragata1_2:
   mov matriz [bx][si], 2
   add bx, 20
   loop fragata1_2 

   mov bx, 5
   mov si, 10
   SortearMacro
   mov cx,2
   mov al, 20
   mul bl
   xchg bx, ax
   submarino1_2:
   mov matriz [bx][si], 3
   inc si
   loop submarino1_2

   mov bx, 5
   mov si, 17
   SortearMacro
   mov cx, 2
   mov al,20
   mul bl
   xchg bx, ax
   submarino2_2:
   mov matriz [bx][si], 4
   add bx, 20
   loop submarino2_2
  
   mov bx, 10
   mov si, 8
   SortearMacro
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   PushVMatriz; pilha -> si|bx
   add bx, 20
   add si, 1
   mov matriz [bx][si],5
   PopVMatriz
   hidro_aviao1_2:
   mov matriz [bx][si],5
   add bx, 20
   loop hidro_aviao1_2

   mov bx, 15
   mov si, 15
   SortearMacro
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   PushVMatriz; pilha -> si|bx
   add bx, 20
   add si, 1
   mov matriz [bx][si],6
   PopVMatriz
   hidro_aviao2_2:
   mov matriz [bx][si],6
   add bx, 20
   loop hidro_aviao2_2
   

  ret

 mod2 ENDP






 ;MOD1
 mod1 PROC
   mov bx, 13
   xor si,si
   SortearMacro
   mov cx, 4
   mov al,20
   mul bl
   xchg bx, ax
   encouracado1_1:
   mov matriz [bx][si], 1
   add bx, 20
   loop encouracado1_1 

   mov bx, 16
   mov si, 12
   SortearMacro
   mov cx,3
   mov al, 20
   mul bl
   xchg bx, ax
   fragata1_1:
   mov matriz [bx][si], 2
   inc si
   loop fragata1_1

   mov bx, 8
   mov si, 10
   SortearMacro
   mov cx,2
   mov al, 20
   mul bl
   xchg bx, ax
   submarino1_1:
   mov matriz [bx][si], 3
   inc si
   loop submarino1_1

   mov bx, 11
   mov si, 5
   SortearMacro
   mov cx, 2
   mov al,20
   mul bl
   xchg bx, ax
   submarino2_1:
   mov matriz [bx][si], 4
   add bx, 20
   loop submarino2_1

   xor bx,bx
   mov si, 2
   SortearMacro
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   PushVMatriz; pilha -> si|bx
   add bx, 20
   dec si
   mov matriz [bx][si],5
   PopVMatriz
   hidro_aviao1_1:
   mov matriz [bx][si],5
   add bx, 20
   loop hidro_aviao1_1

   xor bx,bx
   mov si, 10
   SortearMacro
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   PushVMatriz; pilha -> si|bx
   add bx, 20
   inc si
   mov matriz [bx][si],6
   PopVMatriz
   hidro_aviao2_1:
   mov matriz [bx][si],6
   add bx, 20
   loop hidro_aviao2_1

   ret
 mod1 ENDP








 ;MOD0
 mod0 PROC
   
  mov bx, 13
   mov si, 1
   SortearMacro
   mov cx, 4
   mov al,20
   mul bl
   xchg bx, ax
   encouracado1_0:
   mov matriz [bx][si], 1
   add bx, 20
   loop encouracado1_0

   mov bx, 16
   mov si, 12
   SortearMacro
   mov cx,3
   mov al, 20
   mul bl
   xchg bx, ax
   fragata1_0:
   mov matriz [bx][si], 2
   inc si
   loop fragata1_0

   mov bx, 8
   mov si, 10
   SortearMacro
   mov cx,2
   mov al, 20
   mul bl
   xchg bx, ax
   submarino1_0:
   mov matriz [bx][si], 3
   inc si
   loop submarino1_0

   mov bx, 11
   mov si, 5
   SortearMacro
   mov cx, 2
   mov al,20
   mul bl
   xchg bx, ax
   submarino2_0:
   mov matriz [bx][si], 4
   add bx, 20
   loop submarino2_0

   xor bx,bx
   mov si, 10
   SortearMacro
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   PushVMatriz; pilha -> si|bx
   add bx, 20
   inc si
   mov matriz [bx][si],5
   PopVMatriz
   hidro_aviao1_0:
   mov matriz [bx][si],5
   inc si
   loop hidro_aviao1_0

   xor bx,bx
   xor si,si
   SortearMacro
   mov cx, 3
   mov al,20
   mul bl
   xchg bx, ax
   PushVMatriz; pilha -> si|bx
   add bx, 20
   inc si
   mov matriz [bx][si],6
   PopVMatriz
   hidro_aviao2_0:
   mov matriz [bx][si],6
   inc si
   loop hidro_aviao2_0

 ret
 mod0 ENDP

 ;Sortear3
 sortear3 proc
    mov ah,2ch
    ResortearMaior3:
    int 21h
    and dx, 00000011b
    cmp dx, 3
    jae ResortearMaior3
    cmp dl,compar[0]
    je ResortearMaior3
    mov compar[0], dl
    ret
endp




 addaprinta proc
  mov bx, extra_s
  mov dl, mossT[bx]
  int 21h
  add extra_s, 1

  mov bx, extra_s
  mov dl, mossT[bx]
  int 21h
  add extra_s, 1

  ret
 addaprinta endp

 lim_km_prinn proc
    mov cx, 20
    mov dl, ' '
    PrintaMsg 2
    int 21h
    int 21h
    mov dx, 'A'
    print_letras_tabela:
    int 21h
    push dx
    mov dx, ''
    int 21h
    pop dx
    inc dl
    loop print_letras_tabela
    mov dl, 10
    int 21h

    call addaprinta
    mov dl, ' '
    int 21h


    xor bx,bx
    mov di, 20
    test_print:
    mov cx, 20
    xor si,si
    test_print1:
    mov dl, matrizshow[bx][si]
    add dl, 30h
    int 21h
    inc si
    mov dl, ' '
    int 21h
    loop test_print1
    mov dl, 10
    int 21h

    push bx
    call addaprinta
    mov dl, ' '
    int 21h
    pop bx


    add bx, 20
    dec di
    jnz test_print
    mov extra_s, 0
    ret
 lim_km_prinn endp


 in_game proc
    jogo:
    mov al, 1
    cmp controleEncerrar, al
    je enddd
    call perguntar_cord
    call conferir_disparo
    call ganhar_jogo
    mov al, 19; Quantidade total de slots de barco
    cmp quantacertosTotal, al
    jne jogo
    enddd:
    mov dx, offset obrigado
    PrintaMsg 9
    ret
 in_game endp


 perguntar_cord proc
    

    lerdnovo_ampliado:
    call limpar_tela
    mov dx, offset stringquantnau
    PrintaMsg 9
    
    call naufragios

    mov dl, quantidadenaufragios
    or dl, 30h
    PrintaMsg 2

    mov dx,offset totaldenau
    PrintaMsg 9

    PulaLinha

    mov dx, offset quantungacertungprintungs
    PrintaMsg 9


    mov ah,2
    mov dl, quantacertosTotal; Printar a quantidade de acertos
    or dl, 30h
    cmp dl, 39h
    jb naosubitrair
    push dx
    mov dl, 31h
    int 21h
    pop dx
    sub dl, 10h
    naosubitrair:
    int 21h

    mov dx, offset totaldeposs
    PrintaMsg 9

    PulaLinha
    xor cx,cx
    mov dx, offset menleicord
    PrintaMsg 9

    mov dx, offset menleiletra
    int 21h

    jmp codigonormal
    lerdnovo:
    jmp lerdnovo_ampliado
    codigonormal:

    PrintaMsg 1
    cmp al, 60h
    jb maius
    sub al, 61h
    jmp minusc
    maius:
    sub al, 41h
    minusc:
    and ax, 00ffh
    mov si, ax

    PulaLinha

    mov dx, offset menleinum
    PrintaMsg 9

    PrintaMsg 1
    xor al, 30h
    mov ch, al
    mov bl, 10
    mul bl
    mov bx, ax
    PrintaMsg 1
    and ax, 000fh
    mov cl, al
    add bx, ax
    mov al, 20
    mul bx
    mov bx, ax

    PulaLinha

    lea dx, optroccord
    PrintaMsg 9

    mov dl,mossL[si]
    PrintaMsg 2

    mov dl, ch
    add dl, 30h
    int 21h
    mov dl, cl
    add dl,30h
    int 21h
    
    lea dx, contoptroccord
    PrintaMsg 9
    
    PrintaMsg 1
    cmp al, 31h
    je lerdnovo
    
    ret
 perguntar_cord endp


 limpar_tela proc
 mov dl, 10
 mov cx, 30
 mov ah, 2
 loopdelimpartela:
 int 21h
 loop loopdelimpartela
 ret
 limpar_tela endp


 conferir_disparo proc
   
   PulaLinha

   mov dl, 30h
   cmp matrizshow[bx][si], dl 
   jne ja_disparou

   cmp matriz[bx][si], 0
   je errou
   

   mov matriz[bx][si], 0
   mov matrizshow[bx][si],0Fah
   call lim_km_prinn
   lea dx, ma
   PrintaMsg 9
   
   jmp acertou
   errou:
   mov matrizshow[bx][si],1fh
   call lim_km_prinn
   lea dx, me
   PrintaMsg 9
   acertou:

   jmp nao_dsp_ja

   ja_disparou:
   call lim_km_prinn
   lea dx, mj
   PrintaMsg 9
   
   nao_dsp_ja:

   PrintaMsg 1

   cmp al, 100
   jne naosub
   sub al, 32; Encerrar antes E aceitar tanto D como d
   naosub:
   cmp al, 68
   jne n_encerrar
   
  
   
   mov al, 1
   
   mov controleEncerrar, al; encerrar
   
   n_encerrar:

   ret


 conferir_disparo endp




 ganhar_jogo proc
 mov ah, 0
 mov quantacertosTotal, ah
 xor bx, bx
 mov di, 20
 loopconferirganho:
 mov cx, 20
 xor si, si
 trocalinhaconferirganho:
 mov ah, matrizshow[bx][si]
 inc si
 cmp ah, 0Fah
 jne naoparaumponto
 push ax
 mov ax, 1
 add quantacertosTotal,al
 pop ax
 naoparaumponto:
 loop trocalinhaconferirganho
 add bx, 20
 dec di
 jnz loopconferirganho
 

 ret
 ganhar_jogo endp





 naufragios proc
 ;Recebe a info de qual é o numero da embaração com Al antes do call
 mov ah, 6
 mov quantidadenaufragios, ah

 ;mov ah, 6  Haviao
 call confnauplural

 mov ah, 5;Haviao
 call confnauplural

 mov ah, 4;sub
 call confnauplural
  
 mov ah, 3;sub
 call confnauplural

 mov ah, 2;frag
 call confnauplural

 mov ah, 1;enc
 call confnauplural

 ret 
 naufragios endp

 confnauplural proc
 xor bx, bx
 mov di, 20
 laco1:
 xor si, si
 mov cx, 20
 laco2:
 cmp matriz[bx][si], ah
 jne negativo
 mov al, 1
 sub quantidadenaufragios, al
 jmp finalneg
 negativo:
 inc si
 loop laco2
 add bx, 20
 dec di
 jnz laco1


 finalneg:

 ret
 confnauplural endp

 end main