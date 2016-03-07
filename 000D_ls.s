	.section
	.text
	.globl sum
sum:
	push %rbp
	mov     %rsp, %rbp
	add     %rdi, %rsi
	mov     %rsi, %rax
	leave
	ret
