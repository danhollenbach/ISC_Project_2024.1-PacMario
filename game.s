.data
STAGE:		.half 3				# nivel (0 = mapa 1, 1 = mapa 2, 2 = victory, 3 = menu, 4 = game over/victory)

CHAR_POS: 	.half 60, 112			# x, y
OLD_CHAR_POS:	.half 60, 112			# x, y
MARIO_STATUS:	.half 1, 3, 1			# numero do sprite (0 = parado, 1 = movendo), direcao (0 = esquerda, 1 = direita, 2 = cima, 3 = baixo), invencivel (0 = poder, 1 = normal)
MARIO_HITBOX1:  .half 0,0			# hitbox do mario
MARIO_HITBOX2:  .half 0,0
MARIO_CENTER:	.half 0,0			# centro do mario
HIT_COUNT:	.half 0				# checa pra ver se o mario colidiu com algo 

POINTS:		.half 0				# contagem de pontos para a passagem do mapa / condicao de vitoria
CURRENT:	.half 0				# contador fisico da pontuacao que sera mostrado no bitmap display
TIMER1:		.half 100			# contador do power do mario na primeira fase (5 s)
TIMER2:		.half 80			# contador do power do mario na segunda fase (4 s)
PRESSED:	.half 0				# endereco para verificar o cheat pressionado (0 = nao, 1 = sim)
COL:		.half 0				# checa colisao (0 = n, 1 = ss)

		.eqv P_REDX, 128
		.eqv P_REDY, 128		# x e y do fantasma preso
RED_POS:	.half 160,112			# x, y
RED_OLD_POS:	.half 160,112			# x, y
RED_STATUS:	.half 1, 3, 1			# numero do sprite (0 = parado, 1 = movendo), direcao (0 = esquerda, 1 = direita, 2 = cima, 3 = baixo), assustado (0 = fragil, 1 = normal)
RED_HITBOX1:	.half 0,0			# hitbox do vermelho
RED_HITBOX2:	.half 0,0
RED_TRAPED:	.half 0				# ve se o fantasma esta preso ou nao (1 = preso, 0 = nao)
RED_TIMER:	.half 0				# conta o n de segundos que o fantasma esta preso

		.eqv P_PINKX, 128
		.eqv P_PINKY, 128		# x e y do fantasma preso
PINK_POS:	.half 128,128			# x, y
PINK_OLD_POS:	.half 128,128			# x, y
PINK_STATUS:	.half 1, 1, 1			# numero do sprite (0 = parado, 1 = movendo), direcao (0 = esquerda, 1 = direita, 2 = cima, 3 = baixo), assustado (0 = fragil, 1 = normal)
PINK_HITBOX1:	.half 0,0			# hitbox do rosa
PINK_HITBOX2:	.half 0,0
PINK_TRAPED:	.half 1				# ve se o fantasma esta preso ou nao (1 = preso, 0 = nao)
PINK_TIMER:	.half -80			# conta o n de segundos que o fantasma esta preso (comeca com -60 para a diferenca no tempo de release)

		.eqv P_ORANGEX, 136
		.eqv P_ORANGEY, 112		# x e y do fantasma preso
ORANGE_POS:	.half 136,112			# x, y
ORANGE_OLD_POS:	.half 136,112			# x, y
ORANGE_STATUS:	.half 1, 0, 1			# numero do sprite (0 = parado, 1 = movendo), direcao (0 = esquerda, 1 = direita, 2 = cima, 3 = baixo), assustado (0 = fragil, 1 = normal)
ORANGE_HITBOX1:	.half 0,0			# hitbox do laranja
ORANGE_HITBOX2:	.half 0,0
ORANGE_TRAPED:	.half 1				# ve se o fantasma esta preso ou nao (1 = preso, 0 = nao)
ORANGE_TIMER:	.half -40			# conta o n de segundos que o fantasma esta preso (comeca com -30 para a diferenca no tempo de release)

		.eqv P_BLUEDX, 128
		.eqv P_BLUEY, 196		# x e y do fantasma preso
BLUE_POS:	.half 128,96			# x, y
BLUE_OLD_POS:	.half 128,96			# x, y
BLUE_STATUS:	.half 1, 1, 1			# numero do sprite (0 = parado, 1 = movendo), direcao (0 = esquerda, 1 = direita, 2 = cima, 3 = baixo), assustado (0 = fragil, 1 = normal)
BLUE_HITBOX1:	.half 0,0			# hitbox do azul
BLUE_HITBOX2:	.half 0,0
BLUE_TRAPED:	.half 1				# ve se o fantasma esta preso ou nao (1 = preso, 0 = nao)
BLUE_TIMER:	.half 0				# conta o n de segundos que o fantasma esta preso	

SCOREBOARD:	.string "SCORE"	
RECORDE:	.string "HIGH"	
LIFESPACE:	.string "LIFE"
LIFECOUNT:	.half 3
		.include "Macros/macros.s"
		.include "Macros/MACROSv21.s"
.text

MENU:		la t0, D_BG_MUSIC
		la t1, M_BG
		sw t1, 0(t0)
		jal a0, ST_MUS
		la a0, menu1
		li a1, 0
		li a2, 0
		li a5, 0
		render_map(a0, a1, a2, 320, 240, a5)
		la a0, menu2
		li a5, 1
		render_map(a0, a1, a2, 320, 240, a5)
		mv a5, s8
		# renderiza as 2 partes do menu para o player
			
MENU_LOOP:	xori s8, s8, 1			# inverte o frame
		li t0,0xFF200604		# carrega em t0 o endereco de troca de frame
		sw s8,0(t0)			# mostra o sprite pronto para o usuario
		call KEY2
		la t0, PRESSED
		lh t1, 0(t0)			# checa se alguma tecla foi apertada para sair do loop do menu
		bne t1, zero, PRESS_RES	
		li a7 32
		beqz a5, TIMEUP
		li a0, 750
		j WAIT
		
TIMEUP:		li a0, 1750

WAIT:		ecall				# freeza a mensagem na tela (1 s tela do menu e 2s 'press m') 
		j MENU_LOOP
		
PRESS_RES:	li t1, 0
		sh t1, 0(t0)			# reseta o contador

SETUP:		li s10, 0			# contador para a animacao do sprite
		li s7, 0			# offset inicial para o sprite dos fantasmas 
		la a0, black
		li a1, 0
		li a2, 0
		li a5, 0
		render_map(a0, a1, a2, 320, 240, a5)
		li a5, 1
		render_map(a0, a1, a2, 320, 240, a5)
		# deixa a tela preta em ambos frames
		li a7, 32
		li a0, 1000			
		ecall				# pausa por 1 s
		la t0, STAGE
		lh t0, 0(t0)			# carrega qual o nivel que o player esta
		beqz t0, MAPA1
		li t2, 2
		beq t0, t2, VICTORY		# caso o jogador passe da segunda fase (STAGE = 1), ele ganha
		la a0, mapa_2			# carrega o endereco do mapa2 em a0
		mv s2, a0
		la s3, moedas_2			# carrega o endereco do mapa de moedas 2
		la s4, mapa_2c
		j PRINT_MAP
		
MAPA1:		la a0,mapa_1n			# carrega o endereco do mapa1 em a0
		mv s2, a0
		la s3, moedas_1n		# coloca o endereço do mapa de moedas 
		la s4, mapa_1c 
		
PRINT_MAP:	li a1,0				# x = 0
		li a2,0				# y = 0
		li a5,0				# frame = 0
		render_map(a0, a1, a2, 320, 240, a5)
		li a5,1				# frame = 1
		mv a0, s2
		render_map(a0, a1, a2, 320, 240, a5)
		# esse setup serve pra desenhar o "mapa" nos dois frames antes do "jogo" comecar
		mv a0, s3
		li a5, 0
		render_map(a0, a1, a2, 320, 240, a5) 
		# desenha as moedas no mapa
		la a0, CHAR_POS
		li t0, 60
		li t1, 112
		sh t0, 0(a0)
		sh t1, 2(a0) 			
		la a0, OLD_CHAR_POS
		sh t0, 0(a0)			
		sh t1, 2(a0)			# reseta a posicao do mario para a inicial (x = 60, y = 112) , assim como OLD_CHAR_POS
		la a0, mario_down
		li a1, 60
		li a2, 112
		li a5, 0
		li a6, 0
		li a7, 0
		render(a0, a1, a2, 16, 16, a5, a6, a7)
		# spawna o mario na condicao inicial para comecar o game loop
		
HUD:		li a7, 104
		la a0, SCOREBOARD
		li a1, 268
		li a2, 20
		li a3, 0x00FF
		mv a4, a5
		ecall				# printa o SCORE: no HUD
		la a0, RECORDE
		li a1, 270
		li a2, 68
		ecall				# printa o high score no HUD
		la a0, LIFESPACE
		li a1, 270
		li a2, 116
		ecall				# printa o contador de vidas
		
LIFE_CONFIG:	la a0, LIFECOUNT		# checa a quantidade de vidas do player para imprimir no bitmap ou levar ao game over
		lh t0, 0(a0)
		beqz t0, GAME_OVER
		li a1, 280
		li a2, 136
		li a6, 0
		li a7, 0
		li t1, 1
		beq t0, t1, ONE_L
		li t1, 2
		beq t0, t1, TWO_L
THREE_L:	la a0, life_3
		render(a0, a1, a2, 16, 56, a5, a6, a7)
		j STANDBY	
		# imprime tres vidas do player na aba do HUD
		

TWO_L:		la a0, life_2
		render(a0, a1, a2, 16, 56, a5, a6, a7)	
		j STANDBY
		# imprime duas vidas do player na aba do HUD
		
ONE_L:		la a0, life
		render(a0, a1, a2, 16, 56, a5, a6, a7)	
		# imprime uma do player na aba do HUD		
		
STANDBY:	li t0,0xFF200604		# carrega em t0 o endereco de troca de frame
		li a5, 0
		sw a5,0(t0)			# mostra o sprite pronto para o usuario
		li a7 32
		li a0 2000
		ecall				# freeza a tela inicial por 2 s antes do jogo comecar		
		
GAME_LOOP: 	la a0, POINTS
		lh a0, 0(a0)			# carrega o número de pontos em a0
		li t0, 240			# numero total de pontos por fase
		beq a0, t0, NEXT_LEVEL		# caso o player alcance o fim do mapa, muda de fase
		la a0, CURRENT
		lh a0, 0(a0)
		li a1, 268
		li a2, 30
		li a3, 0x00FF
		li a4, 0
		li a7, 101 
		ecall				# imprime os pontos do player
		call KEY2
		la a0, PRESSED
		lh t0, 0(a0)
		beqz t0, NORMAL_LOOP		# caso o cheat 'm' nao foi pressionado, continua o loop
		li t0, 0
		sh t0, 0(a0)			# reseta o PRESSED
		j SETUP				# vai para o inicio da configuracao
		
NORMAL_LOOP:	############			# coloca os fantasmas presos ou nao
		prison_check(RED_TRAPED, 128, 128, RED_TIMER, RED_POS)
		prison_check(PINK_TRAPED, 128, 128, PINK_TIMER, PINK_POS)
		prison_check(ORANGE_TRAPED, 136, 112, ORANGE_TIMER, ORANGE_POS)
		prison_check(BLUE_TRAPED, 128, 96, BLUE_TIMER, BLUE_POS)
		la t0, STAGE
		lh t0, 0(t0)			# carrega qual o nivel atual
		la t1, CHAR_POS
		lh t2, 2(t1)			# y do mario
		lh t1, 0(t1)			# x do mario
		beqz t0, STAGE_1
		la a0, moedas_2c		# carrega o 2 mapa de colisao das moedas
		coin_check(a0, t1, t2)		# verifica colisao de moedas no segundo mapa
		j POWER2

STAGE_1:	la a0, moedas_1c
		coin_check(a0, t1, t2)		# verifica colisao de moedas no primeiro mapa
		
		la t1, TIMER1			# chama o contador do poder do mario na segunda fase
		lh t1, 0(t1)
		j POWER_DOWN
		
POWER2:		la t1, TIMER2
		lh t1, 0(t1)			# chama o contador do poder do mario na segunda fase
		
		
POWER_DOWN:	la a0, MARIO_STATUS
		lh t0, 4(a0)			# carrega se o mario esta poderoso ou nao
		bne t0, zero, STEP_2		# caso esteja normal, ignora essa rotina
		addi s9, s9, 1			# adiciona um ao contador de tempo
		bne s9, t1, STEP_2
		li t1, 1
		sh t1, 4(a0)			# zera o poder do mario
		li s9, 0			# zera o contador
		

STEP_2:		call MOVE
		###########			# movimento dos fantasmas (pegar estado como argumento para menor velocidade no medo e checar se esta preso)
		la a0, STAGE
		lh a0, 0(a0)			# carrega qual mapa esta sendo renderizado
		beqz a0, LEVEL_1
		la s2, mapa_2			# mapa 2
		la s5, moedas_2c		# mapa de colisao de moedas 2
		j ERASE

LEVEL_1:	la s2, mapa_1n			# mapa 1
		la s5, moedas_1c		# mapa de colisao de moedas 2

ERASE:		la t0, OLD_CHAR_POS		# carrega a posicao antiga do mario
		mv a0, s2			# mapa de base para o apagamento
		lh a1, 0(t0)			# x
		lh a2, 2(t0)			# y
		mv a5, s0			# carrega o frame
		li a6, 0			
		li a7, 1			# operacao de apagamento
		render(a0, a1, a2, 16, 16, a5, a6, a7)
		
		# fazer o apagamento dos fantasmas
		# RED
		ghost_er(RED_OLD_POS)
		mv a5, s0			# carrega o frame
		mv a0, s2
		render(a0, a1, a2, 16, 16, a5, a6, a7)
		
		# PINK
		ghost_er(PINK_OLD_POS)
		mv a5, s0			# carrega o frame
		mv a0, s2
		render(a0, a1, a2, 16, 16, a5, a6, a7)
		
		# BLUE
		ghost_er(BLUE_OLD_POS)
		mv a5, s0			# carrega o frame
		mv a0, s2
		render(a0, a1, a2, 16, 16, a5, a6, a7)
		
		# ORANGE
		ghost_er(ORANGE_OLD_POS)
		mv a5, s0			# carrega o frame
		mv a0, s2
		render(a0, a1, a2, 16, 16, a5, a6, a7)
		
		li t0,0xFF200604		# carrega em t0 o endereco de troca de frame
		sw s0,0(t0)			# mostra o sprite pronto para o usuario
		la t1, MARIO_STATUS
		lh a6, 0(t1)			# carrega em s0 a condicao do sprite (parado / mexendo)
		li t0, 2
		bge s10, t0, CHANGE_SPRITE
		j CONTINUE
		
CHANGE_SPRITE:	xori a6, a6, 1
		sh a6, 0(t1)
		li s10, -1

CONTINUE:	mv s7, a6
		li a7, 0 
		
		# renderizar os fantasmas
		# RED
		la t0, RED_STATUS
		lh t0, 2(t0)			# carrega a direcao do fantasma
		ghost_dir(red_up, red_down, red_right, red_left, t0, red_f)
		la t0, RED_POS
		lh a1, 0(t0)
		lh a2, 2(t0)
		mv a5, s0
		mv a6, s7
		render(a0, a1, a2, 16, 16, a5, a6, a7)
		
		# PINK
		la t0, PINK_STATUS
		lh t0, 2(t0)			# carrega a direcao do fantasma
		ghost_dir(pink_up, pink_down, pink_right, pink_left, t0, pink_f)
		la t0, PINK_POS
		lh a1, 0(t0)
		lh a2, 2(t0)
		mv a5, s0
		mv a6, s7
		render(a0, a1, a2, 16, 16, a5, a6, a7)
		# BLUE
		la t0, BLUE_STATUS
		lh t0, 2(t0)			# carrega a direcao do fantasma
		ghost_dir(blue_up, blue_down, blue_right, blue_left, t0, blue_f)
		la t0, BLUE_POS
		lh a1, 0(t0)
		lh a2, 2(t0)
		mv a5, s0
		mv a6, s7
		render(a0, a1, a2, 16, 16, a5, a6, a7)
		
		# ORANGE
		la t0, ORANGE_STATUS
		lh t0, 2(t0)			# carrega a direcao do fantasma
		ghost_dir(orange_up, orange_down, orange_right, orange_left, t0, orange_f)
		la t0, ORANGE_POS
		lh a1, 0(t0)
		lh a2, 2(t0)
		mv a5, s0
		mv a6, s7
		render(a0, a1, a2, 16, 16, a5, a6, a7)
		
		############			# checa colisao com os fantasmas e perda de vida/ morte do fantasma
		g_colision(RED_POS, MARIO_CENTER, RED_TRAPED, 128, 128)
		la t0, HIT_COUNT
		lh t0, 0(t0)	
		bne t0, zero, COL_SKIP		# pula a colisao dos outros fantasmas caso ja tenha colidido com um deles
		g_colision(PINK_POS, MARIO_CENTER, PINK_TRAPED, 128, 128)
		la t0, HIT_COUNT
		lh t0, 0(t0)
		bne t0, zero, COL_SKIP
		g_colision(ORANGE_POS, MARIO_CENTER, ORANGE_TRAPED, 136, 112)
		la t0, HIT_COUNT
		lh t0, 0(t0)
		bne t0, zero, COL_SKIP
		g_colision(BLUE_POS, MARIO_CENTER, BLUE_TRAPED, 128, 96)
		
COL_SKIP:	la t0, CHAR_POS
		lh a1, 0(t0)			# x
		lh a2, 2(t0)			# y
		mv a5, s0			# carrega o frame renderizado
		la t0, HIT_COUNT		# carrega se o mario foi atingido ou nao
		lh t0, 0(t0)
		bne t0, zero, PRINT_D		# caso o mario tenha sido atingido, pula o load de sprites
		la t1, MARIO_STATUS
		lh t0, 4(t1)			# carrega se o mario esta energizado ou nao
		lh t1, 2(t1)			# carrega a direcao do personagem
		mv a6, s7
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
		j PRINT

PRINT_D:	li a6, 0

PRINT:		li a7, 0
		render(a0, a1, a2, 16, 16, a5, a6, a7)

		li t0,0xFF200604		# carrega em t0 o endereco de troca de frame
		sw s0,0(t0)			# mostra o sprite pronto para o usuario
		addi s10, s10, 1		# incrementa o contador da animacao
		
HIT_RESPAWN:	la t0, HIT_COUNT
		lh t1, 0(t0)			# carrega se o mario foi atingido
		beqz, t1, IGNORE_HIT		# se nao foi, carrega a rotina normal
		li t1, 0
		sh t1, 0(t0)			# atualiza o contador de hits
		la t0, CHAR_POS
		lh t1, 0(t0)			# x do mario
		lh t2, 2(t0)			# y do mario
		la t0, OLD_CHAR_POS
		sh t1, 0(t0)
		sh t2, 2(t0)			# atualiza para antigas posicoes
		la t0, CHAR_POS	
		li t1, 60
		li t2, 112
		sh t1, 0(t0)
		sh t2, 2(t0)			# bota o mario na posicao inicial
		la t0, RED_POS
		li t1, 160
		li t2, 112
		sh t1, 0(t0)			
		sh t2, 2(t0)
		g_reset(PINK_POS, 128, 128, PINK_TIMER, PINK_TRAPED, 80)
		g_reset(ORANGE_POS, 136, 112, ORANGE_TIMER, ORANGE_TRAPED, 40)
		g_reset(BLUE_POS, 128, 96, BLUE_TIMER, BLUE_TRAPED, 0)
		# reseta os fantasmas para o aprisionamento
		li t0, 0			# contador do loop de morte

DEATH_LOOP:	li t1, 40
		addi t0, t0, 1
		li a7, 32
		li a0, 50
		ecall
		blt t0, t1, DEATH_LOOP

		la t0, OLD_CHAR_POS
		la a0, black
		lh a1, 0(t0)
		lh a2, 2(t0)
		li a5, 0
		li a6, 0
		li a7, 0
		render(a0, a1, a2, 16, 16, a5, a6, a7)
		# apaga o rastro do mario morto
		
		j LIFE_CONFIG
		
	
IGNORE_HIT:	li a7 32
		li a0 50
		ecall				# pausa por 50 ms
		jal P_MUS
		j GAME_LOOP

NEXT_LEVEL:	la a0, MARIO_STATUS
		li t0, 1
		sh t0, 4(a0)			# zera o contador de poder do mario
		la a0, POINTS
		li t0, 0
		sh t0, 0(a0)			# zera a quantia de pontos
		la a0, STAGE
		lh t2, 0(a0)
		addi t2, t2, 1			# soma 1 ao nivel atual, logo, vai pra o proximo nivel
		sh t2, 0(a0)
		j SETUP				# volta para o setup
						
GAME_OVER:	la a0, game_over1
		li a1, 0
		li a2, 0
		li a5, 0
		render_map(a0, a1, a2, 320, 240, a5)
		la a0, game_over2
		li a5, 1
		render_map(a0, a1, a2, 320, 240, a5)
		mv s8, a5
		# renderiza as 2 partes da derrota para o player
		la a0, STAGE
		li t0, 4
		sh t0, 0(a0)			# guarda 4 (tela de game over) no STAGE
		j END_LOOP			# prossegue para checar a tela de sair do jogo
		
		
VICTORY:	la a0, win1
		li a1, 0
		li a2, 0
		li a5, 0
		render_map(a0, a1, a2, 320, 240, a5)
		la a0, win2
		li a5, 1
		render_map(a0, a1, a2, 320, 240, a5)
		mv s8, a5
		# renderiza as 2 partes da vitoria para o player
		
END_LOOP:	xori s8, s8, 1			# inverte o frame
		li t0,0xFF200604		# carrega em t0 o endereco de troca de frame
		sw s8,0(t0)			# mostra o sprite pronto para o usuario
		call KEY2
		la t0, PRESSED
		lh t1, 0(t0)			# checa se alguma tecla foi apertada para sair do loop do menu
		bne t1, zero, EXIT	
		li a7 32
		beqz a5, TIMEUP2
		li a0, 750
		j WAIT2
		
TIMEUP2:	li a0, 1750

WAIT2:		ecall				# freeza a mensagem na tela (1 s tela do menu e 2s 'press m') 
		j END_LOOP

EXIT:		li a7, 10
		ecall				# sai do jogo caso a tecla seja pressionada


.data
    	.include "Sounds/music.data"
	.include "Sprites_data/menu1.data"
	.include "Sprites_data/black.data"
	.include "Sprites_data/menu2.data"
	.include "Sprites_data/mapa_1n.data"
	.include "Sprites_data/mapa_1c.data"
	.include "Sprites_data/moedas_1n.data"
	.include "Sprites_data/moedas_1c.data"
	.include "Sprites_data/mapa_2.data"
	.include "Sprites_data/mapa_2c.data"
	.include "Sprites_data/moedas_2.data"
	.include "Sprites_data/moedas_2c.data"
	.include "Sprites_data/mario_up.data"
	.include "Sprites_data/mario_down.data"
	.include "Sprites_data/mario_left.data"
	.include "Sprites_data/mario_right.data"
	.include "Sprites_data/mario_pup.data"
	.include "Sprites_data/mario_pdown.data"
	.include "Sprites_data/mario_pleft.data"
	.include "Sprites_data/mario_pright.data"
	.include "Sprites_data/red_up.data"
	.include "Sprites_data/red_down.data"
	.include "Sprites_data/red_right.data"
	.include "Sprites_data/red_left.data"
	.include "Sprites_data/red_f.data"		
	.include "Sprites_data/blue_up.data"
	.include "Sprites_data/blue_down.data"
	.include "Sprites_data/blue_right.data"
	.include "Sprites_data/blue_left.data"
	.include "Sprites_data/blue_f.data"
	.include "Sprites_data/pink_up.data"
	.include "Sprites_data/pink_down.data"
	.include "Sprites_data/pink_right.data"
	.include "Sprites_data/pink_left.data"
	.include "Sprites_data/pink_f.data"
	.include "Sprites_data/orange_up.data"
	.include "Sprites_data/orange_down.data"
	.include "Sprites_data/orange_right.data"
	.include "Sprites_data/orange_left.data"
	.include "Sprites_data/orange_f.data"	
	.include "Sprites_data/end_f.data"
	.include "Sprites_data/death.data"
	.include "Sprites_data/life.data"
	.include "Sprites_data/life_2.data"
	.include "Sprites_data/life_3.data"
 	.include "Sprites_data/game_over1.data"
	.include "Sprites_data/game_over2.data"
	.include "Sprites_data/win1.data"
	.include "Sprites_data/win2.data"
	.include "In-game mechanics/render.s"
	.include "In-game mechanics/move.s"
	.include "In-game mechanics/colision.s"
	.include "Sounds/musicPlayer.s"
	.include "Macros/SYSTEMv21.s"	
