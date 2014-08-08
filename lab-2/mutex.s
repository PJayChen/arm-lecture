	.syntax unified
	.arch armv7-a
	.text

	.equ locked, 1
	.equ unlocked, 0

	.global lock_mutex
	.type lock_mutex, function
lock_mutex:
        
        @while(*r0 == 1);
	ldrex r1, [r0]
	cmp r1, locked
	beq lock_mutex

	@lock the mutex
	mov r1, locked
	strex r2, r1, [r0]
	cmp r2, #1
	beq lock_mutex	
	
	dmb

	bx lr

	.size lock_mutex, .-lock_mutex

	.global unlock_mutex
	.type unlock_mutex, function
unlock_mutex:
	mov r1, unlocked
	str r1, [r0]	
	dmb
	bx lr
	.size unlock_mutex, .-unlock_mutex

	.end
