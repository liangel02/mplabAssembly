title "hbridge.asm" 
;
; Explain the Operation of the Program 
;
; Hardware Notes:
;   details about which PIC is being used, I/O ports used, clock speed, etc.
;
; Angel Li
; December 27th, 2019 
; -------------------------------------------------------------------------
; Setup 
    LIST R=DEC					;the default numbering system is
						;decimal 
    INCLUDE "p16f684.inc"			;include the "header file" for 
						;this pic which equates labels 
						;to specific addresses in memory
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

org	0	    ;"origin" directive which indicates to start program on 
		    ;first address of memory(0x00)
    movlw 7	    ;turn off Comparators 
    movwf CMCON0
    
    bsf STATUS, RP0	;bank 1
    clrf ANSEL ^ 0x080	;all PORTS are Digital 
    
    clrf TRISC		;teaching PORTC to be output (make all bits 0)
    
    bcf STATUS, RP0	;bank 0
loop:
    nop
    call seq1
    call seq2
    call seq3
    goto loop
; -----------------------------------------------------------------------------
PAGE
; Subroutines 
seq1:
    movlw b'00000010'	    ;move forward 
    movwf PORTC
    Dlay 5000000	    ;delay 5 seconds
    nop
    return
seq2:
    movlw b'00000000'	    ;stop
    movwf PORTC
    Dlay 5000000	    ;delay 5 seconds 
    nop 
    return
seq3: 
    movlw b'00000001'	    ;move backwards
    movwf PORTC
    Dlay 5000000	    ;delay 5 seconds 
    nop
    return
end 