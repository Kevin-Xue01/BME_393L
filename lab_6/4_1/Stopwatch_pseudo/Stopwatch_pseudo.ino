const int switchPin = 2; // the number of the input pin
long startTime; // store starting time here
long duration; // variable to store how long the timer has been running
float secduration; // variable to store the duration in seconds
int switchPinValue = HIGH;
void setup()
{
  pinMode(switchPin, INPUT_PULLUP);
  Serial.begin(9600); //this will allow the Uno to comunicate with the serial monitor
}

void loop()
{
switchPinValue = digitalRead(switchPin);
if (switchPinValue == LOW){
  Serial.println("Button pushed"); // this will print to the serial monitor
  startTime = millis(); // stores the number of millisceoncds since the Uno was last reset. See http://arduino.cc/en/Reference/millis
  while (1) {
    if (digitalRead(switchPin) == HIGH) {
      break;
    }
  }
  duration = millis() - startTime;
  secduration=(float)duration / (1000) ; /* convert the integer value for the time differnce into a 
                                                      floating variable before calculating time lapsed in seconds keeps precision */
  Serial.print("Button released after "); // print out your results
  Serial.print(secduration);
  Serial.println(" seconds");
}
}
