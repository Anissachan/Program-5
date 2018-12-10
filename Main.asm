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


loop	LDI R0, Buffer		;output character to console
	BRz loop
	TRAP x21
	AND R1, R1, #0
	STI R1, Buffer

	ADD R5, R4, #-3
	BRzp StopCodon
	

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
	ADD R5, R4, #-1
	BRz isinSeqU
	AND R4, R4, #0
	BRnzp loop

isinSeqU        ADD R4, R4, #1
		BRnzp loop


LETTERC	AND R4, R4, #0		;clearing counter since C does not contribute to the sequence
	BRnzp loop

LETTERG	ADD R5, R4, #-2
	BRz isinSeqG
	AND R4, R4, #0
	BRnzp loop

isinSeqG ADD R4, R4, #1
	 LD R0, BAR
	 OUT
	 BRnzp loop


StopCodon  
	   ADD R0, R0, #0		;tells what letter is in R0
	   LD R2, CHECKA		
	   ADD R3, R0, R2
	   Brz CHARACTERA
	   LD R2, CHECKU
	   ADD R3, R0, R2
	   BRz CHARACTERU
	   LD R2, CHECKC
	   ADD R3, R0, R2
	   BRz CHARACTERC
	   LD R2, CHECKG
	   ADD R3, R0, R2
	   BRz CHARACTERG


CHARACTERU AND R4, R4, #0
	   ADD R4, R4, #4	
	   BRnzp loop

CHARACTERA ADD R5, R4, #-4
	   BRzp isinSeqAFINAL
	   AND R4, R4, #0
	   ADD R4, R4, #3
	   BRnzp loop

isinSeqAFINAL   ADD R4, R4, #1
	   ADD R5, R4, #-6
	   BRz	ENDING
	   BRnp loop

CHARACTERG ADD R5, R4, #-5
	   BRzp isinSeqGFINAL
	   AND R4, R4, #0
           ADD R4, R4, #3
	   BRnzp loop

isinSeqGFINAL	ADD R4, R4, #1
		ADD R5, R4, #-6
	        BRZ ENDING
		BRnp loop

CHARACTERC 	AND R4, R4, #3		;clearing counter since C does not contribute to the sequence
		BRnzp loop
	        

 
ENDING HALT
		



CHECKA	.FILL #-65
CHECKU	.FILL #-85
CHECKC	.FILL #-67
CHECKG	.FILL #-71





STACK	.FILL x4000
KBIVE 	.FILL x0180
KBISR 	.FILL x2600
KBSR 	.FILL xFE00
KBIEN	.FILL x4000
Buffer	.FILL x4600
BAR	.FILL #124


		.END
