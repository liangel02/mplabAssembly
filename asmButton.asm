title "asmButton" 
;
; Explain the Operation of the Program 
;
; Hardware Notes:
;   details about which PIC is being used, I/O ports used, clock speed, etc.
;
; Angel Li
; December 8th, 2019 
; -------------------------------------------------------------------------
; Setup 
    LIST R=DEC					;the default numbering system is decimal 
    INCLUDE "p16f684.inc"			;include the "header file" for this pic which equates labels to specific addresses in memory
    INCLUDE "asmDelay.inc"
__CONFIG _FCMEN_OFF & _IESO_OFF & _BOD_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTOSCIO

; variables 
CBLOCK 0x20 
; put variable names here.
; CBLOCK will asign variables 
; to the first available GPRs (General Purpose Registers),
; which begin at 0x20 (decimal 32)and end at 0x7F(decimal 127)
 ENDC
; -----------------------------------------------------------------------------
 PAGE
; Mainline Code 

org	0	    ;"origin" directive which indicates to start program on first address of memory(0x00)
    movlw 7	    ;turn off Comparators 
    movwf CMCON0
    
    bsf STATUS, RP0	;all PORTS are Digital 
    clrf ANSEL ^ 0x080
    
    clrf TRISC ^ 0x80	    ;teach all of PORT C to be outputs 
  
    clrf TRISA ^ 0x080		;teach all of PORT A to be inputs
    bsf TRISA, RA5
    bcf STATUS, RP0 

loop:			    ;loop continuously, checking button input
    nop
    btfss PORTA, 5
	call flashFast
    btfsc PORTA, 5
	call flashSlow 
    goto loop 
; -----------------------------------------------------------------------------
PAGE
; Subroutines 

flashFast:		;flash LEDs quickly
    Dlay 20000
	movlw b'011100'
	movwf PORTC
	nop 
    Dlay 20000
	clrf PORTC
	nop
	return 
	
flashSlow:		;flash LEDs slowly 
    Dlay 2000000
	movlw b'011100'
	movwf PORTC
	nop
    Dlay 2000000
	clrf PORTC
	nop
	return 
end

