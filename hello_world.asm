;hello_world.asm
;---------------------------------------------------------------------
.STACK
;---------------------------------------------------------------------
.DATA
    MSG DB  "Hello World!$"
;---------------------------------------------------------------------
.CODE

;setup the DS register for the program
    MOV AX, @DATA
    MOV DS, AX
    
;print the message onto the console
    MOV AH, 09H
    MOV DX, OFFSET MSG
    INT 21H
    
;terminate the program
    MOV AH, 4CH
    INT 21H
    END