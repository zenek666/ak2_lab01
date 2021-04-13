# Skladnia x86 AT&T GAS (a nie Intel)
sysexit = 1
sysread = 3
syswrite = 4
stdout = 1
successexit = 0
SYSCALL32 = 0x80

.data
STDIN = 0
READ = 3
BUF_SIZE = 256
BUF: .space BUF_SIZE



hello:
    .string "Witamy, wpisz tekst\n"

error:
.string "Za dlugi tekst\n"

.text
.globl _start
_start:
    pushl %ebp
    movl %esp, %ebp
    movl $syswrite, %eax # write(1, hello, strlen(hello))
    movl $stdout, %ebx
    movl $hello, %ecx
    movl $20, %edx
    int  $0x80

    movl $BUF_SIZE, %edx
	movl $BUF, %ecx
	movl $STDIN, %ebx
	movl $READ, %eax
	int $SYSCALL32

    movl $100, %ebx
    cmp %ebx, %eax
    jle done

    movl $syswrite, %eax # write(1, error, strlen(error))
    movl $stdout, %ebx
    movl $error, %ecx
    movl $16, %edx
    int  $0x80
    jmp exit

done: # w eax rozmiar wczytanego ciagu


    movl %eax, %ebx
    movl $0, %ecx

 en:  
    movl $0, %eax
    movb BUF(, %ecx,1), %al
    cmp $65, %eax # if( 65 <= char && char <= 90  )
    jge c
    jmp next

    c: 
    cmp $77, %eax 
    jle d
    jg g
    jmp next

   g: 
   cmp $90, %eax
    jle h
    jg e
    jmp next 

    h:
    push %ebx
    movl $77, %esi
    movl %eax, %edx
    sub %esi, %edx
    movl $65, %ebx
    add %ebx, %edx
    movl %edx, %eax
    movb %al, BUF(, %ecx,1)
    popl %ebx
    jmp next
    

    e:
    cmp $97, %eax
    jge f
    jmp next

    f:
    cmp $109, %eax
    jl d
    jge i

    i:
    cmp $122, %eax
    jle j
    jmp next

j:
    pushl %ebx
    movl $109, %esi
    movl %eax, %edx
    sub %esi, %edx
    movl $97, %ebx
    add %ebx, %edx
    movl %edx, %eax
    movb %al, BUF(, %ecx,1)
    popl %ebx
    jmp next
   

    d:
    movl $13, %edx
    add %edx, %eax
    movb %al, BUF(, %ecx,1)
    jmp next

    next:
    inc %ecx
    cmp %ebx, %ecx
    jl en
 
done1:
    movl %ebx, %edx
    movl $syswrite, %eax # write(1, BUF, strlen(BUF))
    movl $stdout, %ebx
    movl $BUF, %ecx 
    int  $0x80

exit:

    movl $sysexit, %eax # exit(0)
    movl $0, %ebx
    popl %ebp
    int  $0x80
