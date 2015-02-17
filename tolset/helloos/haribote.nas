; haribote-os
; TAB=4

;About BOOT_INFO
CYLS		EQU		0x0ff0			; set boot area
LEDS		EQU		0x0ff1
VMODE		EQU		0x0ff2			; color bits
SCRNX		EQU		0x0ff4			; screen x
SCRNY		EQU		0x0ff6			; screen y
VRAM		EQU		0x0ff8			; screen image buffer start addr

		ORG		0xc200			; 0x8000 + 0x4200 program start memory addr

; call BIOS to change display to black screen
		
		MOV 		AL,0x13
		MOV		AH,0x00
		INT		0x10 

		MOV		BYTE[VMODE],8
		MOV		WORD[SCRNX],320
		MOV		WORD[SCRNY],200
		MOV		DWORD[VRAM],0x000a0000

;BIOS get LED light status
		MOV		AH,0x02
		INT		0x16
		MOV		[LEDS],AL
fin:
		HLT
		JMP		fin
