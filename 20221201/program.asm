         YREGS                                                                  
PROGRAM  CSECT                                                                  
         STM   R14,R12,12(R13)                       
         LR    R12,R15                              
         USING PROGRAM,R12                                                     
         ST    R13,SAVE+4                          
         LR    R14,R13                                                          
         LA    R13,SAVE                           
         ST    R13,8(,R14)                  
         OPEN  (SYSOUT,(OUTPUT),SYSIN,(INPUT))       
         J     MAIN
* --------------------------------------------------------------------
END      EQU   *
         CLOSE (SYSOUT,,SYSIN)
         L     R13,SAVE+4                                  
         LM    R14,R12,12(R13)                             
         LA    R15,0                                  
         BR    R14                                                              
* --------------------------------------------------------------------  

* ------- MAIN START -------
MAIN     EQU   *
         ZAP   TMPSUM,=P'0'
         ZAP   MAXSUM1,=P'0'
         ZAP   MAXSUM2,=P'0'
         ZAP   MAXSUM3,=P'0'

LOOP     EQU   *   
         GET   SYSIN
         LH    R2,0(R1)
         AHI   R1,4
         S     R2,=F'5'

         CLI   0(R1),C' '
         BE    NEWSUM        

         EX    R2,EXECPACK
         AP    TMPSUM,APL8
         J     LOOP

NEWSUM   EQU   *
         CP    TMPSUM,MAXSUM1
         BNH   NEWSUM1
         ZAP   MAXSUM3,MAXSUM2
         ZAP   MAXSUM2,MAXSUM1
         ZAP   MAXSUM1,TMPSUM
         J     NEWSUM3
NEWSUM1  EQU   *
         CP    TMPSUM,MAXSUM2
         BNH   NEWSUM2
         ZAP   MAXSUM3,MAXSUM2
         ZAP   MAXSUM2,TMPSUM
         J     NEWSUM3
NEWSUM2  EQU   *
         CP    TMPSUM,MAXSUM3
         BNH   NEWSUM3
         ZAP   MAXSUM3,TMPSUM
NEWSUM3  EQU   *
         ZAP   TMPSUM,=P'0'
         J     LOOP

EOFSYSIN EQU   *
         UNPK  WTOTEXT(15),MAXSUM1
         OI    WTOTEXT+14,X'F0'
         MVI   WTOTEXT+15,C';'
         UNPK  WTOTEXT+16(15),MAXSUM2
         OI    WTOTEXT+30,X'F0'
         MVI   WTOTEXT+31,C';'
         UNPK  WTOTEXT+32(15),MAXSUM3
         OI    WTOTEXT+46,X'F0'
         ZAP   TMPSUM,MAXSUM1
         AP    TMPSUM,MAXSUM2
         AP    TMPSUM,MAXSUM3
         MVI   WTOTEXT+47,C';'
         UNPK  WTOTEXT+48(15),TMPSUM
         OI    WTOTEXT+62,X'F0'
         BAL   R14,PRINT
         J     END
* ------- MAIN END -------

* --------------------------------------------------------------------  

* ------- SUB ROUTINES START -------
PRINT    EQU   *
         WTO   MF=(E,WTOBLOCK)
         PUT   SYSOUT,WTOTEXT
         MVI   WTOTEXT,C' '
         MVC   WTOTEXT+1(L'WTOTEXT-1),WTOTEXT
         BR    R14
* ------- SUB ROUTINES END ------- 

* --------------------------------------------------------------------   
SYSIN    DCB   DDNAME=SYSIN,DSORG=PS,MACRF=GL,RECFM=VT,LRECL=80,       +
               EODAD=EOFSYSIN
SYSOUT   DCB   DDNAME=SYSOUT,DSORG=PS,MACRF=PM,RECFM=FT,LRECL=80                
*
         LTORG
*       
SAVE     DC    18F'0'                          
*
WTOBLOCK EQU   *
         DC    H'84'
         DC    H'0'
WTOTEXT  DC    CL80' '
*
APL8     DS    PL8
TMPSUM   DS    PL8
MAXSUM1  DS    PL8
MAXSUM2  DS    PL8
MAXSUM3  DS    PL8
EXECPACK PACK  APL8,0(0,R1)
*
         END                                                                    