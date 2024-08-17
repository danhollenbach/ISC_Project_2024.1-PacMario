###############################################
#  Programa de exemplo para Syscall MIDI      #
#  ISC Abr 2018				                  #
#  Marcus Vinicius Lamar		              #
###############################################

.data
# Numero de Notas a tocar
NUM: .word 148
NUM2: .word 36
# lista de nota,dura��o,nota,dura��o,nota,dura��o,...
NOTAS:  76, 200, 64, 200, 76, 200, 76, 200, 67, 200, 72, 200, 76, 200, 67, 200, 79, 200, 67, 200, 79, 200, 67, 200, 67, 200, 65, 200, 64, 200, 62, 200, 72, 200, 60, 200, 59, 200, 67, 200, 57, 200, 55, 200, 64, 200, 60, 200, 55, 200, 69, 200, 57, 200, 71, 200, 59, 200, 70, 200, 69, 200, 57, 200, 67, 200, 76, 200, 64, 200, 79, 200, 81, 200, 65, 200, 77, 200, 79, 200, 60, 200, 76, 200, 64, 200, 72, 200, 74, 200, 71, 200, 57, 200, 55, 200, 72, 200, 60, 200, 59, 200, 67, 200, 57, 200, 55, 200, 64, 200, 60, 200, 55, 200, 69, 200, 57, 200, 71, 200, 59, 200, 70, 200, 69, 200, 57, 200, 67, 200, 76, 200, 64, 200, 79, 200, 81, 200, 65, 200, 77, 200, 79, 200, 60, 200, 76, 200, 64, 200, 72, 200, 74, 200, 71, 200, 57, 200, 55, 200, 60, 200, 55, 200, 79, 200, 78, 200, 77, 200, 74, 200, 63, 200, 76, 200, 53, 200, 68, 200, 69, 200, 72, 200, 57, 200, 69, 200, 72, 200, 74, 200, 60, 200, 55, 200, 79, 200, 78, 200, 77, 200, 74, 200, 63, 200, 76, 200, 65, 200, 84, 200, 65, 200, 84, 200, 84, 200, 59, 200, 58, 200, 57, 200, 60, 200, 55, 200, 79, 200, 78, 200, 77, 200, 74, 200, 63, 200, 76, 200, 53, 200, 68, 200, 69, 200, 72, 200, 55, 200, 69, 200, 72, 200, 74, 200, 56, 200, 55, 200, 75, 200, 67, 200, 63, 200, 74, 200, 59, 200, 55, 200, 72, 200, 55, 200, 52, 200, 55, 200, 60, 200, 48, 200, 48, 200, 55, 200, 48, 200, 48, 200, 48, 200, 48, 200 
NOTAS2: 50, 800, 45, 800, 55, 800, 43, 800, 48, 800, 47, 800, 45, 800, 53, 800, 48, 800, 52, 800, 45, 800, 43, 800, 48, 800, 52, 800, 53, 800, 50, 800, 48, 800, 52, 800, 45, 800, 43, 800, 48, 800, 52, 800, 53, 800, 43, 800, 48, 800, 52, 800, 53, 800, 43, 800, 48, 800, 52, 800, 41, 800, 42, 800, 43, 800, 47, 800, 48, 800, 36, 800 

.text
INICIO: 
    la s0, NUM       # define o endere�o do n�mero de notas
    lw s1, 0(s0)     # le o numero de notas
    la s0, NOTAS     # define o endere�o das notas
    li t0, 0         # zera o contador de notas

    la s2, NUM2      # define o endere�o do n�mero de notas2
    lw s3, 0(s2)     # le o numero de notas2
    la s2, NOTAS2    # define o endere�o de notas2
    li t1, 0         # zera o contador de notas2

    li a2, 32        # define o instrumento para notas
    li a4, 87        # define o instrumento para notas2
    li a3, 127       # define o volume para notas
    li s4, 0	     # 16 para contagem de notas2
    
INST_DOIS: 
    lw a6, 0(s2)     # le o valor da segunda nota
    lw a7, 4(s2)     # le a duracao da segunda nota
    mv a0, a6        # move valor da segunda nota para a0
    mv a1, a7        # move duracao da segunda nota para a1
    li a7, 31        # define a chamada de syscall para tocar nota
    ecall            # toca a segunda nota

    addi s4, s4, 4	 # zera o contador de notas2
    addi s2, s2, 8   # incrementa para o endere�o da pr�xima nota
    addi t1, t1, 1   # incrementa o contador de notas

LOOP_MUSICA:   
    beq t0, s1, REINICIA     # se o contador chegou no final, v� para REINICIA
    beq t0, s4, INST_DOIS    # se o contador2 chegou em 16, v� para DOIS
    
    lw a0, 0(s0)        # le o valor da nota
    lw a1, 4(s0)        # le a duracao da nota
    li a7, 31           # define a chamada de syscall para tocar nota
    ecall               # toca a nota

    addi a1, a1, -5	    # reduzir a pausa pra evitar pausa abrupta nas notas
    mv a0, a1           # move duracao da nota para a pausa
    li a7, 32           # define a chamada de syscal para pausa
    ecall               # realiza uma pausa de a0 ms

    addi s0, s0, 8      # incrementa para o endere�o da pr�xima nota
    addi t0, t0, 1      # incrementa o contador de notas

    j LOOP_MUSICA      # volta ao loop

REINICIA:
	j INICIO			# volta ao inicio

FIM:
    li a7, 10           # define o syscall Exit
    ecall               # exit
