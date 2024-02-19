const int speedpot = A5;
const int sfarL = A0;
const int sleft = A1;
const int smiddle = A2;
const int sright = A3;
const int sfarR = A4;

const int farLled = 13;
const int leftled = 12;
const int middleled = 11;
const int rightled = 8;
const int farRled = 7;

const int leftR = 3;
const int leftF = 4;
const int rightF = 5;
const int rightR = 6;

const int speedL = 10;
const int speedR = 9;

int farL = 0;
int left = 0;
int middle = 0;
int right = 0;
int farR = 0;
int speedIn = 0;
  
float farLvalue = 0;
float leftvalue = 0;
float middlevalue = 0;
float rightvalue = 0;
float farRvalue = 0;
float speedvalue = 0;

bool farLstatus = false;
bool leftstatus = false;
bool middlestatus = false;
bool rightstatus = false;
bool farRstatus = false;

bool runmode = false;
bool linefound = false;


unsigned long lineticker = 0;
unsigned long currentmillis = 0;

unsigned long lastmiddletime = 0;
unsigned long lastlefttime = 0;
unsigned long lastrighttime = 0;
unsigned long lastfarRtime = 0;
unsigned long lastfarLtime = 0;
unsigned long lastmovetime = 0;

int movestatus = 0;
float currentspeedvalue = 0;
float maxspeed = 0;
float delayvalue = 0.0;
String direct = "";
String currentstatus = "";

unsigned long lastdecidetime = 0;

bool rightturncomplete = true;
bool leftturncomplete = true;






void setup(){
  Serial.begin(115200);

  pinMode(speedpot, INPUT);
  pinMode(sfarL, INPUT);
  pinMode(sleft, INPUT);
  pinMode(smiddle, INPUT);
  pinMode(sright, INPUT);
  pinMode(sfarR, INPUT);

  pinMode(farLled ,OUTPUT);
  pinMode(leftled ,OUTPUT);
  pinMode(middleled ,OUTPUT);
  pinMode(rightled ,OUTPUT);
  pinMode(farRled ,OUTPUT);
  
  pinMode(leftR, OUTPUT);
  pinMode(leftF, OUTPUT);
  pinMode(rightR, OUTPUT);
  pinMode(rightF, OUTPUT);

  pinMode(speedL, OUTPUT); 
  pinMode(speedR, OUTPUT);

  analogWrite(speedL, 0);
  analogWrite(speedR, 0);
  
// Pins D9 and D10 - 30 Hz
  TCCR1A = 0b00000001; // 8bit
  TCCR1B = 0b00000101; // x1024 phase correct

//---------------------------------------------------------------------------------------------------------
  maxspeed = 60;
//---------------------------------------------------------------------------------------------------------
}




void loop() {
  runstatus();
  readanalog();
  ledrun();
  if(runmode == true){
    decidestatus();
      movecar(direct);
    
  }
  currentmillis = millis();
} 




void runstatus(){
  if(speedvalue != 30 && runmode == false){
    delay(1000);
    runmode = true;
    Serial.println("Movement Enabled");
    direct = "straight";
  }
  if(speedvalue == 30 && runmode == true){
    runmode = false;
    direct = "";
    Serial.print("Movement Disabled\t");
    stopcar();
  }
}




void readanalog(){
  farL = analogRead(sfarL);
  left = analogRead(sleft);
  middle = analogRead(smiddle);
  right = analogRead(sright);
  farR = analogRead(sfarR);

  speedvalue = 38;
  delayvalue = 10;
  
  farLvalue = (float)farL * 5.0 / 1023.0;
  leftvalue = (float)left * 5.0 / 1023.0;
  middlevalue = (float)middle * 5.0 / 1023.0;
  rightvalue = (float)right * 5.0 / 1023.0;
  farRvalue = (float)farR * 5.0 / 1023.0;
  
//  Serial.print("farL: ");
//  Serial.print(farLvalue);
//  Serial.print("  Left: ");
//  Serial.print(leftvalue);
//  Serial.print("  Middle: ");
//  Serial.print(middlevalue);
//  Serial.print("  Right: ");
//  Serial.print(rightvalue);
//  Serial.print("  farR: ");
//  Serial.println(farRvalue);
}




void ledrun(){
  if(farLvalue > 0.40){
    digitalWrite(farLled ,HIGH);
    farLstatus = true;
    lastfarLtime = currentmillis;
  }
  else{
    digitalWrite(farLled ,LOW);
    farLstatus = false;
  }

  
  if(leftvalue > 0.40){
    digitalWrite(leftled ,HIGH);
    leftstatus = true;
    lastlefttime = currentmillis;
  }
  else{
    digitalWrite(leftled ,LOW);
    leftstatus = false;
  }

  
  if(middlevalue > 0.40){
    digitalWrite(middleled ,HIGH);
    middlestatus = true;
    lastmiddletime = currentmillis;
  }
  else{
    digitalWrite(middleled ,LOW);
    middlestatus = false;
  }

  
  if(rightvalue > 0.40){
    digitalWrite(rightled ,HIGH);
    rightstatus = true;
    lastrighttime = currentmillis;
  }
  else{
    digitalWrite(rightled ,LOW);
    rightstatus = false;
  }

  
  if(farRvalue > 0.40){
    digitalWrite(farRled ,HIGH);
    farRstatus = true;
    lastfarRtime = currentmillis;
  }
  else{ 
    digitalWrite(farRled ,LOW);
    farRstatus = false;
  }
}




void movecar(String direct){
  if(direct == "straight"){
    //-----------00|00------------
    if(middlestatus == true && leftstatus == false && rightstatus == false && farRstatus == false && farLstatus == false){
      if(movestatus == 1){
      }
      else{
        moveforward();
      }
    }
    //-----------0||00------------
    else if(middlestatus == true && leftstatus == true && rightstatus == false && farRstatus == false && farLstatus == false){
      if(movestatus == 1){
      }
      else{
        moveforward();
      }
    }
    //-----------00||0------------
    else if(middlestatus == true && leftstatus == false && rightstatus == true && farRstatus == false && farLstatus == false){
      if(movestatus == 1){
      }
      else{
        moveforward();
      }
    }
    //-----------000|0------------  
    else if(middlestatus == false && leftstatus == false && rightstatus == true && farRstatus == false && farLstatus == false){
      if(movestatus == 3){
      }
      else{
        moveright();
      }
    }
    //-----------0|000------------  
    else if(middlestatus == false && leftstatus == true && rightstatus == false && farRstatus == false && farLstatus == false){
      if(movestatus == 2){
      }
      else{
        moveleft();
      }
    }
    //-----------000||------------  
    else if(middlestatus == false && leftstatus == false && rightstatus == true && farRstatus == true && farLstatus == false){
      if(movestatus == 5){
      }
      else{
        hardright();
      }
    }
    //-----------||000------------  
    else if(middlestatus == false && leftstatus == true && rightstatus == false && farRstatus == false && farLstatus == true){
      if(movestatus == 4){
      }
      else{
        hardleft();
      }
    }
    //-----------|0000------------  
    else if(middlestatus == false && leftstatus == false && rightstatus == false && farRstatus == false && farLstatus == true){
      if(movestatus == 4){
      }
      else{
        hardleft();
      }
    }
    //-----------0000|------------  
    else if(middlestatus == false && leftstatus == false && rightstatus == false && farRstatus == true && farLstatus == false){
      if(movestatus == 5){
      } 
      else{
        hardright();
      }
    }
   }



   
  if(direct == "left"){
     //-----------|0000------------  
     if(middlestatus == false && leftstatus == false && rightstatus == false && farRstatus == false && farLstatus == true){
       if(movestatus == 7){
       }
       else{
         spinleft();
       }
     }
     //-----------||000------------  
     else if(middlestatus == false && leftstatus == true && rightstatus == false && farRstatus == false && farLstatus == true){
       if(movestatus == 4){
       }
       else{
         hardleft();
       }
     }
     //-----------0|000------------  
     else if(middlestatus == false && leftstatus == true && rightstatus == false && farRstatus == false && farLstatus == false){
       if(movestatus == 2){
       }
       else{
         moveleft();
       }
     }
    //-----------0||00------------
    else if(middlestatus == true && leftstatus == true && rightstatus == false && farRstatus == false && farLstatus == false){
      if(movestatus == 2){
      }
      else{
        moveleft();
      }
    }
  }



  if(direct == "right"){
    //-----------00||0------------
    if(middlestatus == true && leftstatus == false && rightstatus == true && farRstatus == false && farLstatus == false){
      if(movestatus == 3){
      }
      else{
        moveright();
      }
    }
    //-----------000|0------------  
    else if(middlestatus == false && leftstatus == false && rightstatus == true && farRstatus == false && farLstatus == false){
      if(movestatus == 3){
      }
      else{
        moveright();
      }
    }
    //-----------000||------------  
    else if(middlestatus == false && leftstatus == false && rightstatus == true && farRstatus == true && farLstatus == false){
      if(movestatus == 5){
      }
      else{
        hardright();
      }  
    }
    //-----------0000|------------  
    else if(middlestatus == false && leftstatus == false && rightstatus == false && farRstatus == true && farLstatus == false){
      if(movestatus == 8){
      } 
      else{
        spinright();
      }
    }
  }
  lastmovetime = currentmillis;
}




void decidestatus(){
  if(direct != "straight"){
    if(rightturncomplete == true && leftturncomplete == true){
      direct = "straight";
      lastdecidetime = currentmillis;
      Serial.println(direct);
      moveforward();
    }
  }
  if(direct != "left"){
    if(leftturncomplete == true && rightturncomplete == true){
      if(middlestatus == false && leftstatus == false && rightstatus == false && farRstatus == false && farLstatus == true){
        direct = "left";
        leftturncomplete = false;
        lastdecidetime = currentmillis;
        Serial.println(direct);
        spinleft();
      }
    }
  }
  if(direct == "left" && currentmillis - lastdecidetime > 500 && direct == "left" && middlestatus == true){
    leftturncomplete = true;
  }
 
  if(direct != "right"){
    if(rightturncomplete == true && leftturncomplete == true){
      if(middlestatus == false && leftstatus == false && rightstatus == false && farRstatus == true && farLstatus == false){
        direct = "right";
        rightturncomplete = false;
        lastdecidetime = currentmillis;
        Serial.println(direct);
        spinright();
      }
    }
  }
  if(direct == "right" && currentmillis - lastdecidetime > 500 && direct == "right" && middlestatus == true){
    rightturncomplete = true;
  }
  
//  Serial.println(currentmillis - lastmiddletime);
//  if(currentmillis - lastmiddletime > 3000 && direct == "straight" && middlestatus == false && leftstatus == false && rightstatus == false && farRstatus == false && farLstatus == false){
//      runmode = false;
//      direct = "";
//      Serial.print("Movement Disabled\t");
//      stopcar();
//    }  
}









void moveforward(){
  digitalWrite(leftR, LOW);
  digitalWrite(leftF, HIGH);
  digitalWrite(rightR, LOW);
  digitalWrite(rightF, HIGH);
  analogWrite(speedL, speedvalue);
  analogWrite(speedR, speedvalue);
  serialprint("Forward");
  movestatus = 1;
}

void moveleft(){
  digitalWrite(leftR, LOW);
  digitalWrite(leftF, HIGH);
  digitalWrite(rightR, LOW);
  digitalWrite(rightF, HIGH);
  analogWrite(speedL, speedvalue);
  analogWrite(speedR, speedvalue*0.6);
  serialprint("Left");
  movestatus = 2;
}

void moveright(){
  digitalWrite(leftR, LOW);
  digitalWrite(leftF, HIGH);
  digitalWrite(rightR, LOW);
  digitalWrite(rightF, HIGH);
  analogWrite(speedL, speedvalue*0.6);
  analogWrite(speedR, speedvalue);
  serialprint("Right");
  movestatus = 3;
}

void hardleft(){
  digitalWrite(leftR, HIGH);
  digitalWrite(leftF, LOW);
  digitalWrite(rightR, LOW);
  digitalWrite(rightF, HIGH);
  analogWrite(speedL, speedvalue*0.3);
  analogWrite(speedR, speedvalue*0.8);
  serialprint("H Left");
  movestatus = 4;
}

void hardright(){
  digitalWrite(leftR, LOW);
  digitalWrite(leftF, HIGH);
  digitalWrite(rightR, HIGH);
  digitalWrite(rightF, LOW);
  analogWrite(speedL, speedvalue*0.8);
  analogWrite(speedR, speedvalue*0.3);
  serialprint("H Right");
  movestatus = 5;
}


void spinleft(){
  digitalWrite(leftR, HIGH);
  digitalWrite(leftF, LOW);
  digitalWrite(rightR, LOW);
  digitalWrite(rightF, HIGH);
  analogWrite(speedL, speedvalue*0.4);
  analogWrite(speedR, speedvalue*0.8);
  serialprint("S Left");
  movestatus = 7;
}

void spinright(){
  digitalWrite(leftR, LOW);
  digitalWrite(leftF, HIGH);
  digitalWrite(rightR, HIGH);
  digitalWrite(rightF, LOW);
  analogWrite(speedL, speedvalue*0.8);
  analogWrite(speedR, speedvalue*0.4);
  serialprint("S Right");
  movestatus = 8;
}


void goback(){
  digitalWrite(leftR, HIGH);
  digitalWrite(leftF, LOW);
  digitalWrite(rightR, HIGH);
  digitalWrite(rightF, LOW);
  analogWrite(speedL, speedvalue*1.2);
  analogWrite(speedR, speedvalue*1.2);
  serialprint("Back");
  movestatus = 6;
}

void stopcar(){
  digitalWrite(leftR, LOW);
  digitalWrite(leftF, LOW);
  digitalWrite(rightR, LOW);
  digitalWrite(rightF, LOW);
  serialprint("Stop");
  movestatus = 0;
}

void serialprint(String movement){
  Serial.print(movement);
  Serial.print("\tSpeed = ");
  Serial.print(speedvalue);
  Serial.print("\tDelay = ");
  Serial.println(delayvalue);
}
