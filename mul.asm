;mul.asm
;Author: Ritwik Ramesh Kumar Singh | 2106037
;Program in ISA to multiply two 8-bit signed numbers and show result in binary
;-------------------------------------------------------------------------------------
.STACK
;-------------------------------------------------------------------------------------    
.DATA
    MPND    DB  15
    MPLR    DB  11                            
    Q1      DB  00H
;-------------------------------------------------------------------------------------
.CODE

;Initialize the DS register with Data Segment Address
    MOV AX, @DATA
    MOV DS, AX
    MOV AX, 0       ;Reset the Accumulator to 0
    
;move the variables into the registers
    MOV DL, MPND
    MOV AL, MPLR

;-------------------------------------------------------------------------------------    
;main process of booth multiplication 
    MOV CX, 8       ;initialize loop counter to 8
 booth: TEST AL, 01H    ;check if the LSB is 1
        JZ lsb0         ;if LSB = 0, jump to lsb0 
        CMP Q1, 1       ;compare whether Q-1 is equal to 1  
        JZ sft
        ;else perform addition  
        MOV Q1, 01h
        SUB AH, DL      ;subtract and store difference in AH register        
        JMP sft
        
 lsb0:  CMP Q1, 0       ;compare whether Q-1 is zero
        JZ sft     
        MOV Q1, 0
        ;perform subtraction 
        ADD AH, DL      ;add and store the result in AH register   
 
 ;perform right arithmetic shift on AX register by 1 bit
 sft:   SAR AX, 0001H 
        LOOP booth      ;continue on with the loop until the CX touches zero
                                                                                        
 ;------------------------------------------------------------------------------------- 
 ;print the result stored in AX register onto screen in 16-bits
    MOV BX, AX          ;transfer the contents of AX into BX, as AH will be used for DOS calls
    MOV CX, 10H         ;initialize loop print counter to 16 to print 16 bits   
    
 prn:   MOV AH, 02H     ;DOS "print character" function code to print value in DL
        MOV DL, 30H     ;print '0' character 
        TEST BX, 8000H  ;checking if the MSB of BX is 1 or 0
        JZ zro          ;if MSB = 0, jump to 0
        MOV DL, 31H     ;print '1' character
        
 zro:   INT 21H         ;DOS "interrupt program" to transfer control
        SHL BX, 0001H   ;Shift left logical BX by 1 bit
        LOOP prn
        
 ;-------------------------------------------------------------------------------------
 ;terminate the program
    MOV AH, 4CH         ;DOS "terminate program" function code
    INT 21H
    END