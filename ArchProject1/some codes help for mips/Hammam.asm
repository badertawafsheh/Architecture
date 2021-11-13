
.data
buffer:            .space 8
File_name:         .space 256
String_name:       .space 256 
input_string: 	   .space 256
file: 		   .asciiz "test.txt"
fn: 		   .asciiz "File_name="		#file name
sn: 		   .asciiz "String_name="	#string name
ec: 		   .asciiz "echo "		
wcl: 		   .asciiz "wc -l $File_name"
wcw: 		   .asciiz "wc -w $file_name"
grep: 		   .asciiz "grep $String_name $File_name"
error_msg: 	   .asciiz "Error: wrong input"
enter_command_msg: .asciiz "\nEnter your command \n"

.text
.globl main
main:   # main program entry

	la $a0, enter_command_msg 	#print the command message
	li $v0, 4
	syscall	
	
	la $a0, input_string	#read string from input
	li $a1, 256		#buffer size			
	li $v0, 8		#8 = read string
	syscall	
	
	la $t0, input_string	#load input string
	la $t1, fn
			 	#load string to compare
file_name_loop:
	lb $t2, ($t0)		#each loop load one byte to compare
	lb $t3, ($t1)
	beqz $t3, file_name_function	#if null is reached then the string is correct (branch to commands function)
	bne $t2, $t3, string_name_load	#if string is incorrect jump to compare other strings
	addiu $t0, $t0, 1		#add 1 to load next  byte
	addiu $t1, $t1, 1
	j file_name_loop
	
string_name_load:
	la $t0, input_string	
	la $t1, sn	
		
string_name_loop:
	lb $t2, ($t0)		
	lb $t3, ($t1)
	beqz $t3, string_name_function	
	bne $t2, $t3, echo_load
	addiu $t0, $t0, 1		
	addiu $t1, $t1, 1
	j string_name_loop
	
echo_load:
	la $t0, input_string	
	la $t1, ec
			
echo_loop:
	lb $t2,($t0)		
	lb $t3,($t1)
	beqz $t3,echo_function	
	bne $t2,$t3, wcl_load		#wc -l
	addiu $t0,$t0,1		
	addiu $t1,$t1,1
	j echo_loop
	
wcl_load:
	la $t0,input_string	
	la $t1,wcl	
		
wcl_loop:
	lb $t2,($t0)		
	lb $t3,($t1)
	beqz $t3,wcl_function	
	bne $t2,$t3, wcw_load		#wc -w
	addiu $t0,$t0,1		
	addiu $t1,$t1,1
	j wcl_loop
	
wcw_load:
	la $t0,input_string	
	la $t1,wcw	
		
wcw_loop:
	lb $t2,($t0)		
	lb $t3,($t1)
	beqz $t3,wcw_function	
	bne $t2,$t3, grep_load		
	addiu $t0,$t0,1		
	addiu $t1,$t1,1
	j wcw_loop

grep_load:
	la $t0,input_string	
	la $t1,grep	
		
grep_loop:
	lb $t2,($t0)		
	lb $t3,($t1)
	beqz $t3,grep_function	
	bne $t2,$t3, error_1	#error no command match the input
	addiu $t0,$t0,1		
	addiu $t1,$t1,1
	j grep_loop
	
file_name_function:		#file_name function		
	move $a0,$t0		#call function to copy string
	la $a1,File_name
	jal str_cpy

	#la $a0,File_name
	#li $v0,4
	#syscall
	j main

string_name_function:		#string_name function

	move $a0,$t0		#call function to copy string
	la $a1,String_name
	jal str_cpy
	
	#la $a0,String_name
	#li $v0,4
	#syscall
	j main
	
echo_function:			#echo function
	la $a0,ec
	li $v0,4
	syscall
	j main

wcl_function:			#wc -l  function
	la $a0, wcl
	li $v0, 4
	syscall
	j main

wcw_function: 			#wc -w function
	la $a0,wcw
	li $v0,4
	syscall
	j main

grep_function:			#grep function
	la $a0,grep
	li $v0,4
	syscall
	j main

error_1:				#error
	la $a0,error_msg
	li $v0,4
	syscall
	j main

str_cpy:				#copy string from $a0 to $a1 , where a0 and a1 are addresses in the memory
	lb $t2,($a0)		
	sb $t2,($a1)
	beqz $t2,cpy_finish			
	addiu $a0,$a0,1		
	addiu $a1,$a1,1
	j str_cpy
	
cpy_finish:
	jr $ra	
	li	$v0, 10	# Exit program
	syscall
	
	
	
	#******************************** codes for later use ********************************
	#********************************* read string ***************************************
	la $a0,input_string	#read string from input
	li $a1,255
	li $v0,8
	syscall
	
	add $a0,$a0,1		#print string	
	li $v0,4
	syscall
	#**************************************************************************************
	
	#********************************** open and read from file ***************************
	
	# Open File

	li	$v0, 13			# 13=open file
	la	$a0, file		# $a2 = name of file to read
	add	$a1, $0, $0		# $a1=flags=O_RDONLY=0
	add	$a2, $0, $0		# $a2=mode=0
	syscall				# Open FIle, $v0<-fd
	add	$s0, $v0, $0	# store fd in $s0


	li	$v0, 14			# 14=read from  file
	add	$a0, $s0, $0	# $s0 contains fd
	la	$a1, buffer		# buffer to hold int
	li	$a2, 8			# Read 8 bytes
	syscall
	
	li	$v0, 4			# 4=print string
	la	$a0, buffer		# buffer contains the int
	syscall	
	
	li	$v0, 16			# 16=close file
	add	$a0, $s0, $0	# $s0 contains fd
	syscall	
	
	#**************************************************************************************
