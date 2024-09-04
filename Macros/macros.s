.macro render(%sprite, %x, %y, %width, %height, %frame, %status, %op) #most of the inputs are registers
mv a0, %sprite 		# Gets sprite address
mv a1, %x		# X coordinate where rendering will start (top left) --- register
mv a2, %y		# Y coordinate where rendering will start (top left) --- register		
li a3, %width		# Width of printing area (usually the size of the sprite) --- immediate
li a4, %height		# Height of printing area (usually the size of the sprite) --- immediate	
mv a5, %frame		# Frame (0 or 1) --- register						
mv a6, %status		# Status (parado / mexendo)
mv a7, %op		# normal (0) ou apagar (1)
mv s11,ra		# Stores ra to s11
call RENDER_P
mv ra,s11		# Retrieves s11 to ra

.end_macro

.macro render_map(%levelmap, %x, %y, %width, %height, %frame) #most of the inputs are registers
mv a0, %levelmap	# %levelmap contains the address of current level
mv a1, %x		# X coordinate where rendering will start (top left) --- register
mv a2, %y		# Y coordinate where rendering will start (top left) --- register									
li a3, %width		# largura - int
li a4, %height		# altura - int
mv a5, %frame		# Frame (0 or 1) --- register
li a6, 0		# tira o offset do mapa
li a7, 1		# não faz a renderização do player
mv s11,ra		# Stores ra to s11
call RENDER_P
mv ra,s11		# Retrieves s11 to ra

.end_macro

.macro coin_check(%levelcmap, %x, %y)
mv a0, %levelcmap	# contem as informacoes do nivel atual
mv a1, %x		# posicao do player (x)
mv a2, %y		# posicao do player (y)
mv s11, ra
call COIN_COUNT
mv ra, s11

.end_macro


.macro colision(%levelcmap, %x1, %y1, %x2, %y2)
mv a0, %levelcmap	# mapa de colisao (1 ou 2)
mv a1, %x1		# x da primeira hitbox
mv a2, %y1		# y da primeira hitbox
mv a3, %x2		# x da segunda hitbox
mv a4, %y2		# y da segunda hitbox
mv s11, ra
call COLISION_CHECK
mv ra, s11

.end_macro

.macro ghost_dir(%cima, %baixo, %direita, %esquerda, %status, %medo)
la a1, %cima		# sprite de cima
la a2, %baixo		# sprite de baixo
la a3, %direita		# sprite da direita
la a4, %esquerda	# sprite da esquerda
la a5, %status		# direcao (0 = esquerda, 1 = direita, 2 = cima, 3 = baixo)
la a6, %medo		# carrega o sprite do fantasma com medo
mv s11, ra
call GHOST_DIR
mv ra, s11

.end_macro

.macro ghost_er(%position)
la t0, %position	# endereco da posicao do fantasma
lh a1, 0(t0)		# x do fantasma
lh a2, 2(t0)		# y do fantasma
mv s11, ra
call CMAP_CHECK
mv ra, s11

.end_macro

.macro prison_check(%aprisionamento, %xinicial, %yinicial, %timer, %posicao, %status, %old_gpos)
la a0, %aprisionamento 	# endereco que contem se o fantasma esta preso ou nao
li a1, %xinicial 	# posicao caso esteja preso (x)
li a2, %yinicial	# posicao caso esteja preso (y)
la a4, %timer		# endereco com o tempo que esteve preso
la a5, %posicao		# endereco com o x e y do boneco
la a6, %status		# endereco com as informacoes do fantasma
la a7, %old_gpos	# posicao antiga do fantasma
mv s11, ra
call PRISON	
mv ra, s11

.end_macro

.macro g_colision(%ghost_pos, %mario_pos, %aprisionamento, %xinicial, %yinicial)
la a4, %ghost_pos	# endereco com as posicoes do fantasma
lh a0, 0(a4)		# x fantasma
lh a1, 2(a4)		# y fantasma
la t1, %mario_pos	# endereco com as posicoes do mario
lh a2, 0(t1)		# x mario
lh a3, 2(t1)		# y mario
la a5, %aprisionamento	# carrega se o fantasma esta aprisionado ou nao
li a6, %xinicial	# x de aprisionamento do fantasma
li a7, %yinicial	# y de aprisionamento do fantasma
mv s11, ra
call G_HITCHECK
mv ra, s11

.end_macro

.macro g_reset(%ghost_pos, %xinicial, %yinicial, %timer, %prison, %prisontime, %center, %turncounter, %status, %old_gpos)
la a0, %ghost_pos	# carrega o x e y dos fantasmas e os seta para o aprisionamento
la a1, %old_gpos	# posicao antiga do fantasma
lh t0, 0(a0)
lh t1, 2(a0)
sh t0, 0(a1)
sh t1, 2(a1)		# atualiza as posicoes antigas dos fantasmas
li t0, %xinicial	
li t1, %yinicial
sh t0, 0(a0)	
sh t1, 2(a0)
la a0, %timer		# atualiza o timer de aprisionamento para os fantasmas
li t0, %prisontime
sub t0, zero, t0
sh t0, 0(a0)
la a0, %prison		# atualiza o contador de prisao dos fantasmas
li t0, 1
sh t0, 0(a0)
la a0, %turncounter	# contador de virada dos fantasmas
li t0, 0
sh t0, 0(a0)
la a0, %center		# reseta o centro dos fantasmas
li t0 160
li t1, 112
sh t0, 0(a0)
sh t1, 2(a0)
la a0, %status
li t1, 3
sh t1, 2(a0)		# reseta a direcao do fantasma

.end_macro

.macro ghost_move(%status, %prison, %oposite, %colmap, %old_positiong, %positiong, %turnstatus, %center)
la a0, %status		# carrega o estado do fantasma para saber qual a velocidade
la a1, %prison		# carrega o estado de aprisionamento dos fantasmas
la a3, %oposite		# carrega a direcao oposta dos fantasmas
mv a4, %colmap		# mapa de colisao dos fantasmas
la a5, %old_positiong	# posicao antiga do fantasma
la a6, %positiong	# endereco que contem a posicao do fantasma
la a7, %turnstatus	# endereco que contem o contador de mudanca de direcao do fantasma
la t0, %center		# centro do fantasma para testar as intersecoes
mv s11, ra
call G_MOVE
mv ra, s11

.end_macro

.macro red_reset()
la t0, RED_TURN			# zera o contador de virada
li t1, 0
sh t1, 0(t0)
la t0, RED_STATUS		# zera a direcao
li t1, 3
sh t1, 2(t0)
la t0, RED_POS
lh t1, 0(t0)
lh t2, 2(t0)
la t3, RED_OLD_POS
sh t1, 0(t3)
sh t2, 2(t3)			# atualiza a posicao antiga com a atual e salva a nova
li t1, 156
li t2, 112
sh t1, 0(t0)			
sh t2, 2(t0)

.end_macro
