#  
#  COMMIT (Compiler & Micro-architecture)
#

.text
.align 4

	la   sp, stack
	j	loop_test

.data
.align 4
stack:
#	.space 0x00000500