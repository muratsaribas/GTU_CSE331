# $t9 = returnVal deðiþkeni
# $t8 = control deðiþkeni
.data
arraySize: .space 4
num: .space 4
arr: .space 80
posNumbers: .space 80
counter: .space 4
msg1: .asciiz "\nArray Size:"
msg2: .asciiz "Target sum: "
msg3: .asciiz "Array element: "
pos:  .asciiz "Possible!"
npos: .asciiz "Not Possible!"
sm2: .ascii "\n"
sm: .ascii "  "

.text
.globl main

main:

    li $t8, 0				# control = 0	

    li $v0, 4
    la $a0, msg1
    syscall
    
    li $v0, 5
    syscall
    sw $v0, arraySize    		# girilen deðeri arraySize içine yaz
    
    li $v0, 4
    la $a0, msg2
    syscall
    
    li $v0, 5				# kullanýcý giriþi
    syscall
    sw $v0, num				# girilen deðeri num içine yaz
    
    la $t2, arr         		# array adresini $t2 register'ýna yükle
    lw $t1, arraySize			# arraySize deðerini $t1 register'ýna yükle
    array_loop:
    	li $v0, 4
    	la $a0, msg3			# 
    	syscall
    	
    	li $v0, 5			# kullanýcý giriþi
    	syscall
    	sw $v0, 0($t2)			# girilen deðeri t2 register'ýndaki adrese yaz	
    	addi $t2, $t2, 4		# sonraki index
    	addi $t0, $t0, 1		# i++
    	bne $t0, $t1, array_loop	# for(t0=0;t0!=arraySize;t0++)
   lw $t1, counter
   la $t3, posNumbers
   lw $a0, num				# $a0 = num
   la $a1, arr				# $a1 = arr address
   lw $a2, arraySize			# $a2 = arraySize
   jal CheckSumPossibility		# recursive fonksiyonu çaðýr
   
   end_recursive:
   addi $t9, $v0, 0 			# returnVal = control
   
   if1:					# if(returnVal == 1)
      bne $t9, 1, else1
      li $v0, 4
      la $a0, pos			# ekrana "Possible!" yazdýr
      syscall
      j endif
   else1:				# else
      li $v0, 4
      la $a0, npos			# ekrana "Not Possible!" yazdýr
      syscall
         
   endif:
      li $v0, 10
      syscall
# $t1 = counter
# $t3 = posNumbers adres   
CheckSumPossibility:
	addi $sp, $sp, -16		# stack'te 4 word yer aç
    	sw   $ra, 0($sp)		# adres
    	sw   $a0, 4($sp)		# num
    	sw   $a1, 8($sp)		# arr adres
    	sw   $a2, 12($sp)		# arraySize
    	
    	#if:
    	#   bne $t8, 1, else		# if(control !=1)
	#   j exit
	else:
 	   bne $a0, 0, elseif		# if(num!=0) 
 	   addi $t1, $t1, 0
 	   la $t3, posNumbers
 	   li $t8, 1			# control = 1
 	   li $t0, 0			# i = 0
		
 	   print_loop:
 	      li $v0, 1
    	      lw $a0, 0($t3) 	        # 
    	      syscall
    	      li $v0, 4
    	      la $a0, sm
    	      syscall
    	      addi $t3, $t3, 4		# sonraki index
    	      addi $t0, $t0, 1		# i++
    	      bne $t0, $t1, print_loop	# 
	      li $v0, 4
    	      la $a0, sm2
    	      syscall
	      j exit
	elseif:				
	   bne $a2, 0, elseif2		# else if(size!=0)
	   j exit			
	elseif2:			
	   bgt	$a0, 0, recursive	# else if(num > 0)
	   j exit			
	recursive:
	#addi $a0, $a0, 0		# fonksiyona argümanlarý yolla $a0 = num, $a1 = arr adresi, $a2 = size
	#addi $a1, $a1, 0		# ($a0 ve $a1 register'larýnda deðiþiklik yapýlmadýðý için yazmaya gerek yok)
	addi $a2, $a2, -1   		# size-1
	jal CheckSumPossibility
	
	
	recursive2:
	addi $t6, $a2, 0		# size deðerini $t6 register'ýna yükle
	sll $t6, $t6, 2			# arr[size-1] adresine ulaþmak için size*4 
	add $t6, $t6, $a1		# arr baþlangýç adresi + size*4
	lw $t5,	0($t6)			# $t6 adresindeki arr deðerini $t5 register'ýna yükle ($t5 = arr[size-1]
	sw $t5, 0($t3)			# possible[counter] = arr[size-1]
	addi $t3, $t3, 4
	addi $t1, $t1, 1		# counter++;
	sub $a0, $a0, $t5		# num - arr[size-1]
	#addi $a1, $a1, 0		# $a1 register'ýnda bi deðiþiklik yapýlmadý
	#addi $a2, $a2, 0		# size deðiþkeni önceden 1 azaltýlmýþtý, tekrar azaltmaya gerek yok
	jal CheckSumPossibility
	addi $t1, $t1, -1		# counter--;
	addi $t3, $t3, -4
	j exit

   exit:
   	lw $ra,0($sp)       		# stack'ten register'larý oku
	lw $a0,4($sp)
	lw $a1,8($sp)
	lw $a2,12($sp)
	addi $sp,$sp,16       		# stack pointer'ý eski haline getir
	move $v0, $t8
	jr $ra


    	
    


