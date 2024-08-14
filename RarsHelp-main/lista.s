 
 .text
	 auipc s0, 0x0FC10		# carrega o endereço 0x0FC10 em s0, somando 0 no fim para o endereço completo
	 addi s0, s0, 0
	 lw a0, 0(s0)			# carrega em a0 o que está no endereço acima
	 jal ra, LAB1			# pula para LAB1
	 sw a7, 4(s0)			# carrega em a7 o que está logo em seguida a a0, isto é, uma word a frente
	 jal zero, END			# pula para o fim do programa 
LAB1:	 andi t0, a0, 1			# caso a0 seja par, guarda 0 em t0, caso contrário, guarda 1
	 beq t0, zero, LAB2		# caso t0 seja igual a 0, pula para LAB2 
	 srli  t3, a0, 1		# divide o valor de a0 por 2 e guarda em t3
	 addi t0, zero, 3		# coloca 3 em t0
	 rem t1, a0, t0			# obtém o resto da divisão de a0 por t0 e guarda em t1
	 beq t1, zero, LAB2		# caso t1 seja igual a 0, pula para LAB2
	 addi t0, t0, 2 		# soma t0 com 2 (t0 = 5)
	 bltu t0, t3, LAB1		# caso t0 seja menor do que t3 (sem sinal) pula para 
	 addi a7, zero, 1		# coloca 1 em a7
	 jal, zero, END			# pula para o fim do programa
LAB2:	 addi a7, zero, 0 		# coloca 0 em a7
END:	 jalr, zero, ra, 0		# encerra o programa
	
	# Checa se um número é par (guarda 0 em a7 e termina o programa), caso contrário guarda o quociente do número por 2 em t3,  guarda o resto
	# da divisão do número por 3 em t1, se o número for divisível por 3, guarda 0 em a7 e termina o programa, caso contrário checa se t3 é maior que 5e pula para ?, caso não seja,
	# guarda 1 em a7 e termina o programa (se o número inicial for maior que 11 e não divisível por 3) 