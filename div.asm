;div.asm                   
;Ritwik Ramesh Kumar Singh | Roll No: 2106037
;Program in ISA x86 to perform division of two 8-bit numbers using non-restoring division algorithm
;------------------------------------------------------------------------------------------------------    
.STACK
;------------------------------------------------------------------------------------------------------
.DATA
    DIVN    DB  -7
    DIVS    DB  -1
;------------------------------------------------------------------------------------------------------
.CODE

;Initializing the DS register for the program to be able to reference the data
    MOV AX, @DATA
    MOV DS, AX
    MOV AX, 0       ;Resets the Accumulator register to 0
       
;Moving the variables into the registers for faster access
    MOV DL, DIVS    ;Move the divisor into the DL register
    MOV AL, DIVN    ;Move the dividend into the AL register
    
;The main non-restoring division algorithm
;Loop to be performed 8 times
    MOV CX, 08H     ;Initialize loop counter to 8
    
booth:  TEST AH, 80H    ;check the sign of the MSB of AH
        JZ msb0
        ;logic for negative A
        SHL AX, 0001H   ;shift left logical AX by 1 bit
        ADD AH, DL
        JMP nxt
 
msb0:   SHL AX, 0001H   ;Shift left logical AX by 1 bit
        SUB AH, DL      ;Perform subtraction and store the difference in AH register
        JMP nxt
        
nxt:    TEST AH, 80H    ;check again for the sign bit of A
        JZ setLSB1
        AND AL, 254     ;set the LSB of dividend to 0, by ANDING 11111110 with the contents of 
        JMP jmpl
 
setLSB1: OR AL, 01H     ;set the LSB of dividend to 1, by ORing 0000 0001 with the contents of BL       
jmpl:    LOOP booth
         
;Final computation in the result depending upon the sign-bit of the AH register
;Determining the sign-bit of the AH register
    TEST AH, 80H
    JZ output
    ;In case of negative A, add the contents of the registers AH and DL
    ADD AH, DL
                        
;------------------------------------------------------------------------------------------------------
output: MOV BX, AX      ;Copy the entire result into the BX register, as AX is to be used for DOS calls
        
;Displaying output as 16-bit binary format, AH signifying the remainder and AL signifying the quotient
;Loop to be performed 16 times, so initializing the loop counter CX to 10H = 16
        MOV CX, 10H
 

prn:    MOV AH, 02H     ;DOS "print character" function code to print DL
        MOV DL, 30H     ;Print character 0
        TEST BX, 8000H  ;Check if the MSB is 1 or not
        JZ zro          ;if MSB = 0, jump to label zero
        MOV DL, 31H     ;print character 1
zro:    INT 21H         ;DOS Interrupt to print
        SHL BX, 0001H   ;Shift left logical BX by 1 bit
        LOOP prn
        
;------------------------------------------------------------------------------------------------------
;Terminate the program
    MOV AH, 4CH         ;DOS "terminate program" function code
    INT 21H
    END