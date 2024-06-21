void setup() {
  // put your setup code here, to run once:
  pinMode(A0, INPUT); // entrée du capteur de la contraction haute / High contraction sensor input
  pinMode(A1, INPUT); // entrée du capteur de la contraction basse 
  Serial.begin(9600);
}

void loop() {
  Serial.print(analogRead(A0));
  Serial.print("     ");
  Serial.println(analogRead(A1));
  delay(50);
}
