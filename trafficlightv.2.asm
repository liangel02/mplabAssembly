title "trafficlight.asm" 
;
; Explain the Operation of the Program 
;
; Hardware Notes:
;   details about which PIC is being used, I/O ports used, clock speed, etc.
;
; Angel Li
; December 9th, 2019 
; -------------------------------------------------------------------------
; Setup 
    LIST R=DEC					;the default numbering system is
						;decimal 
    INCLUDE "p16f684.inc"			;include the "header file" for 
						;this pic which equates labels 
						;to specific addresses in memory
    INCLUDE "asmDelay.inc"
__CONFIG _FCMEN_OFF & _IESO_OFF & _BOD_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & 
_PWRTE_ON & _WDT_OFF & _INTOSCIO

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

org	0	    ;"origin" directive which indicates to start program on 
		    ;first address of memory(0x00)
    movlw 7	    ;turn off Comparators 
    movwf CMCON0
    
    bsf STATUS, RP0	;bank 1
    clrf ANSEL ^ 0x080	;all PORTS are Digital 
    
    clrf TRISC		;teaching PORTC to be output (make all bits 0)
    
    clrf TRISA	    	;teaching PORTA to be output
    
    bcf STATUS, RP0	;bank 0
loop:
    nop
    call seq1
    call seq2
    call seq3
    call seq4
    call seq5
    call seq6
    call seq7
    call seq8
    goto loop
; -----------------------------------------------------------------------------
PAGE
; Subroutines 
seq1:
    movlw b'00100000'	    ;RC5 is on
    movwf PORTC
    Dlay 1000000	    ;delay for 1 second
    nop
    movlw b'00000100'	    ;RA2 is on
    movwf PORTA
    Dlay 5000000
    nop
    return 
seq2:
    clrf PORTA
    movlw b'00100100'	    ;RC2, RC5 is on 
    movwf PORTC
    Dlay 20000000		    ;delay for 20 seconds
    nop
    return
seq3: 
    movlw b'00100010'	    ;RC5, RC2 is on (red and yellow are on)
    movwf PORTC
    Dlay 15000000		    ;delay for 15 seconds
    nop
    return
seq4:
    movlw b'00100001'	    ;RC0, RC5 is on (red is on)
    movwf PORTC
    Dlay 1000000			    ;delay for 1 second
    nop
    return
seq5:
    movlw b'00000001'	    ;RC0 is on
    movwf PORTC
    Dlay 1000000	    ;delay for 1 second
    nop
    movlw b'00010000'	    ;RA4 is on 
    movwf PORTA
    Dlay 5000000	    ;delay for 5 seconds
    clrf PORTA
    nop
    return
seq6:
    movlw b'00001001'	    ;RC0, RC3 is on 
    movwf PORTC
    Dlay 20000000		    ;delay for 20 seconds
    nop
    return
seq7:
    movlw b'00010001'	    ;RC0, RC4 is on 
    movwf PORTC
    Dlay 15000000		    ;delay for 15 seconds 
    nop
    return
seq8: 
    movlw b'00100001'	    ;RC0, RC5 is on 
    movwf PORTC
    Dlay 2000000		    ;delay for 2 seconds 
    nop
    return 
end 