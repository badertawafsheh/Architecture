.data 
fileName: .space 100
.word 0
buffer: .space 50
propmt1: .asciiz "Enter The File Name :"    
seperator:    .asciiz " : "  # seperator to use while printint conversions
newline:    .asciiz "\n" # newline character
Askmsg : .asciiz "-----------> Please Enter the initial Value of the following <----------- \n"
w1 : .asciiz "weghit 1 : "
w2 : .asciiz "weghit 2 : "
Momentum :.asciiz "Momentum is : "
LearningRate : .asciiz "Learning Rate : "
NumberOfEpochs : .asciiz "number of Epochs : "
ReadFileSuccseeful : .asciiz "The File ReadSucessful"
Threshold :.asciiz "Treshold is : "
.text 
#print Msg to Enter the fileName
main : 
#########################################MESSAGES##############################################
#Pring the Askmsg 
li $v0,4 
la $a0,Askmsg
syscall

#print the First Weight 
li $v0,4 
la $a0 ,w1 
syscall 
li $v0 , 6 
syscall 
mov.s $f1,$f0

#print the Second Weight 
li $v0,4 
la $a0 ,w2
syscall 
li $v0 , 6 
syscall 
mov.s $f2,$f0
#print the Learning Rate 
li $v0,4 
la $a0 ,LearningRate
syscall 
li $v0 , 6 
syscall 
mov.s $f3,$f0
#print the number of Epochs  
li $v0,4 
la $a0 ,NumberOfEpochs
syscall 
li $v0 , 6 
syscall 
move $t4,$v0
#print the Momentum   
li $v0,4 
la $a0 ,Momentum
syscall 
li $v0 , 6 
syscall 
mov.s $f5,$f0

#print the Threshold   
li $v0,4 
la $a0 ,Threshold
syscall 
li $v0 , 6 
syscall 
mov.s $f6,$f0
#Ask to enter the name of file
li $v0,4
la $a0,propmt1
syscall
#########################################Read File ###############################################
# FileName must be full path
li $v0,8
la $a0,fileName            
li $a1,20
syscall 
#replacing last character of fileName with 0 insted of \n 
la $s0,fileName 
#add $s2,$0,$0     #s2 = 0 
addi $s3,$0,'\n'  # s3 = '\n'
loop:
lb $s1,0($s0) #load Charachters into $s0 
beq $s1,$s3,end # break if byte is newLine
#addi $s2,$s2,1 #incremnt counter
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
     
#printTheFile 
li $v0, 4
la $a0, ($a1) 
syscall

#########################################Equations ###############################################

        add $t5, $zero, $a0
        add $t5 , $t5 , 1
        add $t0 , $zero,1 #value for i in loop , detect when the loop end
        add $t1 , $zero,0 #value detect when line end
        
      loop1:
        bge $t0,28,endMain #when all data read go to end 
        blt $t1,3,add_two  #if we are in the same line add 2
        bge $t1,3,add_three #if we are in go to new line add 3
        
      continue :
        lb $a0, ($t5)        
        addi $a2, $a0, -48  #convert To integer
        mtc1 $a2, $f1  
        cvt.s.w $f1, $f1    #convert To Float
        
        #print the number in loop
	li $v0, 2
	mov.s $f12,$f1 
	syscall
	# print newline
	la $a0, newline
	li $v0 4
	syscall
	j loop1
    
    add_two : 
      add $t5 , $t5 , 2
      add $t0 , $t0 , 2
      add , $t1, $t1 , 1  
      j continue
       
    add_three:
      add , $t1, $zero , 0  
      add $t5 , $t5 , 3
      add $t0 , $t0 , 3
      add , $t1, $t1 , 1  
      j continue
  



endFile: 
    li $v0, 16
    add $a0, $s0, $zero
endMain:
    li $v0, 10
    syscall
