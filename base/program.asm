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

* ------- MAIN START -------
MAIN     EQU   *
LOOP     EQU   *   
         GET   SYSIN
         MVC   WTOTEXT(15),0(R1)
         BAL   R14,PRINT
         J     LOOP
EOFSYSIN EQU   *
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
SAVE     DC    18F'0'                  MODULENS EGEN SAVE-AREA           
*
WTOBLOCK EQU   *
         DC    H'84'
         DC    H'0'
WTOTEXT  DC    CL80' '
*
         END                                                                    