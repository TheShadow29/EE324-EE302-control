int ref = 900;
float sum_error = 0;
float present_error;
float old_error;
const int outPin1= 8;
const int outPin2 = 9;

void setup()
{
	Serial.begin(9600);
	pinMode(outPin1, OUTPUT);
	pinMode(outPin2, OUTPUT);
	delay(5000);
}

void loop()
{
	// put your main code here, to run repeatedly:
	int pot_val = analogRead(A1);
	delay(4);
	old_error = present_error;
	present_error = pot_val -ref;
	
	float out_volt = pid(old_error, present_error);
	Serial.print("Pot val ");
	Serial.println(pot_val);
	Serial.print("Error ");
	Serial.println(present_error);
	Serial.print("Out volt ");
	Serial.println(out_volt);
  
//  Serial.print("Out Val");
//  Serial.println(out_volt);

	if (out_volt < 0)
	{
		analogWrite(outPin1, int(-out_volt));
		analogWrite(outPin2, 0);
	}
	else
	{
		analogWrite(outPin2, int(out_volt));
		analogWrite(outPin1, 0);
	}

}

float pid(float old_err, float present_err)
{
	float kp, ki, kd;
	kp = 1;
	ki = 0.06;
	kd = 1;
	float diff_error = present_err - old_err;
	sum_error += present_err;
	float out_v = kp * present_err + ki * sum_error + kd * diff_error;
	return out_v;
}

