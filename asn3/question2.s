	AREA question2, CODE, READWRITE
		ENTRY
		LDR r11, =STRING ;load pointer to the beginning
		LDR r12, =EoS ;load pointer to the end of string

GETC1	LDRB r1, [r11], #1 ;load character from the front of the string
		ORR r1, #&00000020
		CMP r1, #97
		BLT GETC1
		CMP r1, #122
		BGT GETC1
GETC2	LDRB r2, [r12, #-1]! ;load character from the rear of the string
		ORR r2, #&00000020
		CMP r2, #97
		BLT GETC2
		CMP r2, #122
		BGT GETC2
		CMP r1, r2
		BNE	NO
		CMP r11, r12
		BLT	GETC1
YES		MOV r0, #1
		B FIN
NO		MOV r0, #2
FIN		B FIN

	AREA question2, DATA, READWRITE
STRING 	DCB "He lived as a devl, eh?" ;string
EoS		DCB 0x00 ;end of string 

	END
