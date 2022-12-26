#define __SFR_OFFSET 0

#include "avr/io.h"

.global start
.global blink
;------------- Do NOT change anything above this line
start:
  ret

blink: 
  ldi r16, 0xFF  ; Load register 16 with 0xFF (all bits 1)  
  out DDRB, r16 ; Write 0xFF to Data Direction Register for port B. This defines all pins on port B as output.  
  ldi r16, 0x0  ; Load register 16 with 0x00 (all bits 0)  
  out PORTB, r16 ; Write 0x00 to port B. This sets all pins to 0.  
  sbi PORTB, 0  ; Sets bit 0 on port B to 1.
  call delay
  cbi PORTB, 0
  call delay
jmp blink

delay:
    ldi r20, 0xE9
    outer_loop:
      ldi r19, 0x0 ; Load r17 with zero 
      middle_loop:
        ldi r18, 0x0 ; Load r18 with zero 
        inner_loop: 
          mul r17, r17 ; Takes 2 clock cycles to complete 
          inc r18 ; Increment r18 
          brne inner_loop ; If not zero, jump to loop 
        inc r19 
        brne middle_loop
      inc r20
      brne outer_loop
ret
  
