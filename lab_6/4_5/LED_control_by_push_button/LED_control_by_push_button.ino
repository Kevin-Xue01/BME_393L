const int led_pin = 8; // the input pin
const int interrupt_pin_number = 2;
volatile byte led_state = LOW;


void setup()
{
  pinMode(led_pin, OUTPUT);
  pinMode(interrupt_pin_number, INPUT_PULLUP);
  attachInterrupt (digitalPinToInterrupt(interrupt_pin_number), ISR_blink, CHANGE);
}

void loop()
{
    digitalWrite(led_pin, led_state);
}

void ISR_blink(){
  led_state = ~led_state;
}
