;naskfunc
[FORMAT "WCOFF"]        ; ����Ŀ���ļ���ģʽ
[BITS 32]            ; ����32λģʽ�õĻ�е����

; ����Ŀ���ļ�����Ϣ

[FILE "naskfunc.nas"]        ; Դ�ļ�����Ϣ
    GLOBAL    _io_hlt        ; �����а����ĺ�����

; ʵ�ʵĺ���
[SECTION .text]    ;
_io_hlt:    
    HLT
    RET
