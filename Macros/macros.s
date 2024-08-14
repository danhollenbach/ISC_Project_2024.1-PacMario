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


