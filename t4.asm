

.text
    .globl main

########################################
# Encontra o valor maximo em um vetor. #
########################################
# t0 = vetor[i]
# t1 = i
# t2 = n
# t3 = max
########################################

vmax:   

    la      $t0, vetor          # t0 = vetor[0]
    xor     $t1, $t1, $t1       # i = 0
    la		$t2, n              # t2 = *n
    lw      $t2, 0($t2)         # t2 = n
    xor     $t3, $t3, $t3       # max = 0

loop: # do {} while (i<n)

    lw		$t4, 0($t0)		    # le da memoria a[i]
    blt     $t4, $t3, l1        # if a[i] < max { jump l1 }
    add     $t3, $t4, $0        # else { t3 = t4 }
    
l1:

    addi    $t1, $t1, 1         # i++
    addi    $t0, $t0, 4         # t0 = vetor[i]
    blt		$t1, $t2, loop	    # do { loop } while (i<n)

    jr      $ra    