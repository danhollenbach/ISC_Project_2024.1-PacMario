.text
##########################     RENDER IMAGE    ##########################
#     -----------           argument registers           -----------    #
#	a0 = Image Address						#
#	a1 = X coordinate where rendering will start (top left)		#
#	a2 = Y coordinate where rendering will start (top left)		#
#	a3 = width of printing area (usually the size of the sprite)	#
# 	a4 = height of printing area (usually the size of the sprite)	#
#	a5 = frame (0 or 1)						#
#	a6 = status of sprite (usually 0 for sprites that are alone)	#
#									#
#     -----------          temporary registers           -----------    #
#	t0 = bitmap display printing address				#
#	t1 = image address						#
#	t2 = line counter						#
# 	t3 = column counter						#
# 	t4 = temporary operations					#
#########################################################################

RENDER_P:	beqz a7, NORMAL
		add a0,a0,a1	# Image address + X
		li t3,320	# t4 = 320
		mul t3,t3,a2	# t4 = t4 * Y
		add a0,a0,t3	# t5 = Image address + X + 320 * Y
NORMAL:		li t0,0xFF0			# carrega 0xFF0 em t0
		add t0,t0,a5			# adiciona o frame ao FF0 (se o frame for 1 vira FF1, se for 0 fica FF0)
		slli t0,t0,20			# shift de 20 bits pra esquerda (0xFF0 vira 0xFF000000, 0xFF1 vira 0xFF100000)
		add t0,t0,a1			# adiciona x ao t0
		
		li t1,320			# t1 = 320
		mul t1,t1,a2			# t1 = 320 * y
		add t0,t0,t1			# adiciona t1 ao t0
		addi a0,a0,8			# a0 + 8
		mul t4, a3, a4			# carrega o tamanho de um sprite inteiro
		mul t4, t4, a6			# ve se o sprite a ser printado é o parado ou mexendo
		add a0, a0, t4			# adiciona o offset a imagem
		
		mv t2,zero			# zera t2
		mv t3,zero			# zera t3
		
		
PRINT_LINHA:	lw t6,0(a0)			# carrega em t6 uma word (4 pixeis) da imagem
		sw t6,0(t0)			# imprime no bitmap a word (4 pixeis) da imagem
		
		addi t0,t0,4			# incrementa endereco do bitmap
		addi a0,a0,4			# incrementa endereco da imagem
		
		addi t3,t3,4			# incrementa contador de coluna
		blt t3,a3,PRINT_LINHA		# se contador da coluna < largura, continue imprimindo

		addi t0,t0,320			# t0 += 320
		sub t0,t0,a3			# t0 -= largura da imagem
		# ^ isso serve pra "pular" de linha no bitmap display
		beqz a7, NORMAL_PRINT
		addi a0,a0,320	# a0 +=320	
		sub a0,a0,a3	# a0 -= width
NORMAL_PRINT:	mv t3,zero			# zera t3 (contador de coluna)
		addi t2,t2,1			# incrementa contador de linha
		bgt a4,t2,PRINT_LINHA		# se altura > contador de linha, continue imprimindo
		
		ret				# retorna
		
		
