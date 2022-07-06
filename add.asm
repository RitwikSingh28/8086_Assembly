;add.asm
;-----------------------------------------------
.STACK
;-----------------------------------------------
.DATA
    X   DB  24H
    Y   DB  22H
;-----------------------------------------------
.CODE
    
;set up program data segment register
    MOV AX, @DATA
    MOV DS, AX
    
;move the variables to registers AL and BL
    MOV AL, X
    MOV BL, Y
    
;perform the addition and store in BL
    ADD BL, AL
    
;in case if carry is generated, add with carry AH
    ADC BH, BH
    
;print out the sum in binary format from BX on screen
    MOV CX, 10H ;loop iteration count 16
    
prn: MOV AH, 02H    ;DOS "print DL" function code
     MOV DL, 30H    ;Print character '0' 
     TEST BX, 8000H ;Check if the MSB=1
     JZ zro;        ;Check zero flag, if zero = 1, jump to zro
     MOV DL, 31H    ;Print character '1'
 
zro: INT 21H
     SHL BX, 0001H  ;Shift left logical by 1 bit
     LOOP prn
     
;------------------------------------------------
    MOV AH, 4CH     ;DOS "terminate program" code
    INT 21H
    END 