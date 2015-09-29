
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32A
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _flagtancong=R4
	.DEF _offsetphongthu=R6
	.DEF _goctancong=R8
	.DEF _cmdCtrlRobot=R10
	.DEF _idRobot=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_ASCII:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x3E,0x51,0x49,0x45,0x3E,0x0,0x42,0x7F
	.DB  0x40,0x0,0x42,0x61,0x51,0x49,0x46,0x21
	.DB  0x41,0x45,0x4B,0x31,0x18,0x14,0x12,0x7F
	.DB  0x10,0x27,0x45,0x45,0x45,0x39,0x3C,0x4A
	.DB  0x49,0x49,0x30,0x1,0x71,0x9,0x5,0x3
	.DB  0x36,0x49,0x49,0x49,0x36,0x6,0x49,0x49
	.DB  0x29,0x1E,0x0,0x36,0x36,0x0,0x0,0x0
	.DB  0x56,0x36,0x0,0x0,0x8,0x14,0x22,0x41
	.DB  0x0,0x14,0x14,0x14,0x14,0x14,0x0,0x41
	.DB  0x22,0x14,0x8,0x2,0x1,0x51,0x9,0x6
	.DB  0x32,0x49,0x79,0x41,0x3E,0x7E,0x11,0x11
	.DB  0x11,0x7E,0x7F,0x49,0x49,0x49,0x36,0x3E
	.DB  0x41,0x41,0x41,0x22,0x7F,0x41,0x41,0x22
	.DB  0x1C,0x7F,0x49,0x49,0x49,0x41,0x7F,0x9
	.DB  0x9,0x9,0x1,0x3E,0x41,0x49,0x49,0x7A
	.DB  0x7F,0x8,0x8,0x8,0x7F,0x0,0x41,0x7F
	.DB  0x41,0x0,0x20,0x40,0x41,0x3F,0x1,0x7F
	.DB  0x8,0x14,0x22,0x41,0x7F,0x40,0x40,0x40
	.DB  0x40,0x7F,0x2,0xC,0x2,0x7F,0x7F,0x4
	.DB  0x8,0x10,0x7F,0x3E,0x41,0x41,0x41,0x3E
	.DB  0x7F,0x9,0x9,0x9,0x6,0x3E,0x41,0x51
	.DB  0x21,0x5E,0x7F,0x9,0x19,0x29,0x46,0x46
	.DB  0x49,0x49,0x49,0x31,0x1,0x1,0x7F,0x1
	.DB  0x1,0x3F,0x40,0x40,0x40,0x3F,0x1F,0x20
	.DB  0x40,0x20,0x1F,0x3F,0x40,0x38,0x40,0x3F
	.DB  0x63,0x14,0x8,0x14,0x63,0x7,0x8,0x70
	.DB  0x8,0x7,0x61,0x51,0x49,0x45,0x43,0x0
	.DB  0x7F,0x41,0x41,0x0,0x2,0x4,0x8,0x10
	.DB  0x20,0x0,0x41,0x41,0x7F,0x0,0x4,0x2
	.DB  0x1,0x2,0x4,0x40,0x40,0x40,0x40,0x40
	.DB  0x0,0x1,0x2,0x4,0x0,0x20,0x54,0x54
	.DB  0x54,0x78,0x7F,0x48,0x44,0x44,0x38,0x38
	.DB  0x44,0x44,0x44,0x20,0x38,0x44,0x44,0x48
	.DB  0x7F,0x38,0x54,0x54,0x54,0x18,0x8,0x7E
	.DB  0x9,0x1,0x2,0xC,0x52,0x52,0x52,0x3E
	.DB  0x7F,0x8,0x4,0x4,0x78,0x0,0x44,0x7D
	.DB  0x40,0x0,0x20,0x40,0x44,0x3D,0x0,0x7F
	.DB  0x10,0x28,0x44,0x0,0x0,0x41,0x7F,0x40
	.DB  0x0,0x7C,0x4,0x18,0x4,0x78,0x7C,0x8
	.DB  0x4,0x4,0x78,0x38,0x44,0x44,0x44,0x38
	.DB  0x7C,0x14,0x14,0x14,0x8,0x8,0x14,0x14
	.DB  0x18,0x7C,0x7C,0x8,0x4,0x4,0x8,0x48
	.DB  0x54,0x54,0x54,0x20,0x4,0x3F,0x44,0x40
	.DB  0x20,0x3C,0x40,0x40,0x20,0x7C,0x1C,0x20
	.DB  0x40,0x20,0x1C,0x3C,0x40,0x30,0x40,0x3C
	.DB  0x44,0x28,0x10,0x28,0x44,0xC,0x50,0x50
	.DB  0x50,0x3C,0x44,0x64,0x54,0x4C,0x44,0x0
	.DB  0x8,0x36,0x41,0x0,0x0,0x0,0x7F,0x0
	.DB  0x0,0x0,0x41,0x36,0x8,0x0,0x10,0x8
	.DB  0x8,0x10,0x8,0x78,0x46,0x41,0x46,0x78

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x3:
	.DB  0xE7,0xE7,0xE7,0xE7,0xE7
_0x4:
	.DB  0xE7,0xE7,0xE7,0xE7,0xE7
_0x20003:
	.DB  0x1
_0x20004:
	.DB  0xA
_0x20005:
	.DB  0x1
_0x20006:
	.DB  0xA
_0x20007:
	.DB  0x1
_0x20008:
	.DB  0x1
_0x201C1:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x202F3:
	.DB  0x1,0x0,0x0,0x0,0x0,0x0
_0x20000:
	.DB  0x25,0x64,0x0,0x25,0x30,0x2E,0x32,0x66
	.DB  0x0,0x20,0x3C,0x41,0x4B,0x42,0x4F,0x54
	.DB  0x4B,0x49,0x54,0x3E,0x0,0x52,0x4F,0x42
	.DB  0x4F,0x54,0x20,0x57,0x41,0x4C,0x4C,0x0
	.DB  0x57,0x48,0x49,0x54,0x45,0x20,0x4C,0x49
	.DB  0x4E,0x45,0x0,0x46,0x4F,0x4C,0x4F,0x57
	.DB  0x45,0x52,0x0,0x42,0x4C,0x41,0x43,0x4B
	.DB  0x20,0x4C,0x49,0x4E,0x45,0x0,0x42,0x4C
	.DB  0x55,0x45,0x54,0x4F,0x4F,0x54,0x48,0x0
	.DB  0x44,0x52,0x49,0x56,0x45,0x0,0x54,0x45
	.DB  0x53,0x54,0x20,0x4D,0x4F,0x54,0x4F,0x52
	.DB  0x0,0x4D,0x6F,0x74,0x6F,0x72,0x4C,0x0
	.DB  0x4D,0x6F,0x74,0x6F,0x72,0x52,0x0,0x54
	.DB  0x45,0x53,0x54,0x20,0x55,0x41,0x52,0x54
	.DB  0x0,0x54,0x45,0x53,0x54,0x20,0x49,0x52
	.DB  0x0,0x30,0x2E,0x0,0x31,0x2E,0x0,0x32
	.DB  0x2E,0x0,0x33,0x2E,0x0,0x34,0x2E,0x0
	.DB  0x35,0x2E,0x0,0x36,0x2E,0x0,0x37,0x2E
	.DB  0x0,0x3C,0x53,0x45,0x4C,0x46,0x20,0x54
	.DB  0x45,0x53,0x54,0x3E,0x0,0x2A,0x2A,0x2A
	.DB  0x2A,0x2A,0x2A,0x2A,0x2A,0x2A,0x2A,0x2A
	.DB  0x2A,0x0,0x52,0x43,0x20,0x53,0x45,0x52
	.DB  0x56,0x4F,0x0,0x31,0x2E,0x52,0x4F,0x42
	.DB  0x4F,0x54,0x20,0x57,0x41,0x4C,0x4C,0x0
	.DB  0x32,0x2E,0x42,0x4C,0x55,0x45,0x54,0x4F
	.DB  0x4F,0x54,0x48,0x20,0x0,0x33,0x2E,0x57
	.DB  0x48,0x49,0x54,0x45,0x20,0x4C,0x49,0x4E
	.DB  0x45,0x0,0x34,0x2E,0x42,0x4C,0x41,0x43
	.DB  0x4B,0x20,0x4C,0x49,0x4E,0x45,0x0,0x35
	.DB  0x2E,0x54,0x45,0x53,0x54,0x20,0x4D,0x4F
	.DB  0x54,0x4F,0x52,0x0,0x36,0x2E,0x54,0x45
	.DB  0x53,0x54,0x20,0x49,0x52,0x20,0x20,0x20
	.DB  0x0,0x37,0x2E,0x54,0x45,0x53,0x54,0x20
	.DB  0x52,0x46,0x20,0x20,0x20,0x0,0x38,0x2E
	.DB  0x54,0x45,0x53,0x54,0x20,0x55,0x41,0x52
	.DB  0x54,0x20,0x0,0x39,0x2E,0x52,0x43,0x20
	.DB  0x53,0x45,0x52,0x56,0x4F,0x20,0x0,0x31
	.DB  0x30,0x2E,0x55,0x50,0x44,0x41,0x54,0x45
	.DB  0x20,0x52,0x42,0x0,0x44,0x69,0x6E,0x68
	.DB  0x20,0x4D,0x61,0x68,0x6F,0x6E,0x65,0x0
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x05
	.DW  _TX_ADDRESS
	.DW  _0x3*2

	.DW  0x05
	.DW  _RX_ADDRESS
	.DW  _0x4*2

	.DW  0x01
	.DW  _id
	.DW  _0x20003*2

	.DW  0x01
	.DW  _KpR
	.DW  _0x20004*2

	.DW  0x01
	.DW  _KiR
	.DW  _0x20005*2

	.DW  0x01
	.DW  _KpL
	.DW  _0x20006*2

	.DW  0x01
	.DW  _KiL
	.DW  _0x20007*2

	.DW  0x0C
	.DW  _0x20044
	.DW  _0x20000*2+9

	.DW  0x0B
	.DW  _0x2017A
	.DW  _0x20000*2+21

	.DW  0x0B
	.DW  _0x2018F
	.DW  _0x20000*2+32

	.DW  0x08
	.DW  _0x2018F+11
	.DW  _0x20000*2+43

	.DW  0x0B
	.DW  _0x201C2
	.DW  _0x20000*2+51

	.DW  0x08
	.DW  _0x201C2+11
	.DW  _0x20000*2+43

	.DW  0x0A
	.DW  _0x20210
	.DW  _0x20000*2+62

	.DW  0x06
	.DW  _0x20210+10
	.DW  _0x20000*2+72

	.DW  0x0B
	.DW  _0x20227
	.DW  _0x20000*2+78

	.DW  0x07
	.DW  _0x20227+11
	.DW  _0x20000*2+89

	.DW  0x07
	.DW  _0x20227+18
	.DW  _0x20000*2+96

	.DW  0x0A
	.DW  _0x2022C
	.DW  _0x20000*2+103

	.DW  0x08
	.DW  _0x2022D
	.DW  _0x20000*2+113

	.DW  0x03
	.DW  _0x2022D+8
	.DW  _0x20000*2+121

	.DW  0x03
	.DW  _0x2022D+11
	.DW  _0x20000*2+124

	.DW  0x03
	.DW  _0x2022D+14
	.DW  _0x20000*2+127

	.DW  0x03
	.DW  _0x2022D+17
	.DW  _0x20000*2+130

	.DW  0x03
	.DW  _0x2022D+20
	.DW  _0x20000*2+133

	.DW  0x03
	.DW  _0x2022D+23
	.DW  _0x20000*2+136

	.DW  0x03
	.DW  _0x2022D+26
	.DW  _0x20000*2+139

	.DW  0x03
	.DW  _0x2022D+29
	.DW  _0x20000*2+142

	.DW  0x0C
	.DW  _0x20231
	.DW  _0x20000*2+145

	.DW  0x0D
	.DW  _0x20231+12
	.DW  _0x20000*2+157

	.DW  0x09
	.DW  _0x2029A
	.DW  _0x20000*2+170

	.DW  0x0D
	.DW  _0x202A6
	.DW  _0x20000*2+179

	.DW  0x0D
	.DW  _0x202A6+13
	.DW  _0x20000*2+179

	.DW  0x0D
	.DW  _0x202A6+26
	.DW  _0x20000*2+192

	.DW  0x0D
	.DW  _0x202A6+39
	.DW  _0x20000*2+205

	.DW  0x0D
	.DW  _0x202A6+52
	.DW  _0x20000*2+218

	.DW  0x0D
	.DW  _0x202A6+65
	.DW  _0x20000*2+231

	.DW  0x0D
	.DW  _0x202A6+78
	.DW  _0x20000*2+244

	.DW  0x0D
	.DW  _0x202A6+91
	.DW  _0x20000*2+257

	.DW  0x0D
	.DW  _0x202A6+104
	.DW  _0x20000*2+270

	.DW  0x0C
	.DW  _0x202A6+117
	.DW  _0x20000*2+283

	.DW  0x0D
	.DW  _0x202A6+129
	.DW  _0x20000*2+295

	.DW  0x0B
	.DW  _0x202D2
	.DW  _0x20000*2+10

	.DW  0x0D
	.DW  _0x202D2+11
	.DW  _0x20000*2+157

	.DW  0x0C
	.DW  _0x202D2+24
	.DW  _0x20000*2+308

	.DW  0x06
	.DW  0x04
	.DW  _0x202F3*2

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A0060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <string.h>
;#include <nRF24L01/nRF24L01.h>
;#include <delay.h>
;#include <spi.h>
;
;#define CSN    PORTC.2
;#define CE     PORTC.3
;#define SCK    PORTB.7
;#define MISO   PINB.6
;#define MOSI   PORTB.5
;//********************************************************************************
;//unsigned char const TX_ADDRESS[TX_ADR_WIDTH]= {0x34,0x43,0x10,0x10,0x01};	//
;//unsigned char const RX_ADDRESS[RX_ADR_WIDTH]= {0x34,0x43,0x10,0x10,0x01};	//
;unsigned char const TX_ADDRESS[TX_ADR_WIDTH]= {0xE7,0xE7,0xE7,0xE7,0xE7};	// dia chi phat du lieu

	.DSEG
;unsigned char const RX_ADDRESS[RX_ADR_WIDTH]= {0xE7,0xE7,0xE7,0xE7,0xE7};	// dia chi nhan du lieu
;//****************************************************************************************
;//*NRF24L01
;//***************************************************************************************/
;void init_NRF24L01(void)
; 0000 0015 {

	.CSEG
_init_NRF24L01:
; 0000 0016     //init SPI
; 0000 0017     SPCR=0x51; //set this to 0x50 for 1 mbits
	LDI  R30,LOW(81)
	OUT  0xD,R30
; 0000 0018     SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 0019 
; 0000 001A     //inerDelay_us(100);
; 0000 001B     delay_us(100);
	__DELAY_USW 200
; 0000 001C  	CE=0;    // chip enable
	CBI  0x15,3
; 0000 001D  	CSN=1;   // Spi disable
	SBI  0x15,2
; 0000 001E  	//SCK=0;   // Spi clock line init high
; 0000 001F 	SPI_Write_Buf(WRITE_REG + TX_ADDR, TX_ADDRESS, TX_ADR_WIDTH);    //
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDI  R30,LOW(_TX_ADDRESS)
	LDI  R31,HIGH(_TX_ADDRESS)
	CALL SUBOPT_0x0
; 0000 0020 	SPI_Write_Buf(WRITE_REG + RX_ADDR_P0, RX_ADDRESS, RX_ADR_WIDTH); //
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R30,LOW(_RX_ADDRESS)
	LDI  R31,HIGH(_RX_ADDRESS)
	CALL SUBOPT_0x0
; 0000 0021 	SPI_RW_Reg(WRITE_REG + EN_AA, 0x00);      // EN P0, 2-->P1
	LDI  R30,LOW(33)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0022 	SPI_RW_Reg(WRITE_REG + EN_RXADDR, 0x01);  //Enable data P0
	LDI  R30,LOW(34)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0023 	SPI_RW_Reg(WRITE_REG + RF_CH, 2);        // Chanel 0 RF = 2400 + RF_CH* (1or 2 M)
	LDI  R30,LOW(37)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0024 	SPI_RW_Reg(WRITE_REG + RX_PW_P0, RX_PLOAD_WIDTH); // Do rong data truyen 32 byte
	LDI  R30,LOW(49)
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0025 	SPI_RW_Reg(WRITE_REG + RF_SETUP, 0x07);   		// 1M, 0dbm
	LDI  R30,LOW(38)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0026 	SPI_RW_Reg(WRITE_REG + CONFIG, 0x0e);   		 // Enable CRC, 2 byte CRC, Send
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0027 
; 0000 0028 }
	RET
;/****************************************************************************************************/
;//unsigned char SPI_RW(unsigned char Buff)
;//NRF24L01
;/****************************************************************************************************/
;unsigned char SPI_RW(unsigned char Buff)
; 0000 002E {
_SPI_RW:
; 0000 002F    return spi(Buff);
;	Buff -> Y+0
	LD   R30,Y
	ST   -Y,R30
	CALL _spi
	JMP  _0x20C0007
; 0000 0030 }
;/****************************************************************************************************/
;//unsigned char SPI_Read(unsigned char reg)
;//NRF24L01
;/****************************************************************************************************/
;unsigned char SPI_Read(unsigned char reg)
; 0000 0036 {
_SPI_Read:
; 0000 0037 	unsigned char reg_val;
; 0000 0038 
; 0000 0039 	CSN = 0;                // CSN low, initialize SPI communication...
	ST   -Y,R17
;	reg -> Y+1
;	reg_val -> R17
	CBI  0x15,2
; 0000 003A 	SPI_RW(reg);            // Select register to read from..
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _SPI_RW
; 0000 003B 	reg_val = SPI_RW(0);    // ..then read registervalue
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1
; 0000 003C 	CSN = 1;                // CSN high, terminate SPI communication
	SBI  0x15,2
; 0000 003D 
; 0000 003E 	return(reg_val);        // return register value
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20C0008
; 0000 003F }
;/****************************************************************************************************/
;//unsigned char SPI_RW_Reg(unsigned char reg, unsigned char value)
;/****************************************************************************************************/
;unsigned char SPI_RW_Reg(unsigned char reg, unsigned char value)
; 0000 0044 {
_SPI_RW_Reg:
; 0000 0045 	unsigned char status;
; 0000 0046 
; 0000 0047 	CSN = 0;                   // CSN low, init SPI transaction
	ST   -Y,R17
;	reg -> Y+2
;	value -> Y+1
;	status -> R17
	CBI  0x15,2
; 0000 0048 	status = SPI_RW(reg);      // select register
	LDD  R30,Y+2
	CALL SUBOPT_0x1
; 0000 0049 	SPI_RW(value);             // ..and write value to it..
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _SPI_RW
; 0000 004A 	CSN = 1;                   // CSN high again
	SBI  0x15,2
; 0000 004B 
; 0000 004C 	return(status);            // return nRF24L01 status uchar
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20C000B
; 0000 004D }
;/****************************************************************************************************/
;//unsigned char SPI_Read_Buf(unsigned char reg, unsigned char *pBuf, unsigned char uchars)
;//
;/****************************************************************************************************/
;unsigned char SPI_Read_Buf(unsigned char reg, unsigned char *pBuf, unsigned char uchars)
; 0000 0053 {
_SPI_Read_Buf:
; 0000 0054 	unsigned char status,uchar_ctr;
; 0000 0055 
; 0000 0056 	CSN = 0;                    		// Set CSN low, init SPI tranaction
	ST   -Y,R17
	ST   -Y,R16
;	reg -> Y+5
;	*pBuf -> Y+3
;	uchars -> Y+2
;	status -> R17
;	uchar_ctr -> R16
	CBI  0x15,2
; 0000 0057 	status = SPI_RW(reg);       		// Select register to write to and read status uchar
	LDD  R30,Y+5
	CALL SUBOPT_0x1
; 0000 0058 
; 0000 0059 	for(uchar_ctr=0;uchar_ctr<uchars;uchar_ctr++)
	LDI  R16,LOW(0)
_0x14:
	LDD  R30,Y+2
	CP   R16,R30
	BRSH _0x15
; 0000 005A 		pBuf[uchar_ctr] = SPI_RW(0);    //
	MOV  R30,R16
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _SPI_RW
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R16,-1
	RJMP _0x14
_0x15:
; 0000 005C PORTC.2 = 1;
	SBI  0x15,2
; 0000 005D 
; 0000 005E 	return(status);                    // return nRF24L01 status uchar
	MOV  R30,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
; 0000 005F }
;/*********************************************************************************************************/
;//uint SPI_Write_Buf(uchar reg, uchar *pBuf, uchar uchars)
;/*****************************************************************************************************/
;unsigned char SPI_Write_Buf(unsigned char reg, unsigned char *pBuf, unsigned uchars)
; 0000 0064 {
_SPI_Write_Buf:
; 0000 0065 	unsigned char status,uchar_ctr;
; 0000 0066 	CSN = 0;            //SPI
	ST   -Y,R17
	ST   -Y,R16
;	reg -> Y+6
;	*pBuf -> Y+4
;	uchars -> Y+2
;	status -> R17
;	uchar_ctr -> R16
	CBI  0x15,2
; 0000 0067 	status = SPI_RW(reg);
	LDD  R30,Y+6
	CALL SUBOPT_0x1
; 0000 0068 	for(uchar_ctr=0; uchar_ctr<uchars; uchar_ctr++) //
	LDI  R16,LOW(0)
_0x1B:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	MOV  R26,R16
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x1C
; 0000 0069 	SPI_RW(*pBuf++);
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X+
	STD  Y+4,R26
	STD  Y+4+1,R27
	ST   -Y,R30
	RCALL _SPI_RW
	SUBI R16,-1
	RJMP _0x1B
_0x1C:
; 0000 006A PORTC.2 = 1;
	SBI  0x15,2
; 0000 006B 	return(status);    //
	MOV  R30,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
; 0000 006C }
;/****************************************************************************************************/
;//void SetRX_Mode(void)
;//
;/****************************************************************************************************/
;void SetRX_Mode(void)
; 0000 0072 {
_SetRX_Mode:
; 0000 0073 	CE=0;
	CBI  0x15,3
; 0000 0074 	SPI_RW_Reg(WRITE_REG + CONFIG, 0x07);   		// enable power up and prx
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _SPI_RW_Reg
; 0000 0075 	CE = 1;
	SBI  0x15,3
; 0000 0076 	delay_us(130);    //
	__DELAY_USW 260
; 0000 0077 }
	RET
;/****************************************************************************************************/
;//void SetTX_Mode(void)
;//
;/****************************************************************************************************/
;void SetTX_Mode(void)
; 0000 007D {
; 0000 007E 	CE=0;
; 0000 007F 	SPI_RW_Reg(WRITE_REG + CONFIG, 0x0e);   		// Enable CRC, 2 byte CRC, Send
; 0000 0080 	CE = 1;
; 0000 0081 	delay_us(130);    //
; 0000 0082 }
;
;/******************************************************************************************************/
;//unsigned char nRF24L01_RxPacket(unsigned char* rx_buf)
;/******************************************************************************************************/
;unsigned char nRF24L01_RxPacket(unsigned char* rx_buf)
; 0000 0088 {
_nRF24L01_RxPacket:
; 0000 0089     unsigned char revale=0;
; 0000 008A     unsigned char sta;
; 0000 008B 	sta=SPI_Read(STATUS);	// Read Status
	ST   -Y,R17
	ST   -Y,R16
;	*rx_buf -> Y+2
;	revale -> R17
;	sta -> R16
	LDI  R17,0
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _SPI_Read
	MOV  R16,R30
; 0000 008C 	//if(RX_DR)				// Data in RX FIFO
; 0000 008D     if((sta&0x40)!=0)		// Data in RX FIFO
	SBRS R16,6
	RJMP _0x27
; 0000 008E 	{
; 0000 008F 	    CE = 0; 			//SPI
	CBI  0x15,3
; 0000 0090 		SPI_Read_Buf(RD_RX_PLOAD,rx_buf,TX_PLOAD_WIDTH);// read receive payload from RX_FIFO buffer
	LDI  R30,LOW(97)
	ST   -Y,R30
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _SPI_Read_Buf
; 0000 0091 		revale =1;
	LDI  R17,LOW(1)
; 0000 0092 	}
; 0000 0093 	SPI_RW_Reg(WRITE_REG+STATUS,sta);
_0x27:
	LDI  R30,LOW(39)
	ST   -Y,R30
	ST   -Y,R16
	RCALL _SPI_RW_Reg
; 0000 0094     CE = 1; 			//SPI
	SBI  0x15,3
; 0000 0095 	return revale;
	MOV  R30,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20C0004
; 0000 0096 }
;/***********************************************************************************************************/
;//void nRF24L01_TxPacket(unsigned char * tx_buf)
;//
;/**********************************************************************************************************/
;void nRF24L01_TxPacket(unsigned char * tx_buf)
; 0000 009C {
; 0000 009D 	CE=0;
;	*tx_buf -> Y+0
; 0000 009E 	SPI_Write_Buf(WRITE_REG + RX_ADDR_P0, TX_ADDRESS, TX_ADR_WIDTH); // Send Address
; 0000 009F 	SPI_Write_Buf(WR_TX_PLOAD, tx_buf, TX_PLOAD_WIDTH); 			 //send data
; 0000 00A0 	SPI_RW_Reg(WRITE_REG + CONFIG, 0x0e);   		 // Send Out
; 0000 00A1 	CE=1;
; 0000 00A2 }
;
;// --------------------END OF FILE------------------------
;// -------------------------------------------------------
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Evaluation
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 6/4/2015
;Author  : Freeware, for evaluation and non-commercial use only
;Company :
;Comments:
;
;
;Chip type               : ATmega32A
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;#include "stdio.h"
;#include <string.h>
;#include <stdarg.h>
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <spi.h>
;#include <nRF24L01/nRF24L01.h>
;#include "math.h"
;
;// PIN LED ROBO KIT
;#define LEDL   PORTC.4
;#define LEDR   PORTC.5
;
;#define LEDFL   PORTA.4
;#define LEDFR   PORTA.5
;#define LEDBL   PORTA.6
;#define LEDBR   PORTA.7
;
;#define keyKT   PINC.0 // Nut ben trai
;#define keyKP   PINC.1 // Nut ben phai
;
;#define S0  PINA.0
;#define S1  PINA.1
;#define S2  PINA.2
;#define S3  PINA.3
;#define S4  PINA.7
;
;#define MLdir   PORTC.6
;#define MRdir   PORTC.7
;// PIN NOKIA 5110
;#define RST    PORTB.0
;#define SCE    PORTB.1
;#define DC     PORTB.2
;
;#define DIN    PORTB.5
;#define SCK    PORTB.7
;
;
;#define LCD_C     0
;#define LCD_D     1
;
;#define LCD_X     84
;#define LCD_Y     48
;
;#define Black 1
;#define White 0
;#define Filled 1
;#define NotFilled 0
;
;
;//===========================================bien cho vi tri robot
;#define CtrVelocity    //uncomment de  chon chay pid dieu khien van toc, va su dung cac ham vMLtoi,vMLlui,....
;#define ROBOT_ID 5
;//#define SAN_ID -1 //CHON HUONG TAN CONG LA X <0;
;#define SAN_ID 1  //CHON HUONG TAN CONG LA X >0;
; //PHUC ID
;
;/*    Kieu So Nguyen Co Dau    */
;typedef   signed          char int8_t;
;typedef   signed 	      int int16_t;
;typedef   signed  long    int int32_t;
;
;/*	Kieu So Nguyen Khong Dau */
;typedef   unsigned         char uint8_t;
;typedef   unsigned 	   int  uint16_t;
;typedef   unsigned long    int  uint32_t;
;/*	Kieu So Thuc */
;typedef   float            float32_t;
;
;#define 	M_PI   3.14159265358979323846	/* pi */
;// Declare your global variables here
;typedef struct   {
;	    float x;
;		float y;
;}Ball ;
;
;
;typedef struct   {
;	    float id;
;	    float x;
;		float y;
;	    float ox;
;        float oy;
;	    Ball ball;
;}robot ;
;
;robot rb,robot11,robot12,robot13,robot21,robot22,robot23,robotctrl;
;float errangle=0, distance=0,orentation=0;
;int flagtancong=1;
;int offsetphongthu=0;
;int goctancong=0;
;unsigned char RxBuf[32];
;unsigned char readposition();
;void runEscBlindSpot();
;void ctrrobot();// can phai luon luon chay de dieu khien robot
;void rb_move(float x,float y);
;int rb_wait(unsigned long int time );
;void rb_rotate(int angle);     // goc xoay so voi truc x cua toa do
;void calcvitri(float x,float y);
;int calcVangle(int angle);
;float setRobotX=0;
;float setRobotY=0;
;float setRobotXmin=0;
;float setRobotXmax=0;
;
;float setRobotAngleX=0;
;float setRobotAngleY=0;
;float offestsanco=0;
;
;float rbctrlHomeX=0;
;float rbctrlHomeY=0;
;float rbctrlPenaltyX=0;
;float rbctrlPenaltyY=0;
;float rbctrlPenaltyAngle=0;
;
;float rbctrlHomeAngle=0;
;
;unsigned int cmdCtrlRobot,idRobot;
;unsigned int cntsethomeRB  =0;
;unsigned int cntstuckRB=0;
;unsigned int cntunlookRB=0;
;unsigned int flagunlookRB=0;
;unsigned int cntunsignalRF=0;
;unsigned int flagunsignalRF=0;
;unsigned int flagsethome=0;
;
;unsigned int flagselftest = 0;
;unsigned int cntselftest = 0;
;// thu su dung bien enum de chuong trinh goi nho hon
;//eeprom enum flagtask   { sunday, monday, tuesday, wednesday,thursday, friday, idle} flagtaskenum;
;//eeprom enum flagctrlrb { movetopoint, movetoball, kick} flagctrlrbenum;
;
;//==========================================================
;//CAC BIEN NGUOI DUNG
; unsigned char id = 1;

	.DSEG
;//========================================= bien doc IR
;unsigned int IRFL=0;
;unsigned int IRFR=0;
;unsigned int IRBL=0;
;unsigned int IRLINE[5];
;//========================================= bien dieu khien dong co  PHUC
;   //-----------------------------------------------------
;   //bien dieu khien van toc
;   unsigned int timerstick=0,timerstickdis =0,timerstickang=0,timerstickctr=0;
;   unsigned int vQEL=0;  //do (xung/250ms)
;   unsigned int vQER=0;  //do (xung/250ms)
;   unsigned int oldQEL=0;
;   unsigned int oldQER=0;
;   unsigned int svQEL=0;  //dat (xung/250ms) (range: 0-22)
;   unsigned int svQER=0;  //dat (xung/250ms) (range: 0-22)
;   static int seRki=0,seLki=0;
;   int uL = 0 ;
;   int uR = 0;
;
;   int KpR = 10;
;   int KiR = 1;
;   int KpL = 10;
;   int KiL = 1;
;   //------------------------------------------------------
;   //bien dieu khien vi tri
;   unsigned int sd=0;// dat khoang cach  di chuyen (xung)
;   unsigned int oldd=0;// bien luu gia tri vi tri cu
;   unsigned char flagwaitctrRobot = 0;
;   //bien dieu khien goc
;    unsigned int sa=0;// dat goc quay (xung) ( 54 xung/vong quay)
;    unsigned int olda=0;// bien luu gia tri goc cu
;    unsigned char  flagwaitctrAngle = 0;
;   //bien dieu khien trang thai robot
;   unsigned int flagtask=0;
;   unsigned int flagtaskold=0;
;   unsigned int flaghuongtrue=0;
;   int verranglekisum = 0;
;//========================================= bien doc ENCODER
; unsigned int QEL=0;
; unsigned int QER=0;
;//========================================= bien su dung LCD
; unsigned char menu=0,test=0,ok=0,runing_test=0,run_robot=0,ft=1,timer=0;
;//========================================================
;//========================================================
;
;flash unsigned char ASCII[][5] = {
; {0x00, 0x00, 0x00, 0x00, 0x00} // 20
;,{0x00, 0x00, 0x5f, 0x00, 0x00} // 21 !
;,{0x00, 0x07, 0x00, 0x07, 0x00} // 22 "
;,{0x14, 0x7f, 0x14, 0x7f, 0x14} // 23 #
;,{0x24, 0x2a, 0x7f, 0x2a, 0x12} // 24 $
;,{0x23, 0x13, 0x08, 0x64, 0x62} // 25 %
;,{0x36, 0x49, 0x55, 0x22, 0x50} // 26 &
;,{0x00, 0x05, 0x03, 0x00, 0x00} // 27 '
;,{0x00, 0x1c, 0x22, 0x41, 0x00} // 28 (
;,{0x00, 0x41, 0x22, 0x1c, 0x00} // 29 )
;,{0x14, 0x08, 0x3e, 0x08, 0x14} // 2a *
;,{0x08, 0x08, 0x3e, 0x08, 0x08} // 2b +
;,{0x00, 0x50, 0x30, 0x00, 0x00} // 2c ,
;,{0x08, 0x08, 0x08, 0x08, 0x08} // 2d -
;,{0x00, 0x60, 0x60, 0x00, 0x00} // 2e .
;,{0x20, 0x10, 0x08, 0x04, 0x02} // 2f /
;,{0x3e, 0x51, 0x49, 0x45, 0x3e} // 30 0
;,{0x00, 0x42, 0x7f, 0x40, 0x00} // 31 1
;,{0x42, 0x61, 0x51, 0x49, 0x46} // 32 2
;,{0x21, 0x41, 0x45, 0x4b, 0x31} // 33 3
;,{0x18, 0x14, 0x12, 0x7f, 0x10} // 34 4
;,{0x27, 0x45, 0x45, 0x45, 0x39} // 35 5
;,{0x3c, 0x4a, 0x49, 0x49, 0x30} // 36 6
;,{0x01, 0x71, 0x09, 0x05, 0x03} // 37 7
;,{0x36, 0x49, 0x49, 0x49, 0x36} // 38 8
;,{0x06, 0x49, 0x49, 0x29, 0x1e} // 39 9
;,{0x00, 0x36, 0x36, 0x00, 0x00} // 3a :
;,{0x00, 0x56, 0x36, 0x00, 0x00} // 3b ;
;,{0x08, 0x14, 0x22, 0x41, 0x00} // 3c <
;,{0x14, 0x14, 0x14, 0x14, 0x14} // 3d =
;,{0x00, 0x41, 0x22, 0x14, 0x08} // 3e >
;,{0x02, 0x01, 0x51, 0x09, 0x06} // 3f ?
;,{0x32, 0x49, 0x79, 0x41, 0x3e} // 40 @
;,{0x7e, 0x11, 0x11, 0x11, 0x7e} // 41 A
;,{0x7f, 0x49, 0x49, 0x49, 0x36} // 42 B
;,{0x3e, 0x41, 0x41, 0x41, 0x22} // 43 C
;,{0x7f, 0x41, 0x41, 0x22, 0x1c} // 44 D
;,{0x7f, 0x49, 0x49, 0x49, 0x41} // 45 E
;,{0x7f, 0x09, 0x09, 0x09, 0x01} // 46 F
;,{0x3e, 0x41, 0x49, 0x49, 0x7a} // 47 G
;,{0x7f, 0x08, 0x08, 0x08, 0x7f} // 48 H
;,{0x00, 0x41, 0x7f, 0x41, 0x00} // 49 I
;,{0x20, 0x40, 0x41, 0x3f, 0x01} // 4a J
;,{0x7f, 0x08, 0x14, 0x22, 0x41} // 4b K
;,{0x7f, 0x40, 0x40, 0x40, 0x40} // 4c L
;,{0x7f, 0x02, 0x0c, 0x02, 0x7f} // 4d M
;,{0x7f, 0x04, 0x08, 0x10, 0x7f} // 4e N
;,{0x3e, 0x41, 0x41, 0x41, 0x3e} // 4f O
;,{0x7f, 0x09, 0x09, 0x09, 0x06} // 50 P
;,{0x3e, 0x41, 0x51, 0x21, 0x5e} // 51 Q
;,{0x7f, 0x09, 0x19, 0x29, 0x46} // 52 R
;,{0x46, 0x49, 0x49, 0x49, 0x31} // 53 S
;,{0x01, 0x01, 0x7f, 0x01, 0x01} // 54 T
;,{0x3f, 0x40, 0x40, 0x40, 0x3f} // 55 U
;,{0x1f, 0x20, 0x40, 0x20, 0x1f} // 56 V
;,{0x3f, 0x40, 0x38, 0x40, 0x3f} // 57 W
;,{0x63, 0x14, 0x08, 0x14, 0x63} // 58 X
;,{0x07, 0x08, 0x70, 0x08, 0x07} // 59 Y
;,{0x61, 0x51, 0x49, 0x45, 0x43} // 5a Z
;,{0x00, 0x7f, 0x41, 0x41, 0x00} // 5b [
;,{0x02, 0x04, 0x08, 0x10, 0x20} // 5c ¥
;,{0x00, 0x41, 0x41, 0x7f, 0x00} // 5d ]
;,{0x04, 0x02, 0x01, 0x02, 0x04} // 5e ^
;,{0x40, 0x40, 0x40, 0x40, 0x40} // 5f _
;,{0x00, 0x01, 0x02, 0x04, 0x00} // 60 `
;,{0x20, 0x54, 0x54, 0x54, 0x78} // 61 a
;,{0x7f, 0x48, 0x44, 0x44, 0x38} // 62 b
;,{0x38, 0x44, 0x44, 0x44, 0x20} // 63 c
;,{0x38, 0x44, 0x44, 0x48, 0x7f} // 64 d
;,{0x38, 0x54, 0x54, 0x54, 0x18} // 65 e
;,{0x08, 0x7e, 0x09, 0x01, 0x02} // 66 f
;,{0x0c, 0x52, 0x52, 0x52, 0x3e} // 67 g
;,{0x7f, 0x08, 0x04, 0x04, 0x78} // 68 h
;,{0x00, 0x44, 0x7d, 0x40, 0x00} // 69 i
;,{0x20, 0x40, 0x44, 0x3d, 0x00} // 6a j
;,{0x7f, 0x10, 0x28, 0x44, 0x00} // 6b k
;,{0x00, 0x41, 0x7f, 0x40, 0x00} // 6c l
;,{0x7c, 0x04, 0x18, 0x04, 0x78} // 6d m
;,{0x7c, 0x08, 0x04, 0x04, 0x78} // 6e n
;,{0x38, 0x44, 0x44, 0x44, 0x38} // 6f o
;,{0x7c, 0x14, 0x14, 0x14, 0x08} // 70 p
;,{0x08, 0x14, 0x14, 0x18, 0x7c} // 71 q
;,{0x7c, 0x08, 0x04, 0x04, 0x08} // 72 r
;,{0x48, 0x54, 0x54, 0x54, 0x20} // 73 s
;,{0x04, 0x3f, 0x44, 0x40, 0x20} // 74 t
;,{0x3c, 0x40, 0x40, 0x20, 0x7c} // 75 u
;,{0x1c, 0x20, 0x40, 0x20, 0x1c} // 76 v
;,{0x3c, 0x40, 0x30, 0x40, 0x3c} // 77 w
;,{0x44, 0x28, 0x10, 0x28, 0x44} // 78 x
;,{0x0c, 0x50, 0x50, 0x50, 0x3c} // 79 y
;,{0x44, 0x64, 0x54, 0x4c, 0x44} // 7a z
;,{0x00, 0x08, 0x36, 0x41, 0x00} // 7b {
;,{0x00, 0x00, 0x7f, 0x00, 0x00} // 7c |
;,{0x00, 0x41, 0x36, 0x08, 0x00} // 7d }
;,{0x10, 0x08, 0x08, 0x10, 0x08} // 7e ?
;,{0x78, 0x46, 0x41, 0x46, 0x78} // 7f ?
;};
;
;//=========================================================
;void LEDLtoggle()
; 0001 0130 {

	.CSEG
_LEDLtoggle:
; 0001 0131    if(LEDL==0){LEDL=1;}else{LEDL=0;}
	SBIC 0x15,4
	RJMP _0x20009
	SBI  0x15,4
	RJMP _0x2000C
_0x20009:
	CBI  0x15,4
_0x2000C:
; 0001 0132 }
	RET
;//=========================================================
;void LEDRtoggle()
; 0001 0135 {
_LEDRtoggle:
; 0001 0136    if(LEDR==0){LEDR=1;}else{LEDR=0;}
	SBIC 0x15,5
	RJMP _0x2000F
	SBI  0x15,5
	RJMP _0x20012
_0x2000F:
	CBI  0x15,5
_0x20012:
; 0001 0137 }
	RET
;//=========================================================
;// truyen spi master
;void spitx(unsigned char temtx)
; 0001 013B {
_spitx:
; 0001 013C // unsigned char transpi;
; 0001 013D  SPDR = temtx;
;	temtx -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0001 013E  while (!(SPSR & 0x80));
_0x20015:
	SBIS 0xE,7
	RJMP _0x20015
; 0001 013F }
	RJMP _0x20C0007
;
;void LcdWrite(unsigned char dc, unsigned char data)
; 0001 0142 {
_LcdWrite:
; 0001 0143     DC = dc;
;	dc -> Y+1
;	data -> Y+0
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x20018
	CBI  0x18,2
	RJMP _0x20019
_0x20018:
	SBI  0x18,2
_0x20019:
; 0001 0144     SCE=1;
	SBI  0x18,1
; 0001 0145     SCE=0;
	CBI  0x18,1
; 0001 0146     spitx(data);
	LD   R30,Y
	ST   -Y,R30
	RCALL _spitx
; 0001 0147     SCE=1;
	SBI  0x18,1
; 0001 0148 }
	RJMP _0x20C0008
;//This takes a large array of bits and sends them to the LCD
;void LcdBitmap(char my_array[]){
; 0001 014A void LcdBitmap(char my_array[]){
; 0001 014B   int index = 0;
; 0001 014C   for (index = 0 ; index < (LCD_X * LCD_Y / 8) ; index++)
;	my_array -> Y+2
;	index -> R16,R17
; 0001 014D     LcdWrite(LCD_D, my_array[index]);
; 0001 014E }
;
;void hc(int x, int y) {
; 0001 0150 void hc(int x, int y) {
_hc:
; 0001 0151   LcdWrite(0, 0x40 | x);  // Row.  ?
;	x -> Y+2
;	y -> Y+0
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+3
	ORI  R30,0x40
	CALL SUBOPT_0x2
; 0001 0152   LcdWrite(0, 0x80 | y);  // Column.
	LDD  R30,Y+1
	ORI  R30,0x80
	ST   -Y,R30
	RCALL _LcdWrite
; 0001 0153 }
	RJMP _0x20C0004
;
;void LcdCharacter(unsigned char character)
; 0001 0156 {
_LcdCharacter:
; 0001 0157   int index = 0;
; 0001 0158   LcdWrite(LCD_D, 0x00);
	CALL SUBOPT_0x3
;	character -> Y+2
;	index -> R16,R17
; 0001 0159   for (index = 0; index < 5; index++)
_0x20024:
	__CPWRN 16,17,5
	BRGE _0x20025
; 0001 015A   {
; 0001 015B     LcdWrite(LCD_D, ASCII[character - 0x20][index]);
	CALL SUBOPT_0x4
; 0001 015C   }
	__ADDWRN 16,17,1
	RJMP _0x20024
_0x20025:
; 0001 015D   LcdWrite(LCD_D, 0x00);
	RJMP _0x20C000A
; 0001 015E }
;
;void wc(unsigned char character)
; 0001 0161 {
_wc:
; 0001 0162   int index = 0;
; 0001 0163   LcdWrite(LCD_D, 0x00);
	CALL SUBOPT_0x3
;	character -> Y+2
;	index -> R16,R17
; 0001 0164   for (index = 0; index < 5; index++)
_0x20027:
	__CPWRN 16,17,5
	BRGE _0x20028
; 0001 0165   {
; 0001 0166     LcdWrite(LCD_D, ASCII[character - 0x20][index]);
	CALL SUBOPT_0x4
; 0001 0167   }
	__ADDWRN 16,17,1
	RJMP _0x20027
_0x20028:
; 0001 0168   LcdWrite(LCD_D, 0x00);
_0x20C000A:
	LDI  R30,LOW(1)
	CALL SUBOPT_0x5
; 0001 0169 }
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20C000B:
	ADIW R28,3
	RET
;
;void ws(unsigned char *characters)
; 0001 016C {
_ws:
; 0001 016D   while (*characters)
;	*characters -> Y+0
_0x20029:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x2002B
; 0001 016E   {
; 0001 016F     LcdCharacter(*characters++);
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	ST   -Y,R30
	RCALL _LcdCharacter
; 0001 0170   }
	RJMP _0x20029
_0x2002B:
; 0001 0171 }
	RJMP _0x20C0008
;
;void LcdClear(void)
; 0001 0174 {
_LcdClear:
; 0001 0175   int index=0;
; 0001 0176   for (index = 0; index < LCD_X * LCD_Y / 8; index++)
	CALL SUBOPT_0x6
;	index -> R16,R17
_0x2002D:
	__CPWRN 16,17,504
	BRGE _0x2002E
; 0001 0177   {
; 0001 0178     LcdWrite(LCD_D, 0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x5
; 0001 0179   }
	__ADDWRN 16,17,1
	RJMP _0x2002D
_0x2002E:
; 0001 017A   hc(0, 0); //After we clear the display, return to the home position
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7
	RCALL _hc
; 0001 017B }
	RJMP _0x20C0005
;
;void clear(void)
; 0001 017E {
_clear:
; 0001 017F   int index=0;
; 0001 0180   for (index = 0; index < LCD_X * LCD_Y / 8; index++)
	CALL SUBOPT_0x6
;	index -> R16,R17
_0x20030:
	__CPWRN 16,17,504
	BRGE _0x20031
; 0001 0181   {
; 0001 0182     LcdWrite(LCD_D, 0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x5
; 0001 0183   }
	__ADDWRN 16,17,1
	RJMP _0x20030
_0x20031:
; 0001 0184   hc(0, 0); //After we clear the display, return to the home position
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7
	RCALL _hc
; 0001 0185 }
	RJMP _0x20C0005
;//============================
;void wn164(unsigned int so)
; 0001 0188 {
_wn164:
; 0001 0189  unsigned char a[5],i;
; 0001 018A  for(i=0;i<5;i++)
	SBIW R28,5
	ST   -Y,R17
;	so -> Y+6
;	a -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x20033:
	CPI  R17,5
	BRSH _0x20034
; 0001 018B  {
; 0001 018C  a[i]=so%10;        //a[0]= byte thap nhat
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0001 018D  so=so/10;
; 0001 018E  }
	SUBI R17,-1
	RJMP _0x20033
_0x20034:
; 0001 018F  for(i=1;i<5;i++)
	LDI  R17,LOW(1)
_0x20036:
	CPI  R17,5
	BRSH _0x20037
; 0001 0190  {wc(a[4-i]+0x30);}
	CALL SUBOPT_0x8
	CALL SUBOPT_0xA
	RCALL _wc
	SUBI R17,-1
	RJMP _0x20036
_0x20037:
; 0001 0191 }
	RJMP _0x20C0009
;
;void LcdInitialise()
; 0001 0194 {
_LcdInitialise:
; 0001 0195   //reset
; 0001 0196   RST=0;
	CBI  0x18,0
; 0001 0197   delay_us(10);
	__DELAY_USB 27
; 0001 0198   RST=1;
	SBI  0x18,0
; 0001 0199 
; 0001 019A   delay_ms(1000);
	CALL SUBOPT_0xB
; 0001 019B   //khoi dong
; 0001 019C   LcdWrite(LCD_C, 0x21 );  //Tell LCD that extended commands follow
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(33)
	CALL SUBOPT_0x2
; 0001 019D   LcdWrite(LCD_C, 0xBF  );  //Set LCD Vop (Contrast): Try 0xB1(good @ 3.3V) or 0xBF = Dam nhat
	LDI  R30,LOW(191)
	CALL SUBOPT_0x2
; 0001 019E   LcdWrite(LCD_C, 0x06 );  // Set Temp coefficent. //0x04
	LDI  R30,LOW(6)
	CALL SUBOPT_0x2
; 0001 019F   LcdWrite(LCD_C, 0x13 );  //LCD bias mode 1:48: Try 0x13 or 0x14
	LDI  R30,LOW(19)
	CALL SUBOPT_0x2
; 0001 01A0   LcdWrite(LCD_C, 0x20 );  //We must send 0x20 before modifying the display control mode
	LDI  R30,LOW(32)
	CALL SUBOPT_0x2
; 0001 01A1   LcdWrite(LCD_C, 0x0C );  //Set display control, normal mode. 0x0D for inverse, 0x0C normal
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL _LcdWrite
; 0001 01A2 }
	RET
;//========================================================
;//============================ Hien thi so 16 bits
;void wn16(unsigned int so)
; 0001 01A6 {
_wn16:
; 0001 01A7  unsigned char a[5],i;
; 0001 01A8  for(i=0;i<5;i++)
	SBIW R28,5
	ST   -Y,R17
;	so -> Y+6
;	a -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x2003D:
	CPI  R17,5
	BRSH _0x2003E
; 0001 01A9  {
; 0001 01AA  a[i]=so%10;        //a[0]= byte thap nhat
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0001 01AB  so=so/10;
; 0001 01AC  }
	SUBI R17,-1
	RJMP _0x2003D
_0x2003E:
; 0001 01AD 
; 0001 01AE   for(i=0;i<5;i++)
	LDI  R17,LOW(0)
_0x20040:
	CPI  R17,5
	BRSH _0x20041
; 0001 01AF  {LcdCharacter(a[4-i]+0x30);}
	CALL SUBOPT_0x8
	CALL SUBOPT_0xA
	RCALL _LcdCharacter
	SUBI R17,-1
	RJMP _0x20040
_0x20041:
; 0001 01B0 }
_0x20C0009:
	LDD  R17,Y+0
	ADIW R28,8
	RET
;//============================ Hien thi so 16 bits co dau
; void wn16s( int so)
; 0001 01B3 {
_wn16s:
; 0001 01B4  if(so<0){so=0-so; LcdCharacter('-');} else{ LcdCharacter(' ');}
;	so -> Y+0
	LDD  R26,Y+1
	TST  R26
	BRPL _0x20042
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0xC
	LDI  R30,LOW(45)
	RJMP _0x202DB
_0x20042:
	LDI  R30,LOW(32)
_0x202DB:
	ST   -Y,R30
	RCALL _LcdCharacter
; 0001 01B5  wn16(so);
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0xD
; 0001 01B6 }
_0x20C0008:
	ADIW R28,2
	RET
;//============================ hien thi so 32bit co dau
; void wn32s( int so)
; 0001 01B9 {
; 0001 01BA  char tmp[20];
; 0001 01BB  sprintf(tmp,"%d",so);
;	so -> Y+20
;	tmp -> Y+0
; 0001 01BC  ws(tmp);
; 0001 01BD }
;//============================ hien thi so 32bit co dau
; void wnf( float so)
; 0001 01C0 {
; 0001 01C1  char tmp[30];
; 0001 01C2  sprintf(tmp,"%0.2f",so);
;	so -> Y+30
;	tmp -> Y+0
; 0001 01C3  ws(tmp);
; 0001 01C4 }
;
;//============================ hien thi so 32bit co dau
; void wfmt(float so)
; 0001 01C8 {
; 0001 01C9  char tmp[30];
; 0001 01CA  sprintf(tmp,"%0.2f",so);
;	so -> Y+30
;	tmp -> Y+0
; 0001 01CB  ws(tmp);
; 0001 01CC }
;//========================================================
;//========================================================
;void SPIinit()
; 0001 01D0 {
_SPIinit:
; 0001 01D1     SPCR |=1<<SPE | 1<<MSTR;                                         //if spi is used, uncomment this section out
	IN   R30,0xD
	ORI  R30,LOW(0x50)
	OUT  0xD,R30
; 0001 01D2     SPSR |=1<<SPI2X;
	SBI  0xE,0
; 0001 01D3 }
	RET
;//========================================================
;void LCDinit()
; 0001 01D6 {
_LCDinit:
; 0001 01D7     LcdInitialise();
	RCALL _LcdInitialise
; 0001 01D8     LcdClear();
	RCALL _LcdClear
; 0001 01D9     ws(" <AKBOTKIT>");
	__POINTW1MN _0x20044,0
	CALL SUBOPT_0xE
; 0001 01DA }
	RET

	.DSEG
_0x20044:
	.BYTE 0xC
;//========================================================
;//ham doc adc
;#define ADC_VREF_TYPE 0x40
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0001 01E0 {

	.CSEG
_read_adc:
; 0001 01E1 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0001 01E2 // Delay needed for the stabilization of the ADC input voltage
; 0001 01E3 delay_us(10);
	__DELAY_USB 27
; 0001 01E4 // Start the AD conversion
; 0001 01E5 ADCSRA|=0x40;
	SBI  0x6,6
; 0001 01E6 // Wait for the AD conversion to complete
; 0001 01E7 while ((ADCSRA & 0x10)==0);
_0x20045:
	SBIS 0x6,4
	RJMP _0x20045
; 0001 01E8 ADCSRA|=0x10;
	SBI  0x6,4
; 0001 01E9 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x20C0007
; 0001 01EA }
;//========================================================
;//===================================== TRUYEN THONG UART (bluetooth)
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0001 021E {
_usart_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0001 021F char status,data;
; 0001 0220 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0001 0221 data=UDR;
	IN   R16,12
; 0001 0222 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x20048
; 0001 0223    {
; 0001 0224    rx_buffer[rx_wr_index++]=data;
	LDS  R30,_rx_wr_index
	SUBI R30,-LOW(1)
	STS  _rx_wr_index,R30
	CALL SUBOPT_0xF
	ST   Z,R16
; 0001 0225 #if RX_BUFFER_SIZE == 256
; 0001 0226    // special case for receiver buffer size=256
; 0001 0227    if (++rx_counter == 0)
; 0001 0228       {
; 0001 0229 #else
; 0001 022A    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDS  R26,_rx_wr_index
	CPI  R26,LOW(0x8)
	BRNE _0x20049
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0001 022B    if (++rx_counter == RX_BUFFER_SIZE)
_0x20049:
	LDS  R26,_rx_counter
	SUBI R26,-LOW(1)
	STS  _rx_counter,R26
	CPI  R26,LOW(0x8)
	BRNE _0x2004A
; 0001 022C       {
; 0001 022D       rx_counter=0;
	LDI  R30,LOW(0)
	STS  _rx_counter,R30
; 0001 022E #endif
; 0001 022F       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0001 0230       }
; 0001 0231    }
_0x2004A:
; 0001 0232 }
_0x20048:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x202F2
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0001 0239 {
_getchar:
; 0001 023A char data;
; 0001 023B while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x2004B:
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x2004B
; 0001 023C data=rx_buffer[rx_rd_index++];
	LDS  R30,_rx_rd_index
	SUBI R30,-LOW(1)
	STS  _rx_rd_index,R30
	CALL SUBOPT_0xF
	LD   R17,Z
; 0001 023D #if RX_BUFFER_SIZE != 256
; 0001 023E if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDS  R26,_rx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0x2004E
	LDI  R30,LOW(0)
	STS  _rx_rd_index,R30
; 0001 023F #endif
; 0001 0240 #asm("cli")
_0x2004E:
	cli
; 0001 0241 --rx_counter;
	LDS  R30,_rx_counter
	SUBI R30,LOW(1)
	STS  _rx_counter,R30
; 0001 0242 #asm("sei")
	sei
; 0001 0243 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0001 0244 }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0001 0254 {
_usart_tx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0001 0255     if (tx_counter)
	LDS  R30,_tx_counter
	CPI  R30,0
	BREQ _0x2004F
; 0001 0256        {
; 0001 0257        --tx_counter;
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
; 0001 0258        UDR=tx_buffer[tx_rd_index++];
	LDS  R30,_tx_rd_index
	SUBI R30,-LOW(1)
	STS  _tx_rd_index,R30
	CALL SUBOPT_0x10
	LD   R30,Z
	OUT  0xC,R30
; 0001 0259     #if TX_BUFFER_SIZE != 256
; 0001 025A        if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDS  R26,_tx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0x20050
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
; 0001 025B     #endif
; 0001 025C        }
_0x20050:
; 0001 025D }
_0x2004F:
_0x202F2:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0001 0264 {
_putchar:
; 0001 0265     while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
_0x20051:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x8)
	BREQ _0x20051
; 0001 0266     #asm("cli")
	cli
; 0001 0267     if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter
	CPI  R30,0
	BRNE _0x20055
	SBIC 0xB,5
	RJMP _0x20054
_0x20055:
; 0001 0268        {
; 0001 0269        tx_buffer[tx_wr_index++]=c;
	LDS  R30,_tx_wr_index
	SUBI R30,-LOW(1)
	STS  _tx_wr_index,R30
	CALL SUBOPT_0x10
	LD   R26,Y
	STD  Z+0,R26
; 0001 026A     #if TX_BUFFER_SIZE != 256
; 0001 026B        if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDS  R26,_tx_wr_index
	CPI  R26,LOW(0x8)
	BRNE _0x20057
	LDI  R30,LOW(0)
	STS  _tx_wr_index,R30
; 0001 026C     #endif
; 0001 026D        ++tx_counter;
_0x20057:
	LDS  R30,_tx_counter
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
; 0001 026E        }
; 0001 026F     else
	RJMP _0x20058
_0x20054:
; 0001 0270        UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0001 0271     #asm("sei")
_0x20058:
	sei
; 0001 0272 }
	RJMP _0x20C0007
;#pragma used-
;#endif
;void inituart()
; 0001 0276 {
_inituart:
; 0001 0277 // USART initialization
; 0001 0278 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 0279 // USART Receiver: On
; 0001 027A // USART Transmitter: On
; 0001 027B // USART Mode: Asynchronous
; 0001 027C // USART Baud Rate: 38400
; 0001 027D UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0001 027E UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0001 027F UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0001 0280 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0001 0281 UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
; 0001 0282 }
	RET
;
;//========================================================
;//read encoder
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0001 0288 {
_ext_int0_isr:
	CALL SUBOPT_0x11
; 0001 0289      QEL++;
	LDI  R26,LOW(_QEL)
	LDI  R27,HIGH(_QEL)
	RJMP _0x202F1
; 0001 028A }
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0001 028E {
_ext_int1_isr:
	CALL SUBOPT_0x11
; 0001 028F     QER++;
	LDI  R26,LOW(_QER)
	LDI  R27,HIGH(_QER)
_0x202F1:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0001 0290 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;//========================================================
;//khoi tao encoder
;void initencoder()
; 0001 0294 {
_initencoder:
; 0001 0295 // Dem 24 xung / 1 vong banh xe
; 0001 0296 // External Interrupt(s) initialization
; 0001 0297 // INT0: On
; 0001 0298 // INT0 Mode: Any change
; 0001 0299 // INT1: On
; 0001 029A // INT1 Mode: Any change
; 0001 029B // INT2: Off
; 0001 029C GICR|=0xC0;
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0001 029D MCUCR=0x05;
	LDI  R30,LOW(5)
	OUT  0x35,R30
; 0001 029E MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0001 029F GIFR=0xC0;
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0001 02A0 // Global enable interrupts
; 0001 02A1 
; 0001 02A2 //OCR1A=0-255; MOTOR LEFT
; 0001 02A3 //OCR1B=0-255; MOTOR RIGHT
; 0001 02A4 }
	RET
;
;//========================================================
;//control velocity motor
;void vMLtoi(unsigned char v) //congsuat=0-22 (%)
; 0001 02A9 {
_vMLtoi:
; 0001 02AA     seRki=0;//reset thanh phan I
;	v -> Y+0
	CALL SUBOPT_0x12
; 0001 02AB     seLki=0;//reset thanh phan I
; 0001 02AC     //uRold=0;
; 0001 02AD     MLdir = 1;
	SBI  0x15,6
; 0001 02AE     svQEL = v;
	CALL SUBOPT_0x13
; 0001 02AF }
	RJMP _0x20C0007
;//========================================================
;void vMLlui(unsigned char v) //congsuat=0-22 (%)
; 0001 02B2 {
_vMLlui:
; 0001 02B3     seRki=0;//reset thanh phan I
;	v -> Y+0
	CALL SUBOPT_0x12
; 0001 02B4     seLki=0;//reset thanh phan I
; 0001 02B5 
; 0001 02B6     //uRold=0;
; 0001 02B7     MLdir = 0;
	CBI  0x15,6
; 0001 02B8     svQEL = v;
	CALL SUBOPT_0x13
; 0001 02B9 }
	RJMP _0x20C0007
;//========================================================
;void vMLstop()
; 0001 02BC {
_vMLstop:
; 0001 02BD     seRki=0;//reset thanh phan I
	CALL SUBOPT_0x12
; 0001 02BE     seLki=0;//reset thanh phan I
; 0001 02BF     MLdir = 1;
	SBI  0x15,6
; 0001 02C0     OCR1A = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0001 02C1     svQEL = 0;
	STS  _svQEL,R30
	STS  _svQEL+1,R30
; 0001 02C2 }
	RET
;//========================================================
;//========================================================
;void vMRtoi(unsigned char v) //congsuat=0-22 (%)
; 0001 02C6 {
_vMRtoi:
; 0001 02C7     seRki=0;//reset thanh phan I
;	v -> Y+0
	CALL SUBOPT_0x12
; 0001 02C8     seLki=0;//reset thanh phan I
; 0001 02C9     MRdir = 1;
	SBI  0x15,7
; 0001 02CA     svQER = v;
	RJMP _0x20C0006
; 0001 02CB }
;//========================================================
;void vMRlui(unsigned char v) //congsuat=0-22 (%)
; 0001 02CE {
_vMRlui:
; 0001 02CF     seRki=0;//reset thanh phan I
;	v -> Y+0
	CALL SUBOPT_0x12
; 0001 02D0     seLki=0;//reset thanh phan I
; 0001 02D1     MRdir = 0;
	CBI  0x15,7
; 0001 02D2     svQER = v;
_0x20C0006:
	LD   R30,Y
	LDI  R31,0
	STS  _svQER,R30
	STS  _svQER+1,R31
; 0001 02D3 }
_0x20C0007:
	ADIW R28,1
	RET
;//========================================================
;void vMRstop()
; 0001 02D6 {
_vMRstop:
; 0001 02D7     seRki=0;//reset thanh phan I
	CALL SUBOPT_0x12
; 0001 02D8     seLki=0;//reset thanh phan I
; 0001 02D9     MRdir = 1;
	SBI  0x15,7
; 0001 02DA     OCR1B = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0001 02DB     svQER=0;
	STS  _svQER,R30
	STS  _svQER+1,R30
; 0001 02DC }
	RET
;//========================================================
;// ham dieu khien vi tri
;void ctrRobottoi(unsigned int d,unsigned int v)  //v:0-22
; 0001 02E0 {
; 0001 02E1      flagwaitctrAngle=0;
;	d -> Y+2
;	v -> Y+0
; 0001 02E2      flagwaitctrRobot=1;
; 0001 02E3      sd=d;// set gia tri khoang cach di chuyen
; 0001 02E4      oldd = (QEL+QER)/2; // luu gia tri vi tri hien tai
; 0001 02E5      vMRtoi(v);
; 0001 02E6      vMLtoi(v);
; 0001 02E7 }
;// ham dieu khien vi tri
;void ctrRobotlui(unsigned int d,unsigned int v)  //v:0-22
; 0001 02EA {
; 0001 02EB      flagwaitctrAngle=0;
;	d -> Y+2
;	v -> Y+0
; 0001 02EC      flagwaitctrRobot=1;
; 0001 02ED      sd=d;// set gia tri khoang cach di chuyen
; 0001 02EE      oldd = (QEL+QER)/2; // luu gia tri vi tri hien tai
; 0001 02EF      vMRlui(v);
; 0001 02F0      vMLlui(v);
; 0001 02F1 }
;// ham dieu khien goc quay
;void ctrRobotXoay(int angle,unsigned int v)  //v:0-22
; 0001 02F4 {
; 0001 02F5      float fangle=0;
; 0001 02F6      flagwaitctrRobot=0;
;	angle -> Y+6
;	v -> Y+4
;	fangle -> Y+0
; 0001 02F7      if(angle>0)  { //xoay trai
; 0001 02F8 
; 0001 02F9         if(angle > 1) vMRtoi(v);
; 0001 02FA         else vMRtoi(0);
; 0001 02FB         if(angle > 1) vMLlui(v);
; 0001 02FC         else vMLlui(0);
; 0001 02FD      }else  //xoay phai
; 0001 02FE      {
; 0001 02FF         angle=-angle;
; 0001 0300         if(angle > 1) vMRlui(v);
; 0001 0301         else vMRlui(0);
; 0001 0302         if(angle > 1) vMLtoi(v);
; 0001 0303         else vMLtoi(0);
; 0001 0304      }
; 0001 0305      flagwaitctrAngle=1;
; 0001 0306      //sa=angle/2;// set gia tri khoang cach di chuyen chia doi cho di chuyen 2 banh
; 0001 0307      fangle=angle*0.35;// nhan chia so float
; 0001 0308      sa=fangle;
; 0001 0309      olda = QEL; // luu gia tri vi tri hien tai
; 0001 030A }
;
;
;
;
;//========================================================
;// read  vi tri robot   PHUC
;//========================================================
;unsigned char readposition()
; 0001 0313 {
; 0001 0314         unsigned char  i=0;
; 0001 0315         unsigned flagstatus=0;
; 0001 0316 
; 0001 0317         if(nRF24L01_RxPacket(RxBuf)==1)         // Neu nhan duoc du lieu
;	i -> R17
;	flagstatus -> R18,R19
; 0001 0318         {
; 0001 0319          for( i=0;i<28;i++)
; 0001 031A          {
; 0001 031B              *(uint8_t *) ((uint8_t *)&rb + i)=RxBuf[i];
; 0001 031C          }
; 0001 031D 
; 0001 031E 
; 0001 031F          idRobot = fmod(rb.id,10); // doc id
; 0001 0320          cmdCtrlRobot = (int)rb.id/10; // doc ma lenh
; 0001 0321 //           hc(5,40);wn16s(cmdCtrlRobot);
; 0001 0322 //         hc(4,40);wn16s(idRobot);
; 0001 0323 //         hc(3,40);wn16s(flagtask);
; 0001 0324 //
; 0001 0325 //         //delay_ms(100);
; 0001 0326          switch (idRobot)
; 0001 0327          {
; 0001 0328               case 1:
; 0001 0329                 robot11=rb;
; 0001 032A                 break;
; 0001 032B               case 2:
; 0001 032C                 robot12=rb;
; 0001 032D                 break;
; 0001 032E               case 3:
; 0001 032F                 robot13=rb;
; 0001 0330                 break;
; 0001 0331               case 4:
; 0001 0332                 robot21=rb;
; 0001 0333                 break;
; 0001 0334               case 5:
; 0001 0335                 robot22=rb;
; 0001 0336                 break;
; 0001 0337               case 6:
; 0001 0338                 robot23=rb;
; 0001 0339                 break;
; 0001 033A 
; 0001 033B          }
; 0001 033C          if(idRobot==ROBOT_ID)
; 0001 033D          {
; 0001 033E              LEDL=!LEDL;
; 0001 033F              cmdCtrlRobot = (int)rb.id/10; // doc ma lenh
; 0001 0340              flagstatus=1;
; 0001 0341              robotctrl=rb;
; 0001 0342          }
; 0001 0343 
; 0001 0344      }
; 0001 0345 //     //khong thay truyen tinh hieu robot
; 0001 0346 //     if(flagstatus==0)    cntunsignalRF ++;
; 0001 0347 //     else
; 0001 0348 //     {
; 0001 0349 //       cntunsignalRF=0;
; 0001 034A //     }
; 0001 034B //     if(cntunsignalRF > 10000)  // xac nhan mat tin hieu RF
; 0001 034C //     {
; 0001 034D //        flagunsignalRF=1;
; 0001 034E //     }else flagunsignalRF=0;
; 0001 034F //     if(cntunlookRB > 10)  // xac nhan robot roi vao diem mu
; 0001 0350 //     {
; 0001 0351 //        flagunlookRB=1;
; 0001 0352 //     }else  flagunlookRB=0;
; 0001 0353      return flagstatus;
; 0001 0354 
; 0001 0355 }
;//========================================================
;// calc  vi tri robot   so voi mot diem (x,y)        PHUC
;// return goclenh va khoang cach, HUONG TAN CONG
;//========================================================
;void calcvitri(float x,float y)
; 0001 035B {
; 0001 035C         float ahx,ahy,aox,aoy,dah,dao,ahay,cosgoc,anpla0,anpla1,detaanpla;
; 0001 035D         ahx = robotctrl.ox-robotctrl.x;
;	x -> Y+48
;	y -> Y+44
;	ahx -> Y+40
;	ahy -> Y+36
;	aox -> Y+32
;	aoy -> Y+28
;	dah -> Y+24
;	dao -> Y+20
;	ahay -> Y+16
;	cosgoc -> Y+12
;	anpla0 -> Y+8
;	anpla1 -> Y+4
;	detaanpla -> Y+0
; 0001 035E         ahy = robotctrl.oy-robotctrl.y;
; 0001 035F         aox = x-robotctrl.x;
; 0001 0360         aoy = y-robotctrl.y;
; 0001 0361         dah = sqrt(ahx*ahx+ahy*ahy)  ;
; 0001 0362         dao = sqrt(aox*aox+aoy*aoy)  ;
; 0001 0363         ahay= ahx*aox+ahy*aoy;
; 0001 0364         cosgoc = ahay/(dah*dao);
; 0001 0365 
; 0001 0366         anpla0 = atan2(ahy,ahx);
; 0001 0367         anpla1 = atan2(aoy,aox);
; 0001 0368         detaanpla= anpla0-anpla1;
; 0001 0369 
; 0001 036A         errangle = acos(cosgoc*180)/3.14;
; 0001 036B         if(((detaanpla>0)&&(detaanpla <M_PI))|| (detaanpla <-M_PI))  // xet truong hop goc ben phai
; 0001 036C         {
; 0001 036D              errangle = - errangle; // ben phai
; 0001 036E         }
; 0001 036F         else
; 0001 0370         {
; 0001 0371             errangle = errangle;   // ben trai
; 0001 0372 
; 0001 0373         }
; 0001 0374         distance = sqrt(aox*3.48*aox*3.48+aoy*2.89*aoy*2.89); //tinh khoang cach
; 0001 0375         orentation = atan2(ahy,ahx)*180/M_PI + offestsanco;//tinh huong ra goc
; 0001 0376         if(( 0 < orentation && orentation < 74) ||   ( 0 > orentation && orentation > -80) )
; 0001 0377         {
; 0001 0378            if(SAN_ID == 1)// phan san duong
; 0001 0379            {
; 0001 037A             flagtancong=0;
; 0001 037B             offsetphongthu = 70 ;
; 0001 037C             goctancong = 180;
; 0001 037D            }
; 0001 037E            else // phan san am
; 0001 037F            {
; 0001 0380             flagtancong=1;
; 0001 0381 
; 0001 0382            }
; 0001 0383         }else
; 0001 0384         {
; 0001 0385            if(SAN_ID == 1)
; 0001 0386            {
; 0001 0387            flagtancong=1;
; 0001 0388            }
; 0001 0389            else
; 0001 038A            {
; 0001 038B             flagtancong=0;
; 0001 038C             offsetphongthu = -70 ;
; 0001 038D             goctancong = 0;
; 0001 038E            }
; 0001 038F         }
; 0001 0390 
; 0001 0391 }
;void runEscStuck()
; 0001 0393 {
; 0001 0394 
; 0001 0395     //PHUC
; 0001 0396     while(cmdCtrlRobot==4)
; 0001 0397     {
; 0001 0398 
; 0001 0399         DDRA    = 0x00;
; 0001 039A         PORTA   = 0x00;
; 0001 039B         IRFL=read_adc(4);
; 0001 039C         IRFR=read_adc(5);
; 0001 039D 
; 0001 039E //        if((IRFL<300)&&(IRFR<300))
; 0001 039F //        {
; 0001 03A0 //            vMLlui(15);vMRlui(25);
; 0001 03A1 //            delay_ms(50);
; 0001 03A2 //        }else
; 0001 03A3 //        {
; 0001 03A4 //            if (IRFL>300 && IRFR<300)
; 0001 03A5 //            {
; 0001 03A6 //             vMLlui(5);vMRlui(22);delay_ms(300);
; 0001 03A7 //            }
; 0001 03A8 //            if (IRFR>300 && IRFL<300 )
; 0001 03A9 //            {
; 0001 03AA //            vMLlui(22);vMRlui(5);delay_ms(300);
; 0001 03AB //            }
; 0001 03AC //        }
; 0001 03AD 
; 0001 03AE         if((IRFL<300)&&(IRFR<300))
; 0001 03AF         {
; 0001 03B0             vMLtoi(22);vMRlui(22);
; 0001 03B1             delay_ms(100);
; 0001 03B2         }
; 0001 03B3          if (IRFL>300 && IRFR<300)
; 0001 03B4         {
; 0001 03B5             vMLlui(0);vMRlui(25);delay_ms(100);
; 0001 03B6         }
; 0001 03B7         if (IRFR>300 && IRFL<300 )
; 0001 03B8         {
; 0001 03B9             vMLlui(25);vMRlui(0);delay_ms(100);
; 0001 03BA         }
; 0001 03BB         LEDBR=!LEDBR;
; 0001 03BC        // delay_ms(10);
; 0001 03BD        readposition();//doc RF cap nhat lai robot
; 0001 03BE     }
; 0001 03BF }
;void runEscStucksethome()
; 0001 03C1 {
; 0001 03C2     //PHUC
; 0001 03C3     while(cmdCtrlRobot==7)
; 0001 03C4     {
; 0001 03C5          DDRA    = 0x00;
; 0001 03C6          PORTA   = 0x00;
; 0001 03C7         readposition();//doc RF cap nhat ai robot
; 0001 03C8         IRFL=read_adc(4);
; 0001 03C9         IRFR=read_adc(5);
; 0001 03CA 
; 0001 03CB //        if((IRFL<300)&&(IRFR<300))
; 0001 03CC //        {
; 0001 03CD //            vMLlui(20);vMRlui(20);
; 0001 03CE //            delay_ms(100);
; 0001 03CF //        }else
; 0001 03D0 //        {
; 0001 03D1 //            if (IRFL>300 && IRFR<300)
; 0001 03D2 //            {
; 0001 03D3 //             vMLlui(22);vMRlui(5);delay_ms(300);
; 0001 03D4 //            }
; 0001 03D5 //            if (IRFL<300 && IRFR>300  )
; 0001 03D6 //            {
; 0001 03D7 //            vMLlui(5);vMRlui(22);delay_ms(300);
; 0001 03D8 //            }
; 0001 03D9 //        }
; 0001 03DA 
; 0001 03DB 
; 0001 03DC         if((IRFL<300)&&(IRFR<300))
; 0001 03DD         {
; 0001 03DE             vMLtoi(22);vMRlui(22);
; 0001 03DF             delay_ms(100);
; 0001 03E0         }
; 0001 03E1 
; 0001 03E2         if (IRFL>300 && IRFR<300)
; 0001 03E3         {
; 0001 03E4             vMLlui(0);vMRlui(22);delay_ms(300);
; 0001 03E5         }
; 0001 03E6         if (IRFR>300 && IRFL<300 )
; 0001 03E7         {
; 0001 03E8             vMLlui(22);vMRlui(0);delay_ms(300);
; 0001 03E9         }
; 0001 03EA 
; 0001 03EB         LEDBR=!LEDBR;
; 0001 03EC         //delay_ms(10);
; 0001 03ED     }
; 0001 03EE }
;void runEscBlindSpot()
; 0001 03F0 {
; 0001 03F1     //PHUC
; 0001 03F2     while(cmdCtrlRobot==3)
; 0001 03F3     {
; 0001 03F4         DDRA    = 0x00;
; 0001 03F5         PORTA   = 0x00;
; 0001 03F6         readposition();//doc RF cap nhat ai robot
; 0001 03F7         IRFL=read_adc(4);
; 0001 03F8         IRFR=read_adc(5);
; 0001 03F9         if (IRFL>300 && IRFR<300)
; 0001 03FA         {
; 0001 03FB             vMLlui(0);vMRlui(22);delay_ms(300);
; 0001 03FC         }
; 0001 03FD         if (IRFR>300 && IRFL<300 )
; 0001 03FE         {
; 0001 03FF             vMLlui(22);vMRlui(0);delay_ms(300);
; 0001 0400         }
; 0001 0401 
; 0001 0402         if((IRFL<300)&&(IRFR<300))
; 0001 0403         {
; 0001 0404             vMLtoi(20);vMRtoi(20);
; 0001 0405             delay_ms(20);
; 0001 0406         }
; 0001 0407 
; 0001 0408 //        if((IRFL<300)&&(IRFR<300))
; 0001 0409 //        {
; 0001 040A //            vMLlui(20);vMRlui(20);
; 0001 040B //            delay_ms(100);
; 0001 040C //        }else
; 0001 040D //        {
; 0001 040E //            if (IRFL>300 && IRFR<300)
; 0001 040F //            {
; 0001 0410 //             vMLlui(22);vMRlui(5);delay_ms(300);
; 0001 0411 //            }
; 0001 0412 //            if (IRFL<300 && IRFR>300  )
; 0001 0413 //            {
; 0001 0414 //            vMLlui(5);vMRlui(22);delay_ms(300);
; 0001 0415 //            }
; 0001 0416 //        }
; 0001 0417 
; 0001 0418         LEDR=!LEDR;
; 0001 0419         //delay_ms(10);
; 0001 041A     }
; 0001 041B }
;
;void runEscBlindSpotsethome()
; 0001 041E {
; 0001 041F     //PHUC
; 0001 0420     while(cmdCtrlRobot==6)
; 0001 0421     {
; 0001 0422         DDRA    = 0x00;
; 0001 0423         PORTA   = 0x00;
; 0001 0424         readposition();//doc RF cap nhat ai robot
; 0001 0425         IRFL=read_adc(4);
; 0001 0426         IRFR=read_adc(5);
; 0001 0427         if (IRFL>300 && IRFR<300)
; 0001 0428         {
; 0001 0429             vMLlui(0);vMRlui(22);delay_ms(300);
; 0001 042A         }
; 0001 042B         if (IRFR>300 && IRFL<300 )
; 0001 042C         {
; 0001 042D             vMLlui(22);vMRlui(0);delay_ms(300);
; 0001 042E         }
; 0001 042F 
; 0001 0430         if((IRFL<300)&&(IRFR<300))
; 0001 0431         {
; 0001 0432             vMLtoi(20);vMRtoi(20);
; 0001 0433             delay_ms(10);
; 0001 0434         }
; 0001 0435 
; 0001 0436         LEDR=!LEDR;
; 0001 0437         //delay_ms(10);
; 0001 0438     }
; 0001 0439 }
;
;//========================================================
;// SET HOME  vi tri robot, de chuan bi cho tran dau       PHUC//
;//========================================================
;int sethomeRB()
; 0001 043F {
; 0001 0440        while(flagsethome==0)
; 0001 0441        {
; 0001 0442             LEDL=!LEDL;
; 0001 0443               //PHUC SH
; 0001 0444             if(readposition()==1)//co du lieu moi
; 0001 0445             {
; 0001 0446                     //hc(3,40);wn16s(cmdCtrlRobot);
; 0001 0447                     if(cmdCtrlRobot==1)      // dung ma lenh stop chuong trinh
; 0001 0448                     {
; 0001 0449                         flagsethome=0;
; 0001 044A                          return 0;
; 0001 044B                     }
; 0001 044C 
; 0001 044D                     if(cmdCtrlRobot==2 || cmdCtrlRobot==3 || cmdCtrlRobot==4)      // dung ma lenh stop chuong trinh
; 0001 044E                     {
; 0001 044F                         flagsethome=0;
; 0001 0450                         return 0;
; 0001 0451                     }
; 0001 0452 
; 0001 0453                     if(cmdCtrlRobot==5)  //sethome robot
; 0001 0454                     {
; 0001 0455 
; 0001 0456                         calcvitri(rbctrlHomeX,rbctrlHomeY);
; 0001 0457                         if(distance>100) //chay den vi tri
; 0001 0458                         {
; 0001 0459                             if(errangle>18 || errangle<-18 )
; 0001 045A                             {
; 0001 045B                             int nv = errangle*27/180 ;
; 0001 045C                             int verrangle = calcVangle(errangle);
; 0001 045D                             ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 045E                             delay_ms(1);
; 0001 045F                             }else
; 0001 0460                             {
; 0001 0461                             //1xung = 3.14 * 40/24 =5.22
; 0001 0462                             ctrRobottoi(distance/5.22,15);
; 0001 0463                             // verranglekisum=0;//RESET I.
; 0001 0464                             }
; 0001 0465                         }
; 0001 0466                         else //XOAY DUNG HUONG
; 0001 0467                         {
; 0001 0468                             setRobotAngleX=10*cos(rbctrlHomeAngle*M_PI/180);
; 0001 0469                             setRobotAngleY=10*sin(rbctrlHomeAngle*M_PI/180);;
; 0001 046A                             calcvitri(robotctrl.x + setRobotAngleX,robotctrl.y + setRobotAngleY);
; 0001 046B                             if(errangle>90 || errangle<-90 )
; 0001 046C                              {
; 0001 046D 
; 0001 046E                                int nv = errangle*27/180 ;
; 0001 046F                                int verrangle = calcVangle(errangle);
; 0001 0470                                ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 0471                                delay_ms(1);
; 0001 0472                              }else
; 0001 0473                              {
; 0001 0474 
; 0001 0475                                  verranglekisum=0;//RESET I.
; 0001 0476                                  flaghuongtrue=0;
; 0001 0477                                  flagsethome=1;  // bao da set home khong can set nua
; 0001 0478                                  vMRstop();
; 0001 0479                                  vMLstop();
; 0001 047A                                   return 0;
; 0001 047B 
; 0001 047C                              }
; 0001 047D                         }
; 0001 047E 
; 0001 047F                     }
; 0001 0480 
; 0001 0481                     if(cmdCtrlRobot==7)  //sethome IS STUCKED
; 0001 0482                     {
; 0001 0483 
; 0001 0484                        cntstuckRB++;
; 0001 0485                        if(cntstuckRB > 2)
; 0001 0486                        {
; 0001 0487                          runEscStucksethome();
; 0001 0488                          cntstuckRB=0;
; 0001 0489                        }
; 0001 048A                     }
; 0001 048B 
; 0001 048C                     if(cmdCtrlRobot==6) //sethome IS //roi vao diem mu (blind spot) , mat vi tri hay huong
; 0001 048D                     {
; 0001 048E                        LEDBL=1;
; 0001 048F                        cntunlookRB++;
; 0001 0490                        if(cntunlookRB > 2)
; 0001 0491                        {
; 0001 0492                          runEscBlindSpotsethome();
; 0001 0493                          cntunlookRB=0;
; 0001 0494 
; 0001 0495                        }
; 0001 0496 
; 0001 0497                     }
; 0001 0498 
; 0001 0499 
; 0001 049A             }
; 0001 049B 
; 0001 049C             LEDR=!LEDR;
; 0001 049D             wc('d');
; 0001 049E 
; 0001 049F        }
; 0001 04A0        return 0;
; 0001 04A1 
; 0001 04A2 }
;
;int codePenalty()
; 0001 04A5 {
; 0001 04A6    // chay den vi tri duoc dat truoc, sau do da banh 1 lan
; 0001 04A7       //PHUC SH
; 0001 04A8       if(readposition()==1)//co du lieu moi
; 0001 04A9       {
; 0001 04AA            if(cmdCtrlRobot==8)  //set vi tri penalty robot
; 0001 04AB             {
; 0001 04AC                 calcvitri(rbctrlPenaltyX,rbctrlPenaltyY);
; 0001 04AD                 if(distance>50) //chay den vi tri
; 0001 04AE                 {
; 0001 04AF                     if(errangle>18 || errangle<-18 )
; 0001 04B0                     {
; 0001 04B1                     int nv = errangle*27/180 ;
; 0001 04B2                     int verrangle = calcVangle(errangle);
; 0001 04B3                     ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 04B4                     delay_ms(1);
; 0001 04B5                     }else
; 0001 04B6                     {
; 0001 04B7                     //1xung = 3.14 * 40/24 =5.22
; 0001 04B8                     ctrRobottoi(distance/5.22,15);
; 0001 04B9                     // verranglekisum=0;//RESET I.
; 0001 04BA                     }
; 0001 04BB                 }
; 0001 04BC                 else //XOAY DUNG HUONG
; 0001 04BD                 {
; 0001 04BE                     setRobotAngleX=10*cos(rbctrlPenaltyAngle*M_PI/180);
; 0001 04BF                     setRobotAngleY=10*sin(rbctrlPenaltyAngle*M_PI/180);;
; 0001 04C0                     calcvitri(robotctrl.x + setRobotAngleX,robotctrl.y + setRobotAngleY);
; 0001 04C1                     if(errangle>10 || errangle<-10 )
; 0001 04C2                      {
; 0001 04C3 
; 0001 04C4                        int nv = errangle*27/180 ;
; 0001 04C5                        int verrangle = calcVangle(errangle);
; 0001 04C6                        ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 04C7                        delay_ms(1);
; 0001 04C8                      }else
; 0001 04C9                      {
; 0001 04CA 
; 0001 04CB                          verranglekisum=0;//RESET I.
; 0001 04CC                          flaghuongtrue=0;
; 0001 04CD                          flagsethome=1;  // bao da set vitri penalty
; 0001 04CE                          while(cmdCtrlRobot!=2) //cho nhan nut start
; 0001 04CF                          {
; 0001 04D0                             readposition();
; 0001 04D1                          }
; 0001 04D2                          // da banh
; 0001 04D3                          vMRtoi(22);
; 0001 04D4                          vMLtoi(22);
; 0001 04D5                          delay_ms(1000);
; 0001 04D6                          vMRlui(10);
; 0001 04D7                          vMLlui(10);
; 0001 04D8                          delay_ms(1000);
; 0001 04D9                          vMRstop();
; 0001 04DA                          vMLstop();
; 0001 04DB                           return 0;
; 0001 04DC 
; 0001 04DD                      }
; 0001 04DE                 }
; 0001 04DF 
; 0001 04E0             }
; 0001 04E1       }
; 0001 04E2 
; 0001 04E3 }
;
;int macdinh()
; 0001 04E6 {
; 0001 04E7 
; 0001 04E8      if(readposition()==1)//co du lieu moi
; 0001 04E9       {
; 0001 04EA            if(cmdCtrlRobot==5)  //set vi tri penalty robot
; 0001 04EB             {
; 0001 04EC                 calcvitri( rbctrlHomeX, rbctrlHomeY);
; 0001 04ED                 if(distance>50) //chay den vi tri
; 0001 04EE                 {
; 0001 04EF                     if(errangle>18 || errangle<-18 )
; 0001 04F0                     {
; 0001 04F1                     int nv = errangle*27/180 ;
; 0001 04F2                     int verrangle = calcVangle(errangle);
; 0001 04F3                     ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 04F4                     delay_ms(1);
; 0001 04F5                     }else
; 0001 04F6                     {
; 0001 04F7                     //1xung = 3.14 * 40/24 =5.22
; 0001 04F8                     ctrRobottoi(distance/5.22,15);
; 0001 04F9                     // verranglekisum=0;//RESET I.
; 0001 04FA                     }
; 0001 04FB                 }
; 0001 04FC //                else //XOAY DUNG HUONG
; 0001 04FD //                {
; 0001 04FE //                    setRobotAngleX=10*cos(rbctrlHomeAngle*M_PI/180);
; 0001 04FF //                    setRobotAngleY=10*sin(rbctrlHomeAngle*M_PI/180);;
; 0001 0500 //                    calcvitri(robotctrl.x + setRobotAngleX,robotctrl.y + setRobotAngleY);
; 0001 0501 //                    if(errangle>10 || errangle<-10 )
; 0001 0502 //                     {
; 0001 0503 //
; 0001 0504 //                       int nv = errangle*27/180 ;
; 0001 0505 //                       int verrangle = calcVangle(errangle);
; 0001 0506 //                       ctrRobotXoay(nv,verrangle);
; 0001 0507 //                       delay_ms(1);
; 0001 0508 //                     }
; 0001 0509 //                     else
; 0001 050A //                     {
; 0001 050B //                                verranglekisum=0;//RESET I.
; 0001 050C //                                flaghuongtrue=0;
; 0001 050D //                                 flagsethome=1;  // bao da set home khong can set nua
; 0001 050E //                                 vMRstop();
; 0001 050F //                                 vMLstop();
; 0001 0510 //                                  return 0;
; 0001 0511 //                     }
; 0001 0512 //                }
; 0001 0513 //
; 0001 0514             }
; 0001 0515       }
; 0001 0516 
; 0001 0517 
; 0001 0518 }
;void settoadoHomRB()
; 0001 051A {
; 0001 051B     switch(ROBOT_ID)
; 0001 051C     {
; 0001 051D     //PHUC
; 0001 051E        case 1:
; 0001 051F 
; 0001 0520 
; 0001 0521             rbctrlPenaltyX = 0;
; 0001 0522             rbctrlPenaltyY = 0;
; 0001 0523 
; 0001 0524             if(SAN_ID==1)
; 0001 0525             {
; 0001 0526               rbctrlPenaltyAngle = 179;
; 0001 0527               rbctrlHomeAngle = 179 ;
; 0001 0528               rbctrlHomeX = 269.7 ;
; 0001 0529               rbctrlHomeY = 1.7  ;
; 0001 052A               setRobotXmin=80;
; 0001 052B               setRobotXmax=260;
; 0001 052C             }
; 0001 052D             else
; 0001 052E             {
; 0001 052F               rbctrlPenaltyAngle = -15;
; 0001 0530               rbctrlHomeAngle = -15 ;
; 0001 0531               rbctrlHomeX =-226.1 ;
; 0001 0532               rbctrlHomeY = 1.6  ;
; 0001 0533               setRobotXmin=-260;
; 0001 0534               setRobotXmax=-80;
; 0001 0535             }
; 0001 0536        break;
; 0001 0537        case 2:
; 0001 0538 
; 0001 0539 
; 0001 053A             rbctrlPenaltyX=0;
; 0001 053B             rbctrlPenaltyY=0;
; 0001 053C 
; 0001 053D             if(SAN_ID==1)
; 0001 053E             {
; 0001 053F               rbctrlPenaltyAngle = 179;
; 0001 0540               rbctrlHomeAngle = 179 ;
; 0001 0541               rbctrlHomeX =66.0 ;
; 0001 0542               rbctrlHomeY = 79.4  ;
; 0001 0543               setRobotXmin=-270;
; 0001 0544               setRobotXmax=270;
; 0001 0545             }
; 0001 0546             else
; 0001 0547             {
; 0001 0548               rbctrlPenaltyAngle = -15;
; 0001 0549               rbctrlHomeAngle = -15  ;
; 0001 054A               rbctrlHomeX =-44.3 ;
; 0001 054B               rbctrlHomeY = 82.7  ;
; 0001 054C               setRobotXmin=-270;
; 0001 054D               setRobotXmax=270;
; 0001 054E             }
; 0001 054F        break;
; 0001 0550        case 3:
; 0001 0551 
; 0001 0552 
; 0001 0553             rbctrlPenaltyX = 0;
; 0001 0554             rbctrlPenaltyY = 0;
; 0001 0555             rbctrlPenaltyAngle = -15;
; 0001 0556             if(SAN_ID==1)
; 0001 0557             {
; 0001 0558               rbctrlPenaltyAngle = 179;
; 0001 0559               rbctrlHomeAngle = 179 ;
; 0001 055A               rbctrlHomeX =54.1 ;
; 0001 055B               rbctrlHomeY = -99.9  ;
; 0001 055C               setRobotXmin=-270;
; 0001 055D               setRobotXmax=20;
; 0001 055E             }
; 0001 055F             else
; 0001 0560             {
; 0001 0561               rbctrlPenaltyAngle = -15;
; 0001 0562               rbctrlHomeAngle = -15  ;
; 0001 0563               rbctrlHomeX =-53.5 ;
; 0001 0564               rbctrlHomeY =  -93.8 ;
; 0001 0565               setRobotXmin=-20;
; 0001 0566               setRobotXmax=270;
; 0001 0567             }
; 0001 0568        break;
; 0001 0569        case 4:
; 0001 056A 
; 0001 056B             rbctrlPenaltyX=0;
; 0001 056C             rbctrlPenaltyY=0;
; 0001 056D 
; 0001 056E              if(SAN_ID==1)
; 0001 056F             {
; 0001 0570               rbctrlPenaltyAngle = 179;
; 0001 0571               rbctrlHomeAngle = 179 ;
; 0001 0572               rbctrlHomeX = 269.7 ;
; 0001 0573               rbctrlHomeY = 1.7  ;
; 0001 0574               setRobotXmin=80;
; 0001 0575               setRobotXmax=260;
; 0001 0576             }
; 0001 0577             else
; 0001 0578             {
; 0001 0579               rbctrlPenaltyAngle = -15;
; 0001 057A               rbctrlHomeAngle = -15  ;
; 0001 057B               rbctrlHomeX =-226.1 ;
; 0001 057C               rbctrlHomeY = 1.6  ;
; 0001 057D               setRobotXmin=-260;
; 0001 057E               setRobotXmax=-80;
; 0001 057F             }
; 0001 0580        break;
; 0001 0581        case 5:
; 0001 0582 
; 0001 0583             rbctrlPenaltyX = 0;
; 0001 0584             rbctrlPenaltyY = 0;
; 0001 0585              if(SAN_ID==1)
; 0001 0586             {
; 0001 0587                 rbctrlPenaltyAngle = 179;
; 0001 0588                rbctrlHomeAngle = 179 ;
; 0001 0589                rbctrlHomeX =-242 ; //  66
; 0001 058A               rbctrlHomeY = 10.2  ;  //  79.4
; 0001 058B               setRobotXmin=-270;
; 0001 058C               setRobotXmax=270;
; 0001 058D             }
; 0001 058E             else
; 0001 058F             {
; 0001 0590               rbctrlPenaltyAngle = -15;
; 0001 0591               rbctrlHomeAngle = -15  ;
; 0001 0592               rbctrlHomeX =242 ;
; 0001 0593               rbctrlHomeY = -10.2  ;
; 0001 0594               setRobotXmin=-100; //-270
; 0001 0595               setRobotXmax=100;  //270
; 0001 0596             }
; 0001 0597        break;
; 0001 0598        case 6:
; 0001 0599 
; 0001 059A 
; 0001 059B             rbctrlPenaltyX = 0;
; 0001 059C             rbctrlPenaltyY = 0;
; 0001 059D             if(SAN_ID==1)
; 0001 059E             {
; 0001 059F               rbctrlPenaltyAngle = 179;
; 0001 05A0               rbctrlHomeAngle = 179 ;
; 0001 05A1               rbctrlHomeX =-92 ;   //54.1
; 0001 05A2               rbctrlHomeY = 3  ;  // -99.9
; 0001 05A3               setRobotXmin=-270;
; 0001 05A4               setRobotXmax=270;//20
; 0001 05A5             }
; 0001 05A6             else
; 0001 05A7             {
; 0001 05A8               rbctrlPenaltyAngle = -15;
; 0001 05A9               rbctrlHomeAngle = -15  ;
; 0001 05AA               rbctrlHomeX =92 ;    //-53.5
; 0001 05AB               rbctrlHomeY = -3 ;  //-93.8
; 0001 05AC               setRobotXmin=-270;    //-20
; 0001 05AD               setRobotXmax=270;
; 0001 05AE             }
; 0001 05AF        break;
; 0001 05B0 
; 0001 05B1 
; 0001 05B2     }
; 0001 05B3 }
;//=======================================================
;// Tinh luc theo goc quay de dieu khien robot
;int calcVangle(int angle)
; 0001 05B7 {
; 0001 05B8     int verrangle=0;
; 0001 05B9     //tinh thanh phan I
; 0001 05BA     verranglekisum = verranglekisum + angle/20;
;	angle -> Y+2
;	verrangle -> R16,R17
; 0001 05BB     if(verranglekisum>15)verranglekisum = 15;
; 0001 05BC     if(verranglekisum<-15)verranglekisum = -15;
; 0001 05BD     //tinh thanh phan dieu khien
; 0001 05BE     verrangle = 10 + angle/12 + verranglekisum ;
; 0001 05BF     //gioi han bao hoa
; 0001 05C0     if(verrangle<0) verrangle=-verrangle;//lay tri tuyet doi cua van toc v dieu khien
; 0001 05C1     if(verrangle>20) verrangle = 20;
; 0001 05C2     if(verrangle<8) verrangle = 8;
; 0001 05C3     return  verrangle;
; 0001 05C4 }
;//ctrl robot
;void ctrrobot()
; 0001 05C7 {
; 0001 05C8     if(readposition()==1)//co du lieu moi
; 0001 05C9     {
; 0001 05CA           hc(3,40);wn16s(cmdCtrlRobot);
; 0001 05CB //        hc(4,40);wn16s(idRobot);
; 0001 05CC          //-------------------------------------------------
; 0001 05CD         if(cmdCtrlRobot==8)      // dung ma lenh stop chuong trinh
; 0001 05CE         {
; 0001 05CF             flagsethome=0; //cho phep sethome
; 0001 05D0             while(cmdCtrlRobot==8)
; 0001 05D1             {
; 0001 05D2               codePenalty();
; 0001 05D3             }
; 0001 05D4         }
; 0001 05D5 
; 0001 05D6         if(cmdCtrlRobot==1)      // dung ma lenh stop chuong trinh
; 0001 05D7         {
; 0001 05D8             flagsethome=0; //cho phep sethome
; 0001 05D9             while(cmdCtrlRobot==1)
; 0001 05DA             {
; 0001 05DB               readposition();
; 0001 05DC             }
; 0001 05DD         }
; 0001 05DE 
; 0001 05DF         if(cmdCtrlRobot==5)  //sethome robot
; 0001 05E0         {
; 0001 05E1 
; 0001 05E2            cntsethomeRB++;
; 0001 05E3            if(cntsethomeRB > 2)
; 0001 05E4            {
; 0001 05E5              LEDBR=1;
; 0001 05E6              if (flagsethome == 0) sethomeRB();
; 0001 05E7              cntsethomeRB=0;
; 0001 05E8            }
; 0001 05E9 
; 0001 05EA         }
; 0001 05EB 
; 0001 05EC         if(cmdCtrlRobot==4)  //sethome robot
; 0001 05ED         {
; 0001 05EE            flagsethome=0; //cho phep sethome
; 0001 05EF            cntstuckRB++;
; 0001 05F0            if(cntstuckRB > 2)
; 0001 05F1            {
; 0001 05F2              runEscStuck();
; 0001 05F3              cntstuckRB=0;
; 0001 05F4            }
; 0001 05F5         }
; 0001 05F6 
; 0001 05F7         if(cmdCtrlRobot==3)  //roi vao diem mu (blind spot) , mat vi tri hay huong
; 0001 05F8         {
; 0001 05F9            flagsethome=0; //cho phep sethome
; 0001 05FA            cntunlookRB++;
; 0001 05FB            if(cntunlookRB > 2)
; 0001 05FC            {
; 0001 05FD              runEscBlindSpot();
; 0001 05FE              cntunlookRB=0;
; 0001 05FF            }
; 0001 0600 
; 0001 0601         }
; 0001 0602 
; 0001 0603 
; 0001 0604         //------------------------------------------------
; 0001 0605         if(cmdCtrlRobot==2) {// run chuong trinh
; 0001 0606             flagsethome=0; //cho phep sethome
; 0001 0607             switch(flagtask)
; 0001 0608             {
; 0001 0609               // chay den vi tri duoc set boi nguoi dieu khien
; 0001 060A               case 0:
; 0001 060B                      if(setRobotX < setRobotXmin)   setRobotX =  setRobotXmin;
; 0001 060C                      if(setRobotX >setRobotXmax)    setRobotX =  setRobotXmax;
; 0001 060D                      calcvitri(setRobotX,setRobotY);
; 0001 060E                      if(distance>80) //chay den vi tri
; 0001 060F                      {
; 0001 0610                          if(errangle>18 || errangle<-18 )
; 0001 0611                          {
; 0001 0612                            int nv = errangle*27/180 ;
; 0001 0613                            int verrangle = calcVangle(errangle);
; 0001 0614                            ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 0615                            delay_ms(1);
; 0001 0616                          }else
; 0001 0617                          {
; 0001 0618                            //1xung = 3.14 * 40/24 =5.22
; 0001 0619                            ctrRobottoi(distance/5.22,15);
; 0001 061A                           // verranglekisum=0;//RESET I.
; 0001 061B                          }
; 0001 061C                      }
; 0001 061D                      else
; 0001 061E                      {
; 0001 061F                          flagtask=10;
; 0001 0620                      }
; 0001 0621                      break;
; 0001 0622               // quay dung huong duoc set boi nguoi dieu khien
; 0001 0623               case 1:
; 0001 0624 
; 0001 0625                     calcvitri(robotctrl.x + setRobotAngleX,robotctrl.y + setRobotAngleY);
; 0001 0626                     if(errangle>18 || errangle<-18 )
; 0001 0627                      {
; 0001 0628 
; 0001 0629                        int nv = errangle*27/180 ;
; 0001 062A                        int verrangle = calcVangle(errangle);
; 0001 062B                        ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 062C                       // ctrRobotXoay(nv,10);
; 0001 062D                        delay_ms(1);
; 0001 062E                      }else
; 0001 062F                      {
; 0001 0630                        flaghuongtrue++;
; 0001 0631                        if(flaghuongtrue>3)
; 0001 0632                        {
; 0001 0633                         //verranglekisum=0;//RESET I.
; 0001 0634                          flaghuongtrue=0;
; 0001 0635                          flagtask=10;
; 0001 0636                        }
; 0001 0637 
; 0001 0638                      }
; 0001 0639                     break;
; 0001 063A               // chay den vi tri bong
; 0001 063B               case 2:
; 0001 063C 
; 0001 063D                     //PHUC test    rb1 ,s1
; 0001 063E                     if(robotctrl.ball.x < setRobotXmin)   robotctrl.ball.x =  setRobotXmin;
; 0001 063F                     if(robotctrl.ball.x >setRobotXmax)    robotctrl.ball.x =  setRobotXmax;
; 0001 0640                     calcvitri(robotctrl.ball.x,robotctrl.ball.y);
; 0001 0641 
; 0001 0642                      if(errangle>18 || errangle<-18 )
; 0001 0643                      {
; 0001 0644                        int nv = errangle*27/180 ;
; 0001 0645                        int verrangle = calcVangle(errangle);
; 0001 0646                        ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 0647                        delay_ms(1);
; 0001 0648                      }else
; 0001 0649                      {
; 0001 064A                          //1xung = 3.14 * 40/24 =5.22
; 0001 064B                          if(distance>10) //chay den vi tri
; 0001 064C                          {
; 0001 064D                            ctrRobottoi(distance/5.22,15);
; 0001 064E                            delay_ms(5);
; 0001 064F                          }else
; 0001 0650                          {
; 0001 0651                            flagtask=10;
; 0001 0652                          }
; 0001 0653                         // verranglekisum=0;//RESET I.
; 0001 0654                      }
; 0001 0655 
; 0001 0656                     break;
; 0001 0657               // da bong
; 0001 0658               case 3:
; 0001 0659                     ctrRobottoi(40,22);
; 0001 065A                     delay_ms(400);
; 0001 065B                     ctrRobotlui(40,15);
; 0001 065C                     delay_ms(400);
; 0001 065D                     flagtask = 10;
; 0001 065E                     break;
; 0001 065F               case 10:
; 0001 0660                     vMRtoi(0);
; 0001 0661                     vMLtoi(0);
; 0001 0662                     break;
; 0001 0663               //chay theo bong co dinh huong
; 0001 0664               case 4:
; 0001 0665                     calcvitri(robotctrl.ball.x,robotctrl.ball.y);
; 0001 0666                     if(errangle>18 || errangle<-18 )
; 0001 0667                      {
; 0001 0668 
; 0001 0669                        int nv = errangle*27/180 ;
; 0001 066A                        int verrangle = calcVangle(errangle);
; 0001 066B                        ctrRobotXoay(nv,verrangle);
;	nv -> Y+2
;	verrangle -> Y+0
; 0001 066C                       // ctrRobotXoay(nv,10);
; 0001 066D                        delay_ms(1);
; 0001 066E                      }else
; 0001 066F                      {
; 0001 0670                        flaghuongtrue++;
; 0001 0671                        if(flaghuongtrue>3)
; 0001 0672                        {
; 0001 0673                         //verranglekisum=0;//RESET I.
; 0001 0674                          flaghuongtrue=0;
; 0001 0675                          flagtask=10;
; 0001 0676                        }
; 0001 0677 
; 0001 0678                      }
; 0001 0679                     break;
; 0001 067A            }
; 0001 067B        }//end if(cmdCtrlRobot==2)
; 0001 067C     }else   //khong co tin hieu RF hay khong thay robot
; 0001 067D     {
; 0001 067E          //if(flagunlookRB==1) runEscBlindSpot();
; 0001 067F 
; 0001 0680     }
; 0001 0681 
; 0001 0682 
; 0001 0683 }
;
;void rb_move(float x,float y)
; 0001 0686 {
; 0001 0687    flagtask = 0;
;	x -> Y+4
;	y -> Y+0
; 0001 0688    flagtaskold=flagtask;
; 0001 0689    setRobotX=x;
; 0001 068A    setRobotY=y;
; 0001 068B }
;void rb_rotate(int angle)     // goc xoay so voi truc x cua toa do
; 0001 068D {
; 0001 068E    flagtask = 1;
;	angle -> Y+0
; 0001 068F    flagtaskold=flagtask;
; 0001 0690    setRobotAngleX=10*cos(angle*M_PI/180);
; 0001 0691    setRobotAngleY=10*sin(angle*M_PI/180);;
; 0001 0692 }
;
;void rb_goball()
; 0001 0695 {
; 0001 0696    flagtask = 2;
; 0001 0697    flagtaskold=flagtask;
; 0001 0698 }
;void rb_kick()
; 0001 069A {
; 0001 069B    flagtask = 3;
; 0001 069C    flagtaskold=flagtask;
; 0001 069D }
;int rb_wait(unsigned long int time )
; 0001 069F {
; 0001 06A0    time=time*10;
;	time -> Y+0
; 0001 06A1    while(time--)
; 0001 06A2    {
; 0001 06A3      ctrrobot();
; 0001 06A4      if(flagtask==10) return 1 ;// thuc hien xong nhiem vu
; 0001 06A5    }
; 0001 06A6     return 0;
; 0001 06A7 }
;//========================================================
;// Timer1 overflow interrupt service routine
;// period =1/2khz= 0.5ms
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0001 06AC {
_timer1_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0001 06AD // Place your code here
; 0001 06AE    timerstick++;
	LDI  R26,LOW(_timerstick)
	LDI  R27,HIGH(_timerstick)
	CALL SUBOPT_0x14
; 0001 06AF    timerstickdis++;
	LDI  R26,LOW(_timerstickdis)
	LDI  R27,HIGH(_timerstickdis)
	CALL SUBOPT_0x14
; 0001 06B0    timerstickang++;
	LDI  R26,LOW(_timerstickang)
	LDI  R27,HIGH(_timerstickang)
	CALL SUBOPT_0x14
; 0001 06B1    timerstickctr++;
	LDI  R26,LOW(_timerstickctr)
	LDI  R27,HIGH(_timerstickctr)
	CALL SUBOPT_0x14
; 0001 06B2  #ifdef CtrVelocity
; 0001 06B3  // dieu khien van toc
; 0001 06B4    if(timerstick>250)    // 125ms/0.5ms=250 : dung chu ki lay mau = 125 ms
	LDS  R26,_timerstick
	LDS  R27,_timerstick+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x20151
; 0001 06B5    {
; 0001 06B6      int eR=0,eL=0;
; 0001 06B7 
; 0001 06B8      //-------------------------------------------
; 0001 06B9      //cap nhat van toc
; 0001 06BA      vQER = (QER-oldQER);     //(xung / 10ms)
	SBIW R28,4
	CALL SUBOPT_0x15
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
;	eR -> Y+2
;	eL -> Y+0
	LDS  R26,_oldQER
	LDS  R27,_oldQER+1
	CALL SUBOPT_0x16
	SUB  R30,R26
	SBC  R31,R27
	STS  _vQER,R30
	STS  _vQER+1,R31
; 0001 06BB      vQEL = (QEL-oldQEL);     //(xung /10ms)
	LDS  R26,_oldQEL
	LDS  R27,_oldQEL+1
	CALL SUBOPT_0x17
	SUB  R30,R26
	SBC  R31,R27
	STS  _vQEL,R30
	STS  _vQEL+1,R31
; 0001 06BC      oldQEL=QEL;
	CALL SUBOPT_0x17
	STS  _oldQEL,R30
	STS  _oldQEL+1,R31
; 0001 06BD      oldQER=QER;
	CALL SUBOPT_0x16
	STS  _oldQER,R30
	STS  _oldQER+1,R31
; 0001 06BE      timerstick=0;
	LDI  R30,LOW(0)
	STS  _timerstick,R30
	STS  _timerstick+1,R30
; 0001 06BF 
; 0001 06C0      //--------------------------------------------
; 0001 06C1      //tinh PID van toc
; 0001 06C2      //--------------------------------------------
; 0001 06C3      eR=svQER-vQER;
	LDS  R26,_vQER
	LDS  R27,_vQER+1
	LDS  R30,_svQER
	LDS  R31,_svQER+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0001 06C4      //tinh thanh phan I
; 0001 06C5      seRki=seRki+KiR*eR;
	LDS  R26,_KiR
	LDS  R27,_KiR+1
	CALL __MULW12
	CALL SUBOPT_0x18
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x19
; 0001 06C6      if(seRki>100) seRki=100;
	CALL SUBOPT_0x18
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRLT _0x20152
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x19
; 0001 06C7      if(seRki<-100) seRki = -100;
_0x20152:
	CALL SUBOPT_0x18
	CPI  R26,LOW(0xFF9C)
	LDI  R30,HIGH(0xFF9C)
	CPC  R27,R30
	BRGE _0x20153
	LDI  R30,LOW(65436)
	LDI  R31,HIGH(65436)
	CALL SUBOPT_0x19
; 0001 06C8      //tinh them thanh phan P
; 0001 06C9      uR = 100 + KpR*eR + seRki;
_0x20153:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDS  R26,_KpR
	LDS  R27,_KpR+1
	CALL __MULW12
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	CALL SUBOPT_0x18
	ADD  R30,R26
	ADC  R31,R27
	STS  _uR,R30
	STS  _uR+1,R31
; 0001 06CA      if(uR>255) uR =255;
	LDS  R26,_uR
	LDS  R27,_uR+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x20154
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _uR,R30
	STS  _uR+1,R31
; 0001 06CB      if(uR<0) uR =0;
_0x20154:
	LDS  R26,_uR+1
	TST  R26
	BRPL _0x20155
	LDI  R30,LOW(0)
	STS  _uR,R30
	STS  _uR+1,R30
; 0001 06CC 
; 0001 06CD      eL=svQEL-vQEL;
_0x20155:
	LDS  R26,_vQEL
	LDS  R27,_vQEL+1
	LDS  R30,_svQEL
	LDS  R31,_svQEL+1
	CALL SUBOPT_0xC
; 0001 06CE      //tinh thanh phan I
; 0001 06CF      seLki=seLki+KiL*eL;
	LD   R30,Y
	LDD  R31,Y+1
	LDS  R26,_KiL
	LDS  R27,_KiL+1
	CALL __MULW12
	CALL SUBOPT_0x1A
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x1B
; 0001 06D0      if(seLki>100) seLki=100;
	CALL SUBOPT_0x1A
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRLT _0x20156
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x1B
; 0001 06D1      if(seLki<-100) seLki = -100;
_0x20156:
	CALL SUBOPT_0x1A
	CPI  R26,LOW(0xFF9C)
	LDI  R30,HIGH(0xFF9C)
	CPC  R27,R30
	BRGE _0x20157
	LDI  R30,LOW(65436)
	LDI  R31,HIGH(65436)
	CALL SUBOPT_0x1B
; 0001 06D2      //tinh them thanh phan P
; 0001 06D3      uL = 100 + KpL*eL + seLki;
_0x20157:
	LD   R30,Y
	LDD  R31,Y+1
	LDS  R26,_KpL
	LDS  R27,_KpL+1
	CALL __MULW12
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	CALL SUBOPT_0x1A
	ADD  R30,R26
	ADC  R31,R27
	STS  _uL,R30
	STS  _uL+1,R31
; 0001 06D4      if(uL>255) uL =255;
	LDS  R26,_uL
	LDS  R27,_uL+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x20158
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _uL,R30
	STS  _uL+1,R31
; 0001 06D5      if(uL<0) uL =0;
_0x20158:
	LDS  R26,_uL+1
	TST  R26
	BRPL _0x20159
	LDI  R30,LOW(0)
	STS  _uL,R30
	STS  _uL+1,R30
; 0001 06D6 
; 0001 06D7      if(svQER!=0)OCR1B= uR;
_0x20159:
	LDS  R30,_svQER
	LDS  R31,_svQER+1
	SBIW R30,0
	BREQ _0x2015A
	LDS  R30,_uR
	LDS  R31,_uR+1
	RJMP _0x202E9
; 0001 06D8      else  OCR1B = 0;
_0x2015A:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x202E9:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0001 06D9 
; 0001 06DA      if(svQEL!=0) OCR1A= uL;
	LDS  R30,_svQEL
	LDS  R31,_svQEL+1
	SBIW R30,0
	BREQ _0x2015C
	LDS  R30,_uL
	LDS  R31,_uL+1
	RJMP _0x202EA
; 0001 06DB      else  OCR1A = 0;
_0x2015C:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x202EA:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0001 06DC 
; 0001 06DD    }
	ADIW R28,4
; 0001 06DE // dieu khien khoang cach
; 0001 06DF   if(timerstickdis>10 && (flagwaitctrRobot==1))
_0x20151:
	LDS  R26,_timerstickdis
	LDS  R27,_timerstickdis+1
	SBIW R26,11
	BRLO _0x2015F
	LDS  R26,_flagwaitctrRobot
	CPI  R26,LOW(0x1)
	BREQ _0x20160
_0x2015F:
	RJMP _0x2015E
_0x20160:
; 0001 06E0   {
; 0001 06E1     unsigned int deltad1=0;
; 0001 06E2     deltad1 =(QER + QEL)/2 - oldd;
	SBIW R28,2
	CALL SUBOPT_0x15
;	deltad1 -> Y+0
	CALL SUBOPT_0x1C
	LDS  R26,_oldd
	LDS  R27,_oldd+1
	CALL SUBOPT_0xC
; 0001 06E3     //if(deltad1<0) deltad1=0;// co the am do kieu so
; 0001 06E4     //hc(3,0);ws("            ");
; 0001 06E5     //hc(3,0);wn16s(deltad1);
; 0001 06E6     if(deltad1>sd)
	LDS  R30,_sd
	LDS  R31,_sd+1
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x20161
; 0001 06E7     {
; 0001 06E8 
; 0001 06E9         vMLstop();
	RCALL _vMLstop
; 0001 06EA         vMRstop();
	RCALL _vMRstop
; 0001 06EB         flagwaitctrRobot=0;
	LDI  R30,LOW(0)
	STS  _flagwaitctrRobot,R30
; 0001 06EC         oldd=(QER+QEL)/2;
	CALL SUBOPT_0x1C
	STS  _oldd,R30
	STS  _oldd+1,R31
; 0001 06ED 
; 0001 06EE     }
; 0001 06EF     timerstickdis=0;
_0x20161:
	LDI  R30,LOW(0)
	STS  _timerstickdis,R30
	STS  _timerstickdis+1,R30
; 0001 06F0 
; 0001 06F1   }
	ADIW R28,2
; 0001 06F2   // dieu khien  vi tri goc quay
; 0001 06F3   if(timerstickang>10 && (flagwaitctrAngle==1))
_0x2015E:
	LDS  R26,_timerstickang
	LDS  R27,_timerstickang+1
	SBIW R26,11
	BRLO _0x20163
	LDS  R26,_flagwaitctrAngle
	CPI  R26,LOW(0x1)
	BREQ _0x20164
_0x20163:
	RJMP _0x20162
_0x20164:
; 0001 06F4   {
; 0001 06F5     unsigned int deltaa=0;
; 0001 06F6     deltaa =(QEL) - olda;
	SBIW R28,2
	CALL SUBOPT_0x15
;	deltaa -> Y+0
	LDS  R26,_olda
	LDS  R27,_olda+1
	CALL SUBOPT_0x17
	CALL SUBOPT_0xC
; 0001 06F7 //    hc(4,0);ws("            ");
; 0001 06F8 //    hc(4,0);wn16s(deltaa);
; 0001 06F9     if(deltaa>sa)
	LDS  R30,_sa
	LDS  R31,_sa+1
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x20165
; 0001 06FA     {
; 0001 06FB         vMLstop();
	RCALL _vMLstop
; 0001 06FC         vMRstop();
	RCALL _vMRstop
; 0001 06FD         flagwaitctrAngle=0;
	LDI  R30,LOW(0)
	STS  _flagwaitctrAngle,R30
; 0001 06FE         olda=QEL;
	CALL SUBOPT_0x17
	STS  _olda,R30
	STS  _olda+1,R31
; 0001 06FF     }
; 0001 0700     timerstickang=0;
_0x20165:
	LDI  R30,LOW(0)
	STS  _timerstickang,R30
	STS  _timerstickang+1,R30
; 0001 0701   }
	ADIW R28,2
; 0001 0702   // dieu khien robot robot
; 0001 0703   if(timerstickctr>1)
_0x20162:
	LDS  R26,_timerstickctr
	LDS  R27,_timerstickctr+1
	SBIW R26,2
	BRLO _0x20166
; 0001 0704   {
; 0001 0705     timerstickctr=0;
	LDI  R30,LOW(0)
	STS  _timerstickctr,R30
	STS  _timerstickctr+1,R30
; 0001 0706   }
; 0001 0707 #endif
; 0001 0708 }
_0x20166:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;//========================================================
;// read  vi tri robot   PHUC
;//========================================================
;unsigned char testposition()
; 0001 070E {
_testposition:
; 0001 070F         unsigned char  i=0;
; 0001 0710         unsigned flagstatus=0;
; 0001 0711 
; 0001 0712    while(keyKT!=0)
	CALL __SAVELOCR4
;	i -> R17
;	flagstatus -> R18,R19
	LDI  R17,0
	__GETWRN 18,19,0
_0x20167:
	SBIS 0x13,0
	RJMP _0x20169
; 0001 0713    {
; 0001 0714         if(nRF24L01_RxPacket(RxBuf)==1)         // Neu nhan duoc du lieu
	LDI  R30,LOW(_RxBuf)
	LDI  R31,HIGH(_RxBuf)
	ST   -Y,R31
	ST   -Y,R30
	CALL _nRF24L01_RxPacket
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x2016A
; 0001 0715         {
; 0001 0716          for( i=0;i<28;i++)
	LDI  R17,LOW(0)
_0x2016C:
	CPI  R17,28
	BRSH _0x2016D
; 0001 0717          {
; 0001 0718              *(uint8_t *) ((uint8_t *)&rb + i)=RxBuf[i];
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_rb)
	SBCI R27,HIGH(-_rb)
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_RxBuf)
	SBCI R31,HIGH(-_RxBuf)
	LD   R30,Z
	ST   X,R30
; 0001 0719          }
	SUBI R17,-1
	RJMP _0x2016C
_0x2016D:
; 0001 071A 
; 0001 071B 
; 0001 071C          idRobot = fmod(rb.id,10); // doc id
	CALL SUBOPT_0x1D
	CALL __PUTPARD1
	CALL SUBOPT_0x1E
	CALL __PUTPARD1
	CALL _fmod
	CALL __CFD1U
	MOVW R12,R30
; 0001 071D          cmdCtrlRobot = (int)rb.id/10; // doc ma lenh
	CALL SUBOPT_0x1D
	CALL __CFD1
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R10,R30
; 0001 071E          switch (idRobot)
	MOVW R30,R12
; 0001 071F          {
; 0001 0720               case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20171
; 0001 0721                   robot11=rb;
	LDI  R30,LOW(_rb)
	LDI  R31,HIGH(_rb)
	LDI  R26,LOW(_robot11)
	LDI  R27,HIGH(_robot11)
	RJMP _0x202EB
; 0001 0722                 break;
; 0001 0723               case 2:
_0x20171:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20172
; 0001 0724                   robot12=rb;
	LDI  R30,LOW(_rb)
	LDI  R31,HIGH(_rb)
	LDI  R26,LOW(_robot12)
	LDI  R27,HIGH(_robot12)
	RJMP _0x202EB
; 0001 0725                 break;
; 0001 0726               case 3:
_0x20172:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20173
; 0001 0727 
; 0001 0728                   robot13=rb;
	LDI  R30,LOW(_rb)
	LDI  R31,HIGH(_rb)
	LDI  R26,LOW(_robot13)
	LDI  R27,HIGH(_robot13)
	RJMP _0x202EB
; 0001 0729                   break;
; 0001 072A               case 4:
_0x20173:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20174
; 0001 072B                   robot21=rb;
	LDI  R30,LOW(_rb)
	LDI  R31,HIGH(_rb)
	LDI  R26,LOW(_robot21)
	LDI  R27,HIGH(_robot21)
	RJMP _0x202EB
; 0001 072C                 break;
; 0001 072D               case 5:
_0x20174:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x20175
; 0001 072E                   robot22=rb;
	LDI  R30,LOW(_rb)
	LDI  R31,HIGH(_rb)
	LDI  R26,LOW(_robot22)
	LDI  R27,HIGH(_robot22)
	RJMP _0x202EB
; 0001 072F                 break;
; 0001 0730               case 6:
_0x20175:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x20170
; 0001 0731                   robot23=rb;
	LDI  R30,LOW(_rb)
	LDI  R31,HIGH(_rb)
	LDI  R26,LOW(_robot23)
	LDI  R27,HIGH(_robot23)
_0x202EB:
	LDI  R24,28
	CALL __COPYMML
; 0001 0732                 break;
; 0001 0733 
; 0001 0734          }
_0x20170:
; 0001 0735          if(idRobot==ROBOT_ID)
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R12
	CPC  R31,R13
	BREQ PC+3
	JMP _0x20177
; 0001 0736          {
; 0001 0737              LEDR=!LEDR;
	SBIS 0x15,5
	RJMP _0x20178
	CBI  0x15,5
	RJMP _0x20179
_0x20178:
	SBI  0x15,5
_0x20179:
; 0001 0738              flagstatus=1;
	__GETWRN 18,19,1
; 0001 0739              robotctrl=rb;
	LDI  R30,LOW(_rb)
	LDI  R31,HIGH(_rb)
	LDI  R26,LOW(_robotctrl)
	LDI  R27,HIGH(_robotctrl)
	LDI  R24,28
	CALL __COPYMML
; 0001 073A              hc(5,40);wn16s(cmdCtrlRobot);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x1F
	ST   -Y,R11
	ST   -Y,R10
	CALL SUBOPT_0x20
; 0001 073B              hc(4,40);wn16s(idRobot);
	CALL SUBOPT_0x1F
	ST   -Y,R13
	ST   -Y,R12
	CALL SUBOPT_0x21
; 0001 073C              hc(3,20);wn16s(robotctrl.x);
	CALL SUBOPT_0x22
	__GETD1MN _robotctrl,4
	CALL SUBOPT_0x23
; 0001 073D              hc(2,20);wn16s(robotctrl.y);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x22
	__GETD1MN _robotctrl,8
	CALL SUBOPT_0x23
; 0001 073E              hc(1,1);wn16s(robotctrl.ox);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x25
	RCALL _hc
	__GETD1MN _robotctrl,12
	CALL SUBOPT_0x23
; 0001 073F              hc(0,1);wn16s(robotctrl.oy);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x25
	RCALL _hc
	__GETD1MN _robotctrl,16
	CALL SUBOPT_0x23
; 0001 0740              delay_ms(200);
	CALL SUBOPT_0x26
; 0001 0741          }
; 0001 0742 
; 0001 0743      }
_0x20177:
; 0001 0744    }
_0x2016A:
	RJMP _0x20167
_0x20169:
; 0001 0745      return flagstatus;
	MOV  R30,R18
	RJMP _0x20C0003
; 0001 0746 
; 0001 0747 }
;//========================================================
;void robotwall()
; 0001 074A {
_robotwall:
; 0001 074B unsigned int demled=0;
; 0001 074C         DDRA    = 0x00;
	ST   -Y,R17
	ST   -Y,R16
;	demled -> R16,R17
	__GETWRN 16,17,0
	CALL SUBOPT_0x27
; 0001 074D         PORTA   = 0x00;
; 0001 074E 
; 0001 074F         LcdClear();
; 0001 0750         hc(0,10);
	CALL SUBOPT_0x28
; 0001 0751         ws ("ROBOT WALL");
	__POINTW1MN _0x2017A,0
	CALL SUBOPT_0xE
; 0001 0752         LEDL=1;LEDR=1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 0753 
; 0001 0754    while(keyKT!=0)
_0x2017F:
	SBIS 0x13,0
	RJMP _0x20181
; 0001 0755    {
; 0001 0756         IRFL=read_adc(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	STS  _IRFL,R30
	STS  _IRFL+1,R31
; 0001 0757         IRFR=read_adc(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _read_adc
	STS  _IRFR,R30
	STS  _IRFR+1,R31
; 0001 0758         hc(1,0) ; wn16(IRFL);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x7
	RCALL _hc
	LDS  R30,_IRFL
	LDS  R31,_IRFL+1
	CALL SUBOPT_0xD
; 0001 0759         hc(1,42); wn16(IRFR);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x29
	LDS  R30,_IRFR
	LDS  R31,_IRFR+1
	CALL SUBOPT_0xD
; 0001 075A 
; 0001 075B         if (IRFL>250)
	LDS  R26,_IRFL
	LDS  R27,_IRFL+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLO _0x20182
; 0001 075C         {
; 0001 075D             vMLlui(22);vMRlui(10);delay_ms(600);
	LDI  R30,LOW(22)
	ST   -Y,R30
	RCALL _vMLlui
	LDI  R30,LOW(10)
	CALL SUBOPT_0x2A
; 0001 075E         }
; 0001 075F         if (IRFR>250)
_0x20182:
	LDS  R26,_IRFR
	LDS  R27,_IRFR+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRLO _0x20183
; 0001 0760         {
; 0001 0761             vMLlui(10);vMRlui(22);delay_ms(600);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _vMLlui
	LDI  R30,LOW(22)
	CALL SUBOPT_0x2A
; 0001 0762         }
; 0001 0763         if((IRFL<300)&(IRFR<300))
_0x20183:
	LDS  R26,_IRFL
	LDS  R27,_IRFL+1
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL __LTW12U
	MOV  R0,R30
	LDS  R26,_IRFR
	LDS  R27,_IRFR+1
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL __LTW12U
	AND  R30,R0
	BREQ _0x20184
; 0001 0764         {
; 0001 0765             vMLtoi(22);vMRtoi(22);
	LDI  R30,LOW(22)
	ST   -Y,R30
	RCALL _vMLtoi
	LDI  R30,LOW(22)
	ST   -Y,R30
	RCALL _vMRtoi
; 0001 0766         }
; 0001 0767 
; 0001 0768        demled++;
_0x20184:
	__ADDWRN 16,17,1
; 0001 0769        if(demled>50){demled=0;LEDLtoggle(); LEDRtoggle();}
	__CPWRN 16,17,51
	BRLO _0x20185
	__GETWRN 16,17,0
	CALL SUBOPT_0x2B
; 0001 076A    }
_0x20185:
	RJMP _0x2017F
_0x20181:
; 0001 076B 
; 0001 076C }
_0x20C0005:
	LD   R16,Y+
	LD   R17,Y+
	RET

	.DSEG
_0x2017A:
	.BYTE 0xB
;////========================================================
;//void robotline() //DIGITAL I/O
;//{
;//    unsigned char status=2;
;//    unsigned char prestatus=2;
;//
;//    DDRA =0x00;
;//    PORTA=0xFF;
;////#define S0  PINA.0 status 0
;////#define S1  PINA.1 status 1
;////#define S2  PINA.2 status 2
;////#define S3  PINA.3 status 3
;////#define S4  PINA.7 status 4
;//        LcdClear();
;//        hc(0,1);
;//        ws ("LINE FOLOWER");
;//        hc(1,20);
;//        ws (" ROBOT");
;//        LEDL=1;LEDR=1;
;//
;//   while(keyKT!=0)
;//   {
;//      if (S2==0)
;//      {
;//          status=2;
;//          vMLtoi(80);vMRtoi(80);
;//      }
;//      //===========================
;//      if ((prestatus==2)&(S1==0))
;//      {
;//          status=1;
;//          vMLtoi(80);vMRtoi(50);
;//      }
;//      if ((prestatus==2)&(S0==0))
;//      {
;//          status=0;
;//          vMLtoi(80);vMRtoi(30);
;//      }
;//       //===========================
;//      if ((prestatus==2)&(S3==0))
;//      {
;//          status=1;
;//          vMLtoi(50);vMRtoi(80);
;//      }
;//      if ((prestatus==2)&(S4==0))
;//      {
;//          status=0;
;//          vMLtoi(30);vMRtoi(80);
;//      }
;//       //===========================
;//      if ((prestatus==1)&(S0==0))
;//      {
;//          status=1;
;//          vMLtoi(80);vMRtoi(40);
;//      }
;//      if ((prestatus==3)&(S4==0))
;//      {
;//          status=0;
;//          vMLtoi(40);vMRtoi(80);
;//      }
;//
;//      prestatus=status;
;//      delay_ms(200);LEDLtoggle();LEDRtoggle();
;//
;//  }
;// }
;
;
;//========================================================
;void readline()
; 0001 07B3 {

	.CSEG
_readline:
; 0001 07B4     int i=0,j=0;
; 0001 07B5     // reset the values
; 0001 07B6         for(i = 0; i < 5; i++)
	CALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 16,17,0
_0x20187:
	__CPWRN 16,17,5
	BRGE _0x20188
; 0001 07B7         IRLINE[i] = 0;
	CALL SUBOPT_0x2C
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	__ADDWRN 16,17,1
	RJMP _0x20187
_0x20188:
; 0001 07B9 for (j = 0; j < 50; j++)
	__GETWRN 18,19,0
_0x2018A:
	__CPWRN 18,19,50
	BRLT PC+3
	JMP _0x2018B
; 0001 07BA         {
; 0001 07BB             IRLINE[0]= IRLINE[0]+read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	LDS  R26,_IRLINE
	LDS  R27,_IRLINE+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _IRLINE,R30
	STS  _IRLINE+1,R31
; 0001 07BC             IRLINE[1]= IRLINE[1]+read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	__GETW2MN _IRLINE,2
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _IRLINE,2
; 0001 07BD             IRLINE[2]= IRLINE[2]+read_adc(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	CALL SUBOPT_0x2D
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _IRLINE,4
; 0001 07BE             IRLINE[3]= IRLINE[3]+read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	__GETW2MN _IRLINE,6
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _IRLINE,6
; 0001 07BF             IRLINE[4]= IRLINE[4]+read_adc(7);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _read_adc
	__GETW2MN _IRLINE,8
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _IRLINE,8
; 0001 07C0         }
	__ADDWRN 18,19,1
	RJMP _0x2018A
_0x2018B:
; 0001 07C1         // get the rounded average of the readings for each sensor
; 0001 07C2         for (i = 0; i < 5; i++)
	__GETWRN 16,17,0
_0x2018D:
	__CPWRN 16,17,5
	BRGE _0x2018E
; 0001 07C3         IRLINE[i] = (IRLINE[i] + (50 >> 1)) /50;
	CALL SUBOPT_0x2C
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2E
	ADIW R30,25
	MOVW R26,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL __DIVW21U
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
	__ADDWRN 16,17,1
	RJMP _0x2018D
_0x2018E:
; 0001 07C4 }
_0x20C0003:
	CALL __LOADLOCR4
_0x20C0004:
	ADIW R28,4
	RET
;//========================================================
;void robotwhiteline() //ANALOG OK
; 0001 07C7 {
_robotwhiteline:
; 0001 07C8     unsigned char i=0,imax;
; 0001 07C9     int imaxlast=0;
; 0001 07CA     unsigned int  admax;
; 0001 07CB     unsigned int  demled=0;
; 0001 07CC     unsigned int flagblindT=0;
; 0001 07CD     unsigned int flagblindP=0;
; 0001 07CE     DDRA =0x00;
	SBIW R28,6
	CALL SUBOPT_0x15
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
	CALL __SAVELOCR6
;	i -> R17
;	imax -> R16
;	imaxlast -> R18,R19
;	admax -> R20,R21
;	demled -> Y+10
;	flagblindT -> Y+8
;	flagblindP -> Y+6
	LDI  R17,0
	__GETWRN 18,19,0
	CALL SUBOPT_0x27
; 0001 07CF     PORTA=0x00;
; 0001 07D0 
; 0001 07D1         LcdClear();
; 0001 07D2         hc(0,1);
	CALL SUBOPT_0x25
	RCALL _hc
; 0001 07D3         ws ("WHITE LINE");
	__POINTW1MN _0x2018F,0
	CALL SUBOPT_0xE
; 0001 07D4         hc(1,10);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x28
; 0001 07D5         ws ("FOLOWER");
	__POINTW1MN _0x2018F,11
	CALL SUBOPT_0xE
; 0001 07D6         LEDL=1;LEDR=1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 07D7         //doc va khoi dong gia tri cho imaxlast
; 0001 07D8          readline();
	CALL SUBOPT_0x2F
; 0001 07D9         admax = IRLINE[0];imax=0;
; 0001 07DA         for(i=1;i<5;i++){if(admax<IRLINE[i]){admax=IRLINE[i];imax=i;}}
_0x20195:
	CPI  R17,5
	BRSH _0x20196
	CALL SUBOPT_0x30
	CALL SUBOPT_0x2E
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x20197
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
_0x20197:
	SUBI R17,-1
	RJMP _0x20195
_0x20196:
; 0001 07DB         imaxlast=imax;
	MOV  R18,R16
	CLR  R19
; 0001 07DC    while(keyKT!=0)
_0x20198:
	SBIS 0x13,0
	RJMP _0x2019A
; 0001 07DD    {
; 0001 07DE         //doc gia tri cam bien
; 0001 07DF         readline();
	CALL SUBOPT_0x2F
; 0001 07E0         admax = IRLINE[0];imax=0;
; 0001 07E1         for(i=1;i<5;i++){if(admax<IRLINE[i]){admax=IRLINE[i];imax=i;}}
_0x2019C:
	CPI  R17,5
	BRSH _0x2019D
	CALL SUBOPT_0x30
	CALL SUBOPT_0x2E
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x2019E
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
_0x2019E:
	SUBI R17,-1
	RJMP _0x2019C
_0x2019D:
; 0001 07E2           //imax=2;
; 0001 07E3          if((imax-imaxlast > 1)||(imax-imaxlast <-1))  //tranh truong hop nhay bo trang thai
	CALL SUBOPT_0x32
	SUB  R30,R18
	SBC  R31,R19
	MOVW R26,R30
	SBIW R30,2
	BRGE _0x201A0
	MOVW R30,R26
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRGE _0x2019F
_0x201A0:
; 0001 07E4         {
; 0001 07E5         }
; 0001 07E6         else
	RJMP _0x201A2
_0x2019F:
; 0001 07E7         {
; 0001 07E8             switch(imax)
	CALL SUBOPT_0x32
; 0001 07E9             {
; 0001 07EA               case 0:
	SBIW R30,0
	BRNE _0x201A6
; 0001 07EB                   vMLtoi(1); vMRtoi(20) ;
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0001 07EC                   //flagblindT = 0;
; 0001 07ED                   flagblindP = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 07EE                 break;
	RJMP _0x201A5
; 0001 07EF               case 1:
_0x201A6:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x201A7
; 0001 07F0                   vMLtoi(1); vMRtoi(15) ;
	CALL SUBOPT_0x33
	CALL SUBOPT_0x35
; 0001 07F1                 break;
	RJMP _0x201A5
; 0001 07F2               case 2:
_0x201A7:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x201A8
; 0001 07F3                   vMLtoi(15);vMRtoi(15) ;
	CALL SUBOPT_0x36
	CALL SUBOPT_0x35
; 0001 07F4                 break;
	RJMP _0x201A5
; 0001 07F5               case 3:
_0x201A8:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x201A9
; 0001 07F6                  vMLtoi(15); vMRtoi(1) ;
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
; 0001 07F7                 break;
	RJMP _0x201A5
; 0001 07F8               case 4:
_0x201A9:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x201AB
; 0001 07F9                   vMLtoi(20);vMRtoi(1)  ;
	CALL SUBOPT_0x38
; 0001 07FA                   flagblindT = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 07FB                   //flagblindP = 0;
; 0001 07FC                 break;
; 0001 07FD               default:
_0x201AB:
; 0001 07FE                  // vMLtoi(5); vMRtoi(5) ;
; 0001 07FF                 break;
; 0001 0800             }
_0x201A5:
; 0001 0801              imaxlast=imax;
	MOV  R18,R16
	CLR  R19
; 0001 0802         }
_0x201A2:
; 0001 0803 
; 0001 0804             while(flagblindT ==1 && keyKT!=0) //lac duong ben trai
_0x201AC:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x201AF
	CALL SUBOPT_0x39
	BRNE _0x201B0
_0x201AF:
	RJMP _0x201AE
_0x201B0:
; 0001 0805             {
; 0001 0806                vMLtoi(20);vMRtoi(1)  ;
	CALL SUBOPT_0x38
; 0001 0807                 readline();
	CALL SUBOPT_0x2F
; 0001 0808                 admax = IRLINE[0];imax=0;
; 0001 0809                 for(i=1;i<5;i++){if(admax<IRLINE[i]){admax=IRLINE[i];imax=i;}}
_0x201B2:
	CPI  R17,5
	BRSH _0x201B3
	CALL SUBOPT_0x30
	CALL SUBOPT_0x2E
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x201B4
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
_0x201B4:
	SUBI R17,-1
	RJMP _0x201B2
_0x201B3:
; 0001 080A                 imaxlast=imax;
	MOV  R18,R16
	CLR  R19
; 0001 080B                if(IRLINE[2]>500)  flagblindT=0;
	CALL SUBOPT_0x2D
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLO _0x201B5
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
; 0001 080C 
; 0001 080D 
; 0001 080E             }
_0x201B5:
	RJMP _0x201AC
_0x201AE:
; 0001 080F             while(flagblindP ==1 && keyKT!=0 ) //lac duong ben phai
_0x201B6:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,1
	BRNE _0x201B9
	CALL SUBOPT_0x39
	BRNE _0x201BA
_0x201B9:
	RJMP _0x201B8
_0x201BA:
; 0001 0810             {
; 0001 0811                vMLtoi(1);vMRtoi(20)  ;
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
; 0001 0812                 readline();
	CALL SUBOPT_0x2F
; 0001 0813                 admax = IRLINE[0];imax=0;
; 0001 0814                 for(i=1;i<5;i++){if(admax<IRLINE[i]){admax=IRLINE[i];imax=i;}}
_0x201BC:
	CPI  R17,5
	BRSH _0x201BD
	CALL SUBOPT_0x30
	CALL SUBOPT_0x2E
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x201BE
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
_0x201BE:
	SUBI R17,-1
	RJMP _0x201BC
_0x201BD:
; 0001 0815                 imaxlast=imax;
	MOV  R18,R16
	CLR  R19
; 0001 0816                if(IRLINE[2]>500)  flagblindP=0;
	CALL SUBOPT_0x2D
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLO _0x201BF
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0001 0817 
; 0001 0818             }
_0x201BF:
	RJMP _0x201B6
_0x201B8:
; 0001 0819         hc(3,10);wn16s(imax);
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x32
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x20
; 0001 081A         hc(4,10);wn16s(admax);
	CALL SUBOPT_0x3B
	ST   -Y,R21
	ST   -Y,R20
	RCALL _wn16s
; 0001 081B 
; 0001 081C        demled++;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0001 081D        if(demled>30){demled=0;LEDLtoggle();LEDRtoggle(); }
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,31
	BRLO _0x201C0
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
	CALL SUBOPT_0x2B
; 0001 081E    }
_0x201C0:
	RJMP _0x20198
_0x2019A:
; 0001 081F }
	CALL __LOADLOCR6
	ADIW R28,12
	RET

	.DSEG
_0x2018F:
	.BYTE 0x13
;
;////========================================================
;////========================================================
;//void robotblackline() //ANALOG OK
;//{
;//    int i=0,j=0
;//    ,imin=0;
;//    unsigned int admin;
;//    unsigned int demled=0;
;//    unsigned int flagblindT=0;
;//    unsigned int flagblindP=0;
;//    int iminlast=0;
;//    DDRA =0x00;
;//    PORTA=0x00;
;//
;//        LcdClear();
;//        hc(0,1);
;//        ws ("BLACK LINE");
;//        hc(1,10);
;//        ws ("FOLOWER");
;//        LEDL=1;LEDR=1;
;//
;//        //doc lan dau tien  de khoi dong gia tri iminlast;
;//        readline();
;//        admin = IRLINE[0];imin=0;
;//        for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
;//        iminlast=imin;
;//
;//   while(keyKT!=0)
;//   {
;//       //doc gia tri cam bien
;//        readline();
;//        admin = IRLINE[0];imin=0;
;//        for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
;//        hc(2,10);wn16s(iminlast);
;//        hc(3,10);wn16s(imin);
;//        hc(4,10);wn16s(admin);
;//
;//        if((imin-iminlast > 1)||(imin-iminlast <-1))  //tranh truong hop nhay bo trang thai
;//        {
;//        }
;//        else
;//        {
;//             switch(imin)
;//            {
;//              case 0:
;//                  vMLtoi(1); vMRtoi(15) ;
;//                  //flagblindT = 0;
;//                  flagblindP = 1;
;//                break;
;//              case 1:
;//                  vMLtoi(2); vMRtoi(8) ;
;//                break;
;//              case 2:
;//                  vMLtoi(10);vMRtoi(10) ;
;//                break;
;//              case 3:
;//                 vMLtoi(8); vMRtoi(2) ;
;//                break;
;//              case 4:
;//                  vMLtoi(15);vMRtoi(1)  ;
;//                  flagblindT = 1;
;//                  //flagblindP = 0;
;//                break;
;//              default:
;//                 // vMLtoi(5); vMRtoi(5) ;
;//                break;
;//            }
;//
;//              iminlast=imin;
;//         }
;//
;//
;//            while(flagblindT == 1 && keyKT!=0) //lac duong ben trai
;//            {
;//               vMLtoi(20);vMRtoi(2)  ;
;//               readline();
;//               admin = IRLINE[0];imin=0;
;//               for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
;//               iminlast=imin;
;//               if(IRLINE[2]<310)  flagblindT=0;
;//
;//            }
;//            while(flagblindP ==1 && keyKT!=0) //lac duong ben phai
;//            {
;//               vMLtoi(2);vMRtoi(20)  ;
;//               readline();
;//               admin = IRLINE[0];imin=0;
;//               for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
;//               iminlast=imin;
;//               if(IRLINE[2]<310)  flagblindP=0;
;//
;//            }
;//
;//
;//       demled++;
;//       if(demled>30){demled=0;LEDLtoggle();LEDRtoggle(); }
;//   }
;//}
;
;//========================================================
;//========================================================
;void robotblackline() //ANALOG OK
; 0001 0887 {

	.CSEG
_robotblackline:
; 0001 0888     long int lastvalueline=0, valueline=0,value=0,online=0;
; 0001 0889     int i=0,j=0
; 0001 088A     ,imin=0;
; 0001 088B     long avrg=0,sum=0 ;
; 0001 088C     unsigned int admin;
; 0001 088D      unsigned char imax;
; 0001 088E     int imaxlast=0;
; 0001 088F     unsigned int  admax;
; 0001 0890     unsigned int demled=0;
; 0001 0891     unsigned int flagblindT=0;
; 0001 0892     unsigned int flagblindP=0;
; 0001 0893     float udk,sumi=0,err,lasterr;
; 0001 0894 
; 0001 0895     int iminlast=0;
; 0001 0896     DDRA =0x00;
	SBIW R28,55
	LDI  R24,55
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x201C1*2)
	LDI  R31,HIGH(_0x201C1*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	lastvalueline -> Y+57
;	valueline -> Y+53
;	value -> Y+49
;	online -> Y+45
;	i -> R16,R17
;	j -> R18,R19
;	imin -> R20,R21
;	avrg -> Y+41
;	sum -> Y+37
;	admin -> Y+35
;	imax -> Y+34
;	imaxlast -> Y+32
;	admax -> Y+30
;	demled -> Y+28
;	flagblindT -> Y+26
;	flagblindP -> Y+24
;	udk -> Y+20
;	sumi -> Y+16
;	err -> Y+12
;	lasterr -> Y+8
;	iminlast -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	CALL SUBOPT_0x27
; 0001 0897     PORTA=0x00;
; 0001 0898 
; 0001 0899         LcdClear();
; 0001 089A         hc(0,1);
	CALL SUBOPT_0x25
	RCALL _hc
; 0001 089B         ws ("BLACK LINE");
	__POINTW1MN _0x201C2,0
	CALL SUBOPT_0xE
; 0001 089C         hc(1,10);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x28
; 0001 089D         ws ("FOLOWER");
	__POINTW1MN _0x201C2,11
	CALL SUBOPT_0xE
; 0001 089E         LEDL=1;LEDR=1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 089F 
; 0001 08A0         //doc lan dau tien  de khoi dong gia tri iminlast;
; 0001 08A1         readline();
	CALL SUBOPT_0x3C
; 0001 08A2         admin = IRLINE[0];imin=0;
; 0001 08A3         for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
_0x201C8:
	__CPWRN 16,17,5
	BRGE _0x201C9
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x3D
	BRSH _0x201CA
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2E
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x201CA:
	__ADDWRN 16,17,1
	RJMP _0x201C8
_0x201C9:
; 0001 08A4         iminlast=imin;
	__PUTWSR 20,21,6
; 0001 08A5         admin = 1024;
	LDI  R30,LOW(1024)
	LDI  R31,HIGH(1024)
	STD  Y+35,R30
	STD  Y+35+1,R31
; 0001 08A6         admax = 0;
	STD  Y+30,R30
	STD  Y+30+1,R30
; 0001 08A7    //calib
; 0001 08A8    while(keyKT!=0)
_0x201CB:
	SBIS 0x13,0
	RJMP _0x201CD
; 0001 08A9    {
; 0001 08AA       //doc gia tri cam bien
; 0001 08AB       readline();
	RCALL _readline
; 0001 08AC 
; 0001 08AD       for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
	__GETWRN 16,17,1
_0x201CF:
	__CPWRN 16,17,5
	BRGE _0x201D0
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x3D
	BRSH _0x201D1
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2E
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x201D1:
	__ADDWRN 16,17,1
	RJMP _0x201CF
_0x201D0:
; 0001 08AE       //hc(3,10);wn16s(admin);
; 0001 08AF       hc(3,10);wn16s(admin);
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3E
; 0001 08B0 
; 0001 08B1       for(i=1;i<5;i++){if(admax<IRLINE[i]){admax=IRLINE[i];imax=i;}}
	__GETWRN 16,17,1
_0x201D3:
	__CPWRN 16,17,5
	BRGE _0x201D4
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2E
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x201D5
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2E
	STD  Y+30,R30
	STD  Y+30+1,R31
	__PUTBSR 16,34
_0x201D5:
	__ADDWRN 16,17,1
	RJMP _0x201D3
_0x201D4:
; 0001 08B2       hc(4,10);wn16s(admax);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x3B
	LDD  R30,Y+30
	LDD  R31,Y+30+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _wn16s
; 0001 08B3    }
	RJMP _0x201CB
_0x201CD:
; 0001 08B4    //test gia tri doc line
; 0001 08B5    online=0;
	LDI  R30,LOW(0)
	__CLRD1S 45
; 0001 08B6    while(1)
_0x201D6:
; 0001 08B7    {
; 0001 08B8       //doc gia tri cam bien
; 0001 08B9       readline();
	RCALL _readline
; 0001 08BA       for(i=0;i<5;i++)
	__GETWRN 16,17,0
_0x201DA:
	__CPWRN 16,17,5
	BRLT PC+3
	JMP _0x201DB
; 0001 08BB       {
; 0001 08BC          value=IRLINE[i];
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2E
	CLR  R22
	CLR  R23
	__PUTD1S 49
; 0001 08BD          if(value<280) online=1;
	__GETD2S 49
	__CPD2N 0x118
	BRGE _0x201DC
	__GETD1N 0x1
	__PUTD1S 45
; 0001 08BE          avrg = avrg+i*1000*value;
_0x201DC:
	MOVW R30,R16
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12
	MOVW R26,R30
	__GETD1S 49
	CALL __CWD2
	CALL __MULD12
	__GETD2S 41
	CALL __ADDD12
	__PUTD1S 41
; 0001 08BF          sum = sum+value;
	__GETD1S 49
	__GETD2S 37
	CALL __ADDD12
	__PUTD1S 37
; 0001 08C0       }
	__ADDWRN 16,17,1
	RJMP _0x201DA
_0x201DB:
; 0001 08C1       //hc(1,10);wn16s(online);
; 0001 08C2       if(online==1)
	__GETD2S 45
	__CPD2N 0x1
	BRNE _0x201DD
; 0001 08C3       {
; 0001 08C4          valueline=(int)(avrg/ sum);
	__GETD1S 37
	__GETD2S 41
	CALL __DIVD21
	CLR  R22
	CLR  R23
	CALL __CWD1
	__PUTD1S 53
; 0001 08C5         // hc(2,10);wn16s(valueline);
; 0001 08C6          online=0;
	LDI  R30,LOW(0)
	__CLRD1S 45
; 0001 08C7          avrg=0;
	__CLRD1S 41
; 0001 08C8          sum=0;
	__CLRD1S 37
; 0001 08C9       }else
	RJMP _0x201DE
_0x201DD:
; 0001 08CA       {
; 0001 08CB          if(lastvalueline>1935)
	__GETD2S 57
	__CPD2N 0x790
	BRLT _0x201DF
; 0001 08CC          valueline=2000;
	__GETD1N 0x7D0
	RJMP _0x202EC
; 0001 08CD          else
_0x201DF:
; 0001 08CE          valueline=1800;
	__GETD1N 0x708
_0x202EC:
	__PUTD1S 53
; 0001 08CF       }
_0x201DE:
; 0001 08D0       err = 1935-valueline;
	__GETD2S 53
	__GETD1N 0x78F
	CALL __SUBD12
	CALL __CDF1
	CALL SUBOPT_0x3F
; 0001 08D1       if(err>100) err=100;
	CALL SUBOPT_0x40
	__GETD1N 0x42C80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x201E1
	CALL SUBOPT_0x3F
; 0001 08D2       if(err<-100) err=-100;
_0x201E1:
	CALL SUBOPT_0x40
	__GETD1N 0xC2C80000
	CALL __CMPF12
	BRSH _0x201E2
	CALL SUBOPT_0x3F
; 0001 08D3       sumi=sumi+ err/35;
_0x201E2:
	CALL SUBOPT_0x40
	__GETD1N 0x420C0000
	CALL SUBOPT_0x41
	CALL SUBOPT_0x42
; 0001 08D4       if(sumi>6) sumi=6;
	__GETD2S 16
	__GETD1N 0x40C00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x201E3
	CALL SUBOPT_0x42
; 0001 08D5       if(sumi<-6) sumi=-6;
_0x201E3:
	__GETD2S 16
	__GETD1N 0xC0C00000
	CALL __CMPF12
	BRSH _0x201E4
	CALL SUBOPT_0x42
; 0001 08D6       udk = err/7 + sumi+(err-lasterr)/30;
_0x201E4:
	CALL SUBOPT_0x40
	__GETD1N 0x40E00000
	CALL SUBOPT_0x41
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x43
	__GETD1S 12
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41F00000
	CALL __DIVF21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	CALL SUBOPT_0x44
; 0001 08D7       if(udk>10) {udk=9;sumi=0;}
	CALL SUBOPT_0x45
	CALL SUBOPT_0x1E
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x201E5
	__GETD1N 0x41100000
	CALL SUBOPT_0x46
; 0001 08D8       if(udk<-10){ udk=-9;sumi=0;}
_0x201E5:
	CALL SUBOPT_0x45
	__GETD1N 0xC1200000
	CALL __CMPF12
	BRSH _0x201E6
	__GETD1N 0xC1100000
	CALL SUBOPT_0x46
; 0001 08D9       //hc(5,10);wn16s(udk);
; 0001 08DA       vMLtoi(10+udk); vMRtoi(10-udk) ;
_0x201E6:
	__GETD1S 20
	__GETD2N 0x41200000
	CALL __ADDF12
	CALL __CFD1U
	ST   -Y,R30
	RCALL _vMLtoi
	CALL SUBOPT_0x45
	CALL SUBOPT_0x1E
	CALL __SUBF12
	CALL __CFD1U
	ST   -Y,R30
	RCALL _vMRtoi
; 0001 08DB 
; 0001 08DC       lastvalueline=valueline;
	__GETD1S 53
	__PUTD1S 57
; 0001 08DD       lasterr=err;
	__GETD1S 12
	__PUTD1S 8
; 0001 08DE    }
	RJMP _0x201D6
; 0001 08DF 
; 0001 08E0    while(keyKT!=0)
_0x201E7:
	SBIS 0x13,0
	RJMP _0x201E9
; 0001 08E1    {
; 0001 08E2        //doc gia tri cam bien
; 0001 08E3         readline();
	CALL SUBOPT_0x3C
; 0001 08E4         admin = IRLINE[0];imin=0;
; 0001 08E5         for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
_0x201EB:
	__CPWRN 16,17,5
	BRGE _0x201EC
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x3D
	BRSH _0x201ED
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2E
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x201ED:
	__ADDWRN 16,17,1
	RJMP _0x201EB
_0x201EC:
; 0001 08E6         hc(2,10);wn16s(iminlast);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x28
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x21
; 0001 08E7         hc(3,10);wn16s(imin);
	CALL SUBOPT_0x28
	ST   -Y,R21
	ST   -Y,R20
	CALL SUBOPT_0x20
; 0001 08E8         hc(4,10);wn16s(admin);
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3E
; 0001 08E9 
; 0001 08EA         if((imin-iminlast > 1)||(imin-iminlast <-1))  //tranh truong hop nhay bo trang thai
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	MOVW R30,R20
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	SBIW R30,2
	BRGE _0x201EF
	MOVW R30,R26
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRGE _0x201EE
_0x201EF:
; 0001 08EB         {
; 0001 08EC         }
; 0001 08ED         else
	RJMP _0x201F1
_0x201EE:
; 0001 08EE         {
; 0001 08EF              switch(imin)
	MOVW R30,R20
; 0001 08F0             {
; 0001 08F1               case 0:
	SBIW R30,0
	BRNE _0x201F5
; 0001 08F2                   vMLtoi(1); vMRtoi(15) ;
	CALL SUBOPT_0x33
	CALL SUBOPT_0x35
; 0001 08F3                   //flagblindT = 0;
; 0001 08F4                   flagblindP = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+24,R30
	STD  Y+24+1,R31
; 0001 08F5                 break;
	RJMP _0x201F4
; 0001 08F6               case 1:
_0x201F5:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x201F6
; 0001 08F7                   vMLtoi(2); vMRtoi(8) ;
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _vMLtoi
	LDI  R30,LOW(8)
	ST   -Y,R30
	RCALL _vMRtoi
; 0001 08F8                 break;
	RJMP _0x201F4
; 0001 08F9               case 2:
_0x201F6:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x201F7
; 0001 08FA                   vMLtoi(10);vMRtoi(10) ;
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _vMLtoi
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _vMRtoi
; 0001 08FB                 break;
	RJMP _0x201F4
; 0001 08FC               case 3:
_0x201F7:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x201F8
; 0001 08FD                  vMLtoi(8); vMRtoi(2) ;
	LDI  R30,LOW(8)
	CALL SUBOPT_0x47
; 0001 08FE                 break;
	RJMP _0x201F4
; 0001 08FF               case 4:
_0x201F8:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x201FA
; 0001 0900                   vMLtoi(15);vMRtoi(1)  ;
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
; 0001 0901                   flagblindT = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+26,R30
	STD  Y+26+1,R31
; 0001 0902                   //flagblindP = 0;
; 0001 0903                 break;
; 0001 0904               default:
_0x201FA:
; 0001 0905                  // vMLtoi(5); vMRtoi(5) ;
; 0001 0906                 break;
; 0001 0907             }
_0x201F4:
; 0001 0908 
; 0001 0909               iminlast=imin;
	__PUTWSR 20,21,6
; 0001 090A          }
_0x201F1:
; 0001 090B 
; 0001 090C 
; 0001 090D             while(flagblindT == 1 && keyKT!=0) //lac duong ben trai
_0x201FB:
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	SBIW R26,1
	BRNE _0x201FE
	CALL SUBOPT_0x39
	BRNE _0x201FF
_0x201FE:
	RJMP _0x201FD
_0x201FF:
; 0001 090E             {
; 0001 090F                vMLtoi(20);vMRtoi(2)  ;
	LDI  R30,LOW(20)
	CALL SUBOPT_0x47
; 0001 0910                readline();
	CALL SUBOPT_0x3C
; 0001 0911                admin = IRLINE[0];imin=0;
; 0001 0912                for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
_0x20201:
	__CPWRN 16,17,5
	BRGE _0x20202
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x3D
	BRSH _0x20203
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2E
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x20203:
	__ADDWRN 16,17,1
	RJMP _0x20201
_0x20202:
; 0001 0913                iminlast=imin;
	__PUTWSR 20,21,6
; 0001 0914                if(IRLINE[2]<310)  flagblindT=0;
	CALL SUBOPT_0x2D
	CPI  R26,LOW(0x136)
	LDI  R30,HIGH(0x136)
	CPC  R27,R30
	BRSH _0x20204
	LDI  R30,LOW(0)
	STD  Y+26,R30
	STD  Y+26+1,R30
; 0001 0915 
; 0001 0916             }
_0x20204:
	RJMP _0x201FB
_0x201FD:
; 0001 0917             while(flagblindP ==1 && keyKT!=0) //lac duong ben phai
_0x20205:
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	SBIW R26,1
	BRNE _0x20208
	CALL SUBOPT_0x39
	BRNE _0x20209
_0x20208:
	RJMP _0x20207
_0x20209:
; 0001 0918             {
; 0001 0919                vMLtoi(2);vMRtoi(20)  ;
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _vMLtoi
	CALL SUBOPT_0x34
; 0001 091A                readline();
	CALL SUBOPT_0x3C
; 0001 091B                admin = IRLINE[0];imin=0;
; 0001 091C                for(i=1;i<5;i++){if(admin>IRLINE[i]){admin=IRLINE[i];imin=i;}}
_0x2020B:
	__CPWRN 16,17,5
	BRGE _0x2020C
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x3D
	BRSH _0x2020D
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2E
	STD  Y+35,R30
	STD  Y+35+1,R31
	MOVW R20,R16
_0x2020D:
	__ADDWRN 16,17,1
	RJMP _0x2020B
_0x2020C:
; 0001 091D                iminlast=imin;
	__PUTWSR 20,21,6
; 0001 091E                if(IRLINE[2]<310)  flagblindP=0;
	CALL SUBOPT_0x2D
	CPI  R26,LOW(0x136)
	LDI  R30,HIGH(0x136)
	CPC  R27,R30
	BRSH _0x2020E
	LDI  R30,LOW(0)
	STD  Y+24,R30
	STD  Y+24+1,R30
; 0001 091F 
; 0001 0920             }
_0x2020E:
	RJMP _0x20205
_0x20207:
; 0001 0921 
; 0001 0922 
; 0001 0923        demled++;
	LDD  R30,Y+28
	LDD  R31,Y+28+1
	ADIW R30,1
	STD  Y+28,R30
	STD  Y+28+1,R31
; 0001 0924        if(demled>30){demled=0;LEDLtoggle();LEDRtoggle(); }
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	SBIW R26,31
	BRLO _0x2020F
	LDI  R30,LOW(0)
	STD  Y+28,R30
	STD  Y+28+1,R30
	CALL SUBOPT_0x2B
; 0001 0925    }
_0x2020F:
	RJMP _0x201E7
_0x201E9:
; 0001 0926 }
	CALL __LOADLOCR6
	ADIW R28,61
	RET

	.DSEG
_0x201C2:
	.BYTE 0x13
;//========================================================
;void bluetooth()
; 0001 0929 {  unsigned char kytu;

	.CSEG
_bluetooth:
; 0001 092A    unsigned int demled;
; 0001 092B 
; 0001 092C         LcdClear();
	CALL __SAVELOCR4
;	kytu -> R17
;	demled -> R18,R19
	CALL SUBOPT_0x48
; 0001 092D         hc(0,10);
	CALL SUBOPT_0x28
; 0001 092E         ws ("BLUETOOTH");
	__POINTW1MN _0x20210,0
	CALL SUBOPT_0xE
; 0001 092F         hc(1,25);
	CALL SUBOPT_0x25
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	CALL SUBOPT_0x49
; 0001 0930         ws ("DRIVE");
	__POINTW1MN _0x20210,10
	CALL SUBOPT_0xE
; 0001 0931 
; 0001 0932         LEDL=1;LEDR=1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 0933 
; 0001 0934    while(keyKT!=0)
_0x20215:
	SBIS 0x13,0
	RJMP _0x20217
; 0001 0935    {
; 0001 0936         LEDL=1; LEDR=1;
	CALL SUBOPT_0x4A
; 0001 0937         delay_ms(100);
; 0001 0938         LEDL=0; LEDR=0;
; 0001 0939         delay_ms(100);
; 0001 093A 
; 0001 093B       if (rx_counter)
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x20220
; 0001 093C       {
; 0001 093D        //LcdClear();
; 0001 093E        hc(2,42);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x29
; 0001 093F        kytu = getchar();
	CALL _getchar
	MOV  R17,R30
; 0001 0940        LcdCharacter(kytu);
	ST   -Y,R17
	CALL _LcdCharacter
; 0001 0941        //putchar(getchar());
; 0001 0942        if(kytu=='S'){vMLtoi(0);vMRtoi(0);}
	CPI  R17,83
	BRNE _0x20221
	LDI  R30,LOW(0)
	CALL SUBOPT_0x4B
; 0001 0943        if(kytu=='F'){vMLtoi(100);vMRtoi(100);}
_0x20221:
	CPI  R17,70
	BRNE _0x20222
	LDI  R30,LOW(100)
	CALL SUBOPT_0x4C
; 0001 0944        if(kytu=='B'){vMLlui(100);vMRlui(100);}
_0x20222:
	CPI  R17,66
	BRNE _0x20223
	LDI  R30,LOW(100)
	ST   -Y,R30
	RCALL _vMLlui
	LDI  R30,LOW(100)
	ST   -Y,R30
	RCALL _vMRlui
; 0001 0945        if(kytu=='R'){vMLtoi(100);vMRtoi(0);}
_0x20223:
	CPI  R17,82
	BRNE _0x20224
	LDI  R30,LOW(100)
	CALL SUBOPT_0x4B
; 0001 0946        if(kytu=='L'){vMLtoi(0);vMRtoi(100);}
_0x20224:
	CPI  R17,76
	BRNE _0x20225
	LDI  R30,LOW(0)
	CALL SUBOPT_0x4C
; 0001 0947 
; 0001 0948        demled++;
_0x20225:
	__ADDWRN 18,19,1
; 0001 0949        if(demled>1000){demled=0;LEDLtoggle(); LEDRtoggle();}
	__CPWRN 18,19,1001
	BRLO _0x20226
	__GETWRN 18,19,0
	CALL SUBOPT_0x2B
; 0001 094A       }
_0x20226:
; 0001 094B     }
_0x20220:
	RJMP _0x20215
_0x20217:
; 0001 094C }
	CALL __LOADLOCR4
	JMP  _0x20C0002

	.DSEG
_0x20210:
	.BYTE 0x10
;//========================================================
;
;//Chuong trinh test robot
;   void testmotor()
; 0001 0951    {

	.CSEG
_testmotor:
; 0001 0952         LcdClear();
	CALL SUBOPT_0x48
; 0001 0953         hc(0,10);
	CALL SUBOPT_0x28
; 0001 0954         ws ("TEST MOTOR");
	__POINTW1MN _0x20227,0
	CALL SUBOPT_0xE
; 0001 0955 
; 0001 0956         vMRtoi(20);
	CALL SUBOPT_0x34
; 0001 0957         vMLtoi(20);
	LDI  R30,LOW(20)
	ST   -Y,R30
	RCALL _vMLtoi
; 0001 0958       while(keyKT!=0)
_0x20228:
	SBIS 0x13,0
	RJMP _0x2022A
; 0001 0959       {
; 0001 095A         hc(2,0);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x7
	CALL _hc
; 0001 095B         ws ("MotorL");
	__POINTW1MN _0x20227,11
	CALL SUBOPT_0xE
; 0001 095C         hc(2,45);
	CALL SUBOPT_0x24
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	CALL SUBOPT_0x49
; 0001 095D         wn16(QEL);
	CALL SUBOPT_0x17
	CALL SUBOPT_0xD
; 0001 095E         hc(3,0);
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x7
	CALL _hc
; 0001 095F         ws ("MotorR");
	__POINTW1MN _0x20227,18
	CALL SUBOPT_0xE
; 0001 0960         hc(3,45);
	CALL SUBOPT_0x4D
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	CALL SUBOPT_0x49
; 0001 0961         wn16(QER);
	CALL SUBOPT_0x16
	CALL SUBOPT_0xD
; 0001 0962         delay_ms(10);
	CALL SUBOPT_0x4E
; 0001 0963       }
	RJMP _0x20228
_0x2022A:
; 0001 0964 
; 0001 0965        vMRstop();
	RCALL _vMRstop
; 0001 0966        vMLstop();
	RCALL _vMLstop
; 0001 0967    }
	RET

	.DSEG
_0x20227:
	.BYTE 0x19
; //========================================================
; // UART TEST
;   void testuart()
; 0001 096B    {

	.CSEG
_testuart:
; 0001 096C           if (rx_counter)
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x2022B
; 0001 096D           {
; 0001 096E           LcdClear();
	CALL SUBOPT_0x48
; 0001 096F            hc(0,10);
	CALL SUBOPT_0x28
; 0001 0970            ws ("TEST UART");
	__POINTW1MN _0x2022C,0
	CALL SUBOPT_0xE
; 0001 0971            putchar(getchar());
	CALL _getchar
	ST   -Y,R30
	CALL _putchar
; 0001 0972           }
; 0001 0973 
; 0001 0974    }
_0x2022B:
	RET

	.DSEG
_0x2022C:
	.BYTE 0xA
;   //========================================================
; // UART TEST
;   void testrf()
; 0001 0978    {

	.CSEG
_testrf:
; 0001 0979 
; 0001 097A 
; 0001 097B    }
	RET
;
;//========================================================
;   void testir()
; 0001 097F    {    unsigned int AD[8];
_testir:
; 0001 0980 
; 0001 0981         DDRA    = 0x00;
	SBIW R28,16
;	AD -> Y+0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0001 0982         PORTA   = 0x00;
	OUT  0x1B,R30
; 0001 0983 
; 0001 0984         clear();
	CALL _clear
; 0001 0985         hc(0,10);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x28
; 0001 0986         ws ("TEST IR");
	__POINTW1MN _0x2022D,0
	CALL SUBOPT_0xE
; 0001 0987 
; 0001 0988         while(keyKT!=0)
_0x2022E:
	SBIS 0x13,0
	RJMP _0x20230
; 0001 0989         {
; 0001 098A 
; 0001 098B         AD[0]=read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _read_adc
	ST   Y,R30
	STD  Y+1,R31
; 0001 098C         AD[1]=read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0001 098D         AD[2]=read_adc(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0001 098E         AD[3]=read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 098F         AD[4]=read_adc(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 0990         AD[5]=read_adc(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0001 0991         AD[6]=read_adc(6);
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0001 0992         AD[7]=read_adc(7);
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL _read_adc
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0001 0993 
; 0001 0994         hc(1,0) ;ws("0.");wn164(AD[0]);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x7
	CALL _hc
	__POINTW1MN _0x2022D,8
	CALL SUBOPT_0xE
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x4F
; 0001 0995         hc(1,43);ws("1.");wn164(AD[1]);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x50
	__POINTW1MN _0x2022D,11
	CALL SUBOPT_0xE
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x4F
; 0001 0996         hc(2,0) ;ws("2.");wn164(AD[2]);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x7
	CALL _hc
	__POINTW1MN _0x2022D,14
	CALL SUBOPT_0xE
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL SUBOPT_0x4F
; 0001 0997         hc(2,43);ws("3.");wn164(AD[3]);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x50
	__POINTW1MN _0x2022D,17
	CALL SUBOPT_0xE
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x4F
; 0001 0998         hc(3,0) ;ws("4.");wn164(AD[4]);
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x7
	CALL _hc
	__POINTW1MN _0x2022D,20
	CALL SUBOPT_0xE
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL SUBOPT_0x4F
; 0001 0999         hc(3,43);ws("5.");wn164(AD[5]);
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x50
	__POINTW1MN _0x2022D,23
	CALL SUBOPT_0xE
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL SUBOPT_0x4F
; 0001 099A         hc(4,0) ;ws("6.");wn164(AD[6]);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x7
	CALL _hc
	__POINTW1MN _0x2022D,26
	CALL SUBOPT_0xE
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0x4F
; 0001 099B         hc(4,43);ws("7.");wn164(AD[7]);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x50
	__POINTW1MN _0x2022D,29
	CALL SUBOPT_0xE
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CALL SUBOPT_0x4F
; 0001 099C 
; 0001 099D         delay_ms(1000);
	CALL SUBOPT_0xB
; 0001 099E         }
	RJMP _0x2022E
_0x20230:
; 0001 099F 
; 0001 09A0    }
	ADIW R28,16
	RET

	.DSEG
_0x2022D:
	.BYTE 0x20
;
;//========================================================
; void outlcd1()
; 0001 09A4  {

	.CSEG
_outlcd1:
; 0001 09A5      LcdClear();
	CALL SUBOPT_0x48
; 0001 09A6      hc(0,5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x49
; 0001 09A7      ws("<SELF TEST>");
	__POINTW1MN _0x20231,0
	CALL SUBOPT_0xE
; 0001 09A8      hc(1,0);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x7
	CALL _hc
; 0001 09A9      ws("************");
	__POINTW1MN _0x20231,12
	CALL SUBOPT_0xE
; 0001 09AA  }
	RET

	.DSEG
_0x20231:
	.BYTE 0x19
;//========================================================
;void chopledtheoid()
; 0001 09AD {    unsigned char i;

	.CSEG
_chopledtheoid:
; 0001 09AE         DDRA=0xFF;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0001 09AF 
; 0001 09B0          switch (id)
	CALL SUBOPT_0x51
; 0001 09B1             {
; 0001 09B2                 case 1:
	BRNE _0x20235
; 0001 09B3                     LEDR=1;
	SBI  0x15,5
; 0001 09B4                     LEDL=1;PORTA.4=1;delay_ms(10);
	SBI  0x15,4
	SBI  0x1B,4
	CALL SUBOPT_0x4E
; 0001 09B5                     LEDL=0;PORTA.4=0;delay_ms(30);
	CBI  0x15,4
	RJMP _0x202ED
; 0001 09B6                 break;
; 0001 09B7                 case 2:
_0x20235:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20240
; 0001 09B8                     LEDR=1;
	SBI  0x15,5
; 0001 09B9                     LEDL=1;PORTA.6=1;delay_ms(10);
	SBI  0x15,4
	SBI  0x1B,6
	CALL SUBOPT_0x4E
; 0001 09BA                     LEDL=0;PORTA.6=0;delay_ms(30);
	CBI  0x15,4
	CBI  0x1B,6
	RJMP _0x202EE
; 0001 09BB                 break;
; 0001 09BC                 case 3:
_0x20240:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2024B
; 0001 09BD                     LEDR=1;
	SBI  0x15,5
; 0001 09BE                     LEDL=1;PORTA.7=1;delay_ms(10);
	SBI  0x15,4
	SBI  0x1B,7
	CALL SUBOPT_0x4E
; 0001 09BF                     LEDL=0;PORTA.7=0;delay_ms(30);
	CBI  0x15,4
	CBI  0x1B,7
	RJMP _0x202EE
; 0001 09C0                 break;
; 0001 09C1                 case 4:
_0x2024B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20256
; 0001 09C2                     LEDR=1;
	SBI  0x15,5
; 0001 09C3                     LEDL=1;PORTA.5=1;delay_ms(10);
	SBI  0x15,4
	SBI  0x1B,5
	CALL SUBOPT_0x4E
; 0001 09C4                     LEDL=0;PORTA.5=0;delay_ms(30);
	CBI  0x15,4
	CBI  0x1B,5
	RJMP _0x202EE
; 0001 09C5                 break;
; 0001 09C6                 case 5:
_0x20256:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x20261
; 0001 09C7                     LEDL=1;
	SBI  0x15,4
; 0001 09C8                     LEDR=1;PORTA.4=1;delay_ms(10);
	SBI  0x15,5
	SBI  0x1B,4
	CALL SUBOPT_0x4E
; 0001 09C9                     LEDR=0;PORTA.4=0;delay_ms(30);
	RJMP _0x202EF
; 0001 09CA                 break;
; 0001 09CB                 case 6:
_0x20261:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2026C
; 0001 09CC                     LEDL=1;
	SBI  0x15,4
; 0001 09CD                     LEDR=1;PORTA.6=1;delay_ms(10);
	SBI  0x15,5
	SBI  0x1B,6
	CALL SUBOPT_0x4E
; 0001 09CE                     LEDR=0;PORTA.6=0;delay_ms(30);
	CBI  0x15,5
	CBI  0x1B,6
	RJMP _0x202EE
; 0001 09CF                 break;
; 0001 09D0                 case 7:
_0x2026C:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x20277
; 0001 09D1                     LEDL=1;
	SBI  0x15,4
; 0001 09D2                     LEDR=1;PORTA.7=1;delay_ms(10);
	SBI  0x15,5
	SBI  0x1B,7
	CALL SUBOPT_0x4E
; 0001 09D3                     LEDR=0;PORTA.7=0;delay_ms(30);
	CBI  0x15,5
	CBI  0x1B,7
	RJMP _0x202EE
; 0001 09D4                 break;
; 0001 09D5                 case 8:
_0x20277:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x20282
; 0001 09D6                     LEDL=1;
	SBI  0x15,4
; 0001 09D7                     LEDR=1;PORTA.5=1;delay_ms(10);
	SBI  0x15,5
	SBI  0x1B,5
	CALL SUBOPT_0x4E
; 0001 09D8                     LEDR=0;PORTA.5=0;delay_ms(30);
	CBI  0x15,5
	CBI  0x1B,5
	RJMP _0x202EE
; 0001 09D9                 break;
; 0001 09DA                 case 9:
_0x20282:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x20234
; 0001 09DB                     LEDL=1;LEDR=1;PORTA.4=1;delay_ms(10);
	SBI  0x15,4
	SBI  0x15,5
	SBI  0x1B,4
	CALL SUBOPT_0x4E
; 0001 09DC                     LEDL=0;LEDR=0;PORTA.4=0;delay_ms(30);
	CBI  0x15,4
_0x202EF:
	CBI  0x15,5
_0x202ED:
	CBI  0x1B,4
_0x202EE:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x52
; 0001 09DD                 break;
; 0001 09DE             };
_0x20234:
; 0001 09DF         //LEDL=1;delay_ms(100);
; 0001 09E0         //LEDL=0;delay_ms(100);
; 0001 09E1         //for(i=0;i<id;i++)
; 0001 09E2         //{
; 0001 09E3         //    LEDR=1;delay_ms(150);
; 0001 09E4         //    LEDR=0;delay_ms(150);
; 0001 09E5         //}
; 0001 09E6 }
	LD   R17,Y+
	RET
;//========================================================
;//========================================================
;void testRCservo()
; 0001 09EA {
_testRCservo:
; 0001 09EB         clear();
	CALL _clear
; 0001 09EC         hc(0,10);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x28
; 0001 09ED         ws ("RC SERVO");
	__POINTW1MN _0x2029A,0
	CALL SUBOPT_0xE
; 0001 09EE // Timer/Counter 0 initialization
; 0001 09EF // Clock source: System Clock
; 0001 09F0 // Clock value: 7.813 kHz
; 0001 09F1 // Mode: Phase correct PWM top=0xFF
; 0001 09F2 // OC0 output: Non-Inverted PWM
; 0001 09F3 TCCR0=0x65;     //15.32Hz
	LDI  R30,LOW(101)
	CALL SUBOPT_0x53
; 0001 09F4 TCNT0=0x00;
; 0001 09F5 OCR0=0x00;
; 0001 09F6 
; 0001 09F7 // Timer/Counter 2 initialization
; 0001 09F8 // Clock source: System Clock
; 0001 09F9 // Clock value: 7.813 kHz
; 0001 09FA // Mode: Phase correct PWM top=0xFF
; 0001 09FB // OC2 output: Non-Inverted PWM
; 0001 09FC ASSR=0x00;      //15.32Hz
; 0001 09FD TCCR2=0x67;
	LDI  R30,LOW(103)
	OUT  0x25,R30
; 0001 09FE TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0001 09FF OCR2=0x00;
	OUT  0x23,R30
; 0001 0A00 
; 0001 0A01   while(keyKT!=0)
_0x2029B:
	SBIS 0x13,0
	RJMP _0x2029D
; 0001 0A02    {
; 0001 0A03    LEDL=1;LEDR=1;//PORTB.3=1;
	SBI  0x15,4
	SBI  0x15,5
; 0001 0A04    OCR0=2; OCR2=2;
	LDI  R30,LOW(2)
	OUT  0x3C,R30
	OUT  0x23,R30
; 0001 0A05    delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x52
; 0001 0A06 
; 0001 0A07    LEDL=0;LEDR=0;//PORTB.3=1;
	CBI  0x15,4
	CBI  0x15,5
; 0001 0A08    OCR0=10; OCR2=10;
	LDI  R30,LOW(10)
	OUT  0x3C,R30
	OUT  0x23,R30
; 0001 0A09    delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x52
; 0001 0A0A    }
	RJMP _0x2029B
_0x2029D:
; 0001 0A0B // Timer/Counter 0 initialization
; 0001 0A0C // Clock source: System Clock
; 0001 0A0D // Clock value: Timer 0 Stopped
; 0001 0A0E // Mode: Normal top=0xFF
; 0001 0A0F // OC0 output: Disconnected
; 0001 0A10 TCCR0=0x00;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x53
; 0001 0A11 TCNT0=0x00;
; 0001 0A12 OCR0=0x00;
; 0001 0A13 
; 0001 0A14 // Timer/Counter 2 initialization
; 0001 0A15 // Clock source: System Clock
; 0001 0A16 // Clock value: Timer2 Stopped
; 0001 0A17 // Mode: Normal top=0xFF
; 0001 0A18 // OC2 output: Disconnected
; 0001 0A19 ASSR =0x00;
; 0001 0A1A TCCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0001 0A1B TCNT2=0x00;
	OUT  0x24,R30
; 0001 0A1C OCR2 =0x00;
	OUT  0x23,R30
; 0001 0A1D 
; 0001 0A1E }
	RET

	.DSEG
_0x2029A:
	.BYTE 0x9
;
;void selftest()
; 0001 0A21 {

	.CSEG
_selftest:
; 0001 0A22     outlcd1();
	CALL SUBOPT_0x54
; 0001 0A23     hc(2,0);
	CALL SUBOPT_0x7
	CALL _hc
; 0001 0A24     ws ("1.ROBOT WALL");delay_ms(200);
	__POINTW1MN _0x202A6,0
	CALL SUBOPT_0xE
	CALL SUBOPT_0x26
; 0001 0A25      while(flagselftest==1)
_0x202A7:
	LDS  R26,_flagselftest
	LDS  R27,_flagselftest+1
	SBIW R26,1
	BREQ PC+3
	JMP _0x202A9
; 0001 0A26      {
; 0001 0A27         //------------------------------------------------------------------------
; 0001 0A28         //test menu kiem tra  robot
; 0001 0A29          chopledtheoid();
	RCALL _chopledtheoid
; 0001 0A2A           if(keyKT==0)
	SBIC 0x13,0
	RJMP _0x202AA
; 0001 0A2B             {
; 0001 0A2C                 id++;
	LDS  R30,_id
	SUBI R30,-LOW(1)
	STS  _id,R30
; 0001 0A2D                 if(id>11){id=1;}
	LDS  R26,_id
	CPI  R26,LOW(0xC)
	BRLO _0x202AB
	LDI  R30,LOW(1)
	STS  _id,R30
; 0001 0A2E                 switch (id)
_0x202AB:
	CALL SUBOPT_0x51
; 0001 0A2F                 {
; 0001 0A30 
; 0001 0A31                 case 1:
	BRNE _0x202AF
; 0001 0A32                     outlcd1();
	CALL SUBOPT_0x54
; 0001 0A33                     hc(2,0);
	CALL SUBOPT_0x7
	CALL _hc
; 0001 0A34                     ws ("1.ROBOT WALL");delay_ms(200);
	__POINTW1MN _0x202A6,13
	RJMP _0x202F0
; 0001 0A35                 break;
; 0001 0A36                 case 2:
_0x202AF:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x202B0
; 0001 0A37                     outlcd1();
	CALL SUBOPT_0x54
; 0001 0A38                     hc(2,0);
	CALL SUBOPT_0x7
	CALL _hc
; 0001 0A39                     ws ("2.BLUETOOTH ");delay_ms(200);
	__POINTW1MN _0x202A6,26
	RJMP _0x202F0
; 0001 0A3A                 break;
; 0001 0A3B                 case 3:
_0x202B0:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x202B1
; 0001 0A3C                     outlcd1();
	CALL SUBOPT_0x54
; 0001 0A3D                     hc(2,0);
	CALL SUBOPT_0x7
	CALL _hc
; 0001 0A3E                     ws ("3.WHITE LINE");delay_ms(200);
	__POINTW1MN _0x202A6,39
	RJMP _0x202F0
; 0001 0A3F                 break;
; 0001 0A40                 case 4:
_0x202B1:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x202B2
; 0001 0A41                     outlcd1();
	CALL SUBOPT_0x54
; 0001 0A42                     hc(2,0);
	CALL SUBOPT_0x7
	CALL _hc
; 0001 0A43                     ws ("4.BLACK LINE");delay_ms(200);
	__POINTW1MN _0x202A6,52
	RJMP _0x202F0
; 0001 0A44                 break;
; 0001 0A45                 case 5:
_0x202B2:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x202B3
; 0001 0A46                     outlcd1();
	CALL SUBOPT_0x54
; 0001 0A47                     hc(2,0);
	CALL SUBOPT_0x7
	CALL _hc
; 0001 0A48                     ws ("5.TEST MOTOR");delay_ms(200);
	__POINTW1MN _0x202A6,65
	RJMP _0x202F0
; 0001 0A49                 break;
; 0001 0A4A                 case 6:
_0x202B3:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x202B4
; 0001 0A4B                     outlcd1();
	CALL SUBOPT_0x54
; 0001 0A4C                     hc(2,0);
	CALL SUBOPT_0x7
	CALL _hc
; 0001 0A4D                     ws ("6.TEST IR   ");delay_ms(200);
	__POINTW1MN _0x202A6,78
	RJMP _0x202F0
; 0001 0A4E                 break;
; 0001 0A4F                 case 7:
_0x202B4:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x202B5
; 0001 0A50                     outlcd1();
	CALL SUBOPT_0x54
; 0001 0A51                     hc(2,0);
	CALL SUBOPT_0x7
	CALL _hc
; 0001 0A52                     ws ("7.TEST RF   ");delay_ms(200);
	__POINTW1MN _0x202A6,91
	RJMP _0x202F0
; 0001 0A53                 break;
; 0001 0A54                 case 8:
_0x202B5:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x202B6
; 0001 0A55                     outlcd1();
	CALL SUBOPT_0x54
; 0001 0A56                     hc(2,0);
	CALL SUBOPT_0x7
	CALL _hc
; 0001 0A57                     ws ("8.TEST UART ");delay_ms(200);
	__POINTW1MN _0x202A6,104
	RJMP _0x202F0
; 0001 0A58                 break;
; 0001 0A59                 case 9:
_0x202B6:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x202B7
; 0001 0A5A                     outlcd1();
	CALL SUBOPT_0x54
; 0001 0A5B                     hc(2,0);
	CALL SUBOPT_0x7
	CALL _hc
; 0001 0A5C                     ws ("9.RC SERVO ");delay_ms(200);
	__POINTW1MN _0x202A6,117
	RJMP _0x202F0
; 0001 0A5D                 break;
; 0001 0A5E                 case 10:
_0x202B7:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x202AE
; 0001 0A5F                     outlcd1();
	CALL SUBOPT_0x54
; 0001 0A60                     hc(2,0);
	CALL SUBOPT_0x7
	CALL _hc
; 0001 0A61                     ws ("10.UPDATE RB");delay_ms(200);
	__POINTW1MN _0x202A6,129
_0x202F0:
	ST   -Y,R31
	ST   -Y,R30
	CALL _ws
	CALL SUBOPT_0x26
; 0001 0A62                 break;
; 0001 0A63                 };
_0x202AE:
; 0001 0A64             }
; 0001 0A65          if(keyKP==0)
_0x202AA:
	SBIC 0x13,1
	RJMP _0x202B9
; 0001 0A66             {
; 0001 0A67                 switch (id)
	CALL SUBOPT_0x51
; 0001 0A68                 {
; 0001 0A69                 case 1:
	BRNE _0x202BD
; 0001 0A6A                     robotwall() ;
	RCALL _robotwall
; 0001 0A6B                 break;
	RJMP _0x202BC
; 0001 0A6C                 case 2:
_0x202BD:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x202BE
; 0001 0A6D                     bluetooth() ;
	RCALL _bluetooth
; 0001 0A6E                 break;
	RJMP _0x202BC
; 0001 0A6F                 case 3:
_0x202BE:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x202BF
; 0001 0A70                     robotwhiteline() ;
	RCALL _robotwhiteline
; 0001 0A71                 break;
	RJMP _0x202BC
; 0001 0A72                 case 4:
_0x202BF:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x202C0
; 0001 0A73                     robotblackline() ;
	RCALL _robotblackline
; 0001 0A74                 break;
	RJMP _0x202BC
; 0001 0A75                 case 5:
_0x202C0:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x202C1
; 0001 0A76                     testmotor() ;
	RCALL _testmotor
; 0001 0A77                 break;
	RJMP _0x202BC
; 0001 0A78                 case 6:
_0x202C1:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x202C2
; 0001 0A79                     testir()    ;
	RCALL _testir
; 0001 0A7A                 break;
	RJMP _0x202BC
; 0001 0A7B                 case 7:
_0x202C2:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x202C3
; 0001 0A7C                     testrf()    ;
	RCALL _testrf
; 0001 0A7D                 break;
	RJMP _0x202BC
; 0001 0A7E                 case 8:
_0x202C3:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x202C4
; 0001 0A7F                     testuart()  ;
	RCALL _testuart
; 0001 0A80                 break;
	RJMP _0x202BC
; 0001 0A81                 case 9:
_0x202C4:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x202C5
; 0001 0A82                     testRCservo()  ;
	RCALL _testRCservo
; 0001 0A83                 break;
	RJMP _0x202BC
; 0001 0A84                 case 10:
_0x202C5:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x202BC
; 0001 0A85                     testposition() ;
	CALL _testposition
; 0001 0A86                 break;
; 0001 0A87 
; 0001 0A88                 };
_0x202BC:
; 0001 0A89 
; 0001 0A8A             }
; 0001 0A8B 
; 0001 0A8C 
; 0001 0A8D      }//end while(1)
_0x202B9:
	RJMP _0x202A7
_0x202A9:
; 0001 0A8E }
	RET

	.DSEG
_0x202A6:
	.BYTE 0x8E
;//========================================================
;//          HAM MAIN
;//========================================================
;void main(void)
; 0001 0A93 {

	.CSEG
_main:
; 0001 0A94   //  unsigned char flagreadrb;
; 0001 0A95     unsigned int adctest;
; 0001 0A96     unsigned char i;
; 0001 0A97     float pidl,pidr,pl,il,pr,ir,ur,ul;
; 0001 0A98 
; 0001 0A99     //------------- khai  bao chuc nang in out cua cac port
; 0001 0A9A     DDRA    = 0xFF;
	SBIW R28,32
;	adctest -> R16,R17
;	i -> R19
;	pidl -> Y+28
;	pidr -> Y+24
;	pl -> Y+20
;	il -> Y+16
;	pr -> Y+12
;	ir -> Y+8
;	ur -> Y+4
;	ul -> Y+0
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0001 0A9B     DDRB    = 0b10111111;
	LDI  R30,LOW(191)
	OUT  0x17,R30
; 0001 0A9C     DDRC    = 0b11111100;
	LDI  R30,LOW(252)
	OUT  0x14,R30
; 0001 0A9D     DDRD    = 0b11110010;
	LDI  R30,LOW(242)
	OUT  0x11,R30
; 0001 0A9E 
; 0001 0A9F     //------------- khai  bao chuc nang cua adc
; 0001 0AA0     // ADC initialization
; 0001 0AA1     // ADC Clock frequency: 1000.000 kHz
; 0001 0AA2     // ADC Voltage Reference: AVCC pin
; 0001 0AA3     ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0001 0AA4     ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0001 0AA5     //---------------------------------------------------------------------
; 0001 0AA6     //------------- khai  bao chuc nang cua bo timer dung lam PWM cho 2 dong co
; 0001 0AA7     // Timer/Counter 1 initialization
; 0001 0AA8     // Clock source: System Clock
; 0001 0AA9     // Clock value: 1000.000 kHz   //PWM 2KHz
; 0001 0AAA     // Mode: Ph. correct PWM top=0x00FF
; 0001 0AAB     // OC1A output: Non-Inv.
; 0001 0AAC     // OC1B output: Non-Inv.
; 0001 0AAD     // Noise Canceler: Off
; 0001 0AAE     // Input Capture on Falling Edge
; 0001 0AAF     // Timer1 Overflow Interrupt: On  // voi period =1/2khz= 0.5ms
; 0001 0AB0     // Input Capture Interrupt: Off
; 0001 0AB1     // Compare A Match Interrupt: Off
; 0001 0AB2     // Compare B Match Interrupt: Off
; 0001 0AB3     TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0001 0AB4     TCCR1B=0x02;
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0001 0AB5     TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0001 0AB6     TCNT1L=0x00;
	OUT  0x2C,R30
; 0001 0AB7     ICR1H=0x00;
	OUT  0x27,R30
; 0001 0AB8     ICR1L=0x00;
	OUT  0x26,R30
; 0001 0AB9     OCR1AH=0x00;
	OUT  0x2B,R30
; 0001 0ABA     OCR1AL=0x00;
	OUT  0x2A,R30
; 0001 0ABB     OCR1BH=0x00;
	OUT  0x29,R30
; 0001 0ABC     OCR1BL=0x00;
	OUT  0x28,R30
; 0001 0ABD     // Timer(s)/Counter(s) Interrupt(s) initialization  timer0
; 0001 0ABE     TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0001 0ABF 
; 0001 0AC0     //OCR1A=0-255; MOTOR LEFT
; 0001 0AC1     //OCR1B=0-255; MOTOR RIGHT
; 0001 0AC2     for(i=0;i<1;i++)
	LDI  R19,LOW(0)
_0x202C8:
	CPI  R19,1
	BRSH _0x202C9
; 0001 0AC3     {
; 0001 0AC4         LEDL=1; LEDR=1;
	CALL SUBOPT_0x4A
; 0001 0AC5         delay_ms(100);
; 0001 0AC6         LEDL=0; LEDR=0;
; 0001 0AC7         delay_ms(100);
; 0001 0AC8     }
	SUBI R19,-1
	RJMP _0x202C8
_0x202C9:
; 0001 0AC9 
; 0001 0ACA     //khai  bao su dung cua glcd
; 0001 0ACB     SPIinit();
	CALL _SPIinit
; 0001 0ACC     LCDinit();
	CALL _LCDinit
; 0001 0ACD 
; 0001 0ACE     // khai  bao su dung rf dung de cap nhat gia tri vi tri cua robot
; 0001 0ACF     init_NRF24L01();
	CALL _init_NRF24L01
; 0001 0AD0     SetRX_Mode();  // chon kenh tan so phat, va dia chi phat trong file nRF14l01.c
	CALL _SetRX_Mode
; 0001 0AD1     // khai bao su dung encoder
; 0001 0AD2     initencoder(); //lay 2 canh len  xuong
	CALL _initencoder
; 0001 0AD3     // khai bao su dung uart
; 0001 0AD4     inituart();
	CALL _inituart
; 0001 0AD5     #asm("sei")
	sei
; 0001 0AD6 
; 0001 0AD7     //man hinh khoi dong robokit
; 0001 0AD8     hc(0,10);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x28
; 0001 0AD9     ws("<AKBOTKIT>");
	__POINTW1MN _0x202D2,0
	CALL SUBOPT_0xE
; 0001 0ADA     hc(1,0);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x7
	CALL _hc
; 0001 0ADB     ws("************");
	__POINTW1MN _0x202D2,11
	CALL SUBOPT_0xE
; 0001 0ADC 
; 0001 0ADD     //robotwhiteline();
; 0001 0ADE     //robotblackline();
; 0001 0ADF     //kiem tra neu nhan va giu nut trai se vao chuong trinh selftest (kiem tra hoat dong cua robot)
; 0001 0AE0     while (keyKT==0)
_0x202D3:
	SBIC 0x13,0
	RJMP _0x202D5
; 0001 0AE1     {
; 0001 0AE2       cntselftest++;
	LDI  R26,LOW(_cntselftest)
	LDI  R27,HIGH(_cntselftest)
	CALL SUBOPT_0x14
; 0001 0AE3       if(cntselftest>10)
	LDS  R26,_cntselftest
	LDS  R27,_cntselftest+1
	SBIW R26,11
	BRLO _0x202D6
; 0001 0AE4       {
; 0001 0AE5            while (keyKT==0);//CHO NHA NUT AN
_0x202D7:
	SBIS 0x13,0
	RJMP _0x202D7
; 0001 0AE6            cntselftest=0;
	LDI  R30,LOW(0)
	STS  _cntselftest,R30
	STS  _cntselftest+1,R30
; 0001 0AE7            flagselftest=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _flagselftest,R30
	STS  _flagselftest+1,R31
; 0001 0AE8            selftest();
	RCALL _selftest
; 0001 0AE9       }
; 0001 0AEA       delay_ms(100);
_0x202D6:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x52
; 0001 0AEB     }
	RJMP _0x202D3
_0x202D5:
; 0001 0AEC     hc(2,0);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x7
	CALL _hc
; 0001 0AED      ws("Dinh Mahone");
	__POINTW1MN _0x202D2,24
	CALL SUBOPT_0xE
; 0001 0AEE //
; 0001 0AEF //    // vao chuong trinh chinh sau khi bo qua phan selftest
; 0001 0AF0 //    hc(2,0);
; 0001 0AF1 //    ws("MAIN PROGRAM");
; 0001 0AF2 //    settoadoHomRB();
; 0001 0AF3 //    // code you here
; 0001 0AF4 //    while (1)
; 0001 0AF5 //    {
; 0001 0AF6 //     //LEDR=!LEDR;
; 0001 0AF7 //     //PHUC
; 0001 0AF8 //////     //=========================================================   PHUC ID
; 0001 0AF9 ////         chay theo banh co dinh huong tan cong
; 0001 0AFA //        readposition();
; 0001 0AFB //        calcvitri(0,0);    // de xac dinh huong tan cong
; 0001 0AFC //
; 0001 0AFD //        //flagtancong=1;
; 0001 0AFE ////        if(flagtancong==1)
; 0001 0AFF ////        {
; 0001 0B00 ////            flagtask=2;
; 0001 0B01 ////            rb_wait(50);
; 0001 0B02 ////
; 0001 0B03 ////        }else
; 0001 0B04 ////        {
; 0001 0B05 ////            if(offsetphongthu<0)    offsetphongthu=-offsetphongthu;//lay do lon
; 0001 0B06 ////            if(robotctrl.ball.y <= 0)
; 0001 0B07 ////            {
; 0001 0B08 ////                setRobotX = robotctrl.ball.x;
; 0001 0B09 ////                setRobotY = robotctrl.ball.y + offsetphongthu;
; 0001 0B0A ////
; 0001 0B0B ////                flagtask=0;
; 0001 0B0C ////                rb_wait(200);
; 0001 0B0D ////
; 0001 0B0E ////            }else
; 0001 0B0F ////            {
; 0001 0B10 ////                setRobotX = robotctrl.ball.x;
; 0001 0B11 ////                setRobotY = robotctrl.ball.y - offsetphongthu;
; 0001 0B12 ////
; 0001 0B13 ////                flagtask=0;
; 0001 0B14 ////                rb_wait(200);
; 0001 0B15 ////
; 0001 0B16 ////            }
; 0001 0B17 ////
; 0001 0B18 ////             setRobotX = robotctrl.ball.x+offsetphongthu;
; 0001 0B19 ////             setRobotY = robotctrl.ball.y;
; 0001 0B1A ////             rb_wait(200);
; 0001 0B1B ////             rb_goball();
; 0001 0B1C ////             rb_wait(200);
; 0001 0B1D ////
; 0001 0B1E ////
; 0001 0B1F ////        }
; 0001 0B20 //        ctrrobot();// can phai luon luon chay de dieu khien robot
; 0001 0B21 //////        hc(5,40);wn16s(orentation);
; 0001 0B22 //////        hc(4,40);wn16s(flagtancong);
; 0001 0B23 ////     //=========================================================   PHUC ID
; 0001 0B24 ////    //XEP HANG THEO TOA DO CHO TRUOC
; 0001 0B25 ////        ctrrobot();// can phai luon luon chay de dieu khien robot
; 0001 0B26 ////       //rb_move(245,3.3);  //4
; 0001 0B27 ////        rb_move(114,91);  //6
; 0001 0B28 ////       // rb_move(122.6,-80.4);  //5
; 0001 0B29 ////       //rb_move(-102,-58.5);  //3
; 0001 0B2A ////       // rb_move(-112,108.5);  //2
; 0001 0B2B ////       // rb_move(-181,16);  //1
; 0001 0B2C ////       rb_wait(500000);
; 0001 0B2D ////       rb_rotate(180);
; 0001 0B2E ////       rb_wait(500000);
; 0001 0B2F ////       while(1);
; 0001 0B30 //
; 0001 0B31 ////    //==========================================================
; 0001 0B32 ////    //=========================================================
; 0001 0B33 ////    //CHAY THEO BONG
; 0001 0B34 ////       ctrrobot();// can phai luon luon chay de dieu khien robot
; 0001 0B35 ////       rb_goball();
; 0001 0B36 //    //==========================================================
; 0001 0B37 //
; 0001 0B38 ////      rb_wait(50000);
; 0001 0B39 ////      rb_rotate(0);
; 0001 0B3A ////      rb_wait(50000);
; 0001 0B3B ////      rb_kick();
; 0001 0B3C ////      rb_wait(50000);
; 0001 0B3D ////    ==========================================================
; 0001 0B3E ////     KIEM TRA HUONG
; 0001 0B3F ////    readposition();
; 0001 0B40 ////    calcvitri(0,0);
; 0001 0B41 ////    hc(3,0);wn16s(cmdCtrlRobot);
; 0001 0B42 ////    hc(5,40);wn16s(orentation);
; 0001 0B43 ////    hc(4,40);wn16s(flagtancong);
; 0001 0B44 ////    ctrrobot();// can phai luon luon chay de dieu khien robot
; 0001 0B45 //     } //end while(1)
; 0001 0B46 }
	ADIW R28,32
_0x202DA:
	RJMP _0x202DA

	.DSEG
_0x202D2:
	.BYTE 0x24
;
;
;

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_spi:
	LD   R30,Y
	OUT  0xF,R30
_0x2020003:
	SBIS 0xE,7
	RJMP _0x2020003
	IN   R30,0xF
	ADIW R28,1
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL SUBOPT_0x55
	CALL SUBOPT_0x56
    brne __floor1
__floor0:
	CALL SUBOPT_0x55
	RJMP _0x20C0002
__floor1:
    brtc __floor0
	CALL SUBOPT_0x57
	CALL __SUBF12
	RJMP _0x20C0002
_ceil:
	CALL SUBOPT_0x55
	CALL SUBOPT_0x56
    brne __ceil1
__ceil0:
	CALL SUBOPT_0x55
	RJMP _0x20C0002
__ceil1:
    brts __ceil0
	CALL SUBOPT_0x57
	CALL __ADDF12
_0x20C0002:
	ADIW R28,4
	RET
_fmod:
	SBIW R28,4
	__GETD1S 4
	CALL __CPD10
	BRNE _0x2060005
	__GETD1N 0x0
	RJMP _0x20C0001
_0x2060005:
	__GETD1S 4
	CALL SUBOPT_0x43
	CALL __DIVF21
	CALL __PUTD1S0
	CALL SUBOPT_0x55
	CALL __CPD10
	BRNE _0x2060006
	__GETD1N 0x0
	RJMP _0x20C0001
_0x2060006:
	CALL __GETD2S0
	CALL __CPD02
	BRGE _0x2060007
	CALL SUBOPT_0x55
	CALL __PUTPARD1
	RCALL _floor
	RJMP _0x2060033
_0x2060007:
	CALL SUBOPT_0x55
	CALL __PUTPARD1
	RCALL _ceil
_0x2060033:
	CALL __PUTD1S0
	CALL SUBOPT_0x55
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x43
	CALL __SWAPD12
	CALL __SUBF12
_0x20C0001:
	ADIW R28,12
	RET

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_TX_ADDRESS:
	.BYTE 0x5
_RX_ADDRESS:
	.BYTE 0x5
_rb:
	.BYTE 0x1C
_robot11:
	.BYTE 0x1C
_robot12:
	.BYTE 0x1C
_robot13:
	.BYTE 0x1C
_robot21:
	.BYTE 0x1C
_robot22:
	.BYTE 0x1C
_robot23:
	.BYTE 0x1C
_robotctrl:
	.BYTE 0x1C
_errangle:
	.BYTE 0x4
_distance:
	.BYTE 0x4
_orentation:
	.BYTE 0x4
_RxBuf:
	.BYTE 0x20
_setRobotX:
	.BYTE 0x4
_setRobotY:
	.BYTE 0x4
_setRobotXmin:
	.BYTE 0x4
_setRobotXmax:
	.BYTE 0x4
_setRobotAngleX:
	.BYTE 0x4
_setRobotAngleY:
	.BYTE 0x4
_offestsanco:
	.BYTE 0x4
_rbctrlHomeX:
	.BYTE 0x4
_rbctrlHomeY:
	.BYTE 0x4
_rbctrlPenaltyX:
	.BYTE 0x4
_rbctrlPenaltyY:
	.BYTE 0x4
_rbctrlPenaltyAngle:
	.BYTE 0x4
_rbctrlHomeAngle:
	.BYTE 0x4
_cntsethomeRB:
	.BYTE 0x2
_cntstuckRB:
	.BYTE 0x2
_cntunlookRB:
	.BYTE 0x2
_flagsethome:
	.BYTE 0x2
_flagselftest:
	.BYTE 0x2
_cntselftest:
	.BYTE 0x2
_id:
	.BYTE 0x1
_IRFL:
	.BYTE 0x2
_IRFR:
	.BYTE 0x2
_IRLINE:
	.BYTE 0xA
_timerstick:
	.BYTE 0x2
_timerstickdis:
	.BYTE 0x2
_timerstickang:
	.BYTE 0x2
_timerstickctr:
	.BYTE 0x2
_vQEL:
	.BYTE 0x2
_vQER:
	.BYTE 0x2
_oldQEL:
	.BYTE 0x2
_oldQER:
	.BYTE 0x2
_svQEL:
	.BYTE 0x2
_svQER:
	.BYTE 0x2
_seRki_G001:
	.BYTE 0x2
_seLki_G001:
	.BYTE 0x2
_uL:
	.BYTE 0x2
_uR:
	.BYTE 0x2
_KpR:
	.BYTE 0x2
_KiR:
	.BYTE 0x2
_KpL:
	.BYTE 0x2
_KiL:
	.BYTE 0x2
_sd:
	.BYTE 0x2
_oldd:
	.BYTE 0x2
_flagwaitctrRobot:
	.BYTE 0x1
_sa:
	.BYTE 0x2
_olda:
	.BYTE 0x2
_flagwaitctrAngle:
	.BYTE 0x1
_flagtask:
	.BYTE 0x2
_flagtaskold:
	.BYTE 0x2
_flaghuongtrue:
	.BYTE 0x2
_verranglekisum:
	.BYTE 0x2
_QEL:
	.BYTE 0x2
_QER:
	.BYTE 0x2
_rx_buffer:
	.BYTE 0x8
_rx_wr_index:
	.BYTE 0x1
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
_tx_buffer:
	.BYTE 0x8
_tx_wr_index:
	.BYTE 0x1
_tx_rd_index:
	.BYTE 0x1
_tx_counter:
	.BYTE 0x1
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _SPI_Write_Buf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	CALL _SPI_RW
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2:
	ST   -Y,R30
	CALL _LcdWrite
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _LcdWrite
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R30,Y+3
	LDI  R31,0
	SBIW R30,32
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	CALL __MULW12U
	SUBI R30,LOW(-_ASCII*2)
	SBCI R31,HIGH(-_ASCII*2)
	ADD  R30,R16
	ADC  R31,R17
	LPM  R30,Z
	ST   -Y,R30
	JMP  _LcdWrite

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _LcdWrite

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x9:
	MOVW R26,R28
	ADIW R26,1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	SUBI R30,-LOW(48)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	SUB  R30,R26
	SBC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wn16

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xE:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _ws

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(0)
	STS  _seRki_G001,R30
	STS  _seRki_G001+1,R30
	STS  _seLki_G001,R30
	STS  _seLki_G001+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LD   R30,Y
	LDI  R31,0
	STS  _svQEL,R30
	STS  _svQEL+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x14:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDS  R30,_QER
	LDS  R31,_QER+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x17:
	LDS  R30,_QEL
	LDS  R31,_QEL+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	LDS  R26,_seRki_G001
	LDS  R27,_seRki_G001+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	STS  _seRki_G001,R30
	STS  _seRki_G001+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDS  R26,_seLki_G001
	LDS  R27,_seLki_G001+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	STS  _seLki_G001,R30
	STS  _seLki_G001+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	RCALL SUBOPT_0x17
	LDS  R26,_QER
	LDS  R27,_QER+1
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R26
	LSR  R31
	ROR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDS  R30,_rb
	LDS  R31,_rb+1
	LDS  R22,_rb+2
	LDS  R23,_rb+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	CALL _wn16s
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	CALL _wn16s
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
	CALL __CFD1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wn16s

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	OUT  0x1B,R30
	CALL _LcdClear
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2A:
	ST   -Y,R30
	CALL _vMRlui
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	CALL _LEDLtoggle
	JMP  _LEDRtoggle

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x2C:
	MOVW R30,R16
	LDI  R26,LOW(_IRLINE)
	LDI  R27,HIGH(_IRLINE)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	__GETW2MN _IRLINE,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x2E:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2F:
	CALL _readline
	__GETWRMN 20,21,0,_IRLINE
	LDI  R16,LOW(0)
	LDI  R17,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x30:
	MOV  R30,R17
	LDI  R26,LOW(_IRLINE)
	LDI  R27,HIGH(_IRLINE)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x31:
	ADD  R26,R30
	ADC  R27,R31
	LD   R20,X+
	LD   R21,X
	MOV  R16,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _vMLtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(20)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(15)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(15)
	ST   -Y,R30
	JMP  _vMLtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _vMLtoi
	RJMP SUBOPT_0x37

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x3C:
	CALL _readline
	LDS  R30,_IRLINE
	LDS  R31,_IRLINE+1
	STD  Y+35,R30
	STD  Y+35+1,R31
	__GETWRN 20,21,0
	__GETWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3D:
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wn16s

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	CALL __DIVF21
	__GETD2S 16
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	__PUTD1S 20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	__GETD2S 20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x46:
	RCALL SUBOPT_0x44
	LDI  R30,LOW(0)
	__CLRD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x47:
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x48:
	CALL _LcdClear
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x49:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _hc

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4A:
	SBI  0x15,4
	SBI  0x15,5
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CBI  0x15,4
	CBI  0x15,5
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4B:
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4C:
	ST   -Y,R30
	CALL _vMLtoi
	LDI  R30,LOW(100)
	ST   -Y,R30
	JMP  _vMRtoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x4E:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4F:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wn164

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	RJMP SUBOPT_0x49

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x51:
	LDS  R30,_id
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x52:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x53:
	OUT  0x33,R30
	LDI  R30,LOW(0)
	OUT  0x32,R30
	OUT  0x3C,R30
	OUT  0x22,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x54:
	CALL _outlcd1
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x55:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x56:
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	RCALL SUBOPT_0x55
	__GETD2N 0x3F800000
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__LTW12U:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRLO __LTW12UT
	CLR  R30
__LTW12UT:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__COPYMML:
	CLR  R25
__COPYMM:
	PUSH R30
	PUSH R31
__COPYMM0:
	LD   R22,Z+
	ST   X+,R22
	SBIW R24,1
	BRNE __COPYMM0
	POP  R31
	POP  R30
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
