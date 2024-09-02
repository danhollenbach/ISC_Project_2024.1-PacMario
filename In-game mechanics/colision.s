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


CMAP_CHECK:	li t1, 8
		li t2, 40
		div t3, a1, t1
		addi t3, t3, 9			# pega a informacao do mapa de moedas da coordenada correspondente (x)
		div t4, a2, t1
		addi t4, t4, 1
		mul t4, t4, t2			# pega a informacao do mapa de moedas da coordenada correspondente (y)
		add t2, t4, t3			# t2 = x + y * 40 + 8
		add t4, s5, t2			# endereco do mapa de colisao de moedas + posicao relativa do boneco
		lb t2, 0(t4)
		bne t2, zero, CRENDER
		mv a0, s2			# carrega no endereco de erase o mapa normal, caso o fantasma passe por um espaco vazio
		ret
		
CRENDER:	mv a0, s3			# carrega no endereco de erase o mapa de moedas, caso o fantasma passe por um espaco que ainda tem moedas
		ret


G_HITCHECK:	li t0, 16			# divide o mapa em "blocos" de 16 x 16
		div a0, a0, t0			# x do fantasma no mapa dividido
		div a2, a2, t0			# x do mario no mapa dividido
		beq a0, a2, CHECK2		# caso sejam iguais, checa o y, caso nao, retorna
		j WRAP

CHECK2:		div a1, a1, t0			# y do fantasma no mapa dividido
		div a3, a3, t0			# y do mario no mapa dividido
		beq a1, a3, HIT			# caso sejam iguais, trata a colisao
		j WRAP

HIT:		la t0, MARIO_STATUS
		lh t0, 4(t0)			# carrega se o mario esta poderoso ou nao
		beqz t0, G_KILL			# caso o mario esteja poderoso, mata o fantasma
		# o Dan ta trabalhando aqui ainda
		la t0, BATIDA			# efeito sonoro de colisao
    	la t1, DEATH			
    	sw t1, (t0)

		la t0, HIT_COUNT
		li t1, 1
		sh t1, 0(t0)			# atualiza o contador de hit do mario
		la a0, LIFECOUNT
		lh t0, 0(a0)
		addi t0, t0, -1
		sh t0, 0(a0)			# atualiza o contador de vidas
		la t0, MARIO_STATUS
		li t1, 3
		sh t1, 2(t0)			# bota o mario descendo apos a morte (estado inicial)
		la a0, death			# carrega o sprite do mario atingido na colisao
		j WRAP
		
G_KILL:		la a0, CURRENT
		lh t0, 0(a0)			# carrega o numero de pontos atual
		addi t0, t0, 100		# soma o n de pontos ao matar o fantasma
		sh t0, 0(a0)
		li t0, 1
		sh t0, 0(a5)			# atualiza o aprisionamento do fantasma
		sh a6, 0(a4)			# atualiza o x do fantasma para o aprisionamento
		sh a7, 2(a4)			# atualiza o y do fantasma para o aprisionamento
		
WRAP:		ret
