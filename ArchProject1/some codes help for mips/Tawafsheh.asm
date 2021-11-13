.data 
fileName: .space 100
.word 0
buffer: .space 50
propmt1: .asciiz "Enter The File Name :"    

.text 

main : 

#Ask to enter the name of file
li $v0,4
la $a0,propmt1
syscall

# FileName must be full path
li $v0,8
la $a0,fileName            
li $a1,20
syscall 

la $s0,fileName  
addi $s3,$0,'\n'  
loop:
lb $s1,0($s0) 
beq $s1,$s3,NEW # break  newLine
addi $s0,$s0,1  
j loop 

NEW : 
sb $0,0($s0) # replace new line with 0 

#Open file for reading
li   $v0, 13       # system call for open file
la   $a0, fileName # input file name
li   $a1, 0        # flag for reading
li   $a2, 0        # mode is ignored
syscall            # open a file 
move $s0, $v0      # save the file descriptor 

# reading from file just opened
li   $v0, 14       # system call for reading from file
add $a0, $s0, $zero     # file descriptor 
la   $a1, buffer   # address of buffer from which to read  
li   $a2, 1024  # hardcoded buffer length
syscall            # read from file
     
#printTheFile 
li $v0, 4
la $a0, ($a1) 
syscall

#EQ: 

        add $t5, $zero, $a0
        lb $a0, 3($t5)       
        addi $a2, $a0, -48  #convert To integer
        mtc1 $a2, $f1  
        cvt.s.w $f1, $f1    #convert To Float

	#add $a0, $zero, $a2
	li $v0, 2
	mov.s $f12,$f1 
	syscall
	




endFile: 
    li $v0, 16
    add $a0, $s0, $zero
endMain:
    li $v0, 10
    syscall
