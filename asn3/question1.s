	AREA question1, CODE, READWRITE
		ENTRY
		LDR r10, =UPC ;load UPC location 
		MOV r1, #0 ;initalize odd sum
		MOV r2, #0 ;initialize even sum
		MOV r9, #6 ;initializing loop counter

LOOP	LDRB r3, [r10], #1 ;load the character from the UPC string
		SUB	r3, r3, #'0' ;convert character from ASCII to integer value
		ADD r1, r3 ;add value to the cumulative sum of odd numbers
		LDRB r3, [r10], #1 ;load next character from the UPC string
		SUB r3, r3, #'0' ;convert character from ASCII to integer value
		ADD r2, r3 ;add value to the cumulative sum of even numbers
		SUB r9, r9, #1 ;decrementing loop counter
		CMP r9, #1 ;check loop condition
		BGE LOOP
		
		ADD r1, r1, r1, LSL #1 ; 3*r1 = r1+r1<<2
		ADD r4, r1, r2 ;total = oddsum+evensum

VER		SUBS r4, r4, #10 ;subtract 10 from total sum
		BLT INVALID
		BEQ VALID
		B VER

VALID	MOV r0, #1
		B FIN
INVALID	MOV r0, #2

FIN		B FIN

	AREA question1, DATA, READWRITE
UPC		DCB	"013800150738"				;UPC string

	END
