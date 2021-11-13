.data 
fileName: .space 100
.word 0
buffer: .space 50
propmt1: .asciiz "Enter The File Name :"    
seperator:    .asciiz " : "  # seperator to use while printint conversions
newline:    .asciiz "\n" # newline character
Askmsg : .asciiz "Please Enter the initel Value of the following : "
w1 : .asciiz "weghit 1 : "
w2 : .asciiz "weghit 2 : "
Momentum :.asciiz "Momentum is : "
LearningRate : .asciiz "Learning Rate : "
NumberOfEpochs : .asciiz "number of Epochs : "

.text 
main : 
li $v0,4
la $a0,propmt1
syscall

# FileName must be full path
li $v0,8
la $a0,fileName            
li $a1,20
syscall 

#replacing last character of fileName with 0 insted of \n 
la $s0,fileName 
add $s2,$0,$0 #s2 = 0 
addi $s3,$0,'\n' # s3 = '\n'

loop:
lb $s1,0($s0) #load Charachters into $s0 
beq $s1,$s3,end # break if byte is newLine
addi $s2,$s2,1 #incremnt counter
addi $s0,$s0,1  #incremnt str address 
j loop 

end : 
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
    
    #printFile
   li $v0, 4
   la $a0, ($a1)
   syscall

 ################################Test To read integers from File #############################
        add $t0, $zero, $a0
        lb $a0, 5($t0)
	li $v0, 1
	syscall
        addi $a2, $a0, -48
	
	# print seperator
	la $a0, seperator
	li $v0, 4
	syscall
	
	# print converted number
	add $a0, $zero, $a2
	li $v0, 1
	syscall
	
	# print newline
	la $a0, newline
	li $v0 4
	syscall
 #############################################################################################
 
endFile: 
    li $v0, 16
    add $a0, $s0, $zero
endMain:
    li $v0, 10
    syscall
