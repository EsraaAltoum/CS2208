		AREA POWER, CODE, READWRITE
		ENTRY
X 		EQU	12							;Parameter X
N		EQU	7							;Parameter N

;-----------------------------------:: MAIN PROGRAM ::---------------------------------------------

main	MOV	r1, #X						;store the value of X in a register
		MOV	r2, #N						;store the value of N in a register
		ADR	sp, TOS						;initialize the stack pointer
		STMFA sp!, {r0-r2}				;push current register values onto the stack
		
		BL power						;branch to subroutine: power
		SUB sp, #4						;correct sp after subroutine call
		LDR r2, [sp, #8]				;get the return value from the stack		

		LDR r3, =result					;load the address for the variable 'result'
		STR r2, [r3]					;store the return value in result

		LDMFA sp!, {r0-r2}				;restore original register values before subroutine
EOP		B	EOP							;end of program

;-----------------------------------:: SUBROUTINE POWER ::---------------------------------------------

power	
		ADD sp, #4						;make room for local variable y
		STMFA	sp!, {r0-r2, fp, lr}	;reserve 4 empty bytes for the return value (r0)
										;and push the parameters (r1-r2), fp, and lr onto the stack.
		MOV	fp, sp						;adjust the fp to point to this activation record 
		
		LDR	r2, [fp, #-8]				;load parameter N from the stack			
		CMP	r2, #0						;N == 0 ?
		MOVEQ r1, #1					;if(N == 0) return 1
		BEQ	Return						;Branch to Return
			
		LDR	r1, [fp, #-12]				;else, load X from stack
		TST	r2, #1						;N % 2 == 0 ?
		BNE	odd							;if true, branch to odd

		B	even						;else, branch to even
			
			
odd		SUB	r2, r2, #1					;n--
		BL	power						;call power(x, n - 1) recursively
		MUL	r1, r0, r1					;x * return of power(x, n - 1)
		B	Return						;return the value above
			
						
even	ASR	r2, #1						; n >> 1
		BL	power						;call power(x, n>> 1) recursively
		LDR	r0, [fp, #8]				;r0 = return of power(x, n >> 1)
		STR r0, [fp, #-20]				;local variable y = return value
		MUL	r1, r0, r0					;compute y * y
		

Return	STR	r1, [fp, #-16]				;push return value in correct location on the stack
		MOV	sp, fp						;collapse activation record 
		LDMFA	sp!, {r0-r2, fp, pc}	;restore program flow to the previous record.


;------------------------------------------------------------------------------------------------------------


		AREA POWER, DATA, READONLY

result	DCD	0x00					;the final result
TOS		DCD	0x00 					;Full Ascent TOS
		SPACE 0xFF					;clear out some memory for the stack
	
		END
