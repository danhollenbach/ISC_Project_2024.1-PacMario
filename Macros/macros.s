.macro render(%sprite, %x, %y, %width, %height, %frame, %status, %op) #most of the inputs are registers
mv a0, %sprite 		# Gets sprite address
mv a1, %x		# X coordinate where rendering will start (top left) --- register
mv a2, %y		# Y coordinate where rendering will start (top left) --- register		
li a3, %width		# Width of printing area (usually the size of the sprite) --- immediate
li a4, %height		# Height of printing area (usually the size of the sprite) --- immediate	
mv a5, %frame		# Frame (0 or 1) --- register						
mv a6, %status		# Status (parado / mexendo)
mv a7, %op		# normal (0) ou apagar (1)
mv s11,ra			# Stores ra to s11
call RENDER_P
mv ra,s11			# Retrieves s11 to ra

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
mv s11,ra			# Stores ra to s11
call RENDER_P
mv ra,s11			# Retrieves s11 to ra

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
mv a0, %levelcmap	# mapa de colisao (1 ou 2 )
mv a1, %x1		# x da primeira hitbox
mv a2, %y1		# y da primeira hitbox
mv a3, %x2		# x da segunda hitbox
mv a4, %y2		# y da segunda hitbox
mv s11, ra
call COLISION_CHECK
mv ra, s11

.end_macro

.macro ghost_dir (%cima, %baixo, %direita, %esquerda, %direcao, %status)
la a0, %cima		# sprite de cima
la a1, %baixo		# sprite de baixo
la a2, %direita		# sprite da direita
la a3, %esquerda	# sprite da esquerda
mv a4, %direcao		# direcao (0 = esquerda, 1 = direita, 2 = cima, 3 = baixo)
mv a5, %status		# status (0 = fragil, 1 = normal)
mv s11, ra
call GHOST_DIR
mv ra, s11

.end_macro


