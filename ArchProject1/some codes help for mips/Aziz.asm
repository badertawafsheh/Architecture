.data
	EnterFileName: .asciiz "\n Please enter the name of the training file:  " 
	TrainingFile: .space 100
	Msg: .asciiz "\nPlease enter the initial value of the following: \n "
	EnterWeight1: .asciiz "\nW1:  " 
	EnterWeight2: .asciiz "\nW2:  "   
	EnterMomentum: .asciiz "\nMomentum:  "  
	EnterLearnR: .asciiz "\nLearning rate:  "  
	EnterThreshold: .asciiz "\nThreshold:  "  
	EnterEpochs: .asciiz "\nThe number of epochs:  "
	DesiredOutput: .asciiz "\nThe Desired Output:  " 
	
	newline:    .asciiz "\n"
   


	TFilePath: .asciiz "C:\\Users\\LENOVO\\Desktop\\4th-year#2\\Arch\\TrainingFile.txt"
	buffer: .space 1024
	

.text
main:

	jal Read_File
	jal EnterInitialValues
	jal Activation
	finish:
	li $v0,10
	syscall

Read_File:
	li $v0, 13 #open file
	la $a0, TFilePath #the file name

	li $a1, 0 #Read flag
	li $a2,0 #default mode
	syscall

	move $s6, $v0 #save file descriptor
        #read from file
	li $v0, 14 #read from file
	move $a0, $s6 #file desc

	la $a1, buffer #the buffer to hold the string of whole file
	li $a2, 1024  #buffer length
	syscall

       #close the file
	li $v0,16
	move $a0,$s6
	syscall

       #prints what in file
	la $a0,buffer
	li $v0,4
	syscall
	jr $ra




EnterInitialValues:
        #The user enter the name of the training file
	li $v0 , 4
	la $a0 , EnterFileName
	syscall
	# FileName must be full path
	li $v0,8
	la $a0,TrainingFile            
	li $a1,20
	syscall 
	
	#replacing last character of fileName with 0 insted of \n 
	la $s0,TrainingFile 
	add $s2,$0,$0     #s2 = 0 
	addi $s3,$0,'\n'  # s3 = '\n'	
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
	la   $a0, TrainingFile # input file name
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

       #Ask the user to enter the initial values
	li $v0 , 4
	la $a0 , Msg
	syscall
       #Enter the initial value of Weight 1
	li $v0 , 4
	la $a0 , EnterWeight1
	syscall
	li $v0, 6
	syscall
	mov.s $f9, $f0
       ##Enter the initial value of Weight 2
	li $v0 , 4
	la $a0 , EnterWeight2
	syscall
	li $v0, 6
	syscall
	mov.s $f10, $f0
        ##Enter the initial value of Momentum
	li $v0 , 4
	la $a0 , EnterMomentum
	syscall
	li $v0, 5
	syscall
	move $t2, $v0
        #Enter the initial value of Learniing rate
	li $v0 , 4
	la $a0 , EnterLearnR
	syscall
	li $v0, 6
	syscall
	mov.s $f23, $f0
        #Enter the initial value of Thrshold
	li $v0 , 4
	la $a0 , EnterThreshold
	syscall
	li $v0, 6
	syscall
	mov.s $f11, $f0
       #Enter the initial value of Epochs
	li $v0 , 4
	la $a0 , EnterEpochs
	syscall
	li $v0, 5
	syscall
	move $t5, $v0
	
	#Enter the Desired Output 
	li $v0 , 4
	la $a0 , DesiredOutput
	syscall
	li $v0, 6
	syscall
	mov.s $f22, $f0
	
Activation:
       #To calculate the Output value Y(p)
       addi $s0, $0, 1
       mtc1 $s0, $f0
       cvt.s.w $f0, $f0 # $f0 = 0.0 
      
      # move $t6,x1  #put the value of x1 in $t6
       mul.s $f2, $f0,$f9  # --> x1*w1
       
       addi $s2, $0, 1
       mtc1 $s1, $f3
       cvt.s.w $f3, $f3

       mul.s $f5, $f3,$f10  # --> x2*w2
       
      add.s $f0,$f2,$f5
      sub.s $f0,$f0,$f11
       
      #j Error

      
      
       
      li  $t7, 0        # store the value 0 in register $f0
      mtc1 $t7, $f7
      cvt.s.w $f7, $f7
        
      c.lt.s  $f0, $f7  
      bc1t LessThanZero 
      
      li  $t7, 1        # store the value 0 in register $f0
      mtc1 $t7, $f0
      cvt.s.w $f0, $f0  
      
      sub.s $f22,$f22,$f0
      
      li $v0,2
      mov.s $f12, $f22
      syscall
      
      # print newline
	la $a0, newline
	li $v0 4
	syscall
      
       li  $v0, 1
       cvt.w.s $f12, $f0 # we use $f2 as a temp here
       mfc1 $s0, $f12
       move $a0, $s0
       syscall
      
	
      j deltarule
      
      li $v0,10
      syscall
       
LessThanZero:            
	li  $t0, 0        # store the value 0 in register $f0
        mtc1 $t0, $f0
        cvt.s.w $f0, $f0
       
        sub.s $f22,$f22,$f0
        li $v0,2
        mov.s $f12, $f22
        syscall
        
        # print newline
	la $a0, newline
	li $v0 4
	syscall

      
	li  $v0, 1 
        cvt.w.s $f12, $f0 # we use $f2 as a temp here
        mfc1 $s0, $f12
        move $a0, $s0
        syscall	
        		    
        li $v0,10
        syscall
WeightTraining:
       #To update the values of the wieghts 
        
       

       
       add.s  $f18,$f9,$f15     #calculate weight training for the fisrt input
       add.s  $f19,$f10,$f17	#calculate weight training for the second  input
       
      # print newline
	la $a0, newline
	li $v0 4
	syscall
	
	li $v0,2
        mov.s $f12, $f18
        syscall
        
        
         # print newline
	la $a0, newline
	li $v0 4
	syscall
	
	li $v0,2
        mov.s $f12, $f19
        syscall
        
        li $v0,10
        syscall
       
deltarule:
 	addi $s0, $0, 1
        mtc1 $s0, $f0
        cvt.s.w $f0, $f0 		# $f0 = 0.0  
	mul.s  $f14,$f23,$f0 		# delta w1 = a * X1 * error 	
	mul.s $f15,$f14,$f22		# W1 = $f15 
	
	
	
	addi $s2, $0, 0
        mtc1 $s2, $f3			# maybe be S2 instead of S1
        cvt.s.w $f3, $f3		
	mul.s  $f16,$f23,$f3		# delta w2 = a * X2 * error 
	mul.s $f17,$f16,$f22		# W2 = $f17
	
	j WeightTraining
	 
	
Error:
	sub.s $f22,$f22,$f0
	
		
	




