   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.10.2 - 02 Nov 2011
   3                     ; Generator (Limited) V4.3.7 - 29 Nov 2011
  45                     ; 53 void UART1_DeInit(void)
  45                     ; 54 {
  47                     .text:	section	.text,new
  48  0000               _UART1_DeInit:
  52                     ; 57   (void)UART1->SR;
  54  0000 c65230        	ld	a,21040
  55                     ; 58   (void)UART1->DR;
  57  0003 c65231        	ld	a,21041
  58                     ; 60   UART1->BRR2 = UART1_BRR2_RESET_VALUE;  /* Set UART1_BRR2 to reset value 0x00 */
  60  0006 725f5233      	clr	21043
  61                     ; 61   UART1->BRR1 = UART1_BRR1_RESET_VALUE;  /* Set UART1_BRR1 to reset value 0x00 */
  63  000a 725f5232      	clr	21042
  64                     ; 63   UART1->CR1 = UART1_CR1_RESET_VALUE;  /* Set UART1_CR1 to reset value 0x00 */
  66  000e 725f5234      	clr	21044
  67                     ; 64   UART1->CR2 = UART1_CR2_RESET_VALUE;  /* Set UART1_CR2 to reset value 0x00 */
  69  0012 725f5235      	clr	21045
  70                     ; 65   UART1->CR3 = UART1_CR3_RESET_VALUE;  /* Set UART1_CR3 to reset value 0x00 */
  72  0016 725f5236      	clr	21046
  73                     ; 66   UART1->CR4 = UART1_CR4_RESET_VALUE;  /* Set UART1_CR4 to reset value 0x00 */
  75  001a 725f5237      	clr	21047
  76                     ; 67   UART1->CR5 = UART1_CR5_RESET_VALUE;  /* Set UART1_CR5 to reset value 0x00 */
  78  001e 725f5238      	clr	21048
  79                     ; 69   UART1->GTR = UART1_GTR_RESET_VALUE;
  81  0022 725f5239      	clr	21049
  82                     ; 70   UART1->PSCR = UART1_PSCR_RESET_VALUE;
  84  0026 725f523a      	clr	21050
  85                     ; 71 }
  88  002a 81            	ret
 391                     .const:	section	.text
 392  0000               L01:
 393  0000 00000064      	dc.l	100
 394                     ; 90 void UART1_Init(uint32_t BaudRate, UART1_WordLength_TypeDef WordLength, 
 394                     ; 91                 UART1_StopBits_TypeDef StopBits, UART1_Parity_TypeDef Parity, 
 394                     ; 92                 UART1_SyncMode_TypeDef SyncMode, UART1_Mode_TypeDef Mode)
 394                     ; 93 {
 395                     .text:	section	.text,new
 396  0000               _UART1_Init:
 398  0000 520c          	subw	sp,#12
 399       0000000c      OFST:	set	12
 402                     ; 94   uint32_t BaudRate_Mantissa = 0, BaudRate_Mantissa100 = 0;
 406                     ; 97   assert_param(IS_UART1_BAUDRATE_OK(BaudRate));
 408                     ; 98   assert_param(IS_UART1_WORDLENGTH_OK(WordLength));
 410                     ; 99   assert_param(IS_UART1_STOPBITS_OK(StopBits));
 412                     ; 100   assert_param(IS_UART1_PARITY_OK(Parity));
 414                     ; 101   assert_param(IS_UART1_MODE_OK((uint8_t)Mode));
 416                     ; 102   assert_param(IS_UART1_SYNCMODE_OK((uint8_t)SyncMode));
 418                     ; 105   UART1->CR1 &= (uint8_t)(~UART1_CR1_M);  
 420  0002 72195234      	bres	21044,#4
 421                     ; 108   UART1->CR1 |= (uint8_t)WordLength;
 423  0006 c65234        	ld	a,21044
 424  0009 1a13          	or	a,(OFST+7,sp)
 425  000b c75234        	ld	21044,a
 426                     ; 111   UART1->CR3 &= (uint8_t)(~UART1_CR3_STOP);  
 428  000e c65236        	ld	a,21046
 429  0011 a4cf          	and	a,#207
 430  0013 c75236        	ld	21046,a
 431                     ; 113   UART1->CR3 |= (uint8_t)StopBits;  
 433  0016 c65236        	ld	a,21046
 434  0019 1a14          	or	a,(OFST+8,sp)
 435  001b c75236        	ld	21046,a
 436                     ; 116   UART1->CR1 &= (uint8_t)(~(UART1_CR1_PCEN | UART1_CR1_PS  ));  
 438  001e c65234        	ld	a,21044
 439  0021 a4f9          	and	a,#249
 440  0023 c75234        	ld	21044,a
 441                     ; 118   UART1->CR1 |= (uint8_t)Parity;  
 443  0026 c65234        	ld	a,21044
 444  0029 1a15          	or	a,(OFST+9,sp)
 445  002b c75234        	ld	21044,a
 446                     ; 121   UART1->BRR1 &= (uint8_t)(~UART1_BRR1_DIVM);  
 448  002e 725f5232      	clr	21042
 449                     ; 123   UART1->BRR2 &= (uint8_t)(~UART1_BRR2_DIVM);  
 451  0032 c65233        	ld	a,21043
 452  0035 a40f          	and	a,#15
 453  0037 c75233        	ld	21043,a
 454                     ; 125   UART1->BRR2 &= (uint8_t)(~UART1_BRR2_DIVF);  
 456  003a c65233        	ld	a,21043
 457  003d a4f0          	and	a,#240
 458  003f c75233        	ld	21043,a
 459                     ; 128   BaudRate_Mantissa    = ((uint32_t)CLK_GetClockFreq() / (BaudRate << 4));
 461  0042 96            	ldw	x,sp
 462  0043 1c000f        	addw	x,#OFST+3
 463  0046 cd0000        	call	c_ltor
 465  0049 a604          	ld	a,#4
 466  004b cd0000        	call	c_llsh
 468  004e 96            	ldw	x,sp
 469  004f 1c0001        	addw	x,#OFST-11
 470  0052 cd0000        	call	c_rtol
 472  0055 cd0000        	call	_CLK_GetClockFreq
 474  0058 96            	ldw	x,sp
 475  0059 1c0001        	addw	x,#OFST-11
 476  005c cd0000        	call	c_ludv
 478  005f 96            	ldw	x,sp
 479  0060 1c0009        	addw	x,#OFST-3
 480  0063 cd0000        	call	c_rtol
 482                     ; 129   BaudRate_Mantissa100 = (((uint32_t)CLK_GetClockFreq() * 100) / (BaudRate << 4));
 484  0066 96            	ldw	x,sp
 485  0067 1c000f        	addw	x,#OFST+3
 486  006a cd0000        	call	c_ltor
 488  006d a604          	ld	a,#4
 489  006f cd0000        	call	c_llsh
 491  0072 96            	ldw	x,sp
 492  0073 1c0001        	addw	x,#OFST-11
 493  0076 cd0000        	call	c_rtol
 495  0079 cd0000        	call	_CLK_GetClockFreq
 497  007c a664          	ld	a,#100
 498  007e cd0000        	call	c_smul
 500  0081 96            	ldw	x,sp
 501  0082 1c0001        	addw	x,#OFST-11
 502  0085 cd0000        	call	c_ludv
 504  0088 96            	ldw	x,sp
 505  0089 1c0005        	addw	x,#OFST-7
 506  008c cd0000        	call	c_rtol
 508                     ; 131   UART1->BRR2 |= (uint8_t)((uint8_t)(((BaudRate_Mantissa100 - (BaudRate_Mantissa * 100)) << 4) / 100) & (uint8_t)0x0F); 
 510  008f 96            	ldw	x,sp
 511  0090 1c0009        	addw	x,#OFST-3
 512  0093 cd0000        	call	c_ltor
 514  0096 a664          	ld	a,#100
 515  0098 cd0000        	call	c_smul
 517  009b 96            	ldw	x,sp
 518  009c 1c0001        	addw	x,#OFST-11
 519  009f cd0000        	call	c_rtol
 521  00a2 96            	ldw	x,sp
 522  00a3 1c0005        	addw	x,#OFST-7
 523  00a6 cd0000        	call	c_ltor
 525  00a9 96            	ldw	x,sp
 526  00aa 1c0001        	addw	x,#OFST-11
 527  00ad cd0000        	call	c_lsub
 529  00b0 a604          	ld	a,#4
 530  00b2 cd0000        	call	c_llsh
 532  00b5 ae0000        	ldw	x,#L01
 533  00b8 cd0000        	call	c_ludv
 535  00bb b603          	ld	a,c_lreg+3
 536  00bd a40f          	and	a,#15
 537  00bf ca5233        	or	a,21043
 538  00c2 c75233        	ld	21043,a
 539                     ; 133   UART1->BRR2 |= (uint8_t)((BaudRate_Mantissa >> 4) & (uint8_t)0xF0); 
 541  00c5 96            	ldw	x,sp
 542  00c6 1c0009        	addw	x,#OFST-3
 543  00c9 cd0000        	call	c_ltor
 545  00cc a604          	ld	a,#4
 546  00ce cd0000        	call	c_lursh
 548  00d1 b603          	ld	a,c_lreg+3
 549  00d3 a4f0          	and	a,#240
 550  00d5 b703          	ld	c_lreg+3,a
 551  00d7 3f02          	clr	c_lreg+2
 552  00d9 3f01          	clr	c_lreg+1
 553  00db 3f00          	clr	c_lreg
 554  00dd b603          	ld	a,c_lreg+3
 555  00df ca5233        	or	a,21043
 556  00e2 c75233        	ld	21043,a
 557                     ; 135   UART1->BRR1 |= (uint8_t)BaudRate_Mantissa;           
 559  00e5 c65232        	ld	a,21042
 560  00e8 1a0c          	or	a,(OFST+0,sp)
 561  00ea c75232        	ld	21042,a
 562                     ; 138   UART1->CR2 &= (uint8_t)~(UART1_CR2_TEN | UART1_CR2_REN); 
 564  00ed c65235        	ld	a,21045
 565  00f0 a4f3          	and	a,#243
 566  00f2 c75235        	ld	21045,a
 567                     ; 140   UART1->CR3 &= (uint8_t)~(UART1_CR3_CPOL | UART1_CR3_CPHA | UART1_CR3_LBCL); 
 569  00f5 c65236        	ld	a,21046
 570  00f8 a4f8          	and	a,#248
 571  00fa c75236        	ld	21046,a
 572                     ; 142   UART1->CR3 |= (uint8_t)((uint8_t)SyncMode & (uint8_t)(UART1_CR3_CPOL | 
 572                     ; 143                                                         UART1_CR3_CPHA | UART1_CR3_LBCL));  
 574  00fd 7b16          	ld	a,(OFST+10,sp)
 575  00ff a407          	and	a,#7
 576  0101 ca5236        	or	a,21046
 577  0104 c75236        	ld	21046,a
 578                     ; 145   if ((uint8_t)(Mode & UART1_MODE_TX_ENABLE))
 580  0107 7b17          	ld	a,(OFST+11,sp)
 581  0109 a504          	bcp	a,#4
 582  010b 2706          	jreq	L371
 583                     ; 148     UART1->CR2 |= (uint8_t)UART1_CR2_TEN;  
 585  010d 72165235      	bset	21045,#3
 587  0111 2004          	jra	L571
 588  0113               L371:
 589                     ; 153     UART1->CR2 &= (uint8_t)(~UART1_CR2_TEN);  
 591  0113 72175235      	bres	21045,#3
 592  0117               L571:
 593                     ; 155   if ((uint8_t)(Mode & UART1_MODE_RX_ENABLE))
 595  0117 7b17          	ld	a,(OFST+11,sp)
 596  0119 a508          	bcp	a,#8
 597  011b 2706          	jreq	L771
 598                     ; 158     UART1->CR2 |= (uint8_t)UART1_CR2_REN;  
 600  011d 72145235      	bset	21045,#2
 602  0121 2004          	jra	L102
 603  0123               L771:
 604                     ; 163     UART1->CR2 &= (uint8_t)(~UART1_CR2_REN);  
 606  0123 72155235      	bres	21045,#2
 607  0127               L102:
 608                     ; 167   if ((uint8_t)(SyncMode & UART1_SYNCMODE_CLOCK_DISABLE))
 610  0127 7b16          	ld	a,(OFST+10,sp)
 611  0129 a580          	bcp	a,#128
 612  012b 2706          	jreq	L302
 613                     ; 170     UART1->CR3 &= (uint8_t)(~UART1_CR3_CKEN); 
 615  012d 72175236      	bres	21046,#3
 617  0131 200a          	jra	L502
 618  0133               L302:
 619                     ; 174     UART1->CR3 |= (uint8_t)((uint8_t)SyncMode & UART1_CR3_CKEN);
 621  0133 7b16          	ld	a,(OFST+10,sp)
 622  0135 a408          	and	a,#8
 623  0137 ca5236        	or	a,21046
 624  013a c75236        	ld	21046,a
 625  013d               L502:
 626                     ; 176 }
 629  013d 5b0c          	addw	sp,#12
 630  013f 81            	ret
 685                     ; 184 void UART1_Cmd(FunctionalState NewState)
 685                     ; 185 {
 686                     .text:	section	.text,new
 687  0000               _UART1_Cmd:
 691                     ; 186   if (NewState != DISABLE)
 693  0000 4d            	tnz	a
 694  0001 2706          	jreq	L532
 695                     ; 189     UART1->CR1 &= (uint8_t)(~UART1_CR1_UARTD); 
 697  0003 721b5234      	bres	21044,#5
 699  0007 2004          	jra	L732
 700  0009               L532:
 701                     ; 194     UART1->CR1 |= UART1_CR1_UARTD;  
 703  0009 721a5234      	bset	21044,#5
 704  000d               L732:
 705                     ; 196 }
 708  000d 81            	ret
 833                     ; 211 void UART1_ITConfig(UART1_IT_TypeDef UART1_IT, FunctionalState NewState)
 833                     ; 212 {
 834                     .text:	section	.text,new
 835  0000               _UART1_ITConfig:
 837  0000 89            	pushw	x
 838  0001 89            	pushw	x
 839       00000002      OFST:	set	2
 842                     ; 213   uint8_t uartreg = 0, itpos = 0x00;
 846                     ; 216   assert_param(IS_UART1_CONFIG_IT_OK(UART1_IT));
 848                     ; 217   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 850                     ; 220   uartreg = (uint8_t)((uint16_t)UART1_IT >> 0x08);
 852  0002 9e            	ld	a,xh
 853  0003 6b01          	ld	(OFST-1,sp),a
 854                     ; 222   itpos = (uint8_t)((uint8_t)1 << (uint8_t)((uint8_t)UART1_IT & (uint8_t)0x0F));
 856  0005 9f            	ld	a,xl
 857  0006 a40f          	and	a,#15
 858  0008 5f            	clrw	x
 859  0009 97            	ld	xl,a
 860  000a a601          	ld	a,#1
 861  000c 5d            	tnzw	x
 862  000d 2704          	jreq	L61
 863  000f               L02:
 864  000f 48            	sll	a
 865  0010 5a            	decw	x
 866  0011 26fc          	jrne	L02
 867  0013               L61:
 868  0013 6b02          	ld	(OFST+0,sp),a
 869                     ; 224   if (NewState != DISABLE)
 871  0015 0d07          	tnz	(OFST+5,sp)
 872  0017 272a          	jreq	L713
 873                     ; 227     if (uartreg == 0x01)
 875  0019 7b01          	ld	a,(OFST-1,sp)
 876  001b a101          	cp	a,#1
 877  001d 260a          	jrne	L123
 878                     ; 229       UART1->CR1 |= itpos;
 880  001f c65234        	ld	a,21044
 881  0022 1a02          	or	a,(OFST+0,sp)
 882  0024 c75234        	ld	21044,a
 884  0027 2045          	jra	L133
 885  0029               L123:
 886                     ; 231     else if (uartreg == 0x02)
 888  0029 7b01          	ld	a,(OFST-1,sp)
 889  002b a102          	cp	a,#2
 890  002d 260a          	jrne	L523
 891                     ; 233       UART1->CR2 |= itpos;
 893  002f c65235        	ld	a,21045
 894  0032 1a02          	or	a,(OFST+0,sp)
 895  0034 c75235        	ld	21045,a
 897  0037 2035          	jra	L133
 898  0039               L523:
 899                     ; 237       UART1->CR4 |= itpos;
 901  0039 c65237        	ld	a,21047
 902  003c 1a02          	or	a,(OFST+0,sp)
 903  003e c75237        	ld	21047,a
 904  0041 202b          	jra	L133
 905  0043               L713:
 906                     ; 243     if (uartreg == 0x01)
 908  0043 7b01          	ld	a,(OFST-1,sp)
 909  0045 a101          	cp	a,#1
 910  0047 260b          	jrne	L333
 911                     ; 245       UART1->CR1 &= (uint8_t)(~itpos);
 913  0049 7b02          	ld	a,(OFST+0,sp)
 914  004b 43            	cpl	a
 915  004c c45234        	and	a,21044
 916  004f c75234        	ld	21044,a
 918  0052 201a          	jra	L133
 919  0054               L333:
 920                     ; 247     else if (uartreg == 0x02)
 922  0054 7b01          	ld	a,(OFST-1,sp)
 923  0056 a102          	cp	a,#2
 924  0058 260b          	jrne	L733
 925                     ; 249       UART1->CR2 &= (uint8_t)(~itpos);
 927  005a 7b02          	ld	a,(OFST+0,sp)
 928  005c 43            	cpl	a
 929  005d c45235        	and	a,21045
 930  0060 c75235        	ld	21045,a
 932  0063 2009          	jra	L133
 933  0065               L733:
 934                     ; 253       UART1->CR4 &= (uint8_t)(~itpos);
 936  0065 7b02          	ld	a,(OFST+0,sp)
 937  0067 43            	cpl	a
 938  0068 c45237        	and	a,21047
 939  006b c75237        	ld	21047,a
 940  006e               L133:
 941                     ; 257 }
 944  006e 5b04          	addw	sp,#4
 945  0070 81            	ret
 981                     ; 265 void UART1_HalfDuplexCmd(FunctionalState NewState)
 981                     ; 266 {
 982                     .text:	section	.text,new
 983  0000               _UART1_HalfDuplexCmd:
 987                     ; 267   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 989                     ; 269   if (NewState != DISABLE)
 991  0000 4d            	tnz	a
 992  0001 2706          	jreq	L163
 993                     ; 271     UART1->CR5 |= UART1_CR5_HDSEL;  /**< UART1 Half Duplex Enable  */
 995  0003 72165238      	bset	21048,#3
 997  0007 2004          	jra	L363
 998  0009               L163:
 999                     ; 275     UART1->CR5 &= (uint8_t)~UART1_CR5_HDSEL; /**< UART1 Half Duplex Disable */
1001  0009 72175238      	bres	21048,#3
1002  000d               L363:
1003                     ; 277 }
1006  000d 81            	ret
1063                     ; 285 void UART1_IrDAConfig(UART1_IrDAMode_TypeDef UART1_IrDAMode)
1063                     ; 286 {
1064                     .text:	section	.text,new
1065  0000               _UART1_IrDAConfig:
1069                     ; 287   assert_param(IS_UART1_IRDAMODE_OK(UART1_IrDAMode));
1071                     ; 289   if (UART1_IrDAMode != UART1_IRDAMODE_NORMAL)
1073  0000 4d            	tnz	a
1074  0001 2706          	jreq	L314
1075                     ; 291     UART1->CR5 |= UART1_CR5_IRLP;
1077  0003 72145238      	bset	21048,#2
1079  0007 2004          	jra	L514
1080  0009               L314:
1081                     ; 295     UART1->CR5 &= ((uint8_t)~UART1_CR5_IRLP);
1083  0009 72155238      	bres	21048,#2
1084  000d               L514:
1085                     ; 297 }
1088  000d 81            	ret
1123                     ; 305 void UART1_IrDACmd(FunctionalState NewState)
1123                     ; 306 {
1124                     .text:	section	.text,new
1125  0000               _UART1_IrDACmd:
1129                     ; 308   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1131                     ; 310   if (NewState != DISABLE)
1133  0000 4d            	tnz	a
1134  0001 2706          	jreq	L534
1135                     ; 313     UART1->CR5 |= UART1_CR5_IREN;
1137  0003 72125238      	bset	21048,#1
1139  0007 2004          	jra	L734
1140  0009               L534:
1141                     ; 318     UART1->CR5 &= ((uint8_t)~UART1_CR5_IREN);
1143  0009 72135238      	bres	21048,#1
1144  000d               L734:
1145                     ; 320 }
1148  000d 81            	ret
1207                     ; 329 void UART1_LINBreakDetectionConfig(UART1_LINBreakDetectionLength_TypeDef UART1_LINBreakDetectionLength)
1207                     ; 330 {
1208                     .text:	section	.text,new
1209  0000               _UART1_LINBreakDetectionConfig:
1213                     ; 331   assert_param(IS_UART1_LINBREAKDETECTIONLENGTH_OK(UART1_LINBreakDetectionLength));
1215                     ; 333   if (UART1_LINBreakDetectionLength != UART1_LINBREAKDETECTIONLENGTH_10BITS)
1217  0000 4d            	tnz	a
1218  0001 2706          	jreq	L764
1219                     ; 335     UART1->CR4 |= UART1_CR4_LBDL;
1221  0003 721a5237      	bset	21047,#5
1223  0007 2004          	jra	L174
1224  0009               L764:
1225                     ; 339     UART1->CR4 &= ((uint8_t)~UART1_CR4_LBDL);
1227  0009 721b5237      	bres	21047,#5
1228  000d               L174:
1229                     ; 341 }
1232  000d 81            	ret
1267                     ; 349 void UART1_LINCmd(FunctionalState NewState)
1267                     ; 350 {
1268                     .text:	section	.text,new
1269  0000               _UART1_LINCmd:
1273                     ; 351   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1275                     ; 353   if (NewState != DISABLE)
1277  0000 4d            	tnz	a
1278  0001 2706          	jreq	L115
1279                     ; 356     UART1->CR3 |= UART1_CR3_LINEN;
1281  0003 721c5236      	bset	21046,#6
1283  0007 2004          	jra	L315
1284  0009               L115:
1285                     ; 361     UART1->CR3 &= ((uint8_t)~UART1_CR3_LINEN);
1287  0009 721d5236      	bres	21046,#6
1288  000d               L315:
1289                     ; 363 }
1292  000d 81            	ret
1327                     ; 371 void UART1_SmartCardCmd(FunctionalState NewState)
1327                     ; 372 {
1328                     .text:	section	.text,new
1329  0000               _UART1_SmartCardCmd:
1333                     ; 373   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1335                     ; 375   if (NewState != DISABLE)
1337  0000 4d            	tnz	a
1338  0001 2706          	jreq	L335
1339                     ; 378     UART1->CR5 |= UART1_CR5_SCEN;
1341  0003 721a5238      	bset	21048,#5
1343  0007 2004          	jra	L535
1344  0009               L335:
1345                     ; 383     UART1->CR5 &= ((uint8_t)(~UART1_CR5_SCEN));
1347  0009 721b5238      	bres	21048,#5
1348  000d               L535:
1349                     ; 385 }
1352  000d 81            	ret
1388                     ; 394 void UART1_SmartCardNACKCmd(FunctionalState NewState)
1388                     ; 395 {
1389                     .text:	section	.text,new
1390  0000               _UART1_SmartCardNACKCmd:
1394                     ; 396   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1396                     ; 398   if (NewState != DISABLE)
1398  0000 4d            	tnz	a
1399  0001 2706          	jreq	L555
1400                     ; 401     UART1->CR5 |= UART1_CR5_NACK;
1402  0003 72185238      	bset	21048,#4
1404  0007 2004          	jra	L755
1405  0009               L555:
1406                     ; 406     UART1->CR5 &= ((uint8_t)~(UART1_CR5_NACK));
1408  0009 72195238      	bres	21048,#4
1409  000d               L755:
1410                     ; 408 }
1413  000d 81            	ret
1470                     ; 416 void UART1_WakeUpConfig(UART1_WakeUp_TypeDef UART1_WakeUp)
1470                     ; 417 {
1471                     .text:	section	.text,new
1472  0000               _UART1_WakeUpConfig:
1476                     ; 418   assert_param(IS_UART1_WAKEUP_OK(UART1_WakeUp));
1478                     ; 420   UART1->CR1 &= ((uint8_t)~UART1_CR1_WAKE);
1480  0000 72175234      	bres	21044,#3
1481                     ; 421   UART1->CR1 |= (uint8_t)UART1_WakeUp;
1483  0004 ca5234        	or	a,21044
1484  0007 c75234        	ld	21044,a
1485                     ; 422 }
1488  000a 81            	ret
1524                     ; 430 void UART1_ReceiverWakeUpCmd(FunctionalState NewState)
1524                     ; 431 {
1525                     .text:	section	.text,new
1526  0000               _UART1_ReceiverWakeUpCmd:
1530                     ; 432   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1532                     ; 434   if (NewState != DISABLE)
1534  0000 4d            	tnz	a
1535  0001 2706          	jreq	L526
1536                     ; 437     UART1->CR2 |= UART1_CR2_RWU;
1538  0003 72125235      	bset	21045,#1
1540  0007 2004          	jra	L726
1541  0009               L526:
1542                     ; 442     UART1->CR2 &= ((uint8_t)~UART1_CR2_RWU);
1544  0009 72135235      	bres	21045,#1
1545  000d               L726:
1546                     ; 444 }
1549  000d 81            	ret
1572                     ; 451 uint8_t UART1_ReceiveData8(void)
1572                     ; 452 {
1573                     .text:	section	.text,new
1574  0000               _UART1_ReceiveData8:
1578                     ; 453   return ((uint8_t)UART1->DR);
1580  0000 c65231        	ld	a,21041
1583  0003 81            	ret
1617                     ; 461 uint16_t UART1_ReceiveData9(void)
1617                     ; 462 {
1618                     .text:	section	.text,new
1619  0000               _UART1_ReceiveData9:
1621  0000 89            	pushw	x
1622       00000002      OFST:	set	2
1625                     ; 463   uint16_t temp = 0;
1627                     ; 465   temp = (uint16_t)(((uint16_t)( (uint16_t)UART1->CR1 & (uint16_t)UART1_CR1_R8)) << 1);
1629  0001 c65234        	ld	a,21044
1630  0004 5f            	clrw	x
1631  0005 a480          	and	a,#128
1632  0007 5f            	clrw	x
1633  0008 02            	rlwa	x,a
1634  0009 58            	sllw	x
1635  000a 1f01          	ldw	(OFST-1,sp),x
1636                     ; 466   return (uint16_t)( (((uint16_t) UART1->DR) | temp ) & ((uint16_t)0x01FF));
1638  000c c65231        	ld	a,21041
1639  000f 5f            	clrw	x
1640  0010 97            	ld	xl,a
1641  0011 01            	rrwa	x,a
1642  0012 1a02          	or	a,(OFST+0,sp)
1643  0014 01            	rrwa	x,a
1644  0015 1a01          	or	a,(OFST-1,sp)
1645  0017 01            	rrwa	x,a
1646  0018 01            	rrwa	x,a
1647  0019 a4ff          	and	a,#255
1648  001b 01            	rrwa	x,a
1649  001c a401          	and	a,#1
1650  001e 01            	rrwa	x,a
1653  001f 5b02          	addw	sp,#2
1654  0021 81            	ret
1688                     ; 474 void UART1_SendData8(uint8_t Data)
1688                     ; 475 {
1689                     .text:	section	.text,new
1690  0000               _UART1_SendData8:
1694                     ; 477   UART1->DR = Data;
1696  0000 c75231        	ld	21041,a
1697                     ; 478 }
1700  0003 81            	ret
1734                     ; 486 void UART1_SendData9(uint16_t Data)
1734                     ; 487 {
1735                     .text:	section	.text,new
1736  0000               _UART1_SendData9:
1738  0000 89            	pushw	x
1739       00000000      OFST:	set	0
1742                     ; 489   UART1->CR1 &= ((uint8_t)~UART1_CR1_T8);
1744  0001 721d5234      	bres	21044,#6
1745                     ; 491   UART1->CR1 |= (uint8_t)(((uint8_t)(Data >> 2)) & UART1_CR1_T8);
1747  0005 54            	srlw	x
1748  0006 54            	srlw	x
1749  0007 9f            	ld	a,xl
1750  0008 a440          	and	a,#64
1751  000a ca5234        	or	a,21044
1752  000d c75234        	ld	21044,a
1753                     ; 493   UART1->DR   = (uint8_t)(Data);
1755  0010 7b02          	ld	a,(OFST+2,sp)
1756  0012 c75231        	ld	21041,a
1757                     ; 494 }
1760  0015 85            	popw	x
1761  0016 81            	ret
1784                     ; 501 void UART1_SendBreak(void)
1784                     ; 502 {
1785                     .text:	section	.text,new
1786  0000               _UART1_SendBreak:
1790                     ; 503   UART1->CR2 |= UART1_CR2_SBK;
1792  0000 72105235      	bset	21045,#0
1793                     ; 504 }
1796  0004 81            	ret
1830                     ; 511 void UART1_SetAddress(uint8_t UART1_Address)
1830                     ; 512 {
1831                     .text:	section	.text,new
1832  0000               _UART1_SetAddress:
1834  0000 88            	push	a
1835       00000000      OFST:	set	0
1838                     ; 514   assert_param(IS_UART1_ADDRESS_OK(UART1_Address));
1840                     ; 517   UART1->CR4 &= ((uint8_t)~UART1_CR4_ADD);
1842  0001 c65237        	ld	a,21047
1843  0004 a4f0          	and	a,#240
1844  0006 c75237        	ld	21047,a
1845                     ; 519   UART1->CR4 |= UART1_Address;
1847  0009 c65237        	ld	a,21047
1848  000c 1a01          	or	a,(OFST+1,sp)
1849  000e c75237        	ld	21047,a
1850                     ; 520 }
1853  0011 84            	pop	a
1854  0012 81            	ret
1888                     ; 528 void UART1_SetGuardTime(uint8_t UART1_GuardTime)
1888                     ; 529 {
1889                     .text:	section	.text,new
1890  0000               _UART1_SetGuardTime:
1894                     ; 531   UART1->GTR = UART1_GuardTime;
1896  0000 c75239        	ld	21049,a
1897                     ; 532 }
1900  0003 81            	ret
1934                     ; 556 void UART1_SetPrescaler(uint8_t UART1_Prescaler)
1934                     ; 557 {
1935                     .text:	section	.text,new
1936  0000               _UART1_SetPrescaler:
1940                     ; 559   UART1->PSCR = UART1_Prescaler;
1942  0000 c7523a        	ld	21050,a
1943                     ; 560 }
1946  0003 81            	ret
2089                     ; 568 FlagStatus UART1_GetFlagStatus(UART1_Flag_TypeDef UART1_FLAG)
2089                     ; 569 {
2090                     .text:	section	.text,new
2091  0000               _UART1_GetFlagStatus:
2093  0000 89            	pushw	x
2094  0001 88            	push	a
2095       00000001      OFST:	set	1
2098                     ; 570   FlagStatus status = RESET;
2100                     ; 573   assert_param(IS_UART1_FLAG_OK(UART1_FLAG));
2102                     ; 577   if (UART1_FLAG == UART1_FLAG_LBDF)
2104  0002 a30210        	cpw	x,#528
2105  0005 2610          	jrne	L7501
2106                     ; 579     if ((UART1->CR4 & (uint8_t)UART1_FLAG) != (uint8_t)0x00)
2108  0007 9f            	ld	a,xl
2109  0008 c45237        	and	a,21047
2110  000b 2706          	jreq	L1601
2111                     ; 582       status = SET;
2113  000d a601          	ld	a,#1
2114  000f 6b01          	ld	(OFST+0,sp),a
2116  0011 202b          	jra	L5601
2117  0013               L1601:
2118                     ; 587       status = RESET;
2120  0013 0f01          	clr	(OFST+0,sp)
2121  0015 2027          	jra	L5601
2122  0017               L7501:
2123                     ; 590   else if (UART1_FLAG == UART1_FLAG_SBK)
2125  0017 1e02          	ldw	x,(OFST+1,sp)
2126  0019 a30101        	cpw	x,#257
2127  001c 2611          	jrne	L7601
2128                     ; 592     if ((UART1->CR2 & (uint8_t)UART1_FLAG) != (uint8_t)0x00)
2130  001e c65235        	ld	a,21045
2131  0021 1503          	bcp	a,(OFST+2,sp)
2132  0023 2706          	jreq	L1701
2133                     ; 595       status = SET;
2135  0025 a601          	ld	a,#1
2136  0027 6b01          	ld	(OFST+0,sp),a
2138  0029 2013          	jra	L5601
2139  002b               L1701:
2140                     ; 600       status = RESET;
2142  002b 0f01          	clr	(OFST+0,sp)
2143  002d 200f          	jra	L5601
2144  002f               L7601:
2145                     ; 605     if ((UART1->SR & (uint8_t)UART1_FLAG) != (uint8_t)0x00)
2147  002f c65230        	ld	a,21040
2148  0032 1503          	bcp	a,(OFST+2,sp)
2149  0034 2706          	jreq	L7701
2150                     ; 608       status = SET;
2152  0036 a601          	ld	a,#1
2153  0038 6b01          	ld	(OFST+0,sp),a
2155  003a 2002          	jra	L5601
2156  003c               L7701:
2157                     ; 613       status = RESET;
2159  003c 0f01          	clr	(OFST+0,sp)
2160  003e               L5601:
2161                     ; 617   return status;
2163  003e 7b01          	ld	a,(OFST+0,sp)
2166  0040 5b03          	addw	sp,#3
2167  0042 81            	ret
2202                     ; 646 void UART1_ClearFlag(UART1_Flag_TypeDef UART1_FLAG)
2202                     ; 647 {
2203                     .text:	section	.text,new
2204  0000               _UART1_ClearFlag:
2208                     ; 648   assert_param(IS_UART1_CLEAR_FLAG_OK(UART1_FLAG));
2210                     ; 651   if (UART1_FLAG == UART1_FLAG_RXNE)
2212  0000 a30020        	cpw	x,#32
2213  0003 2606          	jrne	L1211
2214                     ; 653     UART1->SR = (uint8_t)~(UART1_SR_RXNE);
2216  0005 35df5230      	mov	21040,#223
2218  0009 2004          	jra	L3211
2219  000b               L1211:
2220                     ; 658     UART1->CR4 &= (uint8_t)~(UART1_CR4_LBDF);
2222  000b 72195237      	bres	21047,#4
2223  000f               L3211:
2224                     ; 660 }
2227  000f 81            	ret
2309                     ; 675 ITStatus UART1_GetITStatus(UART1_IT_TypeDef UART1_IT)
2309                     ; 676 {
2310                     .text:	section	.text,new
2311  0000               _UART1_GetITStatus:
2313  0000 89            	pushw	x
2314  0001 89            	pushw	x
2315       00000002      OFST:	set	2
2318                     ; 677   ITStatus pendingbitstatus = RESET;
2320                     ; 678   uint8_t itpos = 0;
2322                     ; 679   uint8_t itmask1 = 0;
2324                     ; 680   uint8_t itmask2 = 0;
2326                     ; 681   uint8_t enablestatus = 0;
2328                     ; 684   assert_param(IS_UART1_GET_IT_OK(UART1_IT));
2330                     ; 687   itpos = (uint8_t)((uint8_t)1 << (uint8_t)((uint8_t)UART1_IT & (uint8_t)0x0F));
2332  0002 9f            	ld	a,xl
2333  0003 a40f          	and	a,#15
2334  0005 5f            	clrw	x
2335  0006 97            	ld	xl,a
2336  0007 a601          	ld	a,#1
2337  0009 5d            	tnzw	x
2338  000a 2704          	jreq	L27
2339  000c               L47:
2340  000c 48            	sll	a
2341  000d 5a            	decw	x
2342  000e 26fc          	jrne	L47
2343  0010               L27:
2344  0010 6b01          	ld	(OFST-1,sp),a
2345                     ; 689   itmask1 = (uint8_t)((uint8_t)UART1_IT >> (uint8_t)4);
2347  0012 7b04          	ld	a,(OFST+2,sp)
2348  0014 4e            	swap	a
2349  0015 a40f          	and	a,#15
2350  0017 6b02          	ld	(OFST+0,sp),a
2351                     ; 691   itmask2 = (uint8_t)((uint8_t)1 << itmask1);
2353  0019 7b02          	ld	a,(OFST+0,sp)
2354  001b 5f            	clrw	x
2355  001c 97            	ld	xl,a
2356  001d a601          	ld	a,#1
2357  001f 5d            	tnzw	x
2358  0020 2704          	jreq	L67
2359  0022               L001:
2360  0022 48            	sll	a
2361  0023 5a            	decw	x
2362  0024 26fc          	jrne	L001
2363  0026               L67:
2364  0026 6b02          	ld	(OFST+0,sp),a
2365                     ; 695   if (UART1_IT == UART1_IT_PE)
2367  0028 1e03          	ldw	x,(OFST+1,sp)
2368  002a a30100        	cpw	x,#256
2369  002d 261c          	jrne	L7611
2370                     ; 698     enablestatus = (uint8_t)((uint8_t)UART1->CR1 & itmask2);
2372  002f c65234        	ld	a,21044
2373  0032 1402          	and	a,(OFST+0,sp)
2374  0034 6b02          	ld	(OFST+0,sp),a
2375                     ; 701     if (((UART1->SR & itpos) != (uint8_t)0x00) && enablestatus)
2377  0036 c65230        	ld	a,21040
2378  0039 1501          	bcp	a,(OFST-1,sp)
2379  003b 270a          	jreq	L1711
2381  003d 0d02          	tnz	(OFST+0,sp)
2382  003f 2706          	jreq	L1711
2383                     ; 704       pendingbitstatus = SET;
2385  0041 a601          	ld	a,#1
2386  0043 6b02          	ld	(OFST+0,sp),a
2388  0045 2041          	jra	L5711
2389  0047               L1711:
2390                     ; 709       pendingbitstatus = RESET;
2392  0047 0f02          	clr	(OFST+0,sp)
2393  0049 203d          	jra	L5711
2394  004b               L7611:
2395                     ; 713   else if (UART1_IT == UART1_IT_LBDF)
2397  004b 1e03          	ldw	x,(OFST+1,sp)
2398  004d a30346        	cpw	x,#838
2399  0050 261c          	jrne	L7711
2400                     ; 716     enablestatus = (uint8_t)((uint8_t)UART1->CR4 & itmask2);
2402  0052 c65237        	ld	a,21047
2403  0055 1402          	and	a,(OFST+0,sp)
2404  0057 6b02          	ld	(OFST+0,sp),a
2405                     ; 718     if (((UART1->CR4 & itpos) != (uint8_t)0x00) && enablestatus)
2407  0059 c65237        	ld	a,21047
2408  005c 1501          	bcp	a,(OFST-1,sp)
2409  005e 270a          	jreq	L1021
2411  0060 0d02          	tnz	(OFST+0,sp)
2412  0062 2706          	jreq	L1021
2413                     ; 721       pendingbitstatus = SET;
2415  0064 a601          	ld	a,#1
2416  0066 6b02          	ld	(OFST+0,sp),a
2418  0068 201e          	jra	L5711
2419  006a               L1021:
2420                     ; 726       pendingbitstatus = RESET;
2422  006a 0f02          	clr	(OFST+0,sp)
2423  006c 201a          	jra	L5711
2424  006e               L7711:
2425                     ; 732     enablestatus = (uint8_t)((uint8_t)UART1->CR2 & itmask2);
2427  006e c65235        	ld	a,21045
2428  0071 1402          	and	a,(OFST+0,sp)
2429  0073 6b02          	ld	(OFST+0,sp),a
2430                     ; 734     if (((UART1->SR & itpos) != (uint8_t)0x00) && enablestatus)
2432  0075 c65230        	ld	a,21040
2433  0078 1501          	bcp	a,(OFST-1,sp)
2434  007a 270a          	jreq	L7021
2436  007c 0d02          	tnz	(OFST+0,sp)
2437  007e 2706          	jreq	L7021
2438                     ; 737       pendingbitstatus = SET;
2440  0080 a601          	ld	a,#1
2441  0082 6b02          	ld	(OFST+0,sp),a
2443  0084 2002          	jra	L5711
2444  0086               L7021:
2445                     ; 742       pendingbitstatus = RESET;
2447  0086 0f02          	clr	(OFST+0,sp)
2448  0088               L5711:
2449                     ; 747   return  pendingbitstatus;
2451  0088 7b02          	ld	a,(OFST+0,sp)
2454  008a 5b04          	addw	sp,#4
2455  008c 81            	ret
2491                     ; 775 void UART1_ClearITPendingBit(UART1_IT_TypeDef UART1_IT)
2491                     ; 776 {
2492                     .text:	section	.text,new
2493  0000               _UART1_ClearITPendingBit:
2497                     ; 777   assert_param(IS_UART1_CLEAR_IT_OK(UART1_IT));
2499                     ; 780   if (UART1_IT == UART1_IT_RXNE)
2501  0000 a30255        	cpw	x,#597
2502  0003 2606          	jrne	L1321
2503                     ; 782     UART1->SR = (uint8_t)~(UART1_SR_RXNE);
2505  0005 35df5230      	mov	21040,#223
2507  0009 2004          	jra	L3321
2508  000b               L1321:
2509                     ; 787     UART1->CR4 &= (uint8_t)~(UART1_CR4_LBDF);
2511  000b 72195237      	bres	21047,#4
2512  000f               L3321:
2513                     ; 789 }
2516  000f 81            	ret
2529                     	xdef	_UART1_ClearITPendingBit
2530                     	xdef	_UART1_GetITStatus
2531                     	xdef	_UART1_ClearFlag
2532                     	xdef	_UART1_GetFlagStatus
2533                     	xdef	_UART1_SetPrescaler
2534                     	xdef	_UART1_SetGuardTime
2535                     	xdef	_UART1_SetAddress
2536                     	xdef	_UART1_SendBreak
2537                     	xdef	_UART1_SendData9
2538                     	xdef	_UART1_SendData8
2539                     	xdef	_UART1_ReceiveData9
2540                     	xdef	_UART1_ReceiveData8
2541                     	xdef	_UART1_ReceiverWakeUpCmd
2542                     	xdef	_UART1_WakeUpConfig
2543                     	xdef	_UART1_SmartCardNACKCmd
2544                     	xdef	_UART1_SmartCardCmd
2545                     	xdef	_UART1_LINCmd
2546                     	xdef	_UART1_LINBreakDetectionConfig
2547                     	xdef	_UART1_IrDACmd
2548                     	xdef	_UART1_IrDAConfig
2549                     	xdef	_UART1_HalfDuplexCmd
2550                     	xdef	_UART1_ITConfig
2551                     	xdef	_UART1_Cmd
2552                     	xdef	_UART1_Init
2553                     	xdef	_UART1_DeInit
2554                     	xref	_CLK_GetClockFreq
2555                     	xref.b	c_lreg
2556                     	xref.b	c_x
2575                     	xref	c_lursh
2576                     	xref	c_lsub
2577                     	xref	c_smul
2578                     	xref	c_ludv
2579                     	xref	c_rtol
2580                     	xref	c_llsh
2581                     	xref	c_ltor
2582                     	end
