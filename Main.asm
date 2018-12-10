; Main.asm
; Name: Pragna Subrahmanya and Anissa Chan
; UTEid: ps28338 & ac67466
; Continuously reads from x4600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
               .ORIG x4000
; initialize the stack pointer

	LD R6, STACK


; set up the keyboard interrupt vector table entry
	
	LD R1, KBISR
	STI R1, KBIVE


; enable keyboard interrupts

	LD R0, KBIEN
	STI R0, KBSR

	
; start of actual program

;increment 3:

loop	LDI R0, Buffer
	BRz loop
	TRAP x21
	AND R1, R1, #0
	STI R1, Buffer
	
	;Process R0
	

;increment 4: check for start codon
	ADD R0, R0, #0		;tells what letter is in R0
	LD R2, CHECKA		
	ADD R3, R0, R2
	Brz LETTERA
	LD R2, CHECKU
	ADD R3, R0, R2
	BRz LETTERU
	LD R2, CHECKC
	ADD R3, R0, R2
	BRz LETTERC
	LD R2, CHECKG
	ADD R3, R0, R2
	BRz LETTERG

LETTERA
	AND R4, R4, #0
	ADD R4, R4, #1		;counter to keep track of three
	BRnzp loop

LETTERU

LETTERC

LETTERG

CHECKA	.FILL #-65
CHECKU	.FILL #-85
CHECKC	.FILL #-67
CHECKG	.FILL #-71


;increment 5: skip till stop codon



STACK	.FILL x4000
KBIVE 	.FILL x0180
KBISR 	.FILL x2600
KBSR 	.FILL xFE00
KBIEN	.FILL x4000
Buffer	.FILL x4600



		.END
