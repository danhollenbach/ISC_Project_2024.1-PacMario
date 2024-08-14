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
		addi s9, s9, 20		# soma 20 pontos ao contador de pontos
		la a0, POINTS		# carrega o n de pontos atual
		lh t2, 0(a0)
		addi t2, t2,1
		sh t2, 0(a0)		# soma 1 ao n de pontos
		j CLOSE
		
PILL:		##########		# vai pra rotina do mario poderoso 
		addi t2, t2, -7		# agora tira a pilula do mapa
		sb t2, 0(a0)
		

CLOSE:		ret			# retorna
