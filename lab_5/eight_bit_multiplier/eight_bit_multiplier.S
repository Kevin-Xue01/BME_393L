#define __SFR_OFFSET 0

#include "avr/io.h"

.global start
.global eight_bit_multiplier
;------------- Do NOT change anything above this line
start:
  ret

eight_bit_multiplier: 
  ldi r16, 0xFF  
  out DDRB, r16 
  ldi r16, 0x00  
  out PORTB, r16 

  ldi r16, 0x3F  
  out DDRD, r16
  ldi r16, 0xC0
  out PORTD, r16 


  wait_for_initialize_first_value_LSB:
    call display_q_symbol
    in r16, PIND
    andi r16, 0x80
    brne wait_for_initialize_first_value_LSB
    call delay_02
    call display_blank
    ldi r18, 0x00
        
    first_value_LSB_check_if_increment_pressed:  
        call display_r18
        in r16, PIND
        andi r16, 0x80
        brne first_value_LSB_check_if_save_pressed
        call delay_02
        call display_blank
        inc r18
        jmp first_value_LSB_check_if_increment_pressed
        
    first_value_LSB_check_if_save_pressed:
        in r16, PIND
        andi r16, 0x40
        brne first_value_LSB_check_if_increment_pressed
        call flash_r18
        mov r19, r18
        call display_blank
        call clear_r18
        jmp wait_for_initialize_first_value_MSB



        
  wait_for_initialize_first_value_MSB:
    call display_q_symbol
    in r16, PIND
    andi r16, 0x80
    brne wait_for_initialize_first_value_MSB
    call delay_02
    call display_blank
    ldi r18, 0x00
        
    first_value_MSB_check_if_increment_pressed:  
        call display_r18
        in r16, PIND
        andi r16, 0x80
        brne first_value_MSB_check_if_save_pressed
        call delay_02
        call display_blank
        inc r18
        jmp first_value_MSB_check_if_increment_pressed
        
    first_value_MSB_check_if_save_pressed:
        in r16, PIND
        andi r16, 0x40
        brne first_value_MSB_check_if_increment_pressed
        call flash_r18
        mov r20, r18
        call display_blank
        call clear_r18
        jmp wait_for_initialize_second_value_LSB





  wait_for_initialize_second_value_LSB:
    call display_q_symbol
    in r16, PIND
    andi r16, 0x80
    brne wait_for_initialize_second_value_LSB
    call delay_02
    call display_blank
    ldi r18, 0x00
        
    second_value_LSB_check_if_increment_pressed:  
        call display_r18
        in r16, PIND
        andi r16, 0x80
        brne second_value_LSB_check_if_save_pressed
        call delay_02
        call display_blank
        inc r18
        jmp second_value_LSB_check_if_increment_pressed
        
    second_value_LSB_check_if_save_pressed:
        in r16, PIND
        andi r16, 0x40
        brne second_value_LSB_check_if_increment_pressed
        call flash_r18
        mov r21, r18
        call display_blank
        call clear_r18
        jmp wait_for_initialize_second_value_MSB


  wait_for_initialize_second_value_MSB:
    call display_q_symbol
    in r16, PIND
    andi r16, 0x80
    brne wait_for_initialize_second_value_MSB
    call delay_02
    call display_blank
    ldi r18, 0x00
        
    second_value_MSB_check_if_increment_pressed:  
        call display_r18
        in r16, PIND
        andi r16, 0x80
        brne second_value_MSB_check_if_save_pressed
        call delay_02
        call display_blank
        inc r18
        jmp second_value_MSB_check_if_increment_pressed
        
    second_value_MSB_check_if_save_pressed:
        in r16, PIND
        andi r16, 0x40
        brne second_value_MSB_check_if_increment_pressed
        call flash_r18
        mov r22, r18
        call display_blank
        call clear_r18
        


  swap r20
  swap r22
  or r19, r20
  or r21, r22
  mul r19, r21

  mov r19, r0
  mov r20, r0
  mov r21, r1
  mov r22, r1

  andi r19, 0x0F
  swap r20

  andi r21, 0x0F
  swap r22

  display_output:
    mov r18, r19
    call display_r18
    call delay_05
    call delay_05
    call display_blank
    call delay_05

    mov r18, r20
    call display_r18
    call delay_05
    call delay_05
    call display_blank
    call delay_05

    mov r18, r21
    call display_r18
    call delay_05
    call delay_05
    call display_blank
    call delay_05

    mov r18, r22
    call display_r18
    call delay_05
    call delay_05
    call display_blank
    call delay_05

    call display_dash
    call delay_05
    call delay_05

    jmp display_output


            
        
        
        
            
        
display_dash:
    sbi PORTD, 5             
    ret       
            

flash_r18:
    call display_blank
    call delay_05
    call display_r18
    call delay_05
    call display_blank 
    call delay_05
    call display_r18
    call delay_05
    ret  
    
    



delay_05:
    push r20
    push r19
    push r18

    ldi r20, 0xE9
    delay_05_outer_loop:
      ldi r19, 0x0 ; Load r17 with zero 
      delay_05_middle_loop:
        ldi r18, 0x0 ; Load r18 with zero 
        delay_05_inner_loop: 
          mul r17, r17 ; Takes 2 clock cycles to complete 
          inc r18 ; Increment r18 
          brne delay_05_inner_loop ; If not zero, jump to loop 
        inc r19 
        brne delay_05_middle_loop
      inc r20
      brne delay_05_outer_loop
    
    pop r18
    pop r19
    pop r20
    ret

delay_02:
    push r20
    push r19
    push r18

    ldi r20, 0xF6
    delay_02_outer_loop:
      ldi r19, 0x0 ; Load r17 with zero 
      delay_02_middle_loop:
        ldi r18, 0x0 ; Load r18 with zero 
        delay_02_inner_loop: 
          mul r17, r17 ; Takes 2 clock cycles to complete 
          inc r18 ; Increment r18 
          brne delay_02_inner_loop ; If not zero, jump to loop 
        inc r19 
        brne delay_02_middle_loop
      inc r20
      brne delay_02_outer_loop

    pop r18
    pop r19
    pop r20
    ret

clear_r18:
    sbr r18, 0x00
    ret

display_q_symbol:
    sbi PORTD, 3  
    sbi PORTD, 2  
    sbi PORTD, 5  
    sbi PORTB, 2
ret

display_blank:
    cbi PORTD, 3  
    cbi PORTD, 2  
    cbi PORTD, 4  
    cbi PORTD, 5  
    cbi PORTB, 0  
    cbi PORTB, 1  
    cbi PORTB, 2
ret

display_r18:
    
      andi r18, 0x0F
  
      send_F:
          cpi r18, 0x0F
          brne send_E
          sbi PORTD, 3  
          sbi PORTD, 4  
          sbi PORTD, 5  
          sbi PORTB, 2
          ret
      
      send_E:
          cpi r18, 0x0E
          brne send_D
          sbi PORTD, 3  
          sbi PORTD, 4  
          sbi PORTD, 5  
          sbi PORTB, 1  
          sbi PORTB, 2
          ret
      
      send_D:
          cpi r18, 0x0D
          brne send_C
          sbi PORTD, 2  
          sbi PORTD, 5  
          sbi PORTB, 0  
          sbi PORTB, 1  
          sbi PORTB, 2
          ret
          
      send_C:
          cpi r18, 0x0C
          brne send_B
          sbi PORTD, 3  
          sbi PORTD, 4  
          sbi PORTB, 1  
          sbi PORTB, 2
          ret
  
      send_B:
          cpi r18, 0x0B
          brne send_A
          sbi PORTD, 4  
          sbi PORTD, 5  
          sbi PORTB, 0  
          sbi PORTB, 1  
          sbi PORTB, 2
          ret
  
      send_A:
          cpi r18, 0x0A
          brne send_9
          sbi PORTD, 3  
          sbi PORTD, 2  
          sbi PORTD, 4  
          sbi PORTD, 5  
          sbi PORTB, 0  
          sbi PORTB, 2
          ret
      
      send_9:
          cpi r18, 0x09
          brne send_8
          sbi PORTD, 3  
          sbi PORTD, 2  
          sbi PORTD, 4  
          sbi PORTD, 5  
          sbi PORTB, 0  
          sbi PORTB, 1      
          ret
      
      send_8:
          cpi r18, 0x08
          brne send_7
          sbi PORTD, 3  
          sbi PORTD, 2  
          sbi PORTD, 4  
          sbi PORTD, 5  
          sbi PORTB, 0  
          sbi PORTB, 1  
          sbi PORTB, 2      
          ret
      
      send_7:
          cpi r18, 0x07
          brne send_6
          sbi PORTD, 3  
          sbi PORTD, 2  
          sbi PORTB, 0  
          ret
  
      send_6:
          cpi r18, 0x06
          brne send_5
          sbi PORTD, 3  
          sbi PORTD, 4  
          sbi PORTD, 5  
          sbi PORTB, 0  
          sbi PORTB, 1  
          sbi PORTB, 2  
          ret
  
      send_5:
          cpi r18, 0x05
          brne send_4
          sbi PORTD, 3  
          sbi PORTD, 4  
          sbi PORTD, 5  
          sbi PORTB, 0  
          sbi PORTB, 1  
          ret  
  
      send_4:
          cpi r18, 0x04
          brne send_3
          sbi PORTD, 4  
          sbi PORTD, 2  
          sbi PORTD, 5  
          sbi PORTB, 0  
          ret  
      
      send_3:
          cpi r18, 0x03
          brne send_2
          sbi PORTD, 3  
          sbi PORTD, 2  
          sbi PORTD, 5  
          sbi PORTB, 0  
          sbi PORTB, 1  
          ret
      
      send_2:
          cpi r18, 0x02
          brne send_1
          sbi PORTD, 2  
          sbi PORTD, 3  
          sbi PORTD, 5  
          sbi PORTB, 2  
          sbi PORTB, 1  
          ret
  
      send_1:
          cpi r18, 0x01
          brne send_0
          sbi PORTB, 0  
          sbi PORTD, 2  
          ret
      
      send_0:
          cpi r18, 0x00
          brne send_error
          sbi PORTB, 0 
          sbi PORTB, 1 
          sbi PORTB, 2 
          sbi PORTD, 4 
          sbi PORTD, 3 
          sbi PORTD, 2  
          ret
      
      send_error:
          sbi PORTD, 3  
          sbi PORTD, 5    
          sbi PORTB, 1           
          ret
