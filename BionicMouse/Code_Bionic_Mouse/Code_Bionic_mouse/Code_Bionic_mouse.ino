int V0 = 350;           // (1)** Max output value from the EMG captor for the upper part of the forearm
int V1 = 350;           // (2)** Same but for the lower part of the forearm
int upDuration = 450;   // (3)** Duration in milliseconds of an "up" contraction of the user
int downDuration = 450; // (4)** Same but for a "down" contraction 
int timerUp = 0;        // Timer for duration of the upper contraction
int timerDown = 0;      

void setup() {
  Serial.begin(9600);
  pinMode(A0, INPUT);   // Input from the EMG captor for the upper part of the forearm
  pinMode(A1, INPUT);   // Input from the EMG captor for the lower part of the forearm
  pinMode(2, OUTPUT);   // Output signal towards the left click
  pinMode(3, OUTPUT);   // Output signal towards the right click
}

void loop() {
  digitalWrite(2,LOW);  // Initialize the output signals to 0 to avoid persistent clicks between two loops.
  digitalWrite(3,LOW); 
  timerUp = 0; 
  timerDown = 0;
  while(upIsHold() and timerUp<4*upDuration){            // (5)* As long as the high contraction is maintained for at most 4*upDuration, 
    delay(10);                                           //      the timer is incremented by 10 ms.
    timerUp += 10;
  }
  while(downIsHold() and timerDown<3*downDuration){      // (6)* Same for the low contraction for a maximum of 3*upDuration
    delay(10);
    timerDown += 10;
  }
  if(timerUp>10 and timerUp<=upDuration){                // (7)* Simple left click
    digitalWrite(2,HIGH);
    delay(50);
    digitalWrite(2,LOW);    
  }
  else if(timerUp>upDuration and timerUp<=2*upDuration){ // (8)* Double click
    digitalWrite(2,HIGH);
    delay(50);
    digitalWrite(2,LOW);
    delay(50);
    digitalWrite(2,HIGH);
    delay(50);
    digitalWrite(2,LOW);   
  }
  else if(timerUp>2*upDuration){                         // (9)* Triple click
    digitalWrite(2,HIGH);
    delay(50);
    digitalWrite(2,LOW);
    delay(50);
    digitalWrite(2,HIGH);
    delay(50);
    digitalWrite(2,LOW);
    delay(50);
    digitalWrite(2,HIGH);
    delay(50);
    digitalWrite(2,LOW);    
  }
  if(timerDown>10 and timerDown<=downDuration){          // (10)* Right click
    digitalWrite(3,HIGH);
    delay(50);
    digitalWrite(3,LOW);     
  }
  else if(timerDown>downDuration){                       // (11)* Hold click
    do{
      digitalWrite(2,HIGH);
    }while(not(upIsHold()));
    digitalWrite(2, LOW);
  }
  // Serial.print(timerDown);  Commands to display the different contraction times, in order to adapt the code to each individual
  // Serial.print("    ");     
  // Serial.println(timerUp);
  // delay(80);
}
  
bool upIsHold(){   // Function to determine at the moment of the call whether there is a high contraction or not 
  bool upIsHold = 0;
  if((analogRead(A0)>0.7*V0)and(analogRead(A1)<0.6*V1)) upIsHold = 1;   // (12)* Threshold value for detecting high contraction,
  return upIsHold;                                                      //      here set at 60% of the max contraction value V0
}

bool downIsHold(){ // Same for a low contraction
  bool downIsHold = 0;
  if((analogRead(A1)>0.7*V1)and(analogRead(A0)<0.6*V0)) downIsHold = 1; // (13)*
  return downIsHold;
} 
