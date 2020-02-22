title "robot.asm" 
;
; Explain the Operation of the Program 
;
; Hardware Notes:
;   details about which PIC is being used, I/O ports used, clock speed, etc.
;
; Angel Li
; January 5th, 2020
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
    
    movlw b'00110000'	;teaching RA5 and RA4 to be input
    movwf PORTA	
    
    bcf STATUS, RP0	;bank 0
    
Dlay 3000000
loop: 
    nop
    btfss PORTA, 4
	call left 
    btfss PORTA, 5	    ;if input into RA4 is 0, call left (if right sensor is over black)
	call right
    call both 
    goto loop 
; -----------------------------------------------------------------------------
PAGE
; Subroutines 
left:
    movlw b'00000010'	    ;move forward (RC1)
    movwf PORTC
    Dlay 10000 
    movlw b'00000000'
    movwf PORTC
    Dlay 40000
    btfss PORTA, 4
	goto left 
    btfsc PORTA, 5	    ;return if RA5 is white
	return 
    Dlay 100000
    btfsc PORTA, 5
	return 
    movlw b'00001000'
    movwf PORTC
    Dlay 100000 
    movlw b'00000000'
    movwf PORTC
    Dlay 2000000
    btfss PORTA, 4
	goto left 
    nop
    return
right: 
    movlw b'00010000'	    ;move forward (RC4) 
    movwf PORTC
    Dlay 10000
    movlw b'00000000'
    movwf PORTC
    Dlay 40000
    btfss PORTA, 5
	goto right
    ;btfsc PORTA, 4
	;return 
    ;Dlay 100000
    ;btfsc PORTA, 4
	;return 
    ;movlw b'00001001'
    ;movwf PORTC
    ;Dlay 100000 
    ;movlw b'00000000'
    ;movwf PORTC
    ;Dlay 2000000
    ;movlw b'00010000'	    ;move forward (RC4) 
    ;movwf PORTC
    ;Dlay 10000
    ;btfss PORTA, 5
	;goto right 
    nop
    return 
both: 
    movlw b'00010010'
    movwf PORTC
    Dlay 10000
    movlw b'00000000'
    movwf PORTC
    Dlay 20000
    btfss PORTA, 4
	return 
    btfss PORTA, 5
	return 
    goto both 
 
end 

