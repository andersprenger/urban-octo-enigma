.text
    .globl main


main:
    # do stuff...

###############################################################################################
###  fdiv - Divisão.
###############################################################################################
# s1 = dividendo
# s0 = divisor
# v0 = resto
# v1 = divisao
#
# Registradores usados: 0, s0, s1, t0, t1, t2, v0, v1, ra
#
###############################################################################################
fdiv:
    la      $s1, d1
    lw      $s1, 0($s1)
    la      $s0, d2
    lw      $s0, 0($s0)

divider:  
    lui     $t0, 0x8000       # mascara para isolar bit mais significativo
    li      $t1, 32           # contador de iterações

    xor     $v0, $v0, $v0     # registrador P($v0)-A($v1) com  0 e o dividendo
    add     $v1, $s1, $0

dloop:    
    and   $t2, $v1, $t0     # isola em t2 o bit mais significativo do registador 'A' ($v1)
    sll   $v0, $v0, 1       # desloca o registrado P-A
    sll   $v1, $v1, 1 

    beq   $t2, $0, di1    
    ori   $v0, $v0, 1       # coloca 1 no bit menos significativo do registador 'P'($v0)

di1:      
    sub   $t2, $v0, $s0     # subtrai 'P'($v0) do divisor ($s0)
    blt   $t2, $0, di2
    add   $v0, $t2, $0      # se a subtração deu positiva, 'P'($v0) recebe o valor da subtração
    ori   $v1, $v1, 1       # e 'A'($v1) recebe 1 no bit menos significativo

di2:      
    addi  $t1, $t1, -1      # decrementa o número de iterações 
    bne   $t1, $0, dloop 

    jr    $ra               # encerra a funcao

###############################################################################################
### fmax - Encontra o valor maximo em um vetor. 
###############################################################################################
# t0 = vetor[i]
# t1 = i
# t2 = n
# t3 = max
#
# Registradores usados: 0, t0, t1, t2, t3, t4, ra
#
###############################################################################################

fmax:   
    la      $t0, vetor          # t0 = vetor[0]
    xor     $t1, $t1, $t1       # i = 0
    la		$t2, n              # t2 = *n
    lw      $t2, 0($t2)         # t2 = n
    xor     $t3, $t3, $t3       # max = 0

mloop: # do {} while (i<n)
    lw		$t4, 0($t0)		    # le da memoria a[i]
    blt     $t4, $t3, ml1       # if a[i] < max { jump l1 }
    add     $t3, $t4, $0        # else { t3 = t4 }
    
ml1:
    addi    $t1, $t1, 1         # i++
    addi    $t0, $t0, 4         # t0 = vetor[i]
    blt		$t1, $t2, loop	    # do { loop } while (i<n)
    jr      $ra                 # encerra a funcao