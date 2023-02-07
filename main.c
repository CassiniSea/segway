/* MAIN.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */

#include "stm8s.h"
#include "mpu6050.h"
#include "math.h"

#define MOTORMAXSPEEDDELTA 40 //15
#define MOTORMAXPWM 110 //110
#define MOTOR1ZEROPWM 1500
#define MOTOR1MINPWMDEVIATION 10
#define MOTOR2ZEROPWM 1509
#define MOTOR2MINPWMDEVIATION 10
#define SERVOZEROPWM 1420
#define SEGWAYMAXSPEED 10
#define SEGWAYDELAYSPEED 0.1
#define SEGWAYANGLESPEED 8
#define SERVOZEROPWM 1420
#define SERVOMAXANGLE 70
#define BATTERYMINVOLTAGE 82

int8_t axh;
int8_t azh;
int8_t gyh;
float accelerometerAngle;
float gyroAngle=0;
float gyroAngleSpeed;
float accelerometerGyroRatio=0.01;
float angle;
float kp=5; //7
float ki=0.08; //1.4
float kd=5; //3
float integral, prevInput, error, deltaInput;
float balansingSpeed;
int16_t motor1Speed=0;
int16_t motor2Speed=0;
float weightCompensation=0.025;//0.007;
float angleZeroCompensation=0;
int8_t move=0;
float segwaySpeed=0;
float angleSpeed=0;
uint16_t servoAnglePWM=0;
uint8_t batteryVoltage=0;

uint8_t MPU6050ReadReg(uint8_t regaddr)	{
	I2C_GenerateSTART(ENABLE);
	while (!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
	I2C_Send7bitAddress((MPU6050_DEFAULT_ADDRESS<<1), I2C_DIRECTION_TX); // Device address and direction
	while (!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
	I2C_SendData(regaddr); // Mode register
	while (!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
	I2C_GenerateSTOP(ENABLE); // Generating Stop - Ре-Старт не прокатывает без Стоп-а
	I2C_GenerateSTART(ENABLE);
	while (!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
	I2C_Send7bitAddress((MPU6050_DEFAULT_ADDRESS<<1), I2C_DIRECTION_RX); // Device address and direction
	while (!I2C_CheckEvent(I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED));
	I2C_AcknowledgeConfig(I2C_ACK_NONE); //вместо I2C->CR2 &= ~I2C_CR2_ACK; оба варианта правильные // Sending NACK, so slave will release SDA - Без NACK-а слейв не освобождает линию
	I2C_GenerateSTOP(ENABLE); // Send STOP Condition
	while (!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_RECEIVED));
	return I2C_ReceiveData(); // Reading data from the buffer
}

void MPU6050WriteReg(uint8_t Reg, uint8_t Value)	{
	I2C_GenerateSTART(ENABLE);
	while (!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
	I2C_Send7bitAddress((MPU6050_DEFAULT_ADDRESS<<1), I2C_DIRECTION_TX); // Selecting write mode
	while (!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
	I2C_SendData(Reg); // Sending register name
	while (!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
	I2C_SendData(Value); // Sending register value
	while (!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
	I2C_GenerateSTOP(ENABLE); // Send STOP Condition
}

void MPU6050WriteBits(uint8_t regAddr, uint8_t bitStart, uint8_t length, uint8_t data)	{
	uint8_t tmp, mask;
	tmp=MPU6050ReadReg(regAddr);
	mask=((1<<length)-1)<<(bitStart-length+1);
	data <<= (bitStart - length + 1); // shift data into correct position
	data &= mask; // zero all non-important bits in data
  tmp &= ~(mask); // zero all important bits in existing byte
  tmp |= data; // combine data with existing byte
	MPU6050WriteReg(regAddr,tmp);
}

void MPU6050Config(void)	{
	MPU6050WriteBits(	MPU6050_RA_PWR_MGMT_1,
										MPU6050_PWR1_CLKSEL_BIT,
										MPU6050_PWR1_CLKSEL_LENGTH,
										MPU6050_CLOCK_PLL_XGYRO); // Setting clocking source from Gyro X axis
	MPU6050WriteBits(	MPU6050_RA_GYRO_CONFIG,
										MPU6050_GCONFIG_FS_SEL_BIT,
										MPU6050_GCONFIG_FS_SEL_LENGTH,
										MPU6050_GYRO_FS_250);
	MPU6050WriteBits(	MPU6050_RA_ACCEL_CONFIG,
										MPU6050_ACONFIG_AFS_SEL_BIT,
										MPU6050_ACONFIG_AFS_SEL_LENGTH,
										MPU6050_ACCEL_FS_2);
	MPU6050WriteBits(	MPU6050_RA_PWR_MGMT_1,
										MPU6050_PWR1_SLEEP_BIT,
										1,
										0);
}

void setMotor1Speed(int8_t speed)	{
	static int8_t previousSpeed;
	if(speed-previousSpeed>MOTORMAXSPEEDDELTA) speed=previousSpeed+MOTORMAXSPEEDDELTA;
	else if(speed-previousSpeed<-MOTORMAXSPEEDDELTA) speed=previousSpeed-MOTORMAXSPEEDDELTA;
	previousSpeed=speed;
	if(speed>0) speed=speed+MOTOR1MINPWMDEVIATION;
	else if(speed<0) speed=speed-MOTOR1MINPWMDEVIATION;
	TIM2_SetCompare1(MOTOR1ZEROPWM-speed);
}

void setMotor2Speed(int8_t speed)	{
	static int8_t previousSpeed;
	if(speed-previousSpeed>MOTORMAXSPEEDDELTA) speed=previousSpeed+MOTORMAXSPEEDDELTA;
	else if(speed-previousSpeed<-MOTORMAXSPEEDDELTA) speed=previousSpeed-MOTORMAXSPEEDDELTA;
	previousSpeed=speed;
	if(speed>0) speed=speed+MOTOR2MINPWMDEVIATION;
	else if(speed<0) speed=speed-MOTOR2MINPWMDEVIATION;
	TIM2_SetCompare2(MOTOR2ZEROPWM+speed);
}

uint8_t receive;
@far @interrupt void uartReceive(void)	{
	UART1_ClearITPendingBit(UART1_IT_RXNE);
	receive=UART1_ReceiveData8();
	switch (receive)	{
		case 1:
			move=1;
		break;			
		case 2:
			move=0;
		break;
		case 3:
			move=-1;
		break;
		case 4:
			move=0;
		break;
		case 5:
			angleSpeed=SEGWAYANGLESPEED;
		break;
		case 6:
			angleSpeed=0;
		break;
		case 7:
			angleSpeed=-SEGWAYANGLESPEED;
		break;
		case 8:
			angleSpeed=0;
		break;
	}
}

void uartTransmit(uint8_t data){
	while(!UART1_SR_TXE);
	UART1->DR = data;
}

void accelerometerAngleCalc(void)	{
	axh=(int8_t)MPU6050ReadReg(MPU6050_RA_ACCEL_XOUT_H);
	azh=(int8_t)MPU6050ReadReg(MPU6050_RA_ACCEL_ZOUT_H);
	accelerometerAngle=atan((float)azh/(float)axh)*57.296;
}

void gyroAngleCalc(void)	{
	gyh=(int8_t)MPU6050ReadReg(MPU6050_RA_GYRO_YOUT_H);
	gyroAngleSpeed=(float)gyh/21;
	gyroAngle=gyroAngle+gyroAngleSpeed;
}

@far @interrupt void tim2Update(void)	{
	TIM2_ClearITPendingBit(TIM2_IT_UPDATE);
	batteryVoltage=(uint8_t)(ADC1_GetConversionValue()>>2);
	uartTransmit(batteryVoltage);
	accelerometerAngleCalc();
	gyroAngleCalc();
	gyroAngle=accelerometerGyroRatio*accelerometerAngle+(1-accelerometerGyroRatio)*gyroAngle;
	angle=gyroAngle+angleZeroCompensation;
	error=0-angle;
	deltaInput=prevInput-angle;
	prevInput=angle;
	balansingSpeed=0;
	balansingSpeed+=error*kp;
	balansingSpeed+=deltaInput*kd;
	integral+=error*ki;
	balansingSpeed+=integral;
	balansingSpeed=balansingSpeed>MOTORMAXPWM?MOTORMAXPWM:balansingSpeed;
	balansingSpeed=balansingSpeed<-MOTORMAXPWM?-MOTORMAXPWM:balansingSpeed;
	if(TIM1_GetCapture2()>1600) move=1;
	else if(TIM1_GetCapture2()<1200&TIM1_GetCapture2()!=0) move=-1;
	else if(receive==2|receive==4|receive==0) move=0;
	if(TIM1_GetCapture4()-TIM1_GetCapture3()>1600) angleSpeed=-SEGWAYANGLESPEED;
	else if(TIM1_GetCapture4()-TIM1_GetCapture3()<1200&TIM1_GetCapture4()-TIM1_GetCapture3()!=0) angleSpeed=SEGWAYANGLESPEED;
	else if(receive==6|receive==8|receive==0) angleSpeed=0;
	if(move==1&segwaySpeed>-SEGWAYMAXSPEED) segwaySpeed-=SEGWAYDELAYSPEED;
	if(move==-1&segwaySpeed<SEGWAYMAXSPEED) segwaySpeed+=SEGWAYDELAYSPEED;
	if(move==0)
		if(segwaySpeed>0) segwaySpeed-=SEGWAYDELAYSPEED;
		else if(segwaySpeed<0) segwaySpeed+=SEGWAYDELAYSPEED;
	if(accelerometerAngle<40&accelerometerAngle>-40)	{
		motor1Speed=balansingSpeed+segwaySpeed+angleSpeed;
		motor2Speed=balansingSpeed+segwaySpeed-angleSpeed;
		motor1Speed=motor1Speed>127?127:(motor1Speed<-127?-127:motor1Speed);
		motor2Speed=motor2Speed>127?127:(motor2Speed<-127?-127:motor2Speed);
		if(batteryVoltage>BATTERYMINVOLTAGE)	{
			setMotor1Speed((int8_t)motor1Speed);
			setMotor2Speed((int8_t)motor2Speed);	
		}
	}
	else {
		if(batteryVoltage>BATTERYMINVOLTAGE)	{
			setMotor1Speed(0);
			setMotor2Speed(0);	
		}
	}
	balansingSpeed=balansingSpeed*(balansingSpeed<0?-1:1);
	if(angle>0&angleZeroCompensation<90) angleZeroCompensation+=weightCompensation*balansingSpeed;
	else if(angle<0&angleZeroCompensation>-90) angleZeroCompensation-=weightCompensation*balansingSpeed;
	servoAnglePWM=SERVOZEROPWM+gyroAngle*10;
	if(500<(TIM1_GetCapture3()-TIM1_GetCapture2())&(TIM1_GetCapture3()-TIM1_GetCapture2())<2500)	servoAnglePWM+=(SERVOZEROPWM-(TIM1_GetCapture3()-TIM1_GetCapture2()));
	if(servoAnglePWM>(uint16_t)(SERVOZEROPWM+SERVOMAXANGLE*10)) servoAnglePWM=SERVOZEROPWM+SERVOMAXANGLE*10;
	else if(servoAnglePWM<SERVOZEROPWM-SERVOMAXANGLE*10) servoAnglePWM=SERVOZEROPWM-SERVOMAXANGLE*10;
	TIM2_SetCompare3(servoAnglePWM);
}

void Delay(uint32_t t)	{
	uint16_t i;
	while(t>0) {
		t--;
		for(i=1000;i>0;i--);
	}
}

main()	{
	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1|CLK_PRESCALER_CPUDIV1);
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, ENABLE);
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE);
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, ENABLE);
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_I2C, ENABLE);
	Delay(900);
	UART1_DeInit();
	UART1_Init(	57600,
							UART1_WORDLENGTH_8D,
							UART1_STOPBITS_1,
							UART1_PARITY_NO,
							UART1_SYNCMODE_CLOCK_DISABLE,
							UART1_MODE_TXRX_ENABLE);
	UART1_ITConfig(	UART1_IT_RXNE, ENABLE);
	UART1_Cmd(ENABLE);
	TIM2_DeInit();
	TIM2_TimeBaseInit(	TIM2_PRESCALER_16,
											20000);
	TIM2_OC1Init(				TIM2_OCMODE_PWM1,
											TIM2_OUTPUTSTATE_ENABLE,
											200,
											TIM2_OCPOLARITY_HIGH);
	TIM2_OC2Init(				TIM2_OCMODE_PWM1,
											TIM2_OUTPUTSTATE_ENABLE,
											200,
											TIM2_OCPOLARITY_HIGH);	TIM2_Cmd(ENABLE);
	TIM2_OC3Init(				TIM2_OCMODE_PWM1,
											TIM2_OUTPUTSTATE_ENABLE,
											200,
											TIM2_OCPOLARITY_HIGH);
	TIM2_SetCompare1(MOTOR1ZEROPWM);
	TIM2_SetCompare2(MOTOR1ZEROPWM);
	TIM2_SetCompare3(SERVOZEROPWM);
	TIM2_ITConfig(TIM2_IT_UPDATE,ENABLE);
	TIM2_Cmd(ENABLE);
	I2C_DeInit();
	I2C_Init(	100000,
						0x3232,
						I2C_DUTYCYCLE_2,
						I2C_ACK_CURR,
						I2C_ADDMODE_7BIT,
						16);
	I2C_Cmd(ENABLE);
	TIM1_DeInit();
	TIM1_TimeBaseInit(	16000/50/20,
											TIM1_COUNTERMODE_UP,
											20000,
											0);
	TIM1_ICInit(	TIM1_CHANNEL_1,	// К регстру TIM1_CCR1
								TIM1_ICPOLARITY_RISING,	// срабатывает на восходящем фронте
								TIM1_ICSELECTION_DIRECTTI,	// подключен прямой вход TIM1_CH1
								TIM1_ICPSC_DIV1,	
								0);
	TIM1_ICInit(	TIM1_CHANNEL_2, // К регстру TIM1_CCR2
								TIM1_ICPOLARITY_FALLING, // срабатывает на спадающем фронте
								TIM1_ICSELECTION_INDIRECTTI, // подключен непрямой вход TIM1_CH1 (прямой для него TIM1_CH2)
								TIM1_ICPSC_DIV1,
								0);
	TIM1_ICInit(	TIM1_CHANNEL_3,	// К регстру TIM1_CCR3
								TIM1_ICPOLARITY_FALLING,	// срабатывает на спадающем фронте
								TIM1_ICSELECTION_DIRECTTI,	// подключен прямой вход TIM1_CH3
								TIM1_ICPSC_DIV1,	
								0);
	TIM1_ICInit(	TIM1_CHANNEL_4, // К регстру TIM1_CCR4
								TIM1_ICPOLARITY_FALLING, // срабатывает на спадающем фронте
								TIM1_ICSELECTION_DIRECTTI, // подключен прямой вход TIM1_CH4
								TIM1_ICPSC_DIV1,
								0);
	TIM1_SelectInputTrigger(TIM1_TS_TI1FP1); // Действием таймера управляет вход TIM1_CH1
	TIM1_SelectSlaveMode(TIM1_SLAVEMODE_RESET); // Действие таймера - сброс
	TIM1_CCxCmd(TIM1_CHANNEL_2, ENABLE); // Разрешить захват для регистра TIM1_CCR2
	TIM1_CCxCmd(TIM1_CHANNEL_3, ENABLE); // Разрешить захват для регистра TIM1_CCR3
	TIM1_CCxCmd(TIM1_CHANNEL_4, ENABLE); // Разрешить захват для регистра TIM1_CCR4
	TIM1_Cmd(ENABLE);
	ADC1_DeInit();
	ADC1_Init(	ADC1_CONVERSIONMODE_CONTINUOUS,
							ADC1_CHANNEL_3,
							ADC1_PRESSEL_FCPU_D2,
							ADC1_EXTTRIG_TIM,
							DISABLE,
							ADC1_ALIGN_RIGHT,
							ADC1_SCHMITTTRIG_CHANNEL3,
							DISABLE);
	ADC1_Cmd(ENABLE);
	ADC1_StartConversion();
	MPU6050Config();
	Delay(100);
	accelerometerAngleCalc();
	gyroAngle=accelerometerAngle;
	enableInterrupts();
	while (1);
}