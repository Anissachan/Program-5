; ISR.asm
; Name: Pragna Subrahmanya and Anissa Chan
; UTEid: ps28338 & ac67466
; Keyboard ISR runs when a key is struck
; Checks for a valid RNA symbol and places it at x4600
               

.ORIG x2600

START 	LDI R1, KBSR
	BRzp START
	LDI R0, KBDR
	BRnzp checkA

checkA 	LD R2, A
	ADD R3, R2, R0
	BRz Store

checkU 	LD R2, U
	ADD R3, R2, R0
	BRz Store

checkC 	LD R2, C
	ADD R3, R2, R0
	BRz Store

checkG	LD R2, G
	ADD R3, R2, R0
	BRz Store

Store	STI R0, StoreChar
	

RTI
	


	
KBSR		.FILL xFE00
KBDR 		.FILL xFE02
DSR		.FILL xFE04
DDR 		.FILL xFE06
A		.FILL #-65
U 		.FILL #-85
C 		.FILL #-67
G 		.FILL #-71
StoreChar	.FILL x4600
		.END
