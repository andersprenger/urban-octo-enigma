#
#   Trabalho de Fundamentos de Sistemas Digitais
#
#   Anderson R. P. Sprenger
#   Patricia B. de Lima
#
.text
.globl main

main:
    la      $s2,        n                   # s2 = *n
    lw      $s2,        0($s2)              # s2 = n

    la      $s3,        A                   # s3 = *A[0]
    addi    $s4,        $0,     1           # i = 1
    xor     $s5,        $s5,    $s5         # soma = 0
    jal     addLoop                         # calcular soma de s3 em s5
    add     $s1,        $s5,    $0          # s1 = soma
    add     $s0,        $s2,    $0          # s0 = n
    jal     divider                         # calcular divisão em v1
    add     $t3,        $v1,    $0          # t3 = media A

    la      $s3,        B                   # s3 = *B[0]
    addi    $s4,        $0,     1           # i = 1
    xor     $s5,        $s5,    $s5         # soma = 0
    jal     addLoop                         # calcular soma de s3 em s5
    add     $s1,        $s5,    $0          # s1 = soma
    add     $s0,        $s2,    $0          # s0 = n
    jal     divider                         # calcular divisão em v1
    add     $t4,        $v1,    $0          # t4 = media B

    la      $s3,        C                   # s3 = *C[0]
    addi    $s4,        $0,     1           # i = 1
    xor     $s5,        $s5,    $s5         # soma = 0
    jal     addLoop                         # calcular soma de s3 em s5
    add     $s1,        $s5,    $0          # s1 = soma
    add     $s0,        $s2,    $0          # s0 = n
    jal     divider                         # calcular divisão em v1
    add     $t5,        $v1,    $0          # t5 = media C

check1:
    blt     $t4,        $t3,    check2      # if (t4 < t3) { j check2 }
    add     $t3,        $t4,    $0          # t3 = t4

check2:
    blt     $t5,        $t3,    readA       # if (t5 < t3) { j readA }
    add     $t3,        $t5,    $0          # t3 = t5

readA:
    xor     $t6,        $t6,    $t6         # k = 0
    la      $t7,        D                   # t7 = *D[0]

    la      $s3,        A                   # s3 = *A[0]
    addi    $s4,        $0,     0           # i = 1
    jal     subrotina                       # subrotina para A

readB:
    la      $s3,        B                   # s3 = *A[0]
    addi    $s4,        $0,     0           # i = 1
    jal     subrotina                       # subrotina para B

readC:
    la      $s3,        C                   # s3 = *A[0]
    addi    $s4,        $0,     0           # i = 1
    jal     subrotina                       # subrotina para C

saveK:
    sw      $t6,        k                   # k = t6

end: j end


# ##############################################################################################
# ##  subrotina
# ##############################################################################################
subrotina:
    lw      $t0,        0($s3)              # le da memoria vetor[i]
    blt     $t0,        $t3,    srjump      # if (vetor[i] < maior media) { j srjump }
    sw      $t0,        0($t7)              # d[k] = vetor[i]
    addi    $t6,        $t6,    1           # k++
    addi    $t7,        $t7,    4           # t7 = *vetor[i]

srjump:
    addi    $s4,        $s4,    1           # i++
    addi    $s3,        $s3,    4           # s3 = *vetor[k]
    blt     $s4,        $s2,    subrotina   # if (i < n) { i++ }
    jr      $ra                             # else { encerra a funcao }


# ##############################################################################################
# ##  addLoop - Somador.
# ##############################################################################################
addLoop:
    lw      $t0,        0($s3)              # le da memoria vetor[i]
    add     $s5,        $s5,    $t0         # soma += vetor[i]
    blt     $s4,        $s2,    increment   # if (i < n) { i++ }
    jr      $ra                             # else { encerra a funcao }

increment:
    addi    $s4,        $s4,    1           # i++
    addi    $s3,        $s3,    4           # *vetor[i] += 4
    j       addLoop                         # jump to mloop

# ##############################################################################################
# ##  Divisão serial  $s1/ $s0 -->   $v0--> resto    $v1 --> divisão
# ##############################################################################################
divider:
    lui     $t0,        0x8000              # mascara para isolar bit mais significativo
    li      $t1,        32                  # contador de iterações

    xor     $v0,        $v0,    $v0         # registrador P($v0)-A($v1) com  0 e o dividendo
    add     $v1,        $s1,    $0

dloop:
    and     $t2,        $v1,    $t0         # isola em t2 o bit mais significativo do registador 'A' ($v1)
    sll     $v0,        $v0,    1           # desloca o registrado P-A
    sll     $v1,        $v1,    1

    beq     $t2,        $0,     di1
    ori     $v0,        $v0,    1           # coloca 1 no bit menos significativo do registador 'P'($v0)

di1:
    sub     $t2,        $v0,    $s0         # subtrai 'P'($v0) do divisor ($s0)
    blt     $t2,        $0,     di2
    add     $v0,        $t2,    $0          # se a subtração deu positiva, 'P'($v0) recebe o valor da subtração
    ori     $v1,        $v1,    1           # e 'A'($v1) recebe 1 no bit menos significativo

di2:
    addi    $t1,        $t1,    -1          # decrementa o número de iterações
    bne     $t1,        $0,     dloop

    jr      $ra

.data
A: .word 710 200 550 390 700
B: .word 600 444 800 123 910
C: .word 347 300 710 190 610
n: .word 5
k: .word 0
D: .word 0