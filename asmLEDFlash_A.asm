title "asmLEDFlash_A" 
;
; Write to PORTC (RC0) with a delay which makes one LED flash 
; Use bsf, bcf instructions 
;
; Hardware Notes:
;   -p16F684 running at 4MHz
;   -Output:
;	- RC0: one LED through a 680 resistor
;
; Angel Li
; November 28th, 2019 
; -------------------------------------------------------------------------
; Setup 
    LIST R=DEC					;the default numbering system is decimal 
    INCLUDE "p16f684.inc"			;include the "header file" for this pic which equates labels to specific addresses in memory
    INCLUDE "asmDelay.inc"			;new header file for the delay 
__CONFIG _FCMEN_OFF & _IESO_OFF & _BOD_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTOSCIO

; variables
CBLOCK 0x20 
; put variable names here.
; CBLOCK will asign variables to the first available GPRs (General Purpose Registers), which begin at 0x20 (decimal 32)and end at 0x7F(decimal 127)
 ENDC
; -----------------------------------------------------------------------------
 PAGE
; Mainline Code 

org	0	    ;"origin" directive which indicates to start program on first address of memory(0x00)
    movlw 7	    ;turn off COmparators 
    movwf CMCON0
    
    bsf STATUS, RP0	;all PORTS are Digital 
    clrf ANSEL ^ 0x080
    
    clrf TRISC ^ 0x80	    ;teach all of PORT C to be outputs 
    bcf STATUS, RP0 
again			    ;loop continously turning LED ON and OFF
    nop
    bsf PORTC, 0	    ;turn ON LED (set the bit to 1, turn it on)
	Dlay 2000000
    nop
    bcf PORTC, 0	    ;turn OFF LED (set the bit to 0, turn it off)
	Dlay 2000000
    goto again 
end    


