.text

COIN_COUNT:	li t0, 8		# dimensoes do tile do mapa de colisao para comparacao
		li t1, 40		# largura do mapa de colisao 
		div a1, a1, t0		
		addi a1, a1, 1		# pega a posicao relativa do personagem no mapa de colisao de moedas (x)
		div a2, a2, t0
		addi a2, a2, 1		# pega a posicao relativa do personagem no mapa de colisao de moedas (y)
		mul a2, a2, t1		# a2 = y * 40
		add a2, a2, a1		# a2 = y * 40 + x
		addi a2, a2, 8		# pula as informacoes da imagem
		add a0, a0, a2
		lb t2, 0(a0)		# carrega qual o status de moeda na posicao atual (0 = sem moeda, 255 = moeda, 7 = poder)
		beqz t2, CLOSE		# se nao ha moedas, pula para o fim
		li t0, 7
		beq t2, t0, PILL	# se o mario encostar em um poder, trata essa rotina
		addi t2, t2, -255	# se houver moedas, agora transforma em um espaco sem moedas
		sb t2, 0(a0)
		la a0, CURRENT
		lh t0, 0(a0)
		addi t0, t0, 20
		sh t0, 0(a0)		# soma 20 pontos ao contador de pontos
		la a0, POINTS		# carrega o n de pontos atual
		lh t2, 0(a0)
		addi t2, t2,1
		sh t2, 0(a0)		# soma 1 ao n de pontos
		j CLOSE
		
PILL:		la t0, MARIO_STATUS	# vai pra rotina do mario poderoso 
		li t1, 0
		sh t1, 4(t0)		# deixa o mario poderoso
		li s9, 0		# contador para o efeito passar
		addi t2, t2, -7		# agora tira a pilula do mapa
		sb t2, 0(a0)
		j CLOSE
		
COLISION_CHECK: addi a0, a0, 8		# pula as informacoes do mapa
		mv s5, a0		# guarda o endereco do mapa
		li t2, 320
		mul a2, a2, t2		# y = y * 320
		add a0, a0, a2		# a0 = a0 + y
		add a0, a0, a1		# a0 = y * 320 + x + 8
		lb t2, 0(a0)
		bne t2, zero, SKIP_MOVE	# caso a informacao carregada de em um espaco de parede, pula o movimento
		
		mv a0, s5		# infos do mapa
		li t2, 320
		mul a4, a4, t2		# y = y * 320
		add a0, a0, a4		# a0 = a0 + y
		add a0, a0, a3		# a0 = y * 320 + x + 8
		lb t2, 0(a0)
		bne t2, zero, SKIP_MOVE # caso a informacao carregada de em um espaco de parede, pula o movimento
		j CLOSE	

SKIP_MOVE:	la t2, COL
		li t3, 1
		sh t3, 0(t2)		# guarda info da colisao na label

CLOSE:		ret			# retorna
