const int switchPin = 2; 
const int buttonPin = 8; 
long startcount; 
long endcount; 
long duration; 
float period; 
float scaled_period; 
float frequency; 

void setup()
{
  pinMode(switchPin, INPUT);
  pinMode(buttonPin, INPUT_PULLUP);
  Serial.begin(9600); //sets up communication with the serial monitor
}

void loop()
{
  if (digitalRead(buttonPin) == LOW){
    if (digitalRead(switchPin) == HIGH){
        while (digitalRead(switchPin) == HIGH){}
        startcount = millis();
        while (digitalRead(switchPin) == LOW){}
        while (digitalRead(switchPin) == HIGH){}
        endcount = millis();
        duration = endcount - startcount; 
        period = (float)(((float)duration / 1000));
        scaled_period = period; 
        frequency = 1 / scaled_period;
        Serial.print(" Frequency is = ");
        Serial.println(frequency);
    }  
  }
}
