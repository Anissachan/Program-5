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

	AND R1, R1, #0
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
		

loop	LDI R0, Buffer		;output character to console
	BRz loop		;waits for an input, so keeps looping until it gets a letter
	TRAP x21
	AND R1, R1, #0
	STI R1, Buffer


	ADD R5, R4, #-3		;checks if start codon has been detected using sequence counter
	BRzp StopCodon
	

;increment 4: check for start codon

	   ADD R0, R0, #0		;tells what letter is in R0
	   LD R2, CHECKA		
	   ADD R2, R0, R2
	   Brz LETTERA
	   LD R2, CHECKU
	   ADD R2, R0, R2
	   BRz LETTERU
	   LD R2, CHECKC
	   ADD R2, R0, R2
	   BRz LETTERC
	   LD R2, CHECKG
	   ADD R2, R0, R2
	   BRz LETTERG

	


LETTERA
	AND R4, R4, #0
	ADD R4, R4, #1		;incrementing sequence counter to 1
	BRnzp loop

LETTERU
	ADD R5, R4, #-1
	BRz isinSeqU
	AND R4, R4, #0		;clearing sequence counter if U is not in sequence
	BRnzp loop

isinSeqU        ADD R4, R4, #1	;incrementing sequence counter
		BRnzp loop		


LETTERC	AND R4, R4, #0		;clearing sequence counter since C does not contribute to the sequence
	BRnzp loop

LETTERG	ADD R5, R4, #-2		
	BRz isinSeqG
	AND R4, R4, #0		;clearing sequence counter if G is not in sequence
	BRnzp loop

isinSeqG ADD R4, R4, #1
	 LD R0, BAR		;since G is in sequence, print bar to console
	 OUT
	 BRnzp loop


StopCodon  
	   ADD R0, R0, #0		;tells what letter is in R0
	   LD R2, CHECKA		
	   ADD R2, R0, R2
	   Brz CHARACTERA
	   LD R2, CHECKU
	   ADD R2, R0, R2
	   BRz CHARACTERU
	   LD R2, CHECKC
	   ADD R2, R0, R2
	   BRz CHARACTERC
	   LD R2, CHECKG
	   ADD R2, R0, R2
	   BRz CHARACTERG


CHARACTERU AND R4, R4, #0
	   ADD R4, R4, #4	;counter in R4 will now start with 4 instead of zero
	   BRnzp loop

CHARACTERA ADD R5, R4, #-4
	   BRzp isinSeqAFINAL
	   AND R4, R4, #0
	   ADD R4, R4, #3
	   BRnzp loop

isinSeqAFINAL   ADD R4, R4, #1		
	   	ADD R5, R4, #-6		;if A is in sequence, stop codon is detected. End program 
	   	BRz	ENDING
	   	BRnp loop

CHARACTERG 
	   ADD R5, R4, #-3
	   BRz loop
	   ADD R5, R4, #-4		;checking if G is second last in sequence
	   BRz Gis2ndInSeq
	   ADD R5, R4, #-5		;checking if G is last in sequence
	   BRz GisLastinSeq
	   AND R4, R4, #0		
           ADD R4, R4, #3		;reinitialising pointer to 3
	   BRnzp loop

Gis2ndInSeq	AND R3, R3, #0
		ADD R3, R3, #1		;incrementing G counter
		ST R3, GCount
		ADD R4, R4, #1
		BRnzp loop		;incrementing sequence counter

GisLastinSeq	ADD R4, R4, #1		;incrementing counter
		LD R3, GCount
		ADD R3, R3, #-1		;checking if sequence has 'GG'
	        BRz GnotinSeq
		ADD R5, R4, #-6		;checking if G is the last input
		Brz ENDING
		Brnzp loop

GnotinSeq	AND R4, R4, #0		;clearing sequence counter
		AND R3, R3, #0		;clearing G counter
		ADD R4, R4, #3
		Brnzp loop




CHARACTERC 	AND R4, R4, #0
		ADD R4, R4, #3		;clearing counter since C does not contribute to the sequence
		BRnzp loop
	        

 
ENDING HALT
		


GCount  .BLKW 1
CHECKA	.FILL #-65
CHECKU	.FILL #-85
CHECKC	.FILL #-67
CHECKG	.FILL #-71

DSR	.FILL xFE04
DDR	.FILL xFE06


STACK	.FILL x4000
KBIVE 	.FILL x0180
KBISR 	.FILL x2600
KBSR 	.FILL xFE00
KBIEN	.FILL x4000
Buffer	.FILL x4600
BAR	.FILL #124



		.END
