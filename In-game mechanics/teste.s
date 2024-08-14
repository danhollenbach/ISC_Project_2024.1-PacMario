.data
STAGE:		.half 0				# nível (0 = mapa 1, 1 = mapa 2)
CHAR_POS: 	.half 84, 112			# x, y
OLD_CHAR_POS:	.half 84, 112			# x, y
MARIO_STATUS:	.half 1, 3, 1			# número do sprite (0 = parado, 1 = movendo), direção (0 = esquerda, 1 = direita, 2 = cima, 3 = baixo), invencivel (0 = poder, 1 = normal)
		.include "macros.s"

.text

SETUP:		la t0, STAGE
		lh t0, 0(t0)			# carrega qual o nível que o player está
		beqz t0, MAPA1
		#############			# carrega o endereço do mapa2 em a0
MAPA1:		la a0,mapa_1			# carrega o endereco do mapa1 em a0
		
PRINT_MAP:	li a1,0				# x = 0
		li a2,0				# y = 0
		li a5,0				# frame = 0
		render_map(a0, a1, a2, 320, 240, a5)
		li a5,1				# frame = 1
		render_map(a0, a1, a2, 320, 240, a5)
		# esse setup serve pra desenhar o "mapa" nos dois frames antes do "jogo" comecar
		

GAME_LOOP: 	call KEY2
		la a0, black			# coloca a imagem de apagamento de rastro em a0
		la t0, OLD_CHAR_POS		# carrega a posição antiga do mario
		lh a1, 0(t0)			# x
		lh a2, 2(t0)			# y
		mv a5, s0			# carrega o frame
		li a6, 0			
		li a7, 0			# operação de apagamento
		render(a0, a1, a2, 16, 16, a5, a6, a7)
		li t0,0xFF200604		# carrega em t0 o endereco de troca de frame
		sw s0,0(t0)			# mostra o sprite pronto para o usuario
		la t0, CHAR_POS
		lh a1, 0(t0)			# x
		lh a2, 2(t0)			# y
		mv a5, s0			# carrega o frame renderizado
		la t1, MARIO_STATUS
		lh a6, 0(t1)			# carrega em s0 a condição do sprite (parado / mexendo)
		lh t0, 4(t1)			# carrega se o mario está energizado ou não
		lh t1, 2(t1)			# carrega a direção do personagem
		beqz t1, ESQ
		li t2, 1
		beq t1, t2, DIR
		li t2, 2
		beq t1, t2, CIMA
		
BAIXO:		beqz t0, BAIXO_P
		la a0, mario_down		# carrega o sprite do mario descendo
		j PRINT
BAIXO_P:	la a0, mario_pdown		# carrega o sprite do mario energizado descendo
		j PRINT

ESQ:		beqz t0, ESQ_P
		la a0, mario_left		# carrega o sprite do mario pra esquerda
		j PRINT
ESQ_P:		la a0, mario_pleft		# carrega o sprite do mario energizado pra esquerda
		j PRINT	

DIR:		beqz t0, DIR_P
		la a0, mario_right		# carrega o sprite do mario pra direita
		j PRINT
DIR_P:		la a0, mario_pright		# carrega o sprite do mario energizado pra direita	
		j PRINT

CIMA:		beqz t0, CIMA_P
		la a0, mario_up			# carrega o sprite do mario pra cima
		j PRINT
CIMA_P:		la a0, mario_pup		# carrega o sprite do mario energizado pra cima

PRINT:		li a7, 0
		render(a0, a1, a2, 16, 16, a5, a6, a7)
		li t0,0xFF200604		# carrega em t0 o endereco de troca de frame
		sw s0,0(t0)			# mostra o sprite pronto para o usuario
		
		li a7 32
		li a0 30
		ecall				# pausa por 100 ms
		j GAME_LOOP
		

KEY2:		li a5, 1
		la t1, MARIO_STATUS
		lh a6, 0(t1)			# carrega em a6 a condição do sprite (parado / mexendo)
		li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)			# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
   		beq t0,zero,FIM   	   	# Se nao ha tecla pressionada entao vai para FIM
   		xori a6, a6, 1			# inverte a condição (parado -> mexendo e vice e versa)
  		lw t2,4(t1)  			# le o valor da tecla tecla
  		la t1, MARIO_STATUS
		li t0,'w'
		beq t2,t0,CHAR_CIMA		# se tecla pressionada for 'w', chama LOAD_CIMA
		li t0,'a'
		beq t2,t0,CHAR_ESQ		# se tecla pressionada for 'a', chama LOAD_ESQ
		li t0,'s'
		beq t2,t0,CHAR_BAIXO		# se tecla pressionada for 's', chama LOAD_BAIXO
		li t0,'d'
		beq t2,t0,CHAR_DIR		# se tecla pressionada for 'd', chama LOAD_DIR
	
FIM:		ret				# retorna


CHAR_ESQ:	li t3, 0			# carrega a info de direção do sprite do mario e aloca a correspondente (esquerda = 0)
		sh t3, 2(t1)
		la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lh t2,0(t0)
		sh t2,0(t1)
		lh t2,2(t0)
		sh t2,2(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS
		
		la a0,CHAR_POS
		lh t1,0(t0)			# carrega o x atual do personagem
		addi t1,t1,-4			# decrementa 8 pixeis
		sh t1,0(t0)			# salva
		ret

CHAR_DIR:	li t3, 1			# carrega a info de direção do sprite do mario e aloca a correspondente (direita = 1)
		sh t3, 2(t1)
		la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lh t2,0(t0)
		sh t2,0(t1)
		lh t2,2(t0)
		sh t2,2(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS
		
		la t0,CHAR_POS
		lh t1,0(t0)			# carrega o x atual do personagem
		addi t1,t1,4			# incrementa 4 pixeis
		sh t1,0(t0)			# salva
		ret

CHAR_CIMA:	li t3, 2			# carrega a info de direção do sprite do mario e aloca a correspondente (cima = 2)
		sh t3, 2(t1)
		la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lh t2,0(t0)
		sh t2,0(t1)
		lh t2,2(t0)
		sh t2,2(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS
		
		la t0,CHAR_POS
		lh t1,2(t0)			# carrega o y atual do personagem
		addi t1,t1,-4			# decrementa 4 pixeis
		sh t1,2(t0)			# salva
		ret

CHAR_BAIXO:	li t3, 3			# carrega a info de direção do sprite do mario e aloca a correspondente (baixo = 3)
		sh t3, 2(t1)
		la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
		la t1,OLD_CHAR_POS		# carrega em t1 o endereco de OLD_CHAR_POS
		lh t2,0(t0)
		sh t2,0(t1)
		lh t2,2(t0)
		sh t2,2(t1)			# salva a posicao atual do personagem em OLD_CHAR_POS
		
		la t0,CHAR_POS
		lh t1,2(t0)			# carrega o y atual do personagem
		addi t1,t1,4			# incrementa 4 pixeis
		sh t1,2(t0)			# salva
		ret

.data

	.include "Sprites_data/mapa_1.data"
	.include "Sprites_data/mario_up.data"
	.include "Sprites_data/mario_down.data"
	.include "Sprites_data/mario_left.data"
	.include "Sprites_data/mario_right.data"
	.include "Sprites_data/mario_pup.data"
	.include "Sprites_data/mario_pdown.data"
	.include "Sprites_data/mario_pleft.data"
	.include "Sprites_data/mario_pright.data"
	.include "Sprites_data/black.data"
	.include "render.s"
	
