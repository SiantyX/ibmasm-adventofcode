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

*
* ------- MAIN START -------
MAIN     EQU   *
         XR    R6,R6
         LHI   R7,2
LOOP     EQU   *
         MVI   ITEMAREA,X'00'
         MVC   ITEMAREA+1(L'ITEMAREA-1),ITEMAREA
         GET   SYSIN
         LH    R2,0(R1)
         AHI   R2,-4
         AHI   R1,4
         LR    R10,R2            SAVE ORG VAL
         AR    R2,R1             END ADR
*        GET HALFWAY
         SRDA  R10,32
         DR    R10,R7
         LR    R8,R1
         AR    R8,R11         R8 HALFWAY POINT

LOOP1    EQU   *
         CR    R1,R8
         BNL   LOOP2                END OF STR
         LA    R3,ITEMAREA
         XR    R4,R4
         IC    R4,0(R1)
         AR    R3,R4
         STC   R4,0(R3)
         AHI   R1,1
         J     LOOP1

LOOP2    EQU   *
         CR    R1,R2
         BH    ERROR                END OF STR
         LA    R3,ITEMAREA
         XR    R4,R4
         IC    R4,0(R1)
         AR    R3,R4
         CLC   0(1,R3),=X'00'
         BNE   DUPLICATE            DUPLICATE
         AHI   R1,1
         J     LOOP2

DUPLICATE EQU  *
         TR    0(1,R3),CONVERT
         LB    R4,0(R3)
         AR    R6,R4
         CVD   R6,APL8
         UNPK  WTOTEXT(15),APL8
         OI    WTOTEXT+14,X'F0'
         BAL   R14,PRINT
         J     LOOP

ERROR    EQU   *
         MVC   WTOTEXT(13),=C'NO DUPLICATE?'
         BAL   R14,PRINT
         ABEND 101

EOFSYSIN EQU   *
         CVD   R6,APL8
         UNPK  WTOTEXT(15),APL8
         OI    WTOTEXT+14,X'F0'
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
ITEMAREA DS    XL256
CONVERT  DC    256XL'00'
         ORG   CONVERT+C'a'
         DC    X'010203040506070809'
         ORG   CONVERT+C'j'
         DC    X'0A0B0C0D0E0F101112'
         ORG   CONVERT+C's'
         DC    X'131415161718191A'
         ORG   CONVERT+C'A'
         DC    X'1B1C1D1E1F20212223'
         ORG   CONVERT+C'J'
         DC    X'2425262728292A2B2C'
         ORG   CONVERT+C'S'
         DC    X'2D2E2F3031323334'
         ORG
*
         END                                                                    