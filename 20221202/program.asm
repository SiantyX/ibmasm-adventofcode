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
* A = Rock = 1
* B = Paper = 2
* C = Scissors = 3
*
* X = Lose
* Y = Draw
* Z = Win
*
* Win = 6
* Draw = 3
* Loss = 0
*
* Number 0 and 2 same = Draw
* 1 > 3
* 3 > 2
* 2 > 1
*
* 1 - 2 = -1 win Rock(them) vs Paper(us)
* 1 - 3 = -2 loss Rock(them) vs Scissors(us)
*
* 2 - 3 = -1 win Paper(them) vs Scissors(us)
* 2 - 1 = 1 loss Paper(them) vs Rock(us)
*
* 3 - 2 = 1 loss Scissors(them) vs Paper(us)
* 3 - 1 = 2 win Scissors(them) vs Rock(us)
*
* Score -1 and 2 is win for us
*
* ------- MAIN START -------
MAIN     EQU   *
         USING RPS,R1
         LHI   R5,0
         ZAP   APL8,=P'0'
LOOP     EQU   *   
         LHI   R2,0
         LHI   R3,0
         
         CVD   R5,APL8
         UNPK  WTOTEXT(15),APL8
         OI    WTOTEXT+14,X'F0'
         BAL   R14,PRINT

         GET   SYSIN

         IC    R2,THEM
         S     R2,=X'000000C0'

         IC    R3,US
         S     R3,=X'000000E6'
         
         LR    R4,R3  Save original r3 (winloss stat)
         LR    R3,R2  Get same
         CHI   R4,2   DRAW
         BH    NEEDWIN
         BL    NEEDLOSS
*        ELSE DRAW
         J     CALC
NEEDWIN  EQU   *
*        R3 = R2 + 1, IF R3 > 3; R3 = 1
         AHI   R3,1
         CHI   R3,3
         BNH   CALC
         LHI   R3,1
         J     CALC
NEEDLOSS EQU   *
*        R3 = R2 - 1, IF R3 < 1; R3 = 3
         AHI   R3,-1
         CHI   R3,1
         BNL   CALC
         LHI   R3,3
             
CALC     EQU   *
         AR    R5,R3
         SR    R2,R3
         C     R2,=F'-1'
         BE    WIN
         C     R2,=F'2'
         BE    WIN
         C     R2,=F'0'
         BE    DRAW
         MVC   WTOTEXT(4),=C'LOSS'
         BAL   R14,PRINT
         J     LOOP
WIN      EQU   *
         AHI   R5,6
         MVC   WTOTEXT(4),=C'WIN '
         BAL   R14,PRINT
         J     LOOP
DRAW     EQU   *
         AHI   R5,3
         MVC   WTOTEXT(4),=C'DRAW'
         BAL   R14,PRINT
         J     LOOP

EOFSYSIN EQU   *
         CVD   R5,APL8
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
SYSIN    DCB   DDNAME=SYSIN,DSORG=PS,MACRF=GL,RECFM=FT,LRECL=3,        +
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
APL8     DC    PL8'0'
*
RPS      DSECT
THEM     DS    CL1
         DS    CL1
US       DS    CL1
*
         END                                                                    