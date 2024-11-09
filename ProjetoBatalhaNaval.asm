TITLE Projeto
.model small
sortear4 macro
    mov ah,2ch                            ;pega a hora do computador, coloca os segundos em dx
    int 21h
    shr dx,1
    and dx, 00000011b                     ;remover numeros irrelevantes
    ;quatro matrizes inicias possíveis
endm

ZerarValor macro                          ;macro para reseta os índices da matriz
   xor bx,bx
   xor si,si
endm
SortearMacro macro
   call sortear3                           ;sorteia 3 valores (quantidade de casa que o barco pode andar pro lado)
   add bx, dx                              ;altera a linha
   call sortear3                           ;sorteia 3 valores (quantidade de casa que o barco pode andar pro lado)
   add si, dx                              ;altera a coluna
endm
PrintaMsg macro Valor
   mov ah,Valor                            ;O número da função é passado para ah e a função é executada
   int 21h
endm
PopVMatriz macro
   pop si                                  ;macro para retornar valores dos índices, é usado nos modelos, para inserir os hidroaviões na matriz
   pop bx
endm
PushVMatriz macro                          ;macro para retornar valores dos índices, é usado nos modelos, para inserir os hidroaviões na matriz
   push bx
   push si
endm
PulaLinha macro                           ;macro LF (pula uma linha imprimindo o enter na tela)
   mov ah,2
   mov dl,10
   int 21h
endm


.stack 200h
.data ;Matriz 20x20 --> 400 de área 

 matriz db 20 dup(20 dup(0h))

 matrizshow db 20 dup(20 dup(30h))                                                                                   ;matriz onde os barcos são alocados

 ma db 'Voce acertou!',10,' Digite D para desistir ou qualquer outra tecla para disparar novamente$'                 ;ma= mensagem de acerto

 me db 'Voce errou!',10,' Digite D para desistir ou qualquer outra tecla para disparar novamente$'                   ;me= mensagem de erro

 mj db 'Ja disparou nesse local!',10,' Digite D para desistir ou qualquer outra tecla para disparar novamente$'      ;mj= mensagem já disparou nesse local

 minicial db 10,'Seja bem vindo, digite qualquer tecla para continuar$'                                              ;mensagem inicial

 mossT db ' 0 1 2 3 4 5 6 7 8 910111213141516171819  '                                                               ;numeros para as colunas

 mossL db 'abcdefghijklmnopqrst'                                                                                     ;quando a coordenada for digitada, as letras podem ser maiusculas ou minusculas

 menleicord db 10,'Digite a cordenada do disparo',10,'$'                                                             ;mensagens pedindo as coordenadas   

 menleiletra db 'Entre com a letra(somente de A ate T):$'                                                   

 menleinum db 'Entre com o numero (2 digitos, exemplo->01) de 00 ate 19:$'

 optroccord db 'Deseja continuar com a sua cordenada? [','$'                                                         ;pergunta se quer continuar com a mesma coordenada   

 contoptroccord db ']',10,'Digite 1 para trocar ou qualquer outra tecla para confirmar o disparo:$'                  ;continuação do optrocccord

 quantungacertungprintungs db 'Quantidade de acertos total:$'                                                        ;mensagem para mostrar a quantidade de acertos total

 totaldeposs db '/19$'                                                                                               ;total de acertos possíveis, baseado na quantidade de posições das embarcações

 totaldenau db '/6$'                                                                                                 ;quantidade de naufrágios   

 stringquantnau db 'Quantidade de embarcacoes que naufragaram:$'       

 compar db 'a'                                                                                                       ;não ressortear números iguais

 obrigado db 10,'Obrigado por jogar',10,'Encerrando...$'                                                             ;fim de jogo

 extra_s dw 0                                                                                                        ;guarda a posição para printar a próxima matriz

 controleEncerrar db 0                                                                                               ;usada para parar o jogo

 quantidadenaufragios db 6                                                                                           ;controla a quantidade de náufragios

 quantacertosTotal db 0                                                                                              ;quantidade de acertos até o momento
 .code
 ;num 1 -> restricao
 ;1 encouracado -> 4 (tamanho) -> num 2
 ;1 fragata -> 3 -> num 3
 ;2 submarinos -> 2 -> num 4 e 5
 ;2 hidroavião -> 3 e 1 -> num 5 e 6
 main PROC
    mov ax, @data                                             ; Configura o segmento de dados -> DS
    mov ds, ax
    
    ZerarValor                                                ;zera indices
    sortear4                                                  ;devolve 0,1,2 ou 3 em dl

    cmp dl,3                                                  ;se o sorteado for 3, pula para config3      
    je config3
    
    cmp dl, 2                                                 ;se o sorteado for 2, pula para config2  
    je config2

    cmp dl, 1                                                 ;se o sorteado for 1, pula para config1    
    je config1
    
    call mod0                                                 ;se o sorteado for 0, pula para o procedimento mod0 (modelo 0)
    jmp final_da_definicao                                    ;pula para final da definição após sair do procedimento

    config3:                                                  ;a depender de cada config sorteada, entra em seu respectivo procedimento
    call mod3
    jmp final_da_definicao

    config2:
    call mod2
    jmp final_da_definicao

    config1:
    call mod1

    final_da_definicao:                                                                                               

    call lim_km_prinn                                         ;chama o procedimento lim_km_prinn

    lea dx, minicial
    PrintaMsg 9
    PrintaMsg 1
    call lim_km_prinn
    call in_game


    mov ah,4ch                                                 ;encerrando
    int 21h
 main ENDP
 
 

;                       *********TODOS OS MODELOS SEGUEM O MESMO PRINCÍPIO************



;                                   MODELO1


 mod3 PROC
   ZerarValor                                                  ;zera índices SI e DI
   SortearMacro                                                ;sorteia valor
   mov cx,4
   mov al, 20
   mul bl                                                                        
   xchg bx, ax
   encouracado1:                                               ;dispõe o encouraçado na posição sorteada
   mov matriz [bx][si], 1
   inc si
   loop encouracado1

   mov bx, 14                                                  ;muda a posição dos índices
   mov si, 17  
   SortearMacro                                                ;sorteia valor
   mov cx, 3
   mov al,20                                                   ;a depender do valor sorteado, irá para uma posição aleatória da matriz
   mul bl
   xchg bx, ax
   fragata1:
   mov matriz [bx][si], 2                                      ;dispõe a fragata (3 posições -> cx = 3) na posição sorteada
   add bx, 20                                                  ;vai para próxima linha (continuação da disposição da fragata na matriz)
   loop fragata1 

   mov bx, 10                                                  ;muda a posição dos índices                                                                                     
   mov si, 5
   SortearMacro                                                ;sorteia valor      
   mov cx,2                                                    ;a depender do valor sorteado, irá para uma posição aleatória da matriz
   mov al, 20
   mul bl
   xchg bx, ax
   submarino1:
   mov matriz [bx][si], 3                                      ;dispõe o submarino1 (2 posições -> cx = 2) na posição sorteada
   inc si
   loop submarino1

   xor bx,bx                                                   ;muda a posição dos índices
   mov si, 17
   SortearMacro                                                ;sorteia valor
   mov cx, 2                                                                                                                        
   mov al,20                                                   ;a depender do valor sorteado, irá para uma posição aleatória da matriz
   mul bl                                                                                                                  
   xchg bx, ax
   submarino2:                                                 ;dispõe o submarino2 (2 posições -> cx = 2) na posição sorteada   
   mov matriz [bx][si], 4                                                                                                  
   add bx, 20
   loop submarino2
  
   mov bx, 3                                                    ;muda a posição dos índices
   mov si, 7               
   SortearMacro                                                 ;sorteia valor  
   mov cx, 3                                                                                                             
   mov al,20                                                    ;a depender do valor sorteado, vai para uma posição aleatória da matriz
   mul bl
   xchg bx, ax
   PushVMatriz                                                  ;pilha -> si|bx                                                                                           
   add bx, 20                                                   ;bx na próxima linha
   add si, 1                                                    ;si na próxima coluna
   mov matriz [bx][si],5                                        ;insere a "cabeça" do hidroavião
   PopVMatriz                                                   ;retorna valor dos registradores
   hidro_aviao1:
   mov matriz [bx][si],5                                        ;insere o resto do corpo do hidroavião
   add bx, 20
   loop hidro_aviao1

   mov bx, 15                                                   ;muda a posição dos índices
   xor si,si
   SortearMacro                                                 ;sorteia valor 
   mov cx, 3                                                    ;a depender do valor sorteado, vai para uma posição aleatória da matriz                                      
   mov al,20
   mul bl
   xchg bx, ax
   PushVMatriz                                                  ;pilha -> si|bx   
   add bx, 20                                                   ;bx na próxima linha  
   add si, 1                                                    ;si na próxima coluna
   mov matriz [bx][si],6                                        ;insere a "cabeça" do hidroavião     
   PopVMatriz                                                   ;retorna valor dos registradores  
   hidro_aviao2:
   mov matriz [bx][si],6                                        ;insere o resto do corpo do hidroavião
   add bx, 20
   loop hidro_aviao2
   

  ret

 mod3 ENDP


;                                          MODELO 2
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
   PushVMatriz                                    
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



;                                                  MODELO 1
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








 ;                                            MODELO 0
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
    mov ah,2ch                                         ;pega os segundos da hora do computador
    ResortearMaior3:
    int 21h
    and dx, 00000011b                                  ;remove números irrelevantes
    cmp dx, 3
    jae ResortearMaior3                                ;ressortear caso for 3 ou maior          
    cmp dl,compar[0]                                   ;evitar que ele pegue a mesma hora
    je ResortearMaior3
    mov compar[0], dl
    ret
endp




 addaprinta proc
                                                        ;na primeira vez:
  mov bx, extra_s                                       ;bx <-0                               
  mov dl, mossT[bx]                                     ;move primeiro espaço para DL e imprime
  int 21h
  add extra_s, 1

  mov bx, extra_s                                       ;bx <-1
  mov dl, mossT[bx]                                     ;move numero para DL e imprime
  int 21h
  add extra_s, 1                                        ;extra_s <- 2

  ret
 addaprinta endp

 lim_km_prinn proc                                     
    mov cx, 20                                         ;procedimento que imprime as letras de cima do tabuleiro do jogo
    mov dl, ' '                                       
    PrintaMsg 2
    int 21h                                            ;printa espaços
    int 21h
    mov dx, 'A'                                       
    print_letras_tabela:
    int 21h                                            ;printa primeira letra   
    push dx                                            ;salva na pilha
    mov dx, ''                                         ;printa espaço
    int 21h 
    pop dx                                             ;retorna a letra e vai para a próxima          
    inc dl
    loop print_letras_tabela                           ;até imprimir 20 letras
    mov dl, 10                                         ;ENTER
    int 21h

    call addaprinta
    mov dl, ' '                                        ;após printar o primeiro número, dá um espaço 
    int 21h

   ;imprimindo a matrizshow, que é a matriz definida para a impressão

    xor bx,bx                                         ;zera índice das linhas
    mov di, 20                                        ;di é o contador das linhas
    test_print:
    mov cx, 20                                        ;cx é o contador das colunas
    xor si,si                                         ;zera índice das colunas
    test_print1:
    mov dl, matrizshow[bx][si]                        ;primeiro elemento em dl
    add dl, 30h                                       ;transforma em caractere
    int 21h                                           ;imprime
    inc si                                            ;próxima coluna
    mov dl, ' '                                       ;espaço entre colunas
    int 21h
    loop test_print1                                  ;enquanto as colunas não forem totalmente impressas, pula para test_print1
    mov dl, 10                                        ;imprime o enter para espaçar as linhas      
    int 21h

    push bx                                           ;salva bx na pilha (índice das linhas)
    call addaprinta                                   ;insere o próximo número antes de printar as linhas da matriz, (refaz o processo com o extra_s em 2)
    mov dl, ' '                                       ;espaço
    int 21h
    pop bx                                            ;índice das linhas novamente em bx


    add bx, 20                                        ;próxima linha
    dec di                                            ;faz isso 20 vezes
    jnz test_print
    mov extra_s, 0                                    ;reseta a variável extra_s
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
 mov dl, 10                                                                ;limpa a tela com espaços sucessivos
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
                                                                                       ;Recebe a info de qual é o numero da embarcação com Al antes do call
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
 mov al, 1                                                  ;se for 
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