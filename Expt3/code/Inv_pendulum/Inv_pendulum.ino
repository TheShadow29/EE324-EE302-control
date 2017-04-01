 #define sel1 38
#define sel2 39
#define rst_ 40
#define clk 12

#define pi 3.14159

int alpha;
int theta;
byte alpha1, alpha2;
byte theta1, theta2;
float alpha_actual;
float theta_actual;

float theta_prev = 0;
float alpha_prev = 0;
float theta_dot;
float alpha_dot;
int time_old = 0;
int time_new = 0;
int delta_t = 0;
float k1 =-4.242641;
float k2 =72.910965;
float k3 =-2.655214;
float k4 =9.602371;
float u;
int voltage = 0;
float scale = 3;

void setup() {
  pinMode(sel1, OUTPUT);
  pinMode(sel2, OUTPUT);
  pinMode(rst_, OUTPUT);
  pinMode(clk, OUTPUT);

  TCCR1B=0x01;
  analogWrite(clk, 127);

  digitalWrite(rst_, LOW);
  delay(1000);
  digitalWrite(rst_, HIGH);

  DDRC=0b00000000;

  Serial.begin(9600);
//  digitalWrite(sel1, HIGH);
//  digitalWrite(sel2, LOW);
//  alpha1=PINC;
//  digitalWrite(sel1, LOW);
//  digitalWrite(sel2, LOW);
//  alpha2=PINC;
//  alpha=word(alpha2, alpha1);
  
  delay(2000);

}

void loop() 
{
  delay(10);
  digitalWrite(sel1, HIGH);
  digitalWrite(sel2, LOW);
  alpha1=PINC;
  digitalWrite(sel1, LOW);
  digitalWrite(sel2, LOW);
  alpha2=PINC;
  alpha=word(alpha2, alpha1);
//  alpha : 2048 corresponds to 360 degrees
// Clockwise from front is positive
//  alpha = alpha - 1024;
//  alpha = alpha%2048;
//  if (alpha > 1023)
//  {
//    alpha = alpha - 1024;
//  }
//  alpha_actual = alpha*360.0/2048;



  if(alpha > 0)
  {
    alpha_actual = (alpha % 2000)*(360.0/2000.0);
    if(alpha_actual > 180)
    {
      alpha_actual = alpha_actual - 360;
    }
  }
  else
  {
    alpha_actual = -1*((-1 * alpha)%2000)*(360.0/2000.0);
    if (alpha_actual < -180)
    {
      alpha_actual = alpha_actual + 360; 
    }
  }

  alpha_actual = (alpha_actual * pi)/180;

  digitalWrite(sel1, HIGH);
  digitalWrite(sel2, LOW);
  theta1=PINA;
  digitalWrite(sel1, LOW);
  digitalWrite(sel2, LOW);
  theta2=PINA;
  theta=word(theta2, theta1);
//  theta : 2048 corresponds to 360 degrees
// Clockwise from up is positive
//  theta_actual = theta*360.0/2048;
  if(theta > 0)
  {
    theta_actual = (theta % 2000)*(360.0/2000.0);
    if(theta_actual > 180)
    {
      theta_actual = theta_actual - 360;
    }
  }
  else
  {
    theta_actual = -1*((-1 * theta)%2000)*(360.0/2000.0);
    if (theta_actual < -180)
    {
      theta_actual = theta_actual + 360; 
    }
  }

  theta_actual = (theta_actual * pi)/180;

  time_new = millis();
  delta_t = time_new - time_old;

  theta_dot = (theta_actual - theta_prev)*1000/delta_t;
  alpha_dot = (alpha_actual - alpha_prev)*1000/delta_t;

  u = -(k1*theta_actual + k2*(alpha_actual) + k3*theta_dot + k4*alpha_dot);
  scale = 83*6*57;
  voltage = (u/1000)*scale;
  if (voltage > 255)
  {
    voltage = 255;
  }
  else if (voltage < -255)
  {
    voltage = -255;
  }
//  voltage = 0;
  theta_prev = theta_actual;
  alpha_prev = alpha_actual;
  time_old = time_new;

  if(voltage > 0)
  {
      analogWrite(9 , voltage);
      analogWrite(8 , 0);
  }
  else
  {
      analogWrite(9 , 0);
      analogWrite(8 , -voltage);
  }
  Serial.println("alpha_actual :" + String(alpha_actual));
  Serial.println("theta_actual :" + String(theta_actual)) ;
//  Serial.println("theta_dot :" + String(theta_dot));
//  Serial.println("voltage :" + String(voltage));
}
