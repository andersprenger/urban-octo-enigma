.text
    .globl main

main:
    la		$s0, n              # s0 = *n
    lw      $s0, 0($s0)         # s0 = n

    la      $s1, A              # s1 = *vetor[0]
    xor     $s2, $s2, $s2       # i = 0
    xor     $s3, $s3, $s3       # soma = 0
    jal		addLoop				# calcular soma em s3
    jal     divider             # calcular divisão em v1
    
###############################################################################################
###  addLoop - Somador.
###############################################################################################
# t0 = *vetor[i]
# s0 = n
# s1 = *vetor[i]
# s2 = i
# s3 = soma
#
# Registradores usados: t0, s0, s1, s2, s3, ra
#
###############################################################################################

addLoop:
    lw		$t0, 0($s1)         # le da memoria vetor[i]
    add     $s3, $s3, $t0       # soma += vetor[i]
    blt		$s2, $s0, increment	# if (i < n) { i++ }
    jr      $ra                 # else { encerra a funcao }

increment:
    addi    $s2, $s2, 1         # i++
    addi    $s1, $s1, 4         # *vetor[i] += 4
    j		addLoop				# jump to mloop
    
###############################################################################################
###  divider - Divisão.
###############################################################################################
# a1 = dividendo
# s0 = divisor
# v0 = resto
# v1 = divisao
#
# Registradores usados: 0, s0, a1, t0, t1, t2, v0, v1, ra
#
###############################################################################################

divider:  
    lui     $t0, 0x8000         # mascara para isolar bit mais significativo
    li      $t1, 32             # contador de iterações

    xor     $v0, $v0, $v0       # registrador P($v0)-A($v1) com  0 e o dividendo
    add     $v1, $a1, $0

dloop:
    and     $t2, $v1, $t0       # isola em t2 o bit mais significativo do registador 'A' ($v1)
    sll     $v0, $v0, 1         # desloca o registrado P-A
    sll     $v1, $v1, 1 

    beq     $t2, $0, di1    
    ori     $v0, $v0, 1         # coloca 1 no bit menos significativo do registador 'P'($v0)

di1:      
    sub     $t2, $v0, $s0       # subtrai 'P'($v0) do divisor ($s0)
    blt     $t2, $0, di2
    add     $v0, $t2, $0        # se a subtração deu positiva, 'P'($v0) recebe o valor da subtração
    ori     $v1, $v1, 1         # e 'A'($v1) recebe 1 no bit menos significativo

di2:      
    addi    $t1, $t1, -1        # decrementa o número de iterações 
    bne     $t1, $0, dloop      # if (i = 0) { jump dloop }

    jr      $ra                 # encerra a funcao

.data
A: .word 810 100 560 380 600 87
B: .word 800 555 817 124 890 456
C: .word 345 200 700 180 600 490
n: .word 6
k: .word 0
D: .word 0