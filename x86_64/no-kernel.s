	.file	"no-kernel.c"
	
.LCOLDB2:
	
.LHOTB2:
	.globl	_start
	.type	_start, @function
_start:
	
	
	xorl	%r9d, %r9d
	
	
	subq	$56, %rsp
	flds	.LC0(%rip)
	movl	$1732584193, 32(%rsp)
	movl	$-271733879, 36(%rsp)
	movl	$-1732584194, 40(%rsp)
	movl	$271733878, 44(%rsp)
	movb	$-128, 4194874
	movq	$4560, 4194936
.L8:
	movl	32(%rsp), %ebp
	movl	36(%rsp), %edi
	movl	$5, %r10d
	movl	40(%rsp), %esi
	movl	44(%rsp), %edx
	movl	$1, %r11d
	xorl	%r8d, %r8d
.L7:
	movb	%r8b, %cl
	movb	%r8b, %bl
	sarb	$4, %cl
	cmpb	$2, %cl
	je	.L3
	cmpb	$3, %cl
	je	.L4
	cmpb	$1, %cl
	je	.L5
	movl	%esi, %eax
	movb	%r8b, %r12b
	xorl	%edx, %eax
	andl	%edi, %eax
	xorl	%edx, %eax
	jmp	.L6
.L5:
	movl	%edi, %eax
	movb	%r11b, %r12b
	xorl	%esi, %eax
	andl	%edx, %eax
	xorl	%esi, %eax
	jmp	.L18
.L3:
	movl	%edi, %eax
	movb	%r10b, %r12b
	xorl	%esi, %eax
	xorl	%edx, %eax
	jmp	.L18
.L4:
	movl	%edx, %eax
	notl	%eax
	imull	$7, %r8d, %r12d
	orl	%edi, %eax
	xorl	%esi, %eax
.L18:
	andl	$15, %r12d
.L6:
	incl	%r8d
	movl	%r8d, 4(%rsp)
	fildl	4(%rsp)
#APP
# 22 "no-kernel.c" 1
	fsin
	
# 0 "" 2
#NO_APP
	movsbq	%r12b, %r13
	andl	$3, %ebx
	movsbl	%cl, %ecx
	leal	(%rbx,%rcx,4), %ecx
	addl	$5, %r11d
	addl	$3, %r10d
	
	movsbl	ss(%rcx), %ecx
	fabs
	fmul	%st(1), %st
	fisttpq	8(%rsp)
	movq	8(%rsp), %r12
	addl	%r12d, %eax
	addl	4194304(%r9,%r13,4), %eax
	addl	%ebp, %eax
	movl	%edx, %ebp
	roll	%cl, %eax
	addl	%edi, %eax
	cmpl	$64, %r8d
	je	.L20
	movl	%esi, %edx
	movl	%edi, %esi
	movl	%eax, %edi
	jmp	.L7
.L20:
	addq	$64, %r9
	addl	%eax, 36(%rsp)
	addl	%edi, 40(%rsp)
	addl	%esi, 44(%rsp)
	addl	%edx, 32(%rsp)
	cmpq	$640, %r9
	jne	.L8
	fstp	%st(0)
	xorl	%ebx, %ebx
.L12:
	movb	%bl, %al
	movb	%bl, %dl
	movl	$1, %esi
	shrb	%al
	andl	$1, %edx
	movl	$1, %edi
	movzbl	%al, %eax
	cmpb	$1, %dl
	movsbl	32(%rsp,%rax), %eax
	sbbl	%ecx, %ecx
	andl	$4, %ecx
	sarl	%cl, %eax
	andl	$15, %eax
	leal	87(%rax), %ecx
	leal	48(%rax), %edx
	cmpb	$10, %al
	movb	%cl, %al
	movl	$1, %ecx
	cmovl	%edx, %eax
	leaq	31(%rsp), %rdx
	incl	%ebx
	movb	%al, 31(%rsp)
	xorl	%eax, %eax
	call	syscall
	cmpb	$32, %bl
	jne	.L12
	xorl	%esi, %esi
	movl	$60, %edi
	xorl	%eax, %eax
	call	syscall
	addq	$56, %rsp
	xorl	%eax, %eax
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	
	
.LCOLDE2:
	
.LHOTE2:
	.globl	ss
	
	
	.type	ss, @object
	
ss:
	.byte	7
	.byte	12
	.byte	17
	.byte	22
	.byte	5
	.byte	9
	.byte	14
	.byte	20
	.byte	4
	.byte	11
	.byte	16
	.byte	23
	.byte	6
	.byte	10
	.byte	15
	.byte	21
	
	
.LC0:
	.long	1333788672
	
	
