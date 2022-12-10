         YREGS                                                                  
PROGRAM  CSECT                                                                  
         STM   R14,R12,12(R13)         SPARA ANROPANDES REGISTER                
         LR    R12,R15                 SÄTT UPP EGET BAS-REGISTER               
         USING PROGRAM,R12                                                     
         ST    R13,SAVE+4              SPARA ANROPANDES SAVE ADRESS             
         LR    R14,R13                                                          
         LA    R13,SAVE                R13 ÄR DENNA MODULS SAVE-AREA            
         ST    R13,8(,R14)             SPARA I ANROPANDES SAVE-AREA      
         OPEN  (SYSOUT,(OUTPUT),SYSIN,(INPUT))       
         J     MAIN
* --------------------------------------------------------------------
END      EQU   *
         CLOSE (SYSOUT,,SYSIN)
         L     R13,SAVE+4              ANROPANDES SAVE AREA                     
         LM    R14,R12,12(R13)         ÅTERSTÄLL REGISTREN                      
         LA    R15,0                   LÄMNA RETURKOD 0 I REG 15                
         BR    R14                                                              
* --------------------------------------------------------------------  
*
* PART ONE
* x-y,a-b
*
* if x >= a and y <= b
* then x-y is inside a-b
*
* if a >= x and b <= y
* then a-b is inside x-y
*
* PART TWO
* x-y,a-b
* 1-2,2-3
* 2-8,3-7
* if y >= a and b >= x
*
* ------- MAIN START -------
MAIN     EQU   *
         ZAP   NUMINSIDE,=P'0'
*
LOOP     EQU   *   
         GET   SYSIN
*         MVC   WTOTEXT(15),0(R1)
*         BAL   R14,PRINT
         LH    R2,0(R1)
         AHI   R1,4
         AHI   R2,-4
         AR    R2,R1     R2 END OF STR
         LR    R6,R2     SAVE END OF STR IN R6
         LR    R5,R1     SAVE START OF STR IN R5
*        
         SR    R0,R0
         IC    R0,=C'-'
         BAL   R14,FIND
         LR    R4,R2     SAVE NEW START IN R4 TMP
         SR    R2,R1     LENGTH OF START TO FOUND
         AHI   R2,-1
         LA    R7,NUM1_START
         EX    R2,VARPACK
         LR    R1,R4     MOVE NEW START TO R1
         AHI   R1,1      ADD 1 TO SKIP DELIM
         LR    R2,R6     SET END TO END OF STR
*
         SR    R0,R0
         IC    R0,=C','
         BAL   R14,FIND
         LR    R4,R2     SAVE NEW START IN R4 TMP
         SR    R2,R1     LENGTH OF START TO FOUND
         AHI   R2,-1
         LA    R7,NUM1_END
         EX    R2,VARPACK
         LR    R1,R4     MOVE NEW START TO R1
         AHI   R1,1      ADD 1 TO SKIP DELIM
         LR    R2,R6     SET END TO END OF STR
*
         SR    R0,R0
         IC    R0,=C'-'
         BAL   R14,FIND
         LR    R4,R2     SAVE NEW START IN R4 TMP
         SR    R2,R1     LENGTH OF START TO FOUND
         AHI   R2,-1
         LA    R7,NUM2_START
         EX    R2,VARPACK
         LR    R1,R4     MOVE NEW START TO R1
         AHI   R1,1      ADD 1 TO SKIP DELIM
         LR    R2,R6     SET END TO END OF STR
*
         SR    R2,R1     LENGTH OF START TO FOUND
         AHI   R2,-1
*         LHI   R2,1
         LA    R7,NUM2_END
         EX    R2,VARPACK
*
* if y >= a and b >= x
         CP    NUM1_END,NUM2_START
         BL    CONT1
         CP    NUM2_END,NUM1_START
         BL    CONT1
*        NUM1 INSIDE NUM2
         AP    NUMINSIDE,=P'1'
         J     CONT1
*
CONT1    EQU   *
         UNPK  WTOTEXT(15),NUM1_START
         OI    WTOTEXT+14,X'F0'
         UNPK  WTOTEXT+16(15),NUM1_END
         OI    WTOTEXT+30,X'F0'
         UNPK  WTOTEXT+32(15),NUM2_START
         OI    WTOTEXT+46,X'F0'
         UNPK  WTOTEXT+48(15),NUM2_END
         OI    WTOTEXT+62,X'F0'
         UNPK  WTOTEXT+64(15),NUMINSIDE
         OI    WTOTEXT+78,X'F0'
*
         BAL   R14,PRINT
         J     LOOP



VARPACK  PACK  0(8,R7),0(0,R1)

FIND     EQU   *
SRST1    SRST  R2,R1
         BO    SRST1
         BH    NOTFIND
         BR    R14
         
NOTFIND  EQU   *
         STC   R0,WTOTEXT
         MVC   WTOTEXT+2(30),=C'NOT FOUND'
         BAL   R14,PRINT
         ABEND 101

EOFSYSIN EQU   *

         J     END
* ------- MAIN END -------

* --------------------------------------------------------------------  

* ------- SUB ROUTINES START -------
PRINT    EQU   *
         ST    R1,R1SAVE
         WTO   MF=(E,WTOBLOCK)
         PUT   SYSOUT,WTOTEXT
         MVI   WTOTEXT,C' '
         MVC   WTOTEXT+1(L'WTOTEXT-1),WTOTEXT
         L     R1,R1SAVE
         BR    R14
* ------- SUB ROUTINES END ------- 

* --------------------------------------------------------------------   
SYSIN    DCB   DDNAME=SYSIN,DSORG=PS,MACRF=GL,RECFM=VT,LRECL=80,       +
               EODAD=EOFSYSIN
SYSOUT   DCB   DDNAME=SYSOUT,DSORG=PS,MACRF=PM,RECFM=FT,LRECL=80                
*
         LTORG
*       
SAVE     DC    18F'0'                  MODULENS EGEN SAVE-AREA           
*
R1SAVE   DS    F
*
NUM1_START DS  PL8
NUM1_END   DS  PL8
NUM2_START DS  PL8
NUM2_END   DS  PL8
NUMINSIDE  DS  PL8
*
WTOBLOCK EQU   *
         DC    H'84'
         DC    H'0'
WTOTEXT  DC    CL80' '
*
         END                                                                    
