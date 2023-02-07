   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
  17                     	bsct
  18  0000               _gyroAngle:
  19  0000 00000000      	dc.w	0,0
  20  0004               _accelerometerGyroRatio:
  21  0004 3c23d70a      	dc.w	15395,-10486
  22  0008               _kp:
  23  0008 40a00000      	dc.w	16544,0
  24  000c               _ki:
  25  000c 3da3d70a      	dc.w	15779,-10486
  26  0010               _kd:
  27  0010 40a00000      	dc.w	16544,0
  28  0014               _motor1Speed:
  29  0014 0000          	dc.w	0
  30  0016               _motor2Speed:
  31  0016 0000          	dc.w	0
  32  0018               _weightCompensation:
  33  0018 3ccccccc      	dc.w	15564,-13108
  34  001c               _angleZeroCompensation:
  35  001c 00000000      	dc.w	0,0
  36  0020               _move:
  37  0020 00            	dc.b	0
  38  0021               _segwaySpeed:
  39  0021 00000000      	dc.w	0,0
  40  0025               _angleSpeed:
  41  0025 00000000      	dc.w	0,0
  42  0029               _servoAnglePWM:
  43  0029 0000          	dc.w	0
  44  002b               _batteryVoltage:
  45  002b 00            	dc.b	0
  92                     ; 47 uint8_t MPU6050ReadReg(uint8_t regaddr)	{
  94                     .text:	section	.text,new
  95  0000               _MPU6050ReadReg:
  97  0000 88            	push	a
  98       00000000      OFST:	set	0
 101                     ; 48 	I2C_GenerateSTART(ENABLE);
 103  0001 a601          	ld	a,#1
 104  0003 cd0000        	call	_I2C_GenerateSTART
 107  0006               L13:
 108                     ; 49 	while (!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
 110  0006 ae0301        	ldw	x,#769
 111  0009 cd0000        	call	_I2C_CheckEvent
 113  000c 4d            	tnz	a
 114  000d 27f7          	jreq	L13
 115                     ; 50 	I2C_Send7bitAddress((MPU6050_DEFAULT_ADDRESS<<1), I2C_DIRECTION_TX); // Device address and direction
 117  000f aed000        	ldw	x,#53248
 118  0012 cd0000        	call	_I2C_Send7bitAddress
 121  0015               L73:
 122                     ; 51 	while (!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
 124  0015 ae0782        	ldw	x,#1922
 125  0018 cd0000        	call	_I2C_CheckEvent
 127  001b 4d            	tnz	a
 128  001c 27f7          	jreq	L73
 129                     ; 52 	I2C_SendData(regaddr); // Mode register
 131  001e 7b01          	ld	a,(OFST+1,sp)
 132  0020 cd0000        	call	_I2C_SendData
 135  0023               L54:
 136                     ; 53 	while (!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
 138  0023 ae0784        	ldw	x,#1924
 139  0026 cd0000        	call	_I2C_CheckEvent
 141  0029 4d            	tnz	a
 142  002a 27f7          	jreq	L54
 143                     ; 54 	I2C_GenerateSTOP(ENABLE); // Generating Stop - Ре-Старт не прокатывает без Стоп-а
 145  002c a601          	ld	a,#1
 146  002e cd0000        	call	_I2C_GenerateSTOP
 148                     ; 55 	I2C_GenerateSTART(ENABLE);
 150  0031 a601          	ld	a,#1
 151  0033 cd0000        	call	_I2C_GenerateSTART
 154  0036               L35:
 155                     ; 56 	while (!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
 157  0036 ae0301        	ldw	x,#769
 158  0039 cd0000        	call	_I2C_CheckEvent
 160  003c 4d            	tnz	a
 161  003d 27f7          	jreq	L35
 162                     ; 57 	I2C_Send7bitAddress((MPU6050_DEFAULT_ADDRESS<<1), I2C_DIRECTION_RX); // Device address and direction
 164  003f aed001        	ldw	x,#53249
 165  0042 cd0000        	call	_I2C_Send7bitAddress
 168  0045               L16:
 169                     ; 58 	while (!I2C_CheckEvent(I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED));
 171  0045 ae0302        	ldw	x,#770
 172  0048 cd0000        	call	_I2C_CheckEvent
 174  004b 4d            	tnz	a
 175  004c 27f7          	jreq	L16
 176                     ; 59 	I2C_AcknowledgeConfig(I2C_ACK_NONE); //вместо I2C->CR2 &= ~I2C_CR2_ACK; оба варианта правильные // Sending NACK, so slave will release SDA - Без NACK-а слейв не освобождает линию
 178  004e 4f            	clr	a
 179  004f cd0000        	call	_I2C_AcknowledgeConfig
 181                     ; 60 	I2C_GenerateSTOP(ENABLE); // Send STOP Condition
 183  0052 a601          	ld	a,#1
 184  0054 cd0000        	call	_I2C_GenerateSTOP
 187  0057               L76:
 188                     ; 61 	while (!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_RECEIVED));
 190  0057 ae0340        	ldw	x,#832
 191  005a cd0000        	call	_I2C_CheckEvent
 193  005d 4d            	tnz	a
 194  005e 27f7          	jreq	L76
 195                     ; 62 	return I2C_ReceiveData(); // Reading data from the buffer
 197  0060 cd0000        	call	_I2C_ReceiveData
 201  0063 5b01          	addw	sp,#1
 202  0065 81            	ret
 250                     ; 65 void MPU6050WriteReg(uint8_t Reg, uint8_t Value)	{
 251                     .text:	section	.text,new
 252  0000               _MPU6050WriteReg:
 254  0000 89            	pushw	x
 255       00000000      OFST:	set	0
 258                     ; 66 	I2C_GenerateSTART(ENABLE);
 260  0001 a601          	ld	a,#1
 261  0003 cd0000        	call	_I2C_GenerateSTART
 264  0006               L711:
 265                     ; 67 	while (!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
 267  0006 ae0301        	ldw	x,#769
 268  0009 cd0000        	call	_I2C_CheckEvent
 270  000c 4d            	tnz	a
 271  000d 27f7          	jreq	L711
 272                     ; 68 	I2C_Send7bitAddress((MPU6050_DEFAULT_ADDRESS<<1), I2C_DIRECTION_TX); // Selecting write mode
 274  000f aed000        	ldw	x,#53248
 275  0012 cd0000        	call	_I2C_Send7bitAddress
 278  0015               L521:
 279                     ; 69 	while (!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
 281  0015 ae0782        	ldw	x,#1922
 282  0018 cd0000        	call	_I2C_CheckEvent
 284  001b 4d            	tnz	a
 285  001c 27f7          	jreq	L521
 286                     ; 70 	I2C_SendData(Reg); // Sending register name
 288  001e 7b01          	ld	a,(OFST+1,sp)
 289  0020 cd0000        	call	_I2C_SendData
 292  0023               L331:
 293                     ; 71 	while (!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
 295  0023 ae0784        	ldw	x,#1924
 296  0026 cd0000        	call	_I2C_CheckEvent
 298  0029 4d            	tnz	a
 299  002a 27f7          	jreq	L331
 300                     ; 72 	I2C_SendData(Value); // Sending register value
 302  002c 7b02          	ld	a,(OFST+2,sp)
 303  002e cd0000        	call	_I2C_SendData
 306  0031               L141:
 307                     ; 73 	while (!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
 309  0031 ae0784        	ldw	x,#1924
 310  0034 cd0000        	call	_I2C_CheckEvent
 312  0037 4d            	tnz	a
 313  0038 27f7          	jreq	L141
 314                     ; 74 	I2C_GenerateSTOP(ENABLE); // Send STOP Condition
 316  003a a601          	ld	a,#1
 317  003c cd0000        	call	_I2C_GenerateSTOP
 319                     ; 75 }
 322  003f 85            	popw	x
 323  0040 81            	ret
 404                     ; 77 void MPU6050WriteBits(uint8_t regAddr, uint8_t bitStart, uint8_t length, uint8_t data)	{
 405                     .text:	section	.text,new
 406  0000               _MPU6050WriteBits:
 408  0000 89            	pushw	x
 409  0001 89            	pushw	x
 410       00000002      OFST:	set	2
 413                     ; 79 	tmp=MPU6050ReadReg(regAddr);
 415  0002 9e            	ld	a,xh
 416  0003 cd0000        	call	_MPU6050ReadReg
 418  0006 6b02          	ld	(OFST+0,sp),a
 419                     ; 80 	mask=((1<<length)-1)<<(bitStart-length+1);
 421  0008 7b04          	ld	a,(OFST+2,sp)
 422  000a 1007          	sub	a,(OFST+5,sp)
 423  000c 4c            	inc	a
 424  000d 5f            	clrw	x
 425  000e 97            	ld	xl,a
 426  000f 7b07          	ld	a,(OFST+5,sp)
 427  0011 905f          	clrw	y
 428  0013 9097          	ld	yl,a
 429  0015 a601          	ld	a,#1
 430  0017 905d          	tnzw	y
 431  0019 2705          	jreq	L21
 432  001b               L41:
 433  001b 48            	sll	a
 434  001c 905a          	decw	y
 435  001e 26fb          	jrne	L41
 436  0020               L21:
 437  0020 4a            	dec	a
 438  0021 5d            	tnzw	x
 439  0022 2704          	jreq	L61
 440  0024               L02:
 441  0024 48            	sll	a
 442  0025 5a            	decw	x
 443  0026 26fc          	jrne	L02
 444  0028               L61:
 445  0028 6b01          	ld	(OFST-1,sp),a
 446                     ; 81 	data <<= (bitStart - length + 1); // shift data into correct position
 448  002a 7b04          	ld	a,(OFST+2,sp)
 449  002c 1007          	sub	a,(OFST+5,sp)
 450  002e 4c            	inc	a
 451  002f 5f            	clrw	x
 452  0030 97            	ld	xl,a
 453  0031 7b08          	ld	a,(OFST+6,sp)
 454  0033 5d            	tnzw	x
 455  0034 2704          	jreq	L22
 456  0036               L42:
 457  0036 48            	sll	a
 458  0037 5a            	decw	x
 459  0038 26fc          	jrne	L42
 460  003a               L22:
 461  003a 6b08          	ld	(OFST+6,sp),a
 462                     ; 82 	data &= mask; // zero all non-important bits in data
 464  003c 7b08          	ld	a,(OFST+6,sp)
 465  003e 1401          	and	a,(OFST-1,sp)
 466  0040 6b08          	ld	(OFST+6,sp),a
 467                     ; 83   tmp &= ~(mask); // zero all important bits in existing byte
 469  0042 7b01          	ld	a,(OFST-1,sp)
 470  0044 43            	cpl	a
 471  0045 1402          	and	a,(OFST+0,sp)
 472  0047 6b02          	ld	(OFST+0,sp),a
 473                     ; 84   tmp |= data; // combine data with existing byte
 475  0049 7b02          	ld	a,(OFST+0,sp)
 476  004b 1a08          	or	a,(OFST+6,sp)
 477  004d 6b02          	ld	(OFST+0,sp),a
 478                     ; 85 	MPU6050WriteReg(regAddr,tmp);
 480  004f 7b02          	ld	a,(OFST+0,sp)
 481  0051 97            	ld	xl,a
 482  0052 7b03          	ld	a,(OFST+1,sp)
 483  0054 95            	ld	xh,a
 484  0055 cd0000        	call	_MPU6050WriteReg
 486                     ; 86 }
 489  0058 5b04          	addw	sp,#4
 490  005a 81            	ret
 514                     ; 88 void MPU6050Config(void)	{
 515                     .text:	section	.text,new
 516  0000               _MPU6050Config:
 520                     ; 89 	MPU6050WriteBits(	MPU6050_RA_PWR_MGMT_1,
 520                     ; 90 										MPU6050_PWR1_CLKSEL_BIT,
 520                     ; 91 										MPU6050_PWR1_CLKSEL_LENGTH,
 520                     ; 92 										MPU6050_CLOCK_PLL_XGYRO); // Setting clocking source from Gyro X axis
 522  0000 4b01          	push	#1
 523  0002 4b03          	push	#3
 524  0004 ae6b02        	ldw	x,#27394
 525  0007 cd0000        	call	_MPU6050WriteBits
 527  000a 85            	popw	x
 528                     ; 93 	MPU6050WriteBits(	MPU6050_RA_GYRO_CONFIG,
 528                     ; 94 										MPU6050_GCONFIG_FS_SEL_BIT,
 528                     ; 95 										MPU6050_GCONFIG_FS_SEL_LENGTH,
 528                     ; 96 										MPU6050_GYRO_FS_250);
 530  000b 4b00          	push	#0
 531  000d 4b02          	push	#2
 532  000f ae1b04        	ldw	x,#6916
 533  0012 cd0000        	call	_MPU6050WriteBits
 535  0015 85            	popw	x
 536                     ; 97 	MPU6050WriteBits(	MPU6050_RA_ACCEL_CONFIG,
 536                     ; 98 										MPU6050_ACONFIG_AFS_SEL_BIT,
 536                     ; 99 										MPU6050_ACONFIG_AFS_SEL_LENGTH,
 536                     ; 100 										MPU6050_ACCEL_FS_2);
 538  0016 4b00          	push	#0
 539  0018 4b02          	push	#2
 540  001a ae1c04        	ldw	x,#7172
 541  001d cd0000        	call	_MPU6050WriteBits
 543  0020 85            	popw	x
 544                     ; 101 	MPU6050WriteBits(	MPU6050_RA_PWR_MGMT_1,
 544                     ; 102 										MPU6050_PWR1_SLEEP_BIT,
 544                     ; 103 										1,
 544                     ; 104 										0);
 546  0021 4b00          	push	#0
 547  0023 4b01          	push	#1
 548  0025 ae6b06        	ldw	x,#27398
 549  0028 cd0000        	call	_MPU6050WriteBits
 551  002b 85            	popw	x
 552                     ; 105 }
 555  002c 81            	ret
 558                     	switch	.ubsct
 559  0000               L712_previousSpeed:
 560  0000 00            	ds.b	1
 602                     ; 107 void setMotor1Speed(int8_t speed)	{
 603                     .text:	section	.text,new
 604  0000               _setMotor1Speed:
 606  0000 88            	push	a
 607  0001 89            	pushw	x
 608       00000002      OFST:	set	2
 611                     ; 109 	if(speed-previousSpeed>MOTORMAXSPEEDDELTA) speed=previousSpeed+MOTORMAXSPEEDDELTA;
 613  0002 9c            	rvf
 614  0003 5f            	clrw	x
 615  0004 b600          	ld	a,L712_previousSpeed
 616  0006 2a01          	jrpl	L23
 617  0008 53            	cplw	x
 618  0009               L23:
 619  0009 97            	ld	xl,a
 620  000a 1f01          	ldw	(OFST-1,sp),x
 621  000c 7b03          	ld	a,(OFST+1,sp)
 622  000e 5f            	clrw	x
 623  000f 4d            	tnz	a
 624  0010 2a01          	jrpl	L43
 625  0012 53            	cplw	x
 626  0013               L43:
 627  0013 97            	ld	xl,a
 628  0014 72f001        	subw	x,(OFST-1,sp)
 629  0017 a30029        	cpw	x,#41
 630  001a 2f08          	jrslt	L342
 633  001c b600          	ld	a,L712_previousSpeed
 634  001e ab28          	add	a,#40
 635  0020 6b03          	ld	(OFST+1,sp),a
 637  0022 2020          	jra	L542
 638  0024               L342:
 639                     ; 110 	else if(speed-previousSpeed<-MOTORMAXSPEEDDELTA) speed=previousSpeed-MOTORMAXSPEEDDELTA;
 641  0024 9c            	rvf
 642  0025 5f            	clrw	x
 643  0026 b600          	ld	a,L712_previousSpeed
 644  0028 2a01          	jrpl	L63
 645  002a 53            	cplw	x
 646  002b               L63:
 647  002b 97            	ld	xl,a
 648  002c 1f01          	ldw	(OFST-1,sp),x
 649  002e 7b03          	ld	a,(OFST+1,sp)
 650  0030 5f            	clrw	x
 651  0031 4d            	tnz	a
 652  0032 2a01          	jrpl	L04
 653  0034 53            	cplw	x
 654  0035               L04:
 655  0035 97            	ld	xl,a
 656  0036 72f001        	subw	x,(OFST-1,sp)
 657  0039 a3ffd8        	cpw	x,#65496
 658  003c 2e06          	jrsge	L542
 661  003e b600          	ld	a,L712_previousSpeed
 662  0040 a028          	sub	a,#40
 663  0042 6b03          	ld	(OFST+1,sp),a
 664  0044               L542:
 665                     ; 111 	previousSpeed=speed;
 667  0044 7b03          	ld	a,(OFST+1,sp)
 668  0046 b700          	ld	L712_previousSpeed,a
 669                     ; 112 	if(speed>0) speed=speed+MOTOR1MINPWMDEVIATION;
 671  0048 9c            	rvf
 672  0049 7b03          	ld	a,(OFST+1,sp)
 673  004b a100          	cp	a,#0
 674  004d 2d08          	jrsle	L152
 677  004f 7b03          	ld	a,(OFST+1,sp)
 678  0051 ab0a          	add	a,#10
 679  0053 6b03          	ld	(OFST+1,sp),a
 681  0055 200d          	jra	L352
 682  0057               L152:
 683                     ; 113 	else if(speed<0) speed=speed-MOTOR1MINPWMDEVIATION;
 685  0057 9c            	rvf
 686  0058 7b03          	ld	a,(OFST+1,sp)
 687  005a a100          	cp	a,#0
 688  005c 2e06          	jrsge	L352
 691  005e 7b03          	ld	a,(OFST+1,sp)
 692  0060 a00a          	sub	a,#10
 693  0062 6b03          	ld	(OFST+1,sp),a
 694  0064               L352:
 695                     ; 114 	TIM2_SetCompare1(MOTOR1ZEROPWM-speed);
 697  0064 7b03          	ld	a,(OFST+1,sp)
 698  0066 5f            	clrw	x
 699  0067 4d            	tnz	a
 700  0068 2a01          	jrpl	L24
 701  006a 53            	cplw	x
 702  006b               L24:
 703  006b 97            	ld	xl,a
 704  006c 1f01          	ldw	(OFST-1,sp),x
 705  006e ae05dc        	ldw	x,#1500
 706  0071 72f001        	subw	x,(OFST-1,sp)
 707  0074 cd0000        	call	_TIM2_SetCompare1
 709                     ; 115 }
 712  0077 5b03          	addw	sp,#3
 713  0079 81            	ret
 716                     	switch	.ubsct
 717  0001               L752_previousSpeed:
 718  0001 00            	ds.b	1
 760                     ; 117 void setMotor2Speed(int8_t speed)	{
 761                     .text:	section	.text,new
 762  0000               _setMotor2Speed:
 764  0000 88            	push	a
 765  0001 89            	pushw	x
 766       00000002      OFST:	set	2
 769                     ; 119 	if(speed-previousSpeed>MOTORMAXSPEEDDELTA) speed=previousSpeed+MOTORMAXSPEEDDELTA;
 771  0002 9c            	rvf
 772  0003 5f            	clrw	x
 773  0004 b601          	ld	a,L752_previousSpeed
 774  0006 2a01          	jrpl	L64
 775  0008 53            	cplw	x
 776  0009               L64:
 777  0009 97            	ld	xl,a
 778  000a 1f01          	ldw	(OFST-1,sp),x
 779  000c 7b03          	ld	a,(OFST+1,sp)
 780  000e 5f            	clrw	x
 781  000f 4d            	tnz	a
 782  0010 2a01          	jrpl	L05
 783  0012 53            	cplw	x
 784  0013               L05:
 785  0013 97            	ld	xl,a
 786  0014 72f001        	subw	x,(OFST-1,sp)
 787  0017 a30029        	cpw	x,#41
 788  001a 2f08          	jrslt	L303
 791  001c b601          	ld	a,L752_previousSpeed
 792  001e ab28          	add	a,#40
 793  0020 6b03          	ld	(OFST+1,sp),a
 795  0022 2020          	jra	L503
 796  0024               L303:
 797                     ; 120 	else if(speed-previousSpeed<-MOTORMAXSPEEDDELTA) speed=previousSpeed-MOTORMAXSPEEDDELTA;
 799  0024 9c            	rvf
 800  0025 5f            	clrw	x
 801  0026 b601          	ld	a,L752_previousSpeed
 802  0028 2a01          	jrpl	L25
 803  002a 53            	cplw	x
 804  002b               L25:
 805  002b 97            	ld	xl,a
 806  002c 1f01          	ldw	(OFST-1,sp),x
 807  002e 7b03          	ld	a,(OFST+1,sp)
 808  0030 5f            	clrw	x
 809  0031 4d            	tnz	a
 810  0032 2a01          	jrpl	L45
 811  0034 53            	cplw	x
 812  0035               L45:
 813  0035 97            	ld	xl,a
 814  0036 72f001        	subw	x,(OFST-1,sp)
 815  0039 a3ffd8        	cpw	x,#65496
 816  003c 2e06          	jrsge	L503
 819  003e b601          	ld	a,L752_previousSpeed
 820  0040 a028          	sub	a,#40
 821  0042 6b03          	ld	(OFST+1,sp),a
 822  0044               L503:
 823                     ; 121 	previousSpeed=speed;
 825  0044 7b03          	ld	a,(OFST+1,sp)
 826  0046 b701          	ld	L752_previousSpeed,a
 827                     ; 122 	if(speed>0) speed=speed+MOTOR2MINPWMDEVIATION;
 829  0048 9c            	rvf
 830  0049 7b03          	ld	a,(OFST+1,sp)
 831  004b a100          	cp	a,#0
 832  004d 2d08          	jrsle	L113
 835  004f 7b03          	ld	a,(OFST+1,sp)
 836  0051 ab0a          	add	a,#10
 837  0053 6b03          	ld	(OFST+1,sp),a
 839  0055 200d          	jra	L313
 840  0057               L113:
 841                     ; 123 	else if(speed<0) speed=speed-MOTOR2MINPWMDEVIATION;
 843  0057 9c            	rvf
 844  0058 7b03          	ld	a,(OFST+1,sp)
 845  005a a100          	cp	a,#0
 846  005c 2e06          	jrsge	L313
 849  005e 7b03          	ld	a,(OFST+1,sp)
 850  0060 a00a          	sub	a,#10
 851  0062 6b03          	ld	(OFST+1,sp),a
 852  0064               L313:
 853                     ; 124 	TIM2_SetCompare2(MOTOR2ZEROPWM+speed);
 855  0064 7b03          	ld	a,(OFST+1,sp)
 856  0066 5f            	clrw	x
 857  0067 4d            	tnz	a
 858  0068 2a01          	jrpl	L65
 859  006a 53            	cplw	x
 860  006b               L65:
 861  006b 97            	ld	xl,a
 862  006c 1c05e5        	addw	x,#1509
 863  006f cd0000        	call	_TIM2_SetCompare2
 865                     ; 125 }
 868  0072 5b03          	addw	sp,#3
 869  0074 81            	ret
 897                     ; 128 @far @interrupt void uartReceive(void)	{
 899                     .text:	section	.text,new
 900  0000               f_uartReceive:
 902  0000 8a            	push	cc
 903  0001 84            	pop	a
 904  0002 a4bf          	and	a,#191
 905  0004 88            	push	a
 906  0005 86            	pop	cc
 907  0006 3b0002        	push	c_x+2
 908  0009 be00          	ldw	x,c_x
 909  000b 89            	pushw	x
 910  000c 3b0002        	push	c_y+2
 911  000f be00          	ldw	x,c_y
 912  0011 89            	pushw	x
 913  0012 be02          	ldw	x,c_lreg+2
 914  0014 89            	pushw	x
 915  0015 be00          	ldw	x,c_lreg
 916  0017 89            	pushw	x
 919                     ; 129 	UART1_ClearITPendingBit(UART1_IT_RXNE);
 921  0018 ae0255        	ldw	x,#597
 922  001b cd0000        	call	_UART1_ClearITPendingBit
 924                     ; 130 	receive=UART1_ReceiveData8();
 926  001e cd0000        	call	_UART1_ReceiveData8
 928  0021 b702          	ld	_receive,a
 929                     ; 131 	switch (receive)	{
 931  0023 b602          	ld	a,_receive
 933                     ; 155 		break;
 934  0025 4a            	dec	a
 935  0026 2717          	jreq	L713
 936  0028 4a            	dec	a
 937  0029 271a          	jreq	L123
 938  002b 4a            	dec	a
 939  002c 271b          	jreq	L323
 940  002e 4a            	dec	a
 941  002f 271e          	jreq	L523
 942  0031 4a            	dec	a
 943  0032 271f          	jreq	L723
 944  0034 4a            	dec	a
 945  0035 2729          	jreq	L133
 946  0037 4a            	dec	a
 947  0038 2732          	jreq	L333
 948  003a 4a            	dec	a
 949  003b 273d          	jreq	L533
 950  003d 2045          	jra	L153
 951  003f               L713:
 952                     ; 132 		case 1:
 952                     ; 133 			move=1;
 954  003f 35010020      	mov	_move,#1
 955                     ; 134 		break;			
 957  0043 203f          	jra	L153
 958  0045               L123:
 959                     ; 135 		case 2:
 959                     ; 136 			move=0;
 961  0045 3f20          	clr	_move
 962                     ; 137 		break;
 964  0047 203b          	jra	L153
 965  0049               L323:
 966                     ; 138 		case 3:
 966                     ; 139 			move=-1;
 968  0049 35ff0020      	mov	_move,#255
 969                     ; 140 		break;
 971  004d 2035          	jra	L153
 972  004f               L523:
 973                     ; 141 		case 4:
 973                     ; 142 			move=0;
 975  004f 3f20          	clr	_move
 976                     ; 143 		break;
 978  0051 2031          	jra	L153
 979  0053               L723:
 980                     ; 144 		case 5:
 980                     ; 145 			angleSpeed=SEGWAYANGLESPEED;
 982  0053 a608          	ld	a,#8
 983  0055 cd0000        	call	c_ctof
 985  0058 ae0025        	ldw	x,#_angleSpeed
 986  005b cd0000        	call	c_rtol
 988                     ; 146 		break;
 990  005e 2024          	jra	L153
 991  0060               L133:
 992                     ; 147 		case 6:
 992                     ; 148 			angleSpeed=0;
 994  0060 ae0000        	ldw	x,#0
 995  0063 bf27          	ldw	_angleSpeed+2,x
 996  0065 ae0000        	ldw	x,#0
 997  0068 bf25          	ldw	_angleSpeed,x
 998                     ; 149 		break;
1000  006a 2018          	jra	L153
1001  006c               L333:
1002                     ; 150 		case 7:
1002                     ; 151 			angleSpeed=-SEGWAYANGLESPEED;
1004  006c aefff8        	ldw	x,#65528
1005  006f cd0000        	call	c_itof
1007  0072 ae0025        	ldw	x,#_angleSpeed
1008  0075 cd0000        	call	c_rtol
1010                     ; 152 		break;
1012  0078 200a          	jra	L153
1013  007a               L533:
1014                     ; 153 		case 8:
1014                     ; 154 			angleSpeed=0;
1016  007a ae0000        	ldw	x,#0
1017  007d bf27          	ldw	_angleSpeed+2,x
1018  007f ae0000        	ldw	x,#0
1019  0082 bf25          	ldw	_angleSpeed,x
1020                     ; 155 		break;
1022  0084               L153:
1023                     ; 157 }
1026  0084 85            	popw	x
1027  0085 bf00          	ldw	c_lreg,x
1028  0087 85            	popw	x
1029  0088 bf02          	ldw	c_lreg+2,x
1030  008a 85            	popw	x
1031  008b bf00          	ldw	c_y,x
1032  008d 320002        	pop	c_y+2
1033  0090 85            	popw	x
1034  0091 bf00          	ldw	c_x,x
1035  0093 320002        	pop	c_x+2
1036  0096 80            	iret
1069                     ; 159 void uartTransmit(uint8_t data){
1071                     .text:	section	.text,new
1072  0000               _uartTransmit:
1076                     ; 161 	UART1->DR = data;
1078  0000 c75231        	ld	21041,a
1079                     ; 162 }
1082  0003 81            	ret
1111                     ; 164 void accelerometerAngleCalc(void)	{
1112                     .text:	section	.text,new
1113  0000               _accelerometerAngleCalc:
1115  0000 5204          	subw	sp,#4
1116       00000004      OFST:	set	4
1119                     ; 165 	axh=(int8_t)MPU6050ReadReg(MPU6050_RA_ACCEL_XOUT_H);
1121  0002 a63b          	ld	a,#59
1122  0004 cd0000        	call	_MPU6050ReadReg
1124  0007 b725          	ld	_axh,a
1125                     ; 166 	azh=(int8_t)MPU6050ReadReg(MPU6050_RA_ACCEL_ZOUT_H);
1127  0009 a63f          	ld	a,#63
1128  000b cd0000        	call	_MPU6050ReadReg
1130  000e b724          	ld	_azh,a
1131                     ; 167 	accelerometerAngle=atan((float)azh/(float)axh)*57.296;
1133  0010 5f            	clrw	x
1134  0011 b625          	ld	a,_axh
1135  0013 2a01          	jrpl	L66
1136  0015 53            	cplw	x
1137  0016               L66:
1138  0016 97            	ld	xl,a
1139  0017 cd0000        	call	c_itof
1141  001a 96            	ldw	x,sp
1142  001b 1c0001        	addw	x,#OFST-3
1143  001e cd0000        	call	c_rtol
1145  0021 5f            	clrw	x
1146  0022 b624          	ld	a,_azh
1147  0024 2a01          	jrpl	L07
1148  0026 53            	cplw	x
1149  0027               L07:
1150  0027 97            	ld	xl,a
1151  0028 cd0000        	call	c_itof
1153  002b 96            	ldw	x,sp
1154  002c 1c0001        	addw	x,#OFST-3
1155  002f cd0000        	call	c_fdiv
1157  0032 be02          	ldw	x,c_lreg+2
1158  0034 89            	pushw	x
1159  0035 be00          	ldw	x,c_lreg
1160  0037 89            	pushw	x
1161  0038 cd0000        	call	_atan
1163  003b 5b04          	addw	sp,#4
1164  003d ae0010        	ldw	x,#L504
1165  0040 cd0000        	call	c_fmul
1167  0043 ae001f        	ldw	x,#_accelerometerAngle
1168  0046 cd0000        	call	c_rtol
1170                     ; 168 }
1173  0049 5b04          	addw	sp,#4
1174  004b 81            	ret
1201                     ; 170 void gyroAngleCalc(void)	{
1202                     .text:	section	.text,new
1203  0000               _gyroAngleCalc:
1207                     ; 171 	gyh=(int8_t)MPU6050ReadReg(MPU6050_RA_GYRO_YOUT_H);
1209  0000 a645          	ld	a,#69
1210  0002 cd0000        	call	_MPU6050ReadReg
1212  0005 b723          	ld	_gyh,a
1213                     ; 172 	gyroAngleSpeed=(float)gyh/21;
1215  0007 5f            	clrw	x
1216  0008 b623          	ld	a,_gyh
1217  000a 2a01          	jrpl	L47
1218  000c 53            	cplw	x
1219  000d               L47:
1220  000d 97            	ld	xl,a
1221  000e cd0000        	call	c_itof
1223  0011 ae000c        	ldw	x,#L524
1224  0014 cd0000        	call	c_fdiv
1226  0017 ae001b        	ldw	x,#_gyroAngleSpeed
1227  001a cd0000        	call	c_rtol
1229                     ; 173 	gyroAngle=gyroAngle+gyroAngleSpeed;
1231  001d ae001b        	ldw	x,#_gyroAngleSpeed
1232  0020 cd0000        	call	c_ltor
1234  0023 ae0000        	ldw	x,#_gyroAngle
1235  0026 cd0000        	call	c_fgadd
1237                     ; 174 }
1240  0029 81            	ret
1296                     ; 176 @far @interrupt void tim2Update(void)	{
1298                     .text:	section	.text,new
1299  0000               f_tim2Update:
1301  0000 8a            	push	cc
1302  0001 84            	pop	a
1303  0002 a4bf          	and	a,#191
1304  0004 88            	push	a
1305  0005 86            	pop	cc
1306       00000004      OFST:	set	4
1307  0006 3b0002        	push	c_x+2
1308  0009 be00          	ldw	x,c_x
1309  000b 89            	pushw	x
1310  000c 3b0002        	push	c_y+2
1311  000f be00          	ldw	x,c_y
1312  0011 89            	pushw	x
1313  0012 be02          	ldw	x,c_lreg+2
1314  0014 89            	pushw	x
1315  0015 be00          	ldw	x,c_lreg
1316  0017 89            	pushw	x
1317  0018 5204          	subw	sp,#4
1320                     ; 177 	TIM2_ClearITPendingBit(TIM2_IT_UPDATE);
1322  001a a601          	ld	a,#1
1323  001c cd0000        	call	_TIM2_ClearITPendingBit
1325                     ; 178 	batteryVoltage=(uint8_t)(ADC1_GetConversionValue()>>2);
1327  001f cd0000        	call	_ADC1_GetConversionValue
1329  0022 54            	srlw	x
1330  0023 54            	srlw	x
1331  0024 9f            	ld	a,xl
1332  0025 b72b          	ld	_batteryVoltage,a
1333                     ; 179 	uartTransmit(batteryVoltage);
1335  0027 b62b          	ld	a,_batteryVoltage
1336  0029 cd0000        	call	_uartTransmit
1338                     ; 180 	accelerometerAngleCalc();
1340  002c cd0000        	call	_accelerometerAngleCalc
1342                     ; 181 	gyroAngleCalc();
1344  002f cd0000        	call	_gyroAngleCalc
1346                     ; 182 	gyroAngle=accelerometerGyroRatio*accelerometerAngle+(1-accelerometerGyroRatio)*gyroAngle;
1348  0032 a601          	ld	a,#1
1349  0034 cd0000        	call	c_ctof
1351  0037 ae0004        	ldw	x,#_accelerometerGyroRatio
1352  003a cd0000        	call	c_fsub
1354  003d ae0000        	ldw	x,#_gyroAngle
1355  0040 cd0000        	call	c_fmul
1357  0043 96            	ldw	x,sp
1358  0044 1c0001        	addw	x,#OFST-3
1359  0047 cd0000        	call	c_rtol
1361  004a ae0004        	ldw	x,#_accelerometerGyroRatio
1362  004d cd0000        	call	c_ltor
1364  0050 ae001f        	ldw	x,#_accelerometerAngle
1365  0053 cd0000        	call	c_fmul
1367  0056 96            	ldw	x,sp
1368  0057 1c0001        	addw	x,#OFST-3
1369  005a cd0000        	call	c_fadd
1371  005d ae0000        	ldw	x,#_gyroAngle
1372  0060 cd0000        	call	c_rtol
1374                     ; 183 	angle=gyroAngle+angleZeroCompensation;
1376  0063 ae0000        	ldw	x,#_gyroAngle
1377  0066 cd0000        	call	c_ltor
1379  0069 ae001c        	ldw	x,#_angleZeroCompensation
1380  006c cd0000        	call	c_fadd
1382  006f ae0017        	ldw	x,#_angle
1383  0072 cd0000        	call	c_rtol
1385                     ; 184 	error=0-angle;
1387  0075 ae0017        	ldw	x,#_angle
1388  0078 cd0000        	call	c_ltor
1390  007b cd0000        	call	c_fneg
1392  007e ae000b        	ldw	x,#_error
1393  0081 cd0000        	call	c_rtol
1395                     ; 185 	deltaInput=prevInput-angle;
1397  0084 ae000f        	ldw	x,#_prevInput
1398  0087 cd0000        	call	c_ltor
1400  008a ae0017        	ldw	x,#_angle
1401  008d cd0000        	call	c_fsub
1403  0090 ae0007        	ldw	x,#_deltaInput
1404  0093 cd0000        	call	c_rtol
1406                     ; 186 	prevInput=angle;
1408  0096 be19          	ldw	x,_angle+2
1409  0098 bf11          	ldw	_prevInput+2,x
1410  009a be17          	ldw	x,_angle
1411  009c bf0f          	ldw	_prevInput,x
1412                     ; 187 	balansingSpeed=0;
1414  009e ae0000        	ldw	x,#0
1415  00a1 bf05          	ldw	_balansingSpeed+2,x
1416  00a3 ae0000        	ldw	x,#0
1417  00a6 bf03          	ldw	_balansingSpeed,x
1418                     ; 188 	balansingSpeed+=error*kp;
1420  00a8 ae000b        	ldw	x,#_error
1421  00ab cd0000        	call	c_ltor
1423  00ae ae0008        	ldw	x,#_kp
1424  00b1 cd0000        	call	c_fmul
1426  00b4 ae0003        	ldw	x,#_balansingSpeed
1427  00b7 cd0000        	call	c_fgadd
1429                     ; 189 	balansingSpeed+=deltaInput*kd;
1431  00ba ae0007        	ldw	x,#_deltaInput
1432  00bd cd0000        	call	c_ltor
1434  00c0 ae0010        	ldw	x,#_kd
1435  00c3 cd0000        	call	c_fmul
1437  00c6 ae0003        	ldw	x,#_balansingSpeed
1438  00c9 cd0000        	call	c_fgadd
1440                     ; 190 	integral+=error*ki;
1442  00cc ae000b        	ldw	x,#_error
1443  00cf cd0000        	call	c_ltor
1445  00d2 ae000c        	ldw	x,#_ki
1446  00d5 cd0000        	call	c_fmul
1448  00d8 ae0013        	ldw	x,#_integral
1449  00db cd0000        	call	c_fgadd
1451                     ; 191 	balansingSpeed+=integral;
1453  00de ae0013        	ldw	x,#_integral
1454  00e1 cd0000        	call	c_ltor
1456  00e4 ae0003        	ldw	x,#_balansingSpeed
1457  00e7 cd0000        	call	c_fgadd
1459                     ; 192 	balansingSpeed=balansingSpeed>MOTORMAXPWM?MOTORMAXPWM:balansingSpeed;
1461  00ea 9c            	rvf
1462  00eb a66e          	ld	a,#110
1463  00ed cd0000        	call	c_ctof
1465  00f0 96            	ldw	x,sp
1466  00f1 1c0001        	addw	x,#OFST-3
1467  00f4 cd0000        	call	c_rtol
1469  00f7 ae0003        	ldw	x,#_balansingSpeed
1470  00fa cd0000        	call	c_ltor
1472  00fd 96            	ldw	x,sp
1473  00fe 1c0001        	addw	x,#OFST-3
1474  0101 cd0000        	call	c_fcmp
1476  0104 2d08          	jrsle	L001
1477  0106 ae006e        	ldw	x,#110
1478  0109 cd0000        	call	c_itof
1480  010c 2006          	jra	L201
1481  010e               L001:
1482  010e ae0003        	ldw	x,#_balansingSpeed
1483  0111 cd0000        	call	c_ltor
1485  0114               L201:
1486  0114 ae0003        	ldw	x,#_balansingSpeed
1487  0117 cd0000        	call	c_rtol
1489                     ; 193 	balansingSpeed=balansingSpeed<-MOTORMAXPWM?-MOTORMAXPWM:balansingSpeed;
1491  011a 9c            	rvf
1492  011b aeff92        	ldw	x,#65426
1493  011e cd0000        	call	c_itof
1495  0121 96            	ldw	x,sp
1496  0122 1c0001        	addw	x,#OFST-3
1497  0125 cd0000        	call	c_rtol
1499  0128 ae0003        	ldw	x,#_balansingSpeed
1500  012b cd0000        	call	c_ltor
1502  012e 96            	ldw	x,sp
1503  012f 1c0001        	addw	x,#OFST-3
1504  0132 cd0000        	call	c_fcmp
1506  0135 2e08          	jrsge	L401
1507  0137 aeff92        	ldw	x,#65426
1508  013a cd0000        	call	c_itof
1510  013d 2006          	jra	L601
1511  013f               L401:
1512  013f ae0003        	ldw	x,#_balansingSpeed
1513  0142 cd0000        	call	c_ltor
1515  0145               L601:
1516  0145 ae0003        	ldw	x,#_balansingSpeed
1517  0148 cd0000        	call	c_rtol
1519                     ; 194 	if(TIM1_GetCapture2()>1600) move=1;
1521  014b cd0000        	call	_TIM1_GetCapture2
1523  014e a30641        	cpw	x,#1601
1524  0151 2506          	jrult	L144
1527  0153 35010020      	mov	_move,#1
1529  0157 206b          	jra	L344
1530  0159               L144:
1531                     ; 195 	else if(TIM1_GetCapture2()<1200&TIM1_GetCapture2()!=0) move=-1;
1533  0159 cd0000        	call	_TIM1_GetCapture2
1535  015c a30000        	cpw	x,#0
1536  015f 2705          	jreq	L011
1537  0161 ae0001        	ldw	x,#1
1538  0164 2001          	jra	L211
1539  0166               L011:
1540  0166 5f            	clrw	x
1541  0167               L211:
1542  0167 1f03          	ldw	(OFST-1,sp),x
1543  0169 cd0000        	call	_TIM1_GetCapture2
1545  016c a304b0        	cpw	x,#1200
1546  016f 2405          	jruge	L411
1547  0171 ae0001        	ldw	x,#1
1548  0174 2001          	jra	L611
1549  0176               L411:
1550  0176 5f            	clrw	x
1551  0177               L611:
1552  0177 01            	rrwa	x,a
1553  0178 1404          	and	a,(OFST+0,sp)
1554  017a 01            	rrwa	x,a
1555  017b 1403          	and	a,(OFST-1,sp)
1556  017d 01            	rrwa	x,a
1557  017e a30000        	cpw	x,#0
1558  0181 2706          	jreq	L544
1561  0183 35ff0020      	mov	_move,#255
1563  0187 203b          	jra	L344
1564  0189               L544:
1565                     ; 196 	else if(receive==2|receive==4|receive==0) move=0;
1567  0189 3d02          	tnz	_receive
1568  018b 2605          	jrne	L021
1569  018d ae0001        	ldw	x,#1
1570  0190 2001          	jra	L221
1571  0192               L021:
1572  0192 5f            	clrw	x
1573  0193               L221:
1574  0193 1f03          	ldw	(OFST-1,sp),x
1575  0195 b602          	ld	a,_receive
1576  0197 a104          	cp	a,#4
1577  0199 2605          	jrne	L421
1578  019b ae0001        	ldw	x,#1
1579  019e 2001          	jra	L621
1580  01a0               L421:
1581  01a0 5f            	clrw	x
1582  01a1               L621:
1583  01a1 1f01          	ldw	(OFST-3,sp),x
1584  01a3 b602          	ld	a,_receive
1585  01a5 a102          	cp	a,#2
1586  01a7 2605          	jrne	L031
1587  01a9 ae0001        	ldw	x,#1
1588  01ac 2001          	jra	L231
1589  01ae               L031:
1590  01ae 5f            	clrw	x
1591  01af               L231:
1592  01af 01            	rrwa	x,a
1593  01b0 1a02          	or	a,(OFST-2,sp)
1594  01b2 01            	rrwa	x,a
1595  01b3 1a01          	or	a,(OFST-3,sp)
1596  01b5 01            	rrwa	x,a
1597  01b6 01            	rrwa	x,a
1598  01b7 1a04          	or	a,(OFST+0,sp)
1599  01b9 01            	rrwa	x,a
1600  01ba 1a03          	or	a,(OFST-1,sp)
1601  01bc 01            	rrwa	x,a
1602  01bd a30000        	cpw	x,#0
1603  01c0 2702          	jreq	L344
1606  01c2 3f20          	clr	_move
1607  01c4               L344:
1608                     ; 197 	if(TIM1_GetCapture4()-TIM1_GetCapture3()>1600) angleSpeed=-SEGWAYANGLESPEED;
1610  01c4 cd0000        	call	_TIM1_GetCapture3
1612  01c7 1f03          	ldw	(OFST-1,sp),x
1613  01c9 cd0000        	call	_TIM1_GetCapture4
1615  01cc 72f003        	subw	x,(OFST-1,sp)
1616  01cf a30641        	cpw	x,#1601
1617  01d2 2510          	jrult	L354
1620  01d4 aefff8        	ldw	x,#65528
1621  01d7 cd0000        	call	c_itof
1623  01da ae0025        	ldw	x,#_angleSpeed
1624  01dd cd0000        	call	c_rtol
1627  01e0 ac6b026b      	jra	L554
1628  01e4               L354:
1629                     ; 198 	else if(TIM1_GetCapture4()-TIM1_GetCapture3()<1200&TIM1_GetCapture4()-TIM1_GetCapture3()!=0) angleSpeed=SEGWAYANGLESPEED;
1631  01e4 cd0000        	call	_TIM1_GetCapture3
1633  01e7 1f03          	ldw	(OFST-1,sp),x
1634  01e9 cd0000        	call	_TIM1_GetCapture4
1636  01ec 72f003        	subw	x,(OFST-1,sp)
1637  01ef 2705          	jreq	L431
1638  01f1 ae0001        	ldw	x,#1
1639  01f4 2001          	jra	L631
1640  01f6               L431:
1641  01f6 5f            	clrw	x
1642  01f7               L631:
1643  01f7 1f03          	ldw	(OFST-1,sp),x
1644  01f9 cd0000        	call	_TIM1_GetCapture3
1646  01fc 1f01          	ldw	(OFST-3,sp),x
1647  01fe cd0000        	call	_TIM1_GetCapture4
1649  0201 72f001        	subw	x,(OFST-3,sp)
1650  0204 a304b0        	cpw	x,#1200
1651  0207 2405          	jruge	L041
1652  0209 ae0001        	ldw	x,#1
1653  020c 2001          	jra	L241
1654  020e               L041:
1655  020e 5f            	clrw	x
1656  020f               L241:
1657  020f 01            	rrwa	x,a
1658  0210 1404          	and	a,(OFST+0,sp)
1659  0212 01            	rrwa	x,a
1660  0213 1403          	and	a,(OFST-1,sp)
1661  0215 01            	rrwa	x,a
1662  0216 a30000        	cpw	x,#0
1663  0219 270d          	jreq	L754
1666  021b a608          	ld	a,#8
1667  021d cd0000        	call	c_ctof
1669  0220 ae0025        	ldw	x,#_angleSpeed
1670  0223 cd0000        	call	c_rtol
1673  0226 2043          	jra	L554
1674  0228               L754:
1675                     ; 199 	else if(receive==6|receive==8|receive==0) angleSpeed=0;
1677  0228 3d02          	tnz	_receive
1678  022a 2605          	jrne	L441
1679  022c ae0001        	ldw	x,#1
1680  022f 2001          	jra	L641
1681  0231               L441:
1682  0231 5f            	clrw	x
1683  0232               L641:
1684  0232 1f03          	ldw	(OFST-1,sp),x
1685  0234 b602          	ld	a,_receive
1686  0236 a108          	cp	a,#8
1687  0238 2605          	jrne	L051
1688  023a ae0001        	ldw	x,#1
1689  023d 2001          	jra	L251
1690  023f               L051:
1691  023f 5f            	clrw	x
1692  0240               L251:
1693  0240 1f01          	ldw	(OFST-3,sp),x
1694  0242 b602          	ld	a,_receive
1695  0244 a106          	cp	a,#6
1696  0246 2605          	jrne	L451
1697  0248 ae0001        	ldw	x,#1
1698  024b 2001          	jra	L651
1699  024d               L451:
1700  024d 5f            	clrw	x
1701  024e               L651:
1702  024e 01            	rrwa	x,a
1703  024f 1a02          	or	a,(OFST-2,sp)
1704  0251 01            	rrwa	x,a
1705  0252 1a01          	or	a,(OFST-3,sp)
1706  0254 01            	rrwa	x,a
1707  0255 01            	rrwa	x,a
1708  0256 1a04          	or	a,(OFST+0,sp)
1709  0258 01            	rrwa	x,a
1710  0259 1a03          	or	a,(OFST-1,sp)
1711  025b 01            	rrwa	x,a
1712  025c a30000        	cpw	x,#0
1713  025f 270a          	jreq	L554
1716  0261 ae0000        	ldw	x,#0
1717  0264 bf27          	ldw	_angleSpeed+2,x
1718  0266 ae0000        	ldw	x,#0
1719  0269 bf25          	ldw	_angleSpeed,x
1720  026b               L554:
1721                     ; 200 	if(move==1&segwaySpeed>-SEGWAYMAXSPEED) segwaySpeed-=SEGWAYDELAYSPEED;
1723  026b b620          	ld	a,_move
1724  026d a101          	cp	a,#1
1725  026f 2629          	jrne	L564
1727  0271 9c            	rvf
1728  0272 aefff6        	ldw	x,#65526
1729  0275 cd0000        	call	c_itof
1731  0278 96            	ldw	x,sp
1732  0279 1c0001        	addw	x,#OFST-3
1733  027c cd0000        	call	c_rtol
1735  027f ae0021        	ldw	x,#_segwaySpeed
1736  0282 cd0000        	call	c_ltor
1738  0285 96            	ldw	x,sp
1739  0286 1c0001        	addw	x,#OFST-3
1740  0289 cd0000        	call	c_fcmp
1742  028c 2d0c          	jrsle	L564
1745  028e ae0008        	ldw	x,#L374
1746  0291 cd0000        	call	c_ltor
1748  0294 ae0021        	ldw	x,#_segwaySpeed
1749  0297 cd0000        	call	c_fgsub
1751  029a               L564:
1752                     ; 201 	if(move==-1&segwaySpeed<SEGWAYMAXSPEED) segwaySpeed+=SEGWAYDELAYSPEED;
1754  029a b620          	ld	a,_move
1755  029c a1ff          	cp	a,#255
1756  029e 2628          	jrne	L774
1758  02a0 9c            	rvf
1759  02a1 a60a          	ld	a,#10
1760  02a3 cd0000        	call	c_ctof
1762  02a6 96            	ldw	x,sp
1763  02a7 1c0001        	addw	x,#OFST-3
1764  02aa cd0000        	call	c_rtol
1766  02ad ae0021        	ldw	x,#_segwaySpeed
1767  02b0 cd0000        	call	c_ltor
1769  02b3 96            	ldw	x,sp
1770  02b4 1c0001        	addw	x,#OFST-3
1771  02b7 cd0000        	call	c_fcmp
1773  02ba 2e0c          	jrsge	L774
1776  02bc ae0008        	ldw	x,#L374
1777  02bf cd0000        	call	c_ltor
1779  02c2 ae0021        	ldw	x,#_segwaySpeed
1780  02c5 cd0000        	call	c_fgadd
1782  02c8               L774:
1783                     ; 202 	if(move==0)
1785  02c8 3d20          	tnz	_move
1786  02ca 2626          	jrne	L105
1787                     ; 203 		if(segwaySpeed>0) segwaySpeed-=SEGWAYDELAYSPEED;
1789  02cc 9c            	rvf
1790  02cd 9c            	rvf
1791  02ce 3d21          	tnz	_segwaySpeed
1792  02d0 2d0e          	jrsle	L305
1795  02d2 ae0008        	ldw	x,#L374
1796  02d5 cd0000        	call	c_ltor
1798  02d8 ae0021        	ldw	x,#_segwaySpeed
1799  02db cd0000        	call	c_fgsub
1802  02de 2012          	jra	L105
1803  02e0               L305:
1804                     ; 204 		else if(segwaySpeed<0) segwaySpeed+=SEGWAYDELAYSPEED;
1806  02e0 9c            	rvf
1807  02e1 9c            	rvf
1808  02e2 3d21          	tnz	_segwaySpeed
1809  02e4 2e0c          	jrsge	L105
1812  02e6 ae0008        	ldw	x,#L374
1813  02e9 cd0000        	call	c_ltor
1815  02ec ae0021        	ldw	x,#_segwaySpeed
1816  02ef cd0000        	call	c_fgadd
1818  02f2               L105:
1819                     ; 205 	if(accelerometerAngle<40&accelerometerAngle>-40)	{
1821  02f2 9c            	rvf
1822  02f3 a628          	ld	a,#40
1823  02f5 cd0000        	call	c_ctof
1825  02f8 96            	ldw	x,sp
1826  02f9 1c0001        	addw	x,#OFST-3
1827  02fc cd0000        	call	c_rtol
1829  02ff ae001f        	ldw	x,#_accelerometerAngle
1830  0302 cd0000        	call	c_ltor
1832  0305 96            	ldw	x,sp
1833  0306 1c0001        	addw	x,#OFST-3
1834  0309 cd0000        	call	c_fcmp
1836  030c 2f04          	jrslt	L412
1837  030e acab03ab      	jpf	L115
1838  0312               L412:
1840  0312 9c            	rvf
1841  0313 aeffd8        	ldw	x,#65496
1842  0316 cd0000        	call	c_itof
1844  0319 96            	ldw	x,sp
1845  031a 1c0001        	addw	x,#OFST-3
1846  031d cd0000        	call	c_rtol
1848  0320 ae001f        	ldw	x,#_accelerometerAngle
1849  0323 cd0000        	call	c_ltor
1851  0326 96            	ldw	x,sp
1852  0327 1c0001        	addw	x,#OFST-3
1853  032a cd0000        	call	c_fcmp
1855  032d 2d7c          	jrsle	L115
1856                     ; 206 		motor1Speed=balansingSpeed+segwaySpeed+angleSpeed;
1858  032f ae0003        	ldw	x,#_balansingSpeed
1859  0332 cd0000        	call	c_ltor
1861  0335 ae0021        	ldw	x,#_segwaySpeed
1862  0338 cd0000        	call	c_fadd
1864  033b ae0025        	ldw	x,#_angleSpeed
1865  033e cd0000        	call	c_fadd
1867  0341 cd0000        	call	c_ftoi
1869  0344 bf14          	ldw	_motor1Speed,x
1870                     ; 207 		motor2Speed=balansingSpeed+segwaySpeed-angleSpeed;
1872  0346 ae0003        	ldw	x,#_balansingSpeed
1873  0349 cd0000        	call	c_ltor
1875  034c ae0021        	ldw	x,#_segwaySpeed
1876  034f cd0000        	call	c_fadd
1878  0352 ae0025        	ldw	x,#_angleSpeed
1879  0355 cd0000        	call	c_fsub
1881  0358 cd0000        	call	c_ftoi
1883  035b bf16          	ldw	_motor2Speed,x
1884                     ; 208 		motor1Speed=motor1Speed>127?127:(motor1Speed<-127?-127:motor1Speed);
1886  035d 9c            	rvf
1887  035e be14          	ldw	x,_motor1Speed
1888  0360 a30080        	cpw	x,#128
1889  0363 2f05          	jrslt	L061
1890  0365 ae007f        	ldw	x,#127
1891  0368 200f          	jra	L261
1892  036a               L061:
1893  036a 9c            	rvf
1894  036b be14          	ldw	x,_motor1Speed
1895  036d a3ff81        	cpw	x,#65409
1896  0370 2e05          	jrsge	L461
1897  0372 aeff81        	ldw	x,#65409
1898  0375 2002          	jra	L661
1899  0377               L461:
1900  0377 be14          	ldw	x,_motor1Speed
1901  0379               L661:
1902  0379               L261:
1903  0379 bf14          	ldw	_motor1Speed,x
1904                     ; 209 		motor2Speed=motor2Speed>127?127:(motor2Speed<-127?-127:motor2Speed);
1906  037b 9c            	rvf
1907  037c be16          	ldw	x,_motor2Speed
1908  037e a30080        	cpw	x,#128
1909  0381 2f05          	jrslt	L071
1910  0383 ae007f        	ldw	x,#127
1911  0386 200f          	jra	L271
1912  0388               L071:
1913  0388 9c            	rvf
1914  0389 be16          	ldw	x,_motor2Speed
1915  038b a3ff81        	cpw	x,#65409
1916  038e 2e05          	jrsge	L471
1917  0390 aeff81        	ldw	x,#65409
1918  0393 2002          	jra	L671
1919  0395               L471:
1920  0395 be16          	ldw	x,_motor2Speed
1921  0397               L671:
1922  0397               L271:
1923  0397 bf16          	ldw	_motor2Speed,x
1924                     ; 210 		if(batteryVoltage>BATTERYMINVOLTAGE)	{
1926  0399 b62b          	ld	a,_batteryVoltage
1927  039b a153          	cp	a,#83
1928  039d 251a          	jrult	L515
1929                     ; 211 			setMotor1Speed((int8_t)motor1Speed);
1931  039f b615          	ld	a,_motor1Speed+1
1932  03a1 cd0000        	call	_setMotor1Speed
1934                     ; 212 			setMotor2Speed((int8_t)motor2Speed);	
1936  03a4 b617          	ld	a,_motor2Speed+1
1937  03a6 cd0000        	call	_setMotor2Speed
1939  03a9 200e          	jra	L515
1940  03ab               L115:
1941                     ; 216 		if(batteryVoltage>BATTERYMINVOLTAGE)	{
1943  03ab b62b          	ld	a,_batteryVoltage
1944  03ad a153          	cp	a,#83
1945  03af 2508          	jrult	L515
1946                     ; 217 			setMotor1Speed(0);
1948  03b1 4f            	clr	a
1949  03b2 cd0000        	call	_setMotor1Speed
1951                     ; 218 			setMotor2Speed(0);	
1953  03b5 4f            	clr	a
1954  03b6 cd0000        	call	_setMotor2Speed
1956  03b9               L515:
1957                     ; 221 	balansingSpeed=balansingSpeed*(balansingSpeed<0?-1:1);
1959  03b9 9c            	rvf
1960  03ba 9c            	rvf
1961  03bb 3d03          	tnz	_balansingSpeed
1962  03bd 2e05          	jrsge	L002
1963  03bf aeffff        	ldw	x,#65535
1964  03c2 2003          	jra	L202
1965  03c4               L002:
1966  03c4 ae0001        	ldw	x,#1
1967  03c7               L202:
1968  03c7 cd0000        	call	c_itof
1970  03ca ae0003        	ldw	x,#_balansingSpeed
1971  03cd cd0000        	call	c_fgmul
1973                     ; 222 	if(angle>0&angleZeroCompensation<90) angleZeroCompensation+=weightCompensation*balansingSpeed;
1975  03d0 9c            	rvf
1976  03d1 9c            	rvf
1977  03d2 3d17          	tnz	_angle
1978  03d4 2d30          	jrsle	L125
1980  03d6 9c            	rvf
1981  03d7 a65a          	ld	a,#90
1982  03d9 cd0000        	call	c_ctof
1984  03dc 96            	ldw	x,sp
1985  03dd 1c0001        	addw	x,#OFST-3
1986  03e0 cd0000        	call	c_rtol
1988  03e3 ae001c        	ldw	x,#_angleZeroCompensation
1989  03e6 cd0000        	call	c_ltor
1991  03e9 96            	ldw	x,sp
1992  03ea 1c0001        	addw	x,#OFST-3
1993  03ed cd0000        	call	c_fcmp
1995  03f0 2e14          	jrsge	L125
1998  03f2 ae0018        	ldw	x,#_weightCompensation
1999  03f5 cd0000        	call	c_ltor
2001  03f8 ae0003        	ldw	x,#_balansingSpeed
2002  03fb cd0000        	call	c_fmul
2004  03fe ae001c        	ldw	x,#_angleZeroCompensation
2005  0401 cd0000        	call	c_fgadd
2008  0404 2035          	jra	L325
2009  0406               L125:
2010                     ; 223 	else if(angle<0&angleZeroCompensation>-90) angleZeroCompensation-=weightCompensation*balansingSpeed;
2012  0406 9c            	rvf
2013  0407 9c            	rvf
2014  0408 3d17          	tnz	_angle
2015  040a 2e2f          	jrsge	L325
2017  040c 9c            	rvf
2018  040d aeffa6        	ldw	x,#65446
2019  0410 cd0000        	call	c_itof
2021  0413 96            	ldw	x,sp
2022  0414 1c0001        	addw	x,#OFST-3
2023  0417 cd0000        	call	c_rtol
2025  041a ae001c        	ldw	x,#_angleZeroCompensation
2026  041d cd0000        	call	c_ltor
2028  0420 96            	ldw	x,sp
2029  0421 1c0001        	addw	x,#OFST-3
2030  0424 cd0000        	call	c_fcmp
2032  0427 2d12          	jrsle	L325
2035  0429 ae0018        	ldw	x,#_weightCompensation
2036  042c cd0000        	call	c_ltor
2038  042f ae0003        	ldw	x,#_balansingSpeed
2039  0432 cd0000        	call	c_fmul
2041  0435 ae001c        	ldw	x,#_angleZeroCompensation
2042  0438 cd0000        	call	c_fgsub
2044  043b               L325:
2045                     ; 224 	servoAnglePWM=SERVOZEROPWM+gyroAngle*10;
2047  043b ae0000        	ldw	x,#_gyroAngle
2048  043e cd0000        	call	c_ltor
2050  0441 ae0004        	ldw	x,#L335
2051  0444 cd0000        	call	c_fmul
2053  0447 ae0000        	ldw	x,#L345
2054  044a cd0000        	call	c_fadd
2056  044d cd0000        	call	c_ftoi
2058  0450 bf29          	ldw	_servoAnglePWM,x
2059                     ; 225 	if(500<(TIM1_GetCapture3()-TIM1_GetCapture2())&(TIM1_GetCapture3()-TIM1_GetCapture2())<2500)	servoAnglePWM+=(SERVOZEROPWM-(TIM1_GetCapture3()-TIM1_GetCapture2()));
2061  0452 cd0000        	call	_TIM1_GetCapture2
2063  0455 1f03          	ldw	(OFST-1,sp),x
2064  0457 cd0000        	call	_TIM1_GetCapture3
2066  045a 72f003        	subw	x,(OFST-1,sp)
2067  045d a309c4        	cpw	x,#2500
2068  0460 2405          	jruge	L402
2069  0462 ae0001        	ldw	x,#1
2070  0465 2001          	jra	L602
2071  0467               L402:
2072  0467 5f            	clrw	x
2073  0468               L602:
2074  0468 1f03          	ldw	(OFST-1,sp),x
2075  046a cd0000        	call	_TIM1_GetCapture2
2077  046d 1f01          	ldw	(OFST-3,sp),x
2078  046f cd0000        	call	_TIM1_GetCapture3
2080  0472 72f001        	subw	x,(OFST-3,sp)
2081  0475 a301f5        	cpw	x,#501
2082  0478 2505          	jrult	L012
2083  047a ae0001        	ldw	x,#1
2084  047d 2001          	jra	L212
2085  047f               L012:
2086  047f 5f            	clrw	x
2087  0480               L212:
2088  0480 01            	rrwa	x,a
2089  0481 1404          	and	a,(OFST+0,sp)
2090  0483 01            	rrwa	x,a
2091  0484 1403          	and	a,(OFST-1,sp)
2092  0486 01            	rrwa	x,a
2093  0487 a30000        	cpw	x,#0
2094  048a 2719          	jreq	L745
2097  048c cd0000        	call	_TIM1_GetCapture2
2099  048f 1f03          	ldw	(OFST-1,sp),x
2100  0491 cd0000        	call	_TIM1_GetCapture3
2102  0494 72f003        	subw	x,(OFST-1,sp)
2103  0497 1f01          	ldw	(OFST-3,sp),x
2104  0499 ae058c        	ldw	x,#1420
2105  049c 72f001        	subw	x,(OFST-3,sp)
2106  049f 72bb0029      	addw	x,_servoAnglePWM
2107  04a3 bf29          	ldw	_servoAnglePWM,x
2108  04a5               L745:
2109                     ; 226 	if(servoAnglePWM>(uint16_t)(SERVOZEROPWM+SERVOMAXANGLE*10)) servoAnglePWM=SERVOZEROPWM+SERVOMAXANGLE*10;
2111  04a5 be29          	ldw	x,_servoAnglePWM
2112  04a7 a30849        	cpw	x,#2121
2113  04aa 2507          	jrult	L155
2116  04ac ae0848        	ldw	x,#2120
2117  04af bf29          	ldw	_servoAnglePWM,x
2119  04b1 200c          	jra	L355
2120  04b3               L155:
2121                     ; 227 	else if(servoAnglePWM<SERVOZEROPWM-SERVOMAXANGLE*10) servoAnglePWM=SERVOZEROPWM-SERVOMAXANGLE*10;
2123  04b3 be29          	ldw	x,_servoAnglePWM
2124  04b5 a302d0        	cpw	x,#720
2125  04b8 2405          	jruge	L355
2128  04ba ae02d0        	ldw	x,#720
2129  04bd bf29          	ldw	_servoAnglePWM,x
2130  04bf               L355:
2131                     ; 228 	TIM2_SetCompare3(servoAnglePWM);
2133  04bf be29          	ldw	x,_servoAnglePWM
2134  04c1 cd0000        	call	_TIM2_SetCompare3
2136                     ; 229 }
2139  04c4 5b04          	addw	sp,#4
2140  04c6 85            	popw	x
2141  04c7 bf00          	ldw	c_lreg,x
2142  04c9 85            	popw	x
2143  04ca bf02          	ldw	c_lreg+2,x
2144  04cc 85            	popw	x
2145  04cd bf00          	ldw	c_y,x
2146  04cf 320002        	pop	c_y+2
2147  04d2 85            	popw	x
2148  04d3 bf00          	ldw	c_x,x
2149  04d5 320002        	pop	c_x+2
2150  04d8 80            	iret
2192                     ; 231 void Delay(uint32_t t)	{
2194                     .text:	section	.text,new
2195  0000               _Delay:
2197  0000 89            	pushw	x
2198       00000002      OFST:	set	2
2201  0001 2019          	jra	L306
2202  0003               L106:
2203                     ; 234 		t--;
2205  0003 96            	ldw	x,sp
2206  0004 1c0005        	addw	x,#OFST+3
2207  0007 a601          	ld	a,#1
2208  0009 cd0000        	call	c_lgsbc
2210                     ; 235 		for(i=1000;i>0;i--);
2212  000c ae03e8        	ldw	x,#1000
2213  000f 1f01          	ldw	(OFST-1,sp),x
2214  0011               L706:
2218  0011 1e01          	ldw	x,(OFST-1,sp)
2219  0013 1d0001        	subw	x,#1
2220  0016 1f01          	ldw	(OFST-1,sp),x
2223  0018 1e01          	ldw	x,(OFST-1,sp)
2224  001a 26f5          	jrne	L706
2225  001c               L306:
2226                     ; 233 	while(t>0) {
2228  001c 96            	ldw	x,sp
2229  001d 1c0005        	addw	x,#OFST+3
2230  0020 cd0000        	call	c_lzmp
2232  0023 26de          	jrne	L106
2233                     ; 237 }
2236  0025 85            	popw	x
2237  0026 81            	ret
2296                     ; 239 main()	{
2297                     .text:	section	.text,new
2298  0000               _main:
2302                     ; 240 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1|CLK_PRESCALER_CPUDIV1);
2304  0000 a680          	ld	a,#128
2305  0002 cd0000        	call	_CLK_HSIPrescalerConfig
2307                     ; 241 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, ENABLE);
2309  0005 ae0301        	ldw	x,#769
2310  0008 cd0000        	call	_CLK_PeripheralClockConfig
2312                     ; 242 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, ENABLE);
2314  000b ae0701        	ldw	x,#1793
2315  000e cd0000        	call	_CLK_PeripheralClockConfig
2317                     ; 243 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, ENABLE);
2319  0011 ae0501        	ldw	x,#1281
2320  0014 cd0000        	call	_CLK_PeripheralClockConfig
2322                     ; 244 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_I2C, ENABLE);
2324  0017 ae0001        	ldw	x,#1
2325  001a cd0000        	call	_CLK_PeripheralClockConfig
2327                     ; 245 	Delay(900);
2329  001d ae0384        	ldw	x,#900
2330  0020 89            	pushw	x
2331  0021 ae0000        	ldw	x,#0
2332  0024 89            	pushw	x
2333  0025 cd0000        	call	_Delay
2335  0028 5b04          	addw	sp,#4
2336                     ; 246 	UART1_DeInit();
2338  002a cd0000        	call	_UART1_DeInit
2340                     ; 247 	UART1_Init(	57600,
2340                     ; 248 							UART1_WORDLENGTH_8D,
2340                     ; 249 							UART1_STOPBITS_1,
2340                     ; 250 							UART1_PARITY_NO,
2340                     ; 251 							UART1_SYNCMODE_CLOCK_DISABLE,
2340                     ; 252 							UART1_MODE_TXRX_ENABLE);
2342  002d 4b0c          	push	#12
2343  002f 4b80          	push	#128
2344  0031 4b00          	push	#0
2345  0033 4b00          	push	#0
2346  0035 4b00          	push	#0
2347  0037 aee100        	ldw	x,#57600
2348  003a 89            	pushw	x
2349  003b ae0000        	ldw	x,#0
2350  003e 89            	pushw	x
2351  003f cd0000        	call	_UART1_Init
2353  0042 5b09          	addw	sp,#9
2354                     ; 253 	UART1_ITConfig(	UART1_IT_RXNE, ENABLE);
2356  0044 4b01          	push	#1
2357  0046 ae0255        	ldw	x,#597
2358  0049 cd0000        	call	_UART1_ITConfig
2360  004c 84            	pop	a
2361                     ; 254 	UART1_Cmd(ENABLE);
2363  004d a601          	ld	a,#1
2364  004f cd0000        	call	_UART1_Cmd
2366                     ; 255 	TIM2_DeInit();
2368  0052 cd0000        	call	_TIM2_DeInit
2370                     ; 256 	TIM2_TimeBaseInit(	TIM2_PRESCALER_16,
2370                     ; 257 											20000);
2372  0055 ae4e20        	ldw	x,#20000
2373  0058 89            	pushw	x
2374  0059 a604          	ld	a,#4
2375  005b cd0000        	call	_TIM2_TimeBaseInit
2377  005e 85            	popw	x
2378                     ; 258 	TIM2_OC1Init(				TIM2_OCMODE_PWM1,
2378                     ; 259 											TIM2_OUTPUTSTATE_ENABLE,
2378                     ; 260 											200,
2378                     ; 261 											TIM2_OCPOLARITY_HIGH);
2380  005f 4b00          	push	#0
2381  0061 ae00c8        	ldw	x,#200
2382  0064 89            	pushw	x
2383  0065 ae6011        	ldw	x,#24593
2384  0068 cd0000        	call	_TIM2_OC1Init
2386  006b 5b03          	addw	sp,#3
2387                     ; 262 	TIM2_OC2Init(				TIM2_OCMODE_PWM1,
2387                     ; 263 											TIM2_OUTPUTSTATE_ENABLE,
2387                     ; 264 											200,
2387                     ; 265 											TIM2_OCPOLARITY_HIGH);	TIM2_Cmd(ENABLE);
2389  006d 4b00          	push	#0
2390  006f ae00c8        	ldw	x,#200
2391  0072 89            	pushw	x
2392  0073 ae6011        	ldw	x,#24593
2393  0076 cd0000        	call	_TIM2_OC2Init
2395  0079 5b03          	addw	sp,#3
2398  007b a601          	ld	a,#1
2399  007d cd0000        	call	_TIM2_Cmd
2401                     ; 266 	TIM2_OC3Init(				TIM2_OCMODE_PWM1,
2401                     ; 267 											TIM2_OUTPUTSTATE_ENABLE,
2401                     ; 268 											200,
2401                     ; 269 											TIM2_OCPOLARITY_HIGH);
2403  0080 4b00          	push	#0
2404  0082 ae00c8        	ldw	x,#200
2405  0085 89            	pushw	x
2406  0086 ae6011        	ldw	x,#24593
2407  0089 cd0000        	call	_TIM2_OC3Init
2409  008c 5b03          	addw	sp,#3
2410                     ; 270 	TIM2_SetCompare1(MOTOR1ZEROPWM);
2412  008e ae05dc        	ldw	x,#1500
2413  0091 cd0000        	call	_TIM2_SetCompare1
2415                     ; 271 	TIM2_SetCompare2(MOTOR1ZEROPWM);
2417  0094 ae05dc        	ldw	x,#1500
2418  0097 cd0000        	call	_TIM2_SetCompare2
2420                     ; 272 	TIM2_SetCompare3(SERVOZEROPWM);
2422  009a ae058c        	ldw	x,#1420
2423  009d cd0000        	call	_TIM2_SetCompare3
2425                     ; 273 	TIM2_ITConfig(TIM2_IT_UPDATE,ENABLE);
2427  00a0 ae0101        	ldw	x,#257
2428  00a3 cd0000        	call	_TIM2_ITConfig
2430                     ; 274 	TIM2_Cmd(ENABLE);
2432  00a6 a601          	ld	a,#1
2433  00a8 cd0000        	call	_TIM2_Cmd
2435                     ; 275 	I2C_DeInit();
2437  00ab cd0000        	call	_I2C_DeInit
2439                     ; 276 	I2C_Init(	100000,
2439                     ; 277 						0x3232,
2439                     ; 278 						I2C_DUTYCYCLE_2,
2439                     ; 279 						I2C_ACK_CURR,
2439                     ; 280 						I2C_ADDMODE_7BIT,
2439                     ; 281 						16);
2441  00ae 4b10          	push	#16
2442  00b0 4b00          	push	#0
2443  00b2 4b01          	push	#1
2444  00b4 4b00          	push	#0
2445  00b6 ae3232        	ldw	x,#12850
2446  00b9 89            	pushw	x
2447  00ba ae86a0        	ldw	x,#34464
2448  00bd 89            	pushw	x
2449  00be ae0001        	ldw	x,#1
2450  00c1 89            	pushw	x
2451  00c2 cd0000        	call	_I2C_Init
2453  00c5 5b0a          	addw	sp,#10
2454                     ; 282 	I2C_Cmd(ENABLE);
2456  00c7 a601          	ld	a,#1
2457  00c9 cd0000        	call	_I2C_Cmd
2459                     ; 283 	TIM1_DeInit();
2461  00cc cd0000        	call	_TIM1_DeInit
2463                     ; 284 	TIM1_TimeBaseInit(	16000/50/20,
2463                     ; 285 											TIM1_COUNTERMODE_UP,
2463                     ; 286 											20000,
2463                     ; 287 											0);
2465  00cf 4b00          	push	#0
2466  00d1 ae4e20        	ldw	x,#20000
2467  00d4 89            	pushw	x
2468  00d5 4b00          	push	#0
2469  00d7 ae0010        	ldw	x,#16
2470  00da cd0000        	call	_TIM1_TimeBaseInit
2472  00dd 5b04          	addw	sp,#4
2473                     ; 288 	TIM1_ICInit(	TIM1_CHANNEL_1,	// К регстру TIM1_CCR1
2473                     ; 289 								TIM1_ICPOLARITY_RISING,	// срабатывает на восходящем фронте
2473                     ; 290 								TIM1_ICSELECTION_DIRECTTI,	// подключен прямой вход TIM1_CH1
2473                     ; 291 								TIM1_ICPSC_DIV1,	
2473                     ; 292 								0);
2475  00df 4b00          	push	#0
2476  00e1 4b00          	push	#0
2477  00e3 4b01          	push	#1
2478  00e5 5f            	clrw	x
2479  00e6 cd0000        	call	_TIM1_ICInit
2481  00e9 5b03          	addw	sp,#3
2482                     ; 293 	TIM1_ICInit(	TIM1_CHANNEL_2, // К регстру TIM1_CCR2
2482                     ; 294 								TIM1_ICPOLARITY_FALLING, // срабатывает на спадающем фронте
2482                     ; 295 								TIM1_ICSELECTION_INDIRECTTI, // подключен непрямой вход TIM1_CH1 (прямой для него TIM1_CH2)
2482                     ; 296 								TIM1_ICPSC_DIV1,
2482                     ; 297 								0);
2484  00eb 4b00          	push	#0
2485  00ed 4b00          	push	#0
2486  00ef 4b02          	push	#2
2487  00f1 ae0101        	ldw	x,#257
2488  00f4 cd0000        	call	_TIM1_ICInit
2490  00f7 5b03          	addw	sp,#3
2491                     ; 298 	TIM1_ICInit(	TIM1_CHANNEL_3,	// К регстру TIM1_CCR3
2491                     ; 299 								TIM1_ICPOLARITY_FALLING,	// срабатывает на спадающем фронте
2491                     ; 300 								TIM1_ICSELECTION_DIRECTTI,	// подключен прямой вход TIM1_CH3
2491                     ; 301 								TIM1_ICPSC_DIV1,	
2491                     ; 302 								0);
2493  00f9 4b00          	push	#0
2494  00fb 4b00          	push	#0
2495  00fd 4b01          	push	#1
2496  00ff ae0201        	ldw	x,#513
2497  0102 cd0000        	call	_TIM1_ICInit
2499  0105 5b03          	addw	sp,#3
2500                     ; 303 	TIM1_ICInit(	TIM1_CHANNEL_4, // К регстру TIM1_CCR4
2500                     ; 304 								TIM1_ICPOLARITY_FALLING, // срабатывает на спадающем фронте
2500                     ; 305 								TIM1_ICSELECTION_DIRECTTI, // подключен прямой вход TIM1_CH4
2500                     ; 306 								TIM1_ICPSC_DIV1,
2500                     ; 307 								0);
2502  0107 4b00          	push	#0
2503  0109 4b00          	push	#0
2504  010b 4b01          	push	#1
2505  010d ae0301        	ldw	x,#769
2506  0110 cd0000        	call	_TIM1_ICInit
2508  0113 5b03          	addw	sp,#3
2509                     ; 308 	TIM1_SelectInputTrigger(TIM1_TS_TI1FP1); // Действием таймера управляет вход TIM1_CH1
2511  0115 a650          	ld	a,#80
2512  0117 cd0000        	call	_TIM1_SelectInputTrigger
2514                     ; 309 	TIM1_SelectSlaveMode(TIM1_SLAVEMODE_RESET); // Действие таймера - сброс
2516  011a a604          	ld	a,#4
2517  011c cd0000        	call	_TIM1_SelectSlaveMode
2519                     ; 310 	TIM1_CCxCmd(TIM1_CHANNEL_2, ENABLE); // Разрешить захват для регистра TIM1_CCR2
2521  011f ae0101        	ldw	x,#257
2522  0122 cd0000        	call	_TIM1_CCxCmd
2524                     ; 311 	TIM1_CCxCmd(TIM1_CHANNEL_3, ENABLE); // Разрешить захват для регистра TIM1_CCR3
2526  0125 ae0201        	ldw	x,#513
2527  0128 cd0000        	call	_TIM1_CCxCmd
2529                     ; 312 	TIM1_CCxCmd(TIM1_CHANNEL_4, ENABLE); // Разрешить захват для регистра TIM1_CCR4
2531  012b ae0301        	ldw	x,#769
2532  012e cd0000        	call	_TIM1_CCxCmd
2534                     ; 313 	TIM1_Cmd(ENABLE);
2536  0131 a601          	ld	a,#1
2537  0133 cd0000        	call	_TIM1_Cmd
2539                     ; 314 	ADC1_DeInit();
2541  0136 cd0000        	call	_ADC1_DeInit
2543                     ; 315 	ADC1_Init(	ADC1_CONVERSIONMODE_CONTINUOUS,
2543                     ; 316 							ADC1_CHANNEL_3,
2543                     ; 317 							ADC1_PRESSEL_FCPU_D2,
2543                     ; 318 							ADC1_EXTTRIG_TIM,
2543                     ; 319 							DISABLE,
2543                     ; 320 							ADC1_ALIGN_RIGHT,
2543                     ; 321 							ADC1_SCHMITTTRIG_CHANNEL3,
2543                     ; 322 							DISABLE);
2545  0139 4b00          	push	#0
2546  013b 4b03          	push	#3
2547  013d 4b08          	push	#8
2548  013f 4b00          	push	#0
2549  0141 4b00          	push	#0
2550  0143 4b00          	push	#0
2551  0145 ae0103        	ldw	x,#259
2552  0148 cd0000        	call	_ADC1_Init
2554  014b 5b06          	addw	sp,#6
2555                     ; 323 	ADC1_Cmd(ENABLE);
2557  014d a601          	ld	a,#1
2558  014f cd0000        	call	_ADC1_Cmd
2560                     ; 324 	ADC1_StartConversion();
2562  0152 cd0000        	call	_ADC1_StartConversion
2564                     ; 325 	MPU6050Config();
2566  0155 cd0000        	call	_MPU6050Config
2568                     ; 326 	Delay(100);
2570  0158 ae0064        	ldw	x,#100
2571  015b 89            	pushw	x
2572  015c ae0000        	ldw	x,#0
2573  015f 89            	pushw	x
2574  0160 cd0000        	call	_Delay
2576  0163 5b04          	addw	sp,#4
2577                     ; 327 	accelerometerAngleCalc();
2579  0165 cd0000        	call	_accelerometerAngleCalc
2581                     ; 328 	gyroAngle=accelerometerAngle;
2583  0168 be21          	ldw	x,_accelerometerAngle+2
2584  016a bf02          	ldw	_gyroAngle+2,x
2585  016c be1f          	ldw	x,_accelerometerAngle
2586  016e bf00          	ldw	_gyroAngle,x
2587                     ; 329 	enableInterrupts();
2590  0170 9a            rim
2592  0171               L526:
2593                     ; 330 	while (1);
2595  0171 20fe          	jra	L526
2846                     	xdef	_main
2847                     	xdef	_Delay
2848                     	xdef	f_tim2Update
2849                     	xdef	_gyroAngleCalc
2850                     	xdef	_accelerometerAngleCalc
2851                     	xdef	_uartTransmit
2852                     	xdef	f_uartReceive
2853                     	switch	.ubsct
2854  0002               _receive:
2855  0002 00            	ds.b	1
2856                     	xdef	_receive
2857                     	xdef	_setMotor2Speed
2858                     	xdef	_setMotor1Speed
2859                     	xdef	_MPU6050Config
2860                     	xdef	_MPU6050WriteBits
2861                     	xdef	_MPU6050WriteReg
2862                     	xdef	_MPU6050ReadReg
2863                     	xdef	_batteryVoltage
2864                     	xdef	_servoAnglePWM
2865                     	xdef	_angleSpeed
2866                     	xdef	_segwaySpeed
2867                     	xdef	_move
2868                     	xdef	_angleZeroCompensation
2869                     	xdef	_weightCompensation
2870                     	xdef	_motor2Speed
2871                     	xdef	_motor1Speed
2872  0003               _balansingSpeed:
2873  0003 00000000      	ds.b	4
2874                     	xdef	_balansingSpeed
2875  0007               _deltaInput:
2876  0007 00000000      	ds.b	4
2877                     	xdef	_deltaInput
2878  000b               _error:
2879  000b 00000000      	ds.b	4
2880                     	xdef	_error
2881  000f               _prevInput:
2882  000f 00000000      	ds.b	4
2883                     	xdef	_prevInput
2884  0013               _integral:
2885  0013 00000000      	ds.b	4
2886                     	xdef	_integral
2887                     	xdef	_kd
2888                     	xdef	_ki
2889                     	xdef	_kp
2890  0017               _angle:
2891  0017 00000000      	ds.b	4
2892                     	xdef	_angle
2893                     	xdef	_accelerometerGyroRatio
2894  001b               _gyroAngleSpeed:
2895  001b 00000000      	ds.b	4
2896                     	xdef	_gyroAngleSpeed
2897                     	xdef	_gyroAngle
2898  001f               _accelerometerAngle:
2899  001f 00000000      	ds.b	4
2900                     	xdef	_accelerometerAngle
2901  0023               _gyh:
2902  0023 00            	ds.b	1
2903                     	xdef	_gyh
2904  0024               _azh:
2905  0024 00            	ds.b	1
2906                     	xdef	_azh
2907  0025               _axh:
2908  0025 00            	ds.b	1
2909                     	xdef	_axh
2910                     	xref	_atan
2911                     	xref	_UART1_ClearITPendingBit
2912                     	xref	_UART1_ReceiveData8
2913                     	xref	_UART1_ITConfig
2914                     	xref	_UART1_Cmd
2915                     	xref	_UART1_Init
2916                     	xref	_UART1_DeInit
2917                     	xref	_TIM2_ClearITPendingBit
2918                     	xref	_TIM2_SetCompare3
2919                     	xref	_TIM2_SetCompare2
2920                     	xref	_TIM2_SetCompare1
2921                     	xref	_TIM2_ITConfig
2922                     	xref	_TIM2_Cmd
2923                     	xref	_TIM2_OC3Init
2924                     	xref	_TIM2_OC2Init
2925                     	xref	_TIM2_OC1Init
2926                     	xref	_TIM2_TimeBaseInit
2927                     	xref	_TIM2_DeInit
2928                     	xref	_TIM1_GetCapture4
2929                     	xref	_TIM1_GetCapture3
2930                     	xref	_TIM1_GetCapture2
2931                     	xref	_TIM1_CCxCmd
2932                     	xref	_TIM1_SelectSlaveMode
2933                     	xref	_TIM1_SelectInputTrigger
2934                     	xref	_TIM1_Cmd
2935                     	xref	_TIM1_ICInit
2936                     	xref	_TIM1_TimeBaseInit
2937                     	xref	_TIM1_DeInit
2938                     	xref	_I2C_CheckEvent
2939                     	xref	_I2C_SendData
2940                     	xref	_I2C_Send7bitAddress
2941                     	xref	_I2C_ReceiveData
2942                     	xref	_I2C_AcknowledgeConfig
2943                     	xref	_I2C_GenerateSTOP
2944                     	xref	_I2C_GenerateSTART
2945                     	xref	_I2C_Cmd
2946                     	xref	_I2C_Init
2947                     	xref	_I2C_DeInit
2948                     	xref	_CLK_HSIPrescalerConfig
2949                     	xref	_CLK_PeripheralClockConfig
2950                     	xref	_ADC1_GetConversionValue
2951                     	xref	_ADC1_StartConversion
2952                     	xref	_ADC1_Cmd
2953                     	xref	_ADC1_Init
2954                     	xref	_ADC1_DeInit
2955                     .const:	section	.text
2956  0000               L345:
2957  0000 44b18000      	dc.w	17585,-32768
2958  0004               L335:
2959  0004 41200000      	dc.w	16672,0
2960  0008               L374:
2961  0008 3dcccccc      	dc.w	15820,-13108
2962  000c               L524:
2963  000c 41a80000      	dc.w	16808,0
2964  0010               L504:
2965  0010 42652f1a      	dc.w	16997,12058
2966                     	xref.b	c_lreg
2967                     	xref.b	c_x
2968                     	xref.b	c_y
2988                     	xref	c_lzmp
2989                     	xref	c_lgsbc
2990                     	xref	c_fgmul
2991                     	xref	c_ftoi
2992                     	xref	c_fgsub
2993                     	xref	c_fcmp
2994                     	xref	c_fneg
2995                     	xref	c_fadd
2996                     	xref	c_fsub
2997                     	xref	c_fgadd
2998                     	xref	c_ltor
2999                     	xref	c_fmul
3000                     	xref	c_fdiv
3001                     	xref	c_itof
3002                     	xref	c_rtol
3003                     	xref	c_ctof
3004                     	end
