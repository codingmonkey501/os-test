; haribote-ipl
; TAB=4

		ORG		0x7c00			; where the program load from

; FAT12 system

		JMP		entry
		DB		0x90
		DB		"HARIBOTE"		; ブートセクタの名前を自由に書いてよい（8バイト）
		DW		512				; 1セクタの大きさ（512にしなければいけない）
		DB		1				; クラスタの大きさ（1セクタにしなければいけない）
		DW		1				; FATがどこから始まるか（普通は1セクタ目からにする）
		DB		2				; FATの個数（2にしなければいけない）
		DW		224				; ルートディレクトリ領域の大きさ（普通は224エントリにする）
		DW		2880			; このドライブの大きさ（2880セクタにしなければいけない）
		DB		0xf0			; メディアのタイプ（0xf0にしなければいけない）
		DW		9				; FAT領域の長さ（9セクタにしなければいけない）
		DW		18				; 1トラックにいくつのセクタがあるか（18にしなければいけない）
		DW		2				; ヘッドの数（2にしなければいけない）
		DD		0				; パーティションを使ってないのでここは必ず0
		DD		2880			; このドライブ大きさをもう一度書く
		DB		0,0,0x29		; よくわからないけどこの値にしておくといいらしい
		DD		0xffffffff		; たぶんボリュームシリアル番号
		DB		"HARIBOTEOS "	; ディスクの名前（11バイト）
		DB		"FAT12   "		; フォーマットの名前（8バイト）
		RESB	18				; とりあえず18バイトあけておく


entry:
		MOV		AX,0			; レジスタ初期化
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
