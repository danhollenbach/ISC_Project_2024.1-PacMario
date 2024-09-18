.text
################ Teleporte do boneco entre os canos do mapa
TELEPORT:	la s5, MARIO_HITBOX1		# hitbox1
		la s6, MARIO_HITBOX2		# hitbox2
		la t1, TP1			# carrega a label com as infos de teleporte
		lh t2, 0(t1)			# x do teleporte
		lh t3, 0(s5)			# x da hitbox1
		bne t2, t3, TEST2		# caso nao sejam iguais, checa o outro teleporte
		lh t2, 2(t1)			# y do teleporte
		lh t3, 2(s5)			# y da hitbox1
		beq t2, t3, PIPE		# caso sejam iguais, trata o teleporte
		
TEST2:		la t1, TP2			# carrega a label com as infos do outro teleporte
		lh t2, 0(t1)			# x do teleporte 2
		lh t3, 0(s5)			# x da hitbox 1
		bne t2, t3, END_T		# caso nao sejam iguais, o boneco nao se teleporta, logo, continua o movimento
		lh t2, 2(t1)			# x do teleporte 2
		lh t3, 2(s5)			# x da hitbox 1
		beq t3, t2, PIPE		# caso sejam iguais, trata o teleporte
		j END_T
PIPE:		
		la t0, STAGE
		lh t0, 0(t0)			# qual o nivel atual do player
		beqz t0, PIPE1
		
PIPE2:		la t0, CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lh t2, 2(t0)
		sh t2, 2(t1)
		lh t2, 0(t0)	
		lh t3, 0(s5)			# x da primeira hitbox
		sh t2, 0(t1)			# salva as coordenadas antigas
		li t4, 188
		beq t4, t2, TRIM2
		addi t2, t2, 128
		addi t3, t3, 128
		j STORE_T2
		
TRIM2:		addi t2, t2, -128
		addi t3, t3, -128				
		
STORE_T2:	sh t2, 0(t0)
		sh t3, 0(s5)
		sh t3, 0(s6)			# teleporta o boneco
		la t0, TP_COUNT
		li t1, 1
		sh t1, 0(t0)			# atualiza o contador de teleporte
		
		j END_T
				
		
PIPE1:		la t0, CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lh t2, 0(t0)
		sh t2, 0(t1)
		lh t2, 2(t0)	
		lh t3, 2(s5)			# y da primeira hitbox
		sh t2, 2(t1)			# salva as coordenadas antigas
		li t4, 240
		addi t2, t2, 120		# desloca o y do boneco
		addi t3, t3, 120		# desloca o y das hitbox
		bge t2, t4, TRIM1		# tira o modulo do deslocamento
		j STORE_T1
		
TRIM1:		addi t2, t2, -240
		addi t3, t3, -240				
		
STORE_T1:	sh t2, 2(t0)
		sh t3, 2(s5)
		sh t3, 2(s6)			# teleporta o boneco
		la t0, TP_COUNT
		li t1, 1
		sh t1, 0(t0)			# atualiza o contador de teleporte
			
END_T:		ret
