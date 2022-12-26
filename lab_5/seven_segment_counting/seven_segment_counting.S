#define __SFR_OFFSET 0

#include "avr/io.h"

.global start
.global seven_segment_counting
;------------- Do NOT change anything above this line
start:
  ret

seven_segment_counting: 
  ldi r16, 0xFF  
  out DDRB, r16 
  ldi r16, 0x00  
  out PORTB, r16 

  ldi r16, 0xFF  
  out DDRD, r16
  ldi r16, 0x00
  out PORTD, r16 
 
  ldi r17, 0x00
  loop:
  
    call delay
    
    cbi PORTD, 3  
    cbi PORTD, 2  
    cbi PORTD, 4  
    cbi PORTD, 5  
    cbi PORTB, 0  
    cbi PORTB, 1  
    cbi PORTB, 2     

    andi r17, 0x0F

    send_F:
        cpi r17, 0x0F
        brne send_E
        sbi PORTD, 3  
        sbi PORTD, 4  
        sbi PORTD, 5  
        sbi PORTB, 2
        inc r17              
        jmp loop
    
    send_E:
        cpi r17, 0x0E
        brne send_D
        sbi PORTD, 3  
        sbi PORTD, 4  
        sbi PORTD, 5  
        sbi PORTB, 1  
        sbi PORTB, 2
        inc r17          
        jmp loop
    
    send_D:
        cpi r17, 0x0D
        brne send_C
        sbi PORTD, 2  
        sbi PORTD, 5  
        sbi PORTB, 0  
        sbi PORTB, 1  
        sbi PORTB, 2
        inc r17          
        jmp loop

    send_C:
        cpi r17, 0x0C
        brne send_B
        sbi PORTD, 3  
        sbi PORTD, 4  
        sbi PORTB, 1  
        sbi PORTB, 2
        inc r17          
        jmp loop

    send_B:
        cpi r17, 0x0B
        brne send_A
        sbi PORTD, 4  
        sbi PORTD, 5  
        sbi PORTB, 0  
        sbi PORTB, 1  
        sbi PORTB, 2
        inc r17          
        jmp loop

    send_A:
        cpi r17, 0x0A
        brne send_9
        sbi PORTD, 3  
        sbi PORTD, 2  
        sbi PORTD, 4  
        sbi PORTD, 5  
        sbi PORTB, 0  
        sbi PORTB, 2
        inc r17      
        jmp loop
    
    send_9:
        cpi r17, 0x09
        brne send_8
        sbi PORTD, 3  
        sbi PORTD, 2  
        sbi PORTD, 4  
        sbi PORTD, 5  
        sbi PORTB, 0  
        sbi PORTB, 1
        inc r17      
        jmp loop
    
    send_8:
        cpi r17, 0x08
        brne send_7
        sbi PORTD, 3  
        sbi PORTD, 2  
        sbi PORTD, 4  
        sbi PORTD, 5  
        sbi PORTB, 0  
        sbi PORTB, 1  
        sbi PORTB, 2
        inc r17      
        jmp loop
    
    send_7:
        cpi r17, 0x07
        brne send_6
        sbi PORTD, 3  
        sbi PORTD, 2  
        sbi PORTB, 0
        inc r17  
        jmp loop

    send_6:
        cpi r17, 0x06
        brne send_5
        sbi PORTD, 3  
        sbi PORTD, 4  
        sbi PORTD, 5  
        sbi PORTB, 0  
        sbi PORTB, 1  
        sbi PORTB, 2  
        inc r17
        jmp loop

    send_5:
        cpi r17, 0x05
        brne send_4
        sbi PORTD, 3  
        sbi PORTD, 4  
        sbi PORTD, 5  
        sbi PORTB, 0  
        sbi PORTB, 1
        inc r17  
        jmp loop  

    send_4:
        cpi r17, 0x04
        brne send_3
        sbi PORTD, 4  
        sbi PORTD, 2  
        sbi PORTD, 5  
        sbi PORTB, 0
        inc r17  
        jmp loop  
    
    send_3:
        cpi r17, 0x03
        brne send_2
        sbi PORTD, 3  
        sbi PORTD, 2  
        sbi PORTD, 5  
        sbi PORTB, 0  
        sbi PORTB, 1
        inc r17  
        jmp loop
    
    send_2:
        cpi r17, 0x02
        brne send_1
        sbi PORTD, 2  
        sbi PORTD, 3  
        sbi PORTD, 5  
        sbi PORTB, 2  
        sbi PORTB, 1
        inc r17  
        jmp loop

    send_1:
        cpi r17, 0x01
        brne send_0
        sbi PORTB, 0  
        sbi PORTD, 2
        inc r17  
        jmp loop
    
    send_0:
        cpi r17, 0x00
        brne send_error
        sbi PORTB, 0 
        sbi PORTB, 1 
        sbi PORTB, 2 
        sbi PORTD, 4 
        sbi PORTD, 3 
        sbi PORTD, 2
        inc r17  
        jmp loop
    
    send_error:
        sbi PORTD, 3  
        sbi PORTD, 5    
        sbi PORTB, 1           
        jmp loop

delay:
    ldi r20, 0xD2
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
      




  
