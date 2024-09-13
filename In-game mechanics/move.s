KEY2:		li a5, 1
		li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)			# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
   		beq t0,zero,FIM   	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  			# le o valor da tecla tecla
  		la t1, MARIO_STATUS
		li t0,'w'
		beq t2,t0,LOAD_CIMA		# se tecla pressionada for 'w', chama LOAD_CIMA
		li t0,'a'
		beq t2,t0,LOAD_ESQ		# se tecla pressionada for 'a', chama LOAD_ESQ
		li t0,'s'
		beq t2,t0,LOAD_BAIXO		# se tecla pressionada for 's', chama LOAD_BAIXO
		li t0,'d'
		beq t2,t0,LOAD_DIR		# se tecla pressionada for 'd', chama LOAD_DIR
		li t0, 'm'
		beq t2,t0,LOAD_NEXT		# se a tecla for 'm', ativa a troca de fase
	
FIM:		ret				# retorna

LOAD_ESQ:	li t3, 0
		sh t3, 2(t1)			# carrega a dire��o em MARIO_STATUS (esq = 0)
		ret

LOAD_DIR:	li t3, 1			# carrega a dire��o em MARIO_STATUS (dir = 1)
		sh t3, 2(t1)
		ret
		
LOAD_CIMA:	li t3, 2			# carrega a dire��o em MARIO_STATUS (cima = 2)
		sh t3, 2(t1)
		ret
		
LOAD_BAIXO:	li t3, 3			# carrega a dire��o em MARIO_STATUS (baixo = 3)
		sh t3, 2(t1)
		ret

LOAD_NEXT:	la t0, STAGE
		lh t1, 0(t0)			# carrega qual o nivel atual
		li t3, 3
		beq t1, t3 ,BEGIN
		li t3, 2
		blt t1, t3, SKIP		# carrega o cheat caso seja apertado dentro das fases
		j FINISH
		ret
		
BEGIN:		li t3, 0
		sh t3, 0(t0)			# guarda 0 em STAGE, logo, inicia o jogo se o usuario apertar 'm' do menu
		la t0, PRESSED
		li t3, 1
		sh t3, 0(t0)			# atualiza o valor de PRESSED para sair do loop
		ret

SKIP:		addi t1, t1, 1
		sh t1, 0(t0)			# guarda 1 em STAGE, logo, pula de nivel se o usuario apertar 'm' do primeiro nivel
		la t0, PRESSED
		li t3, 1
		sh t3, 0(t0)			# atualiza o valor de PRESSED para sair do loop
		la t0, POINTS
		li t1, 0
		sh t1, 0(t0)			# zera o contador de pontos para passagem de fase
		la t0, MARIO_STATUS
		li t1, 1
		sh t1, 4(t0)			# zera o status de poder do mario
		ret

FINISH:		la t0, PRESSED
		li t3, 1
		sh t3, 0(t0)			# atualiza o valor de PRESSED para sair do loop
		ret		
		
MOVE:		la t0, MARIO_STATUS		# checa a condicao de movimento e anda 4 pixels para a direcao desejada
		la s5, MARIO_HITBOX1
		la s6, MARIO_HITBOX2
		lh t0, 2(t0)			# carrega a direcao do mario
		beqz t0, CHAR_ESQ		# caso a direcao seja 0, move para a esquerda
		li t1, 1
		beq t0, t1, CHAR_DIR		# caso a direcao seja 1, move para a direita
		li t1, 2
		beq t0, t1, CHAR_CIMA		# caso a direcao seja 2, move para cima
		j CHAR_BAIXO			# caso a direcao seja 3, move para baixo
		
		ret

CHAR_ESQ:	la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lh t2,0(t0)
		addi t4, t2, 3
		mv t5, t4
		sh t4, 0(s5)			# carrega o x da primeira hitbox
		sh t5, 0(s6)			# carrega o x da segunda hitbox
		sh t2,0(t1)
		lh t2,2(t0)
		addi t4, t2, 5
		addi t5, t4, 6
		sh t4, 2(s5)			# carrega o y da primeira hitbox
		sh t5, 2(s6)			# carrega o y da segunda hitbox
		sh t2,2(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS
		
		lh t2, 0(s5)			# x hitbox 1
		lh t3, 2(s5)			# y hitbox 1
		lh t4, 0(s6)			# x hitbox 2
		lh t5, 2(s6)			# y hitbox 2
		colision(s4, t2, t3, t4, t5) 	# checa a colisao
		la t2, COL
		lh t3, 0(t2)
		beqz t3, ROTATEL		# caso contra a parede, evita a atualizacao da posicao
		j BREAK
		
ROTATEL:	la a0,CHAR_POS
		lh t1,0(t0)			# carrega o x atual do personagem
		addi t1,t1,-4			# decrementa 4 pixeis
		
		sh t1,0(t0)			# salva
		ret

CHAR_DIR:	la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lh t2,0(t0)
		addi t4, t2, 12			
		mv t5, t4			
		sh t4, 0(s5)			# carrega o x da primeira hitbox
		sh t5, 0(s6)			# carrega o x da segunda hitbox
		sh t2,0(t1)
		lh t2,2(t0)
		addi t4, t2, 5
		addi t5, t4, 6
		sh t4, 2(s5)			# carrega o y da primeira hitbox
		sh t5, 2(s6)			# carrega o y da segunda hitbox
		sh t2,2(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS
		
		lh t2, 0(s5)			# x hitbox 1
		lh t3, 2(s5)			# y hitbox 1
		lh t4, 0(s6)			# x hitbox 2
		lh t5, 2(s6)			# y hitbox 2
		colision(s4, t2, t3, t4, t5) 	# checa a colisao
		la t2, COL
		lh t3, 0(t2)
		beqz t3, ROTATER		# caso contra a parede, evita a atualizacao da posicao
		j BREAK
		
ROTATER:	la t0,CHAR_POS
		lh t1,0(t0)			# carrega o x atual do personagem
		addi t1,t1,4			# incrementa 4 pixeis
		sh t1,0(t0)			# salva
		ret

CHAR_CIMA:	la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lh t2,0(t0)
		addi t4, t2, 4			
		addi t5, t4, 7			
		sh t4, 0(s5)			# carrega o x da primeira hitbox
		sh t5, 0(s6)			# carrega o x da segunda hitbox
		sh t2,0(t1)
		lh t2,2(t0)
		addi t4, t2, 3
		mv t5, t4
		sh t4, 2(s5)			# carrega o y da primeira hitbox
		sh t5, 2(s6)			# carrega o y da segunda hitbox
		sh t2,2(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS
		
		lh t2, 0(s5)			# x hitbox 1
		lh t3, 2(s5)			# y hitbox 1
		lh t4, 0(s6)			# x hitbox 2
		lh t5, 2(s6)			# y hitbox 2
		colision(s4, t2, t3, t4, t5) 	# checa a colisao
		la t2, COL
		lh t3, 0(t2)
		beqz t3, ROTATEU		# caso contra a parede, evita a atualizacao da posicao
		j BREAK
		
ROTATEU:	la t0,CHAR_POS
		lh t1,2(t0)			# carrega o y atual do personagem
		addi t1,t1,-4			# decrementa 4 pixeis
		sh t1,2(t0)			# salva
		ret

CHAR_BAIXO:	la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lh t2,0(t0)
		addi t4, t2, 4			
		addi t5, t4, 7			
		sh t4, 0(s5)			# carrega o x da primeira hitbox
		sh t5, 0(s6)			# carrega o x da segunda hitbox
		sh t2,0(t1)
		lh t2,2(t0)
		addi t4, t2, 12
		mv t5, t4
		sh t4, 2(s5)			# carrega o y da primeira hitbox
		sh t5, 2(s6)			# carrega o y da segunda hitbox
		sh t2,2(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS
		
		lh t2, 0(s5)			# x hitbox 1
		lh t3, 2(s5)			# y hitbox 1
		lh t4, 0(s6)			# x hitbox 2
		lh t5, 2(s6)			# y hitbox 2
		colision(s4, t2, t3, t4, t5) 	# checa a colisao
		la t2, COL
		lh t3, 0(t2)
		beqz t3, ROTATED		# caso contra a parede, evita a atualizacao da posicao
		j BREAK
		
ROTATED:	la t0,CHAR_POS
		lh t1,2(t0)			# carrega o y atual do personagem
		addi t1,t1,4			# incrementa 4 pixeis
		sh t1,2(t0)			# salva
		ret

BREAK:		li t3, 0
		sh t3, 0(t2)			# zera o contador de colisao
		la t0, CHAR_POS
		lh t1, 0(t0)
		lh t2, 2(t0)
		addi t1, t1, 4
		addi t2, t2, 4
		la t0, MARIO_CENTER
		sh t1, 0(t0)			# atualiza o centro do mario (x) como sendo (x do boneco + 4)
		sh t2, 2(t0)			# atualiza o centro do mario (y) como sendo (y do boneco + 4)
		ret

PRISON:		lh t0, 0(a0)			# ve se o fantasma esta aprisionado
		beqz t0, RELEASE		# caso nao esteja aprisionado, vai para o fim da rotina
		lh t0, 0(a4)
		li t1, 80
		bge t0, t1, FREE		# caso ja tenham se passado 3 segundos apos a prisao do fantasma, o libera
		sh a1, 0(a5)			# guarda o x de aprisionamento na posicao
		sh a2, 2(a5)			# guarda o y de aprisionamento na posicao
		beqz t0, UPDATE_L		# caso tenha acabado de ser preso, nao carrega a antiga posicao ainda, para fazer o erase do fantasma do mapa
		addi t0, t0, 1
		sh t0, 0(a4)			# atualiza o contador
		sh a1, 0(a7)
		sh a2, 2(a7)
		j RELEASE

UPDATE_L:	addi t0, t0, 1
		sh t0, 0(a4)			# atualiza o contador
		j RELEASE
		
FREE:		li t1, 2
		sh t1, 0(a0)			# libera o fantasma da condicao de preso
		li t1, 0
		sh t1, 0(a4)			# zera o contador
		li a1, 156			# x do liberacao do fantasma
		li a2, 112			# y de liberacao do fantasma
		sh a1, 0(a5)
		sh a2, 2(a5)
		li t1, 3
		sh t1, 2(a6)			# atualiza a direcao do fantasma

RELEASE:	ret


G_MOVE:		lh a2, 0(a1)			# carrega se os fantasmas estao presos
		li t1, 1
		beq a2, t1, STILL		# caso fantasmas estejam presos, pula o movimento
		li t1, 2
		beq a2, t1, STILL_FREE		# caso acabado de sair do aprisionamento, atualiza o contador e sai da rotina
		lh t1, 0(t0)			# x do meio do fantasma
		lh t2, 2(t0)			# y do meio do fantasma
		li a1, 320
		mul t2, t2, a1			# y no mapa = y * 320
		add t2, t1, t2			# Y * 320 + x
		add t2, t2, s8
		addi t2, t2, 8			# endereco do mapa + y * 320 + x + 8
		lb t2, 0(t2)			# carrega infos do mapa de colisao dos fantasmas no centro do fantasma
		li t3, 2
		rem t3, s9, t3			# checa se o contador do poder do mario e impar
		bne t3, zero, STILL		# caso nao for, pula o movimento (offest para os fantasmas assustados)

G_SENTIDO:	li t1, 7			# cor do bloco de intersecao
		beq t2, t1, TURN_CHECK		# caso o fantasma esteja em uma intersecao, muda a direcao
		j SENTIDO2
		
TURN_CHECK:	lh t1, 0(a7)			# carrega o contador de virar do fantasma
		bne t1, zero, SENTIDO3		# caso acabado de entrar na intersecao, atualiza o contador e muda a direcao
		j TURN	
		
SENTIDO2:	lh t1, 0(a7)
		bne t1, zero, TURN_UPDATE	# caso o contador de virada esteja em 1 ao sair da intersecao, o atualiza 
		j SENTIDO3
		
TURN_UPDATE:	li t1, 0
		sh t1, 0(a7)			# caso o fantasma tenha saido da intersecao, atualiza o contador
		
SENTIDO3:	lh t1, 2(a0)			# carrega a direcao do fantasma
		beqz, t1, G_ESQ
		li t2, 1
		beq t1, t2, G_DIR
		li t2, 2
		beq t1, t2, G_CIMA
		
G_BAIXO:	lh t1, 0(a6)			# carrega o x do fantasma
		sh t1, 0(a5)			# salva o x na antiga posicao do fantasma
		addi t1, t1, 4
		sh t1, 0(t0)			# salva o x na coordenada x do centro
		lh t1, 2(a6)			# carrega o y do fantasma
		sh t1, 2(a5)			# salva o y na antiga posicao do fantasma
		addi t1, t1, 4			# y = y + mov
		sh t1, 2(a6)			# salva o y novo na nova posicao do fantasma
		addi t1, t1, 4
		sh t1, 2(t0)			# salva o y novo na coordenada y do centro
		j STILL
		
G_ESQ:		lh t1, 2(a6)			# carrega o y do fantasma
		sh t1, 2(a5)			# salva o y na antiga posicao do fantasma
		addi t1, t1, 4
		sh t1, 2(t0)			# salva o y na coordenada y do centro
		lh t1, 0(a6)			# carrega o x do fantasma
		sh t1, 0(a5)			# salva o x na antiga posicao do fantasma
		addi t1, t1, -4			# x = x - mov
		sh t1, 0(a6)			# salva o novo x na nova posicao do fantasma
		addi t1, t1, 11		
		sh t1, 0(t0)			# salva o x novo na coordenada x do centro
		j STILL

G_DIR:		lh t1, 2(a6)			# carrega o y do fantasma
		sh t1, 2(a5)			# salva o y na antiga posicao do fantasma
		addi t1, t1, 4
		sh t1, 2(t0)			# salva o y na coordenada y do centro
		lh t1, 0(a6)			# carrega o x do fantasma
		sh t1, 0(a5)			# salva o x na antiga posicao do fantasma
		addi t1, t1, 4			# x = x - mov
		sh t1, 0(a6)			# salva o novo x na nova posicao do fantasma
		addi t1, t1, 4
		sh t1, 0(t0)			# salva o x novo na coordenada x do centro
		j STILL

G_CIMA:		lh t1, 0(a6)			# carrega o x do fantasma
		sh t1, 0(a5)			# salva o x na antiga posicao do fantasma
		addi t1, t1, 4
		sh t1, 0(t0)			# salva o x na coordenada x do centro
		lh t1, 2(a6)			# carrega o y do fantasma
		sh t1, 2(a5)			# salva o y na antiga posicao do fantasma
		addi t1, t1, -4			# y = y - mov
		sh t1, 2(a6)			# salva o y novo na nova posicao do fantasma
		addi t1, t1, 11
		sh t1, 2(t0)			# salva o y novo na coordenada y do centro
		j STILL
		
TURN:		li t6, 1
		sh t6, 0(a7)			# atualiza o contador de mudanca de direcao
		li t6, 0			# contador para o loop
		li t3, 0			# contador para a melhor direcao
		li a6, 0			# salva a direcao para a qual o fantasma se movera
		lh a1, 2(a0)			# direcao do fantasma

TURN_LOOP:	addi a1, a1, 1
		li t5, 4			# comparador para o loop
		bge a1, t5, RESET_C
		j SENTIDO_CHECK
				
RESET_C:	li a1, 0

SENTIDO_CHECK:	bge t6, t5, END_MOVE
		lh t1, 0(t0)			# x do centro do fantasma
		lh t2, 2(t0)			# y do centro do fantasma
		beqz a1, ESQ_CHECK
		li t5, 1
		beq a1, t5, DIR_CHECK
		li t5, 2
		beq a1, t5, UP_CHECK
		
DOWN_CHECK:	addi t2, t2, 8			# checa para ver o movimento para baixo
		mv t5, t2
		li t4, 320
		mul t2, t2, t4
		addi t2, t2, 8
		add t2, t1, t2
		mv t4, t1
		add t2, t2, a4
		lb t2, 0(t2)			# checa a info do mapa de colisao no ponto especificado
		addi t6, t6, 1			# soma ao contador do loop
		bne t2, zero, TURN_LOOP
		li a5, 3			# valor de direcao no status dos personagens (baixo = 3)
		j CHECK_DIST
		
ESQ_CHECK:	addi t1, t1, -8			# checa para ver o movimento para a esquerda
		mv t4, t1
		li t5, 320
		mul t5, t2, t5
		addi t1, t1, 8
		add t1, t5, t1
		mv t5, t2
		add t1, t1, a4
		lb t1, 0(t1)			# checa a info do mapa de colisao no ponto especificado
		addi t6, t6, 1			# soma ao contador do loop
		bne t1, zero, TURN_LOOP
		li a5, 0			# valor de direcao no status dos personagens (esquerda = 0)
		j CHECK_DIST

DIR_CHECK:	addi t1, t1, 8		# checa para ver o movimento para a direita
		mv t4, t1
		li t5, 320
		mul t5, t2, t5
		addi t1, t1, 8
		add t1, t5, t1
		mv t5, t2
		add t1, t1, a4
		lb t1, 0(t1)			# checa a info do mapa de colisao no ponto especificado
		addi t6, t6, 1			# soma ao contador do loop
		bne t1, zero, TURN_LOOP
		li a5, 1			# valor de direcao no status dos personagens (direita = 1)
		j CHECK_DIST

UP_CHECK:	addi t2, t2, -8			# checa para ver o movimento para cima
		mv t5, t2
		li t4, 320
		mul t2, t2, t4
		addi t2, t2, 8
		add t2, t1, t2
		mv t4, t1
		add t2, t2, a4
		lb t2, 0(t2)			# checa a info do mapa de colisao no ponto especificado
		addi t6, t6, 1			# soma ao contador do loop
		bne t2, zero, TURN_LOOP
		li a5, 2			# valor de direcao no status dos personagens (cima = 2)

CHECK_DIST:	lh a2, 0(a3)			# carrega a direcao oposta do fantasma
		bne a5, a2, PIT		# se a direcao for a oposta do fantasma, ignora ela
		j TURN_LOOP
		
PIT:		la a7, CHAR_POS			# endereco da posicao do mario	
		lh a2, 0(a7)			# x da posicao do mario
		lh a7, 2(a7)			# y da posicao do mario
		sub a2, a2, t4			# xmario - xfantasma
		mul a2, a2, a2			# (xmario - xfantasma)^2
		sub a7, a7, t5			# ymario - yfantasma
		mul a7, a7, a7			# (ymario - yfantasma) ^2
		add a2, a2, a7
		lh a7, 4(a0)			# carrega se o fantasma esta assustado ou naO
		beqz t3, LOAD_G			# caso ainda nao haja melhor valor, salva este
		bne a7, zero, NORMAL_CHECK
		bge a2, t3, LOAD_G		# ve se a distancia entre o mario e o fantasma eh menor que a salva, se for, nao muda o valor salvo (rotina do medo)
		j TURN_LOOP
		
NORMAL_CHECK:	blt a2, t3, LOAD_G		# ve se a distancia entre o mario e o fantasma eh maior que a salva, se for, nao muda o valor salvo (rotina normal)
		j TURN_LOOP
		
LOAD_G:		mv t3, a2			# salva na distancia 
		mv a6, a5			# salva a direcao
		j TURN_LOOP	
				
END_MOVE:	sh a6, 2(a0)			# salva a direcao no status do fantasma
		beqz a6, OP_DIR
		li a7, 1
		beq a7, a6, OP_ESQ
		li a7, 2
		beq a6, a7, OP_BAIXO
		
OP_CIMA:	li a7, 2
		sh a7, 0(a3)			# atualiza a nova direcao oposta
		j STILL
		
OP_BAIXO:	li a7, 3
		sh a7, 0(a3)			# atualiza a nova direcao oposta
		j STILL
		
OP_DIR:		li a7, 1
		sh a7, 0(a3)			# atualiza a nova direcao oposta
		j STILL
		
OP_ESQ:		li a7, 0
		sh a7, 0(a3)			# atualiza a nova direcao oposta
		j STILL

STILL_FREE:	li t1, 0
		sh t1, 0(a1)			# liberta o fantasma da condicao de aprisionamento completamente (apos esperar um loop para erase do rastro)

STILL:		ret
