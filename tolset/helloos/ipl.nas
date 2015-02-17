; haribote-ipl
; TAB=4

		ORG		0x7c00			; where the program load from

; FAT12 system

		JMP		entry
		DB		0x90
		DB		"HARIBOTE"		; �u�[�g�Z�N�^�̖��O�����R�ɏ����Ă悢�i8�o�C�g�j
		DW		512				; 1�Z�N�^�̑傫���i512�ɂ��Ȃ���΂����Ȃ��j
		DB		1				; �N���X�^�̑傫���i1�Z�N�^�ɂ��Ȃ���΂����Ȃ��j
		DW		1				; FAT���ǂ�����n�܂邩�i���ʂ�1�Z�N�^�ڂ���ɂ���j
		DB		2				; FAT�̌��i2�ɂ��Ȃ���΂����Ȃ��j
		DW		224				; ���[�g�f�B���N�g���̈�̑傫���i���ʂ�224�G���g���ɂ���j
		DW		2880			; ���̃h���C�u�̑傫���i2880�Z�N�^�ɂ��Ȃ���΂����Ȃ��j
		DB		0xf0			; ���f�B�A�̃^�C�v�i0xf0�ɂ��Ȃ���΂����Ȃ��j
		DW		9				; FAT�̈�̒����i9�Z�N�^�ɂ��Ȃ���΂����Ȃ��j
		DW		18				; 1�g���b�N�ɂ����̃Z�N�^�����邩�i18�ɂ��Ȃ���΂����Ȃ��j
		DW		2				; �w�b�h�̐��i2�ɂ��Ȃ���΂����Ȃ��j
		DD		0				; �p�[�e�B�V�������g���ĂȂ��̂ł����͕K��0
		DD		2880			; ���̃h���C�u�傫����������x����
		DB		0,0,0x29		; �悭�킩��Ȃ����ǂ��̒l�ɂ��Ă����Ƃ����炵��
		DD		0xffffffff		; ���Ԃ�{�����[���V���A���ԍ�
		DB		"HARIBOTEOS "	; �f�B�X�N�̖��O�i11�o�C�g�j
		DB		"FAT12   "		; �t�H�[�}�b�g�̖��O�i8�o�C�g�j
		RESB	18				; �Ƃ肠����18�o�C�g�����Ă���


entry:
		MOV		AX,0			; ���W�X�^������
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

;read frist 516 B from drive A 

		MOV		AX,0x0820
		MOV		ES,AX			; ES:BX buffer address starts from this segment
		MOV		CH,0			; cylinder 0
		MOV		DH,0			; head 0
		MOV		CL,2			; sector 2

		MOV		SI,0			; retry start from 0

retry:
		MOV		AH,0x02			; AH=0x02 : read 
		MOV		AL,1			; how many sectors to read
		MOV		BX,0			; buffer addr start from 0x0820*16 + BX
		MOV		DL,0x00			; driver A
		INT		0x13			; call BIOS 13th method to read
		JNC		fin			; jump if not carry

		ADD		SI,1
		CMP		SI,5			; read at most 5 times
		JAE		error			; display error message

		MOV		AH,0x00			; reset disk status
		MOV		DL,0x00
		INT		0x13
		JMP		retry

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
