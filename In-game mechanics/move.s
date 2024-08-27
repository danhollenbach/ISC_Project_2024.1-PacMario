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
		
MOVE:		la t0, MARIO_STATUS		# checa a condi��o de movimento e anda 4 pixels para a dire��o desejada
		la s5, MARIO_HITBOX1
		la s6, MARIO_HITBOX2 
		lh t0, 2(t0)			# carrega a dire��o do mario
		beqz t0, CHAR_ESQ		# caso a dire��o seja 0, move para a esquerda
		li t1, 1
		beq t0, t1, CHAR_DIR		# caso a dire��o seja 1, move para a direita
		li t1, 2
		beq t0, t1, CHAR_CIMA		# caso a dire��o seja 2, move para cima
		j CHAR_BAIXO			# caso a dire��o seja 3, move para baixo
		
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
		bne t3, zero, BREAK		# caso contra a parede, evita a atualizacao da posicao
		
		la a0,CHAR_POS
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
		bne t3, zero, BREAK		# caso contra a parede, evita a atualizacao da posicao
		
		la t0,CHAR_POS
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
		bne t3, zero, BREAK		# caso contra a parede, evita a atualizacao da posicao
		
		la t0,CHAR_POS
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
		bne t3, zero, BREAK		# caso contra a parede, evita a atualizacao da posicao
		
		la t0,CHAR_POS
		lh t1,2(t0)			# carrega o y atual do personagem
		addi t1,t1,4			# incrementa 4 pixeis
		sh t1,2(t0)			# salva
		ret

BREAK:		li t3, 0
		sh t3, 0(t2)			# zera o contador de colisao
		ret
		
