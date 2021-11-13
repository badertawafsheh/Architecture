.data 
   
    file:   .asciiz "Test.txt"      # filename for input
    msg1:   .asciiz "Please enter the input file name:"
    
prop1: .asciiz "Enter The File Name :"  
    .word 0
    buffer: .space 20
    newline:    .asciiz "\n"
   
.text

main:
 
 #Ask to enter the name of file
li $v0,4
la $a0,prop1
syscall  
fileRead:
# FileName must be full path
li $v0,8
la $a0,file            
li $a1,20
syscall 
    # Open file for reading
    li   $v0, 13       # system call for open file
    la   $a0, file      # input file name
    li   $a1, 0        # flag for reading
    li   $a2, 0        # mode is ignored
    syscall            # open a file 
    move $s0, $v0      # save the file descriptor 

    # reading from file just opened
    li   $v0, 14       # system call for reading from file
    add $a0, $s0, $zero     # file descriptor 
    la   $a1, buffer   # address of buffer from which to read  
    li   $a2, 1024  # hardcoded buffer length
    syscall            
    
    # print newline
	la $a0, newline
	li $v0 4
	syscall
	
    #print
        la $a0, buffer
        li $v0, 4
        syscall
    	
        
   
  
done: 
    li $v0, 16
    add $a0, $s0, $zero
endmain:
    li $v0, 10
    syscall
    

 
