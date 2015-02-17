; haribote-ipl
; TAB=4

		CYLS	EQU	10			; define CYLS = 10

		ORG		0x7c00			; where the program load from

; FAT12 system

		JMP		entry
		DB		0x90
		DB		"HARIBOTE"
		DW		512    
		DB		1
		DW		1    
		DB		2
		DW		224    
		DW    2880    
		DB    0xf0    
		DW    9
		DW    18        
		DW    2        
		DD    0    
		DD    2880    
		DB    0,0,0x29    
		DD    0xffffffff    
		DB    "OS ver 0.01"    
		DB    "FAT12 "    
		RESB    18 


entry:
		MOV		AX,0
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

;read frist 516 B from drive A 

		MOV		AX,0x0820
		MOV		ES,AX			; ES:BX buffer address starts from this segment
		MOV		CH,0			; cylinder 0
		MOV		DH,0			; head 0
		MOV		CL,2			; sector 2
readloop:
		MOV		SI,0			; retry start from 0

retry:
		MOV		AH,0x02			; AH=0x02 : read 
		MOV		AL,1			; how many sectors to read
		MOV		BX,0			; buffer addr start from 0x0820*16 + BX
		MOV		DL,0x00			; driver A
		INT		0x13			; call BIOS 13th method to read
		JNC		next			; read next sector

		ADD		SI,1
		CMP		SI,5			; read at most 5 times
		JAE		error			; display error message

		MOV		AH,0x00			; reset disk status
		MOV		DL,0x00
		INT		0x13
		JMP		retry

next:							; read 17 sectors
		MOV		AX,ES			
		ADD		AX,0x0020		; 512 / 16
		MOV		ES,AX
		ADD		CL,1
		CMP		CL,18
		JBE		readloop		; jump below or equal

		MOV		CL,1
		ADD		DH,1
		CMP		DH,2
		JB		readloop
		MOV		DH,0
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop

; write CYLS into [0x0ff0] and jump to execute
		MOV		[0x0ff0],CH
		JMP		0xc200

fin:
		HLT
		JMP		fin

error:
		MOV		SI,msg
putloop:
		MOV		AL,[SI]			; character code
		ADD		SI,1
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			; function number = 0Eh : Display Character
		MOV		BX,15			; color code
		INT		0x10			; call INT 10h, BIOS video service
		JMP		putloop
msg:
		DB		0x0a, 0x0a
		DB		"load error"
		DB		0x0a
		DB		0

		RESB	0x7dfe-$		; fill with 0x00 until 0x7dfe

		DB		0x55, 0xaa
