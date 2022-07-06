;sub.asm

;Program in x86 ISA to find difference of two signed integers
;-----------------------------------------------------------------------
.STACK
;-----------------------------------------------------------------------
.DATA
    X DB    21H
    Y DB    10H
;----------------------------------------------------------------------
.CODE
   
;initialize DS with @DATA
    MOV AX, @DATA
    MOV DS, AX
    MOV AX, 0       ;Reset AX to 0

;transfer variables to registers AL, BL
    MOV AL, X
    MOV BL, Y
    
;perform subtraction and store difference in BX register
    SUB BL, AL
    SBB BH, BH      ;perform subtraction with borrow in case of borrow being generated   
    TEST BX, 8000H   ;finding out if positive or negative result
    JZ dsp
    NEG BX          ;perform 2s complements of the result
;display result as 16 bit binary pattern from BX register
dsp:    MOV CX, 10H     ;initialize loop counter to 16
    
prn:    MOV AH, 02H ;DOS function code to print one character from DL
        MOV DL, 30H ;print '0' character; ASCII: 48
        TEST BX, 8000H  ;ANDing 1 and the MSB 
        JZ zro
        MOV DL, 31H
zro:    INT 21H
        SHL BX, 0001H   ;Shift left logical BX register by 1 bit   
        LOOP prn
        
;----------------------------------------------------------------------------
;terminate the program 
    MOV AH, 4CH     ;DOS "terminate program" code
    INT 21H
    END