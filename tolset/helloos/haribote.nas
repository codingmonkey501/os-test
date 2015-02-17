; haribote-os
; TAB=4

		ORG		0xc200			; 0x8000 + 0x4200

; call BIOS to change display to black screen
		
		MOV 		AL,0x13
		MOV		AH,0x00
		INT		0x10 
fin:
		HLT
		JMP		fin
