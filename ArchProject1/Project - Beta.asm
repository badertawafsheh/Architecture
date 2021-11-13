                                    #***********Bader Tawafsheh & Ahmad Fraij ***********#
.data 
fileName:     .space 100
              .word 0
buffer:       .space 50
propmt1:      .asciiz "                              Enter The File Name :"    
seperator:    .asciiz " : "  # seperator to use while printint conversions
newline:      .asciiz "\n" # newline character
Askmsg :      .asciiz "=====================================>> Please Enter the initial Value of the following <<====================================\n"
w1 :          .asciiz "                              weghit 1 : "
w2 :          .asciiz "                              weghit 2 : "
Momentum :    .asciiz "                              Momentum is : "
LearningRate :.asciiz "                              Learning Rate : "
NumberOfEpochs :     .asciiz "                              number of Epochs : "
ReadFileSuccseeful : .asciiz "                              The File ReadSucessful"
Threshold :          .asciiz "                              Treshold is : "
print_x1:            .asciiz "x1 : "
print_x2:            .asciiz " | x2 : "
print_Yd:            .asciiz " | Yd : "
print_w1_intial:     .asciiz " | W1 intial : "
print_w2_intial:     .asciiz " | W2 intial : "
print_Y:             .asciiz " | Y : "
print_error:         .asciiz " | error : "
print_w1_final:      .asciiz " | W1 final : "
print_w2_final:      .asciiz " | W2 final : "
test :               .asciiz "-------------------------------------------------------------------------------------------------------------------------------- "
test2 :              .asciiz "                                         ((Epoch Number : "
test3 :              .asciiz "))"
Iteration :          .asciiz"                                  The total number of Iteration is : "
style1 :             .asciiz"                                _______________________________________"
NEpochs :            .asciiz"                                  The total number of Epochs is : "     
EndAsk:              .asciiz"================================================================================================================================ "
.text 

main : 
#########################################MESSAGES##############################################
#Pring the Askmsg
li $v0,4
la $a0,Askmsg
syscall

la $a0, newline  # print newline
li $v0 4
syscall

#print the First Weight
li $v0,4
la $a0 ,w1
syscall
li $v0 , 6
syscall
mov.s $f18,$f0

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
li $v0 , 5
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

la $a0, newline  # print newline
li $v0 4
syscall

#Pring the EndAsk
li $v0,4
la $a0,EndAsk
syscall

la $a0, newline  # print newline
li $v0 4
syscall

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
new_epuq :
#replacing last character of fileName with 0 insted of \n
la $s0,fileName
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
bge $t0,28,endMain   #when all data read go to end
blt $t1,3,add_two    #if we are in the same line add 2
bge $t1,3,add_three  #if we are in go to new line add 3



continue :
lb $a0, ($t5)
addi $a2, $a0, -48  #convert To integer
mtc1 $a2, $f1
cvt.s.w $f1, $f1    #convert To Float
beq $t1,1 ,value1   #store first value
beq $t1,2 ,value2   #store second value
beq $t1,3 ,value3   #store third value and do prosses on data that we read

newline1:

la $a0, newline  # print newline
li $v0 4
syscall
j loop1

#set step value to zero
set_zero : 
add $s5,$zero ,$zero
j after_step


end_epuq :
add $t6,$zero , $zero
add $t7 ,$t7 , 1
beq $t7,$t4 , endMain
j new_epuq

add_two : #add two as offset for $t5 when we are in the same line
add $t5 , $t5 , 2
add $t0 , $t0 , 2
add , $t1, $t1 , 1
j continue

add_three:    #add three as offset for $t5 when we are go to new line
add , $t1, $zero , 0
add $t5 , $t5 , 3
add $t0 , $t0 , 3
add , $t1, $t1 , 1
#addi $s7, $s7 , 1 #counter for the iterations
j continue


value1:
mov.s $f29 , $f1  #store first value of each line in $f29 # x1= $f29
j newline1

value2:
mov.s $f30 , $f1  #store second value of each line in $f30 # x2= $f30
j newline1

value3:
mov.s $f31 , $f1 #store third value of each line in $f31 # Y(input)= $f31


#output_eqution ====> after take all data from first line , we do the procces on it :

mul.s $f25, $f29,$f18  # --> x1*w1
mul.s $f26, $f30,$f2   # --> x2*w2
add.s $f26 , $f25,$f26 # x1*w1 + x2*w2
sub.s $f26, $f26 , $f6 #x1*w1 + x2*w2 - threshold <== in $f26 the value in Float  


add  $s5,$zero ,1
c.lt.s $f26, $f16      #check value for (x1*w1 + x2*w2 - threshold in flote)
bc1t set_zero          #if it less than zero , set output Y to zero


after_step :           

cvt.w.s $f14, $f31 # we use $f14 as a temp here <== in $f31 the value input y is Flote
mfc1 $s4, $f14    #convert value 3 to intger and store it in s4
sub $s6, $s4,$s5    #s6 = error in intger form

#________________________________________#

#        s4 input Y
#        S5 output Y
#        S6 error (input Y - output Y)

#________________________________________#

mtc1 $s6, $f28 
cvt.s.w $f28, $f28

##print result for one line
#print the epoic ittreion


li $v0,4
la $a0 ,newline    # print New line \n 
syscall

li $v0,4
la $a0 ,test2     # print Sentence (Epoch Number ..) 
syscall

li $v0, 1
la $a0,($t7)     # print The number of Epoch 
syscall

li $v0,4
la $a0 ,test3   # print )) as a style
syscall

li $v0,4
la $a0 ,newline # print New line \n 
syscall

# print X1
li $v0,4
la $a0,print_x1 
syscall             
li $v0, 2
mov.s $f12,$f29
syscall

#print X2
li $v0,4
la $a0,print_x2
syscall
li $v0, 2
mov.s $f12,$f30
syscall

#print Yd
li $v0,4
la $a0,print_Yd
syscall
li $v0, 2
mov.s $f12,$f31
syscall

#print w1 initial
li $v0,4
la $a0,print_w1_intial
syscall
li $v0, 2
mov.s $f12,$f18
syscall

#print w2 initial
li $v0,4
la $a0,print_w2_intial
syscall
li $v0, 2
mov.s $f12,$f2
syscall

#print Y output
li $v0,4
la $a0,print_Y
syscall
li $v0, 1
la $a0,($s5)
syscall

#print Error
li $v0,4
la $a0,print_error
syscall
li $v0, 1
la $a0,($s6)
syscall

#find dalta rule for first value

mul.s $f24,$f29,$f3 # value of learning rate* x1
mul.s $f24 , $f24 ,$f28 # value of delta rule

#find wight1  :
add.s $f24 , $f24 ,$f18  #w1
mov.s $f18 , $f24       #update value of w1 for next ittreation


#find dalta rule  for second value

mul.s $f23,$f30,$f3 # value of learning rate* x2
mul.s $f23 , $f23 ,$f28 # value of delta rule

#find wight2   :
add.s $f23 , $f23 ,$f2  #w2
mov.s $f2 , $f23   #update value of w2 for next ittreation

#print w1 final
li $v0,4
la $a0,print_w1_final
syscall
li $v0, 2
mov.s $f12,$f18
syscall

#print w2 final
li $v0,4
la $a0,print_w2_final
syscall
li $v0, 2
mov.s $f12,$f2
syscall

li $v0,4
la $a0,newline  # print New line \n 
syscall

li $v0,4
la $a0,test     # print Style ---------
syscall


add $t6,$t6 , 1
beq $t6,4,end_epuq

j newline1  #go to read new line of input and make its calclation


endFile:
li $v0, 16
add $a0, $s0, $zero

endMain:

li $v0,4
la $a0,newline  # print New line \n 
syscall

li $v0,4
la $a0,newline  # print New line \n 
syscall

li $v0,4
la $a0,style1     # print Style 
syscall 
li $v0,4
la $a0,newline  # print New line \n 
syscall

li $v0,4
la $a0,newline  # print New line \n 
syscall


mul $s7,$t4,4

# print the total #of iterations
li $v0 4
la $a0, Iteration
syscall
li $v0, 1
move $a0, $s7
syscall

li $v0,4
la $a0,newline  # print New line \n 
syscall

li $v0,4
la $a0,style1     # print Style 
syscall


li $v0,4
la $a0,newline  # print New line \n 
syscall

li $v0,4
la $a0,newline  # print New line \n 
syscall



# print the total #of Epochs
li $v0 4
la $a0, NEpochs
syscall
li $v0, 1
move $a0, $t4
syscall

li $v0,4
la $a0,newline  # print New line \n 
syscall

li $v0,4
la $a0,style1     # print Style 
syscall


li $v0, 10
syscall



	
        
   
	
	
