	AREA question1, CODE, READWRITE
			AREA question1, CODE, READWRITE
			ENTRY
			
			ADR r0, STRING1         ;load the address of string1 into r0
			ADR	r1, STRING2         ;load the address of string2 into r1
			MOV r3, #0              ;initializes the index counter in r3 (index = 0)
		
start		LDRB r2,[r0, r3]        ;load a character from string1 into r2 
			CMP r2, #0				;check if the character loaded is the EoS				
			BEQ terminate			;if so, end the program
			
			ADD r4, r3, #0			;make a copy index to look ahead (for skipping 'the')
			CMPNE r2, #' '          ;checks if character is equal to character ' '
			BLEQ ld_nxt				;if it is a ' ', use subroutine to skip to next char

			CMPNE r3, #0			;if the character is not a space, check if it is the first character of the string
			CMPEQ r2, #'t'			;if it is the first character of the string or if the previous was a space, check if this character is a 't'
			BLEQ ld_nxt				;if it is a 't', use subroutine to skip to next char 
			LDRBNE r2, [r0, r3]		;if it isnt restore charater at the index before the character skips

			CMPEQ r2, #'h'			;if the previous was a 't' check if this is an 'h'
			BLEQ ld_nxt				;if it is an 'h', use subroutine to skip to next char 
			LDRBNE r2, [r0, r3]		;if it isnt restore charater at the index before the character skips

			CMPEQ r2, #'e'			;if the previous was a 'h' check if this is an 'e'
			BLEQ ld_nxt				;if it is an 'e', use subroutine to skip to next char 
			LDRBNE r2, [r0, r3]		;if it isnt restore charater at the index before the character skips

			CMPEQ r2, #' '			;if the previous was a 'e' check if this is an ' '
			CMPNE r2, #0			;if it isnt a ' ', check if it is the null terminator
			ADDEQ r3, r4, #0		;if it was either a ' ' or the null terminator update the index to the same value as the lookahead copy index
			BEQ	start				;then restart the loop
			LDRBNE r2, [r0, r3]		;else, restore charater at the index before the character skips

			STRB r2,[r1], #1    	;store the character into STRING2, increment the pointer to the next free space
			ADDNE r3, r3, #1 		;index++
			B start

terminate	B terminate				;end of program


ld_nxt		ADD r4, r4, #1			;increment the copy index	
			LDRB r2, [r0, r4]       ;load the character at that index			
			BX lr 					;return from subroutine					



			AREA question1, DATA, READONLY
	
STRING1 		DCB 	"the and the the man said they must go the the" 			;String1
EoS 			DCB 	0x00						;end of string1
STRING2 		SPACE 	0xFF						;just allocating 255 bytes
	
			END
		END
