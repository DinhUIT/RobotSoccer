/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Evaluation
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 6/4/2015
Author  : Freeware, for evaluation and non-commercial use only
Company :
Comments:


Chip type               : ATmega32A
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/
#include <stdio.h>
#include <mega32a.h>
#include <delay.h>
#include <spi.h>
#include <nRF24L01/nRF24L01.h>


// PIN LED ROBO KIT
#define LEDL   PORTC.4
#define LEDR   PORTC.5

#define LEDFL   PORTA.4
#define LEDFR   PORTA.5
#define LEDBL   PORTA.6
#define LEDBR   PORTA.7

#define MLdir   PORTC.6
#define MRdir   PORTC.7
// PIN NOKIA 5110
#define RST    PORTB.0
#define SCE    PORTB.1
#define DC     PORTB.2

#define DIN    PORTB.5
#define SCK    PORTB.7


#define LCD_C     0
#define LCD_D     1

#define LCD_X     84
#define LCD_Y     48

#define Black 1
#define White 0
#define Filled 1
#define NotFilled 0

//===========================================bien cho vi tri robot
/*    Kieu So Nguyen Co Dau    */
typedef   signed          char int8_t;
typedef   signed 	      int int16_t;
typedef   signed long     int int32_t;

/*	Kieu So Nguyen Khong Dau */
typedef   unsigned         char uint8_t;
typedef   unsigned 	   int  uint16_t;
typedef   unsigned long    int  uint32_t;
/*	Kieu So Thuc */
typedef   float            float32_t;

// Declare your global variables here
typedef struct   {	    
	    float x;
		float y;	    
}Ball ;


typedef struct   {
	    float id;
	    float x;
		float y;
	    float ox;      
        float oy;
	    Ball ball;
}robot ;

robot rb,robot11,robot12,robot13,robot21,robot22,robot23;
unsigned char RxBuf[32];
//========================================= bien doc IR
    unsigned int IRFL=0;
    unsigned int IRFR=0;
    unsigned int IRBL=0;
    unsigned int IRLINE[5];
//========================================= bien doc ENCODER
 unsigned int QEL=0;
 unsigned int QER=0;
//========================================================
//========================================================

flash unsigned char ASCII[][5] = {
 {0x00, 0x00, 0x00, 0x00, 0x00} // 20
,{0x00, 0x00, 0x5f, 0x00, 0x00} // 21 !
,{0x00, 0x07, 0x00, 0x07, 0x00} // 22 "
,{0x14, 0x7f, 0x14, 0x7f, 0x14} // 23 #
,{0x24, 0x2a, 0x7f, 0x2a, 0x12} // 24 $
,{0x23, 0x13, 0x08, 0x64, 0x62} // 25 %
,{0x36, 0x49, 0x55, 0x22, 0x50} // 26 &
,{0x00, 0x05, 0x03, 0x00, 0x00} // 27 '
,{0x00, 0x1c, 0x22, 0x41, 0x00} // 28 (
,{0x00, 0x41, 0x22, 0x1c, 0x00} // 29 )
,{0x14, 0x08, 0x3e, 0x08, 0x14} // 2a *
,{0x08, 0x08, 0x3e, 0x08, 0x08} // 2b +
,{0x00, 0x50, 0x30, 0x00, 0x00} // 2c ,
,{0x08, 0x08, 0x08, 0x08, 0x08} // 2d -
,{0x00, 0x60, 0x60, 0x00, 0x00} // 2e .
,{0x20, 0x10, 0x08, 0x04, 0x02} // 2f /
,{0x3e, 0x51, 0x49, 0x45, 0x3e} // 30 0
,{0x00, 0x42, 0x7f, 0x40, 0x00} // 31 1
,{0x42, 0x61, 0x51, 0x49, 0x46} // 32 2
,{0x21, 0x41, 0x45, 0x4b, 0x31} // 33 3
,{0x18, 0x14, 0x12, 0x7f, 0x10} // 34 4
,{0x27, 0x45, 0x45, 0x45, 0x39} // 35 5
,{0x3c, 0x4a, 0x49, 0x49, 0x30} // 36 6
,{0x01, 0x71, 0x09, 0x05, 0x03} // 37 7
,{0x36, 0x49, 0x49, 0x49, 0x36} // 38 8
,{0x06, 0x49, 0x49, 0x29, 0x1e} // 39 9
,{0x00, 0x36, 0x36, 0x00, 0x00} // 3a :
,{0x00, 0x56, 0x36, 0x00, 0x00} // 3b ;
,{0x08, 0x14, 0x22, 0x41, 0x00} // 3c <
,{0x14, 0x14, 0x14, 0x14, 0x14} // 3d =
,{0x00, 0x41, 0x22, 0x14, 0x08} // 3e >
,{0x02, 0x01, 0x51, 0x09, 0x06} // 3f ?
,{0x32, 0x49, 0x79, 0x41, 0x3e} // 40 @
,{0x7e, 0x11, 0x11, 0x11, 0x7e} // 41 A
,{0x7f, 0x49, 0x49, 0x49, 0x36} // 42 B
,{0x3e, 0x41, 0x41, 0x41, 0x22} // 43 C
,{0x7f, 0x41, 0x41, 0x22, 0x1c} // 44 D
,{0x7f, 0x49, 0x49, 0x49, 0x41} // 45 E
,{0x7f, 0x09, 0x09, 0x09, 0x01} // 46 F
,{0x3e, 0x41, 0x49, 0x49, 0x7a} // 47 G
,{0x7f, 0x08, 0x08, 0x08, 0x7f} // 48 H
,{0x00, 0x41, 0x7f, 0x41, 0x00} // 49 I
,{0x20, 0x40, 0x41, 0x3f, 0x01} // 4a J
,{0x7f, 0x08, 0x14, 0x22, 0x41} // 4b K
,{0x7f, 0x40, 0x40, 0x40, 0x40} // 4c L
,{0x7f, 0x02, 0x0c, 0x02, 0x7f} // 4d M
,{0x7f, 0x04, 0x08, 0x10, 0x7f} // 4e N
,{0x3e, 0x41, 0x41, 0x41, 0x3e} // 4f O
,{0x7f, 0x09, 0x09, 0x09, 0x06} // 50 P
,{0x3e, 0x41, 0x51, 0x21, 0x5e} // 51 Q
,{0x7f, 0x09, 0x19, 0x29, 0x46} // 52 R
,{0x46, 0x49, 0x49, 0x49, 0x31} // 53 S
,{0x01, 0x01, 0x7f, 0x01, 0x01} // 54 T
,{0x3f, 0x40, 0x40, 0x40, 0x3f} // 55 U
,{0x1f, 0x20, 0x40, 0x20, 0x1f} // 56 V
,{0x3f, 0x40, 0x38, 0x40, 0x3f} // 57 W
,{0x63, 0x14, 0x08, 0x14, 0x63} // 58 X
,{0x07, 0x08, 0x70, 0x08, 0x07} // 59 Y
,{0x61, 0x51, 0x49, 0x45, 0x43} // 5a Z
,{0x00, 0x7f, 0x41, 0x41, 0x00} // 5b [
,{0x02, 0x04, 0x08, 0x10, 0x20} // 5c �
,{0x00, 0x41, 0x41, 0x7f, 0x00} // 5d ]
,{0x04, 0x02, 0x01, 0x02, 0x04} // 5e ^
,{0x40, 0x40, 0x40, 0x40, 0x40} // 5f _
,{0x00, 0x01, 0x02, 0x04, 0x00} // 60 `
,{0x20, 0x54, 0x54, 0x54, 0x78} // 61 a
,{0x7f, 0x48, 0x44, 0x44, 0x38} // 62 b
,{0x38, 0x44, 0x44, 0x44, 0x20} // 63 c
,{0x38, 0x44, 0x44, 0x48, 0x7f} // 64 d
,{0x38, 0x54, 0x54, 0x54, 0x18} // 65 e
,{0x08, 0x7e, 0x09, 0x01, 0x02} // 66 f
,{0x0c, 0x52, 0x52, 0x52, 0x3e} // 67 g
,{0x7f, 0x08, 0x04, 0x04, 0x78} // 68 h
,{0x00, 0x44, 0x7d, 0x40, 0x00} // 69 i
,{0x20, 0x40, 0x44, 0x3d, 0x00} // 6a j
,{0x7f, 0x10, 0x28, 0x44, 0x00} // 6b k
,{0x00, 0x41, 0x7f, 0x40, 0x00} // 6c l
,{0x7c, 0x04, 0x18, 0x04, 0x78} // 6d m
,{0x7c, 0x08, 0x04, 0x04, 0x78} // 6e n
,{0x38, 0x44, 0x44, 0x44, 0x38} // 6f o
,{0x7c, 0x14, 0x14, 0x14, 0x08} // 70 p
,{0x08, 0x14, 0x14, 0x18, 0x7c} // 71 q
,{0x7c, 0x08, 0x04, 0x04, 0x08} // 72 r
,{0x48, 0x54, 0x54, 0x54, 0x20} // 73 s
,{0x04, 0x3f, 0x44, 0x40, 0x20} // 74 t
,{0x3c, 0x40, 0x40, 0x20, 0x7c} // 75 u
,{0x1c, 0x20, 0x40, 0x20, 0x1c} // 76 v
,{0x3c, 0x40, 0x30, 0x40, 0x3c} // 77 w
,{0x44, 0x28, 0x10, 0x28, 0x44} // 78 x
,{0x0c, 0x50, 0x50, 0x50, 0x3c} // 79 y
,{0x44, 0x64, 0x54, 0x4c, 0x44} // 7a z
,{0x00, 0x08, 0x36, 0x41, 0x00} // 7b {
,{0x00, 0x00, 0x7f, 0x00, 0x00} // 7c |
,{0x00, 0x41, 0x36, 0x08, 0x00} // 7d }
,{0x10, 0x08, 0x08, 0x10, 0x08} // 7e ?
,{0x78, 0x46, 0x41, 0x46, 0x78} // 7f ?
};

//This is the SFE flame in bit form
char SFEFlame[] = {
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0xE0, 0xF0, 0xF8, 0xFC, 0xFC, 0xFE, 0xFE, 0xFE, 0xFE, 0x1E, 0x0E, 0x02, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x0F, 0x1F, 0x3F, 0x7F, 0xFF, 0xFF, 0xFF, 0xFF,
  0xFF, 0xFE, 0xFC, 0xF8, 0xF8, 0xF0, 0xF8, 0xFE, 0xFE, 0xFC, 0xF8, 0xE0, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0xF8, 0xFC, 0xFE, 0xFE, 0xFF, 0xFF, 0xF3, 0xE0, 0xE0, 0xC0, 0xC0, 0xC0, 0xE0, 0xE0,
  0xF1, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
  0x3E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
  0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F,
  0x3F, 0x1F, 0x07, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
  0xFF, 0x7F, 0x3F, 0x1F, 0x0F, 0x0F, 0x0F, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x03, 0x03,
  0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3F, 0x1F,
  0x0F, 0x07, 0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
};

//Another SparkFun logo
char SFEFlameBubble [] = {
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
  0xC0, 0xC0, 0xE0, 0xE0, 0xF0, 0xF8, 0xF8, 0xFC, 0xFC, 0xFC, 0xFC, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
  0xFE, 0xFE, 0xFE, 0xFE, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xF8, 0xF0, 0xE0, 0xE0, 0xC0, 0xC0, 0x80,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xE0,
  0xF8, 0xFC, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F, 0x3F, 0x3F, 0x3F,
  0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x3F, 0x3F, 0x3F, 0x7F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
  0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFC, 0xF8, 0xE0, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0xC0, 0xFC, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1F, 0x0F, 0x3F, 0x7F, 0x7F, 0x3F, 0x1E,
  0x0E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x01, 0x03, 0x0F, 0x3F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFC, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x01, 0x3F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFC, 0xF0, 0xE0,
  0xE0, 0xC0, 0xC0, 0xE0, 0xE0, 0xE0, 0xF0, 0xF8, 0x7C, 0x7C, 0x7E, 0x7C, 0x38, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x1F, 0x7F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
  0xFF, 0xFF, 0xFF, 0xF8, 0xE0, 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x07, 0x0F, 0x3F, 0x7F, 0xFF,
  0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xF8, 0xF0, 0xF0,
  0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0,
  0xE1, 0xE3, 0xE3, 0xE7, 0xEF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE, 0xFC, 0xF8, 0xF0, 0xE0,
  0xC0, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x01, 0x03, 0x07, 0x07, 0x0F, 0x1F, 0x1F, 0x1F, 0x3F, 0x3F, 0x3F, 0x3F,
  0x3F, 0x3F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F,
  0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F,
  0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7E, 0x7C, 0x78, 0x70, 0x60, 0x40, 0x40, 0x00,
  0x00,
};
//ham su dung cho lcd
//void digitalWrite()
//{
//
//}
//==================================
// truyen spi master
void spitx(unsigned char temtx)
{
// unsigned char transpi;
 SPDR = temtx;
// do
// {
//    transpi =SPSR;
//    transpi =transpi&0x80;
// }
// while(transpi!=0x00);
 while (!(SPSR & 0x80));
}

void LcdWrite(unsigned char dc, unsigned char data)
{
    DC = dc;
    SCE=1;
    SCE=0;
    spitx(data);
    SCE=1;
}
//This takes a large array of bits and sends them to the LCD
void LcdBitmap(char my_array[]){
  int index = 0;
  for (index = 0 ; index < (LCD_X * LCD_Y / 8) ; index++)
    LcdWrite(LCD_D, my_array[index]);
}

void hc(int x, int y) {  
  LcdWrite(0, 0x40 | x);  // Row.  ? 
  LcdWrite(0, 0x80 | y);  // Column.
}

void LcdCharacter(unsigned char character)
{
  int index = 0;
  LcdWrite(LCD_D, 0x00);
  for (index = 0; index < 5; index++)
  {
    LcdWrite(LCD_D, ASCII[character - 0x20][index]);
  }
  LcdWrite(LCD_D, 0x00);
}

void LcdString(unsigned char *characters)
{
  while (*characters)
  {
    LcdCharacter(*characters++);
  }
}

void LcdClear(void)
{
  int index=0;
  for (index = 0; index < LCD_X * LCD_Y / 8; index++)
  {
    LcdWrite(LCD_D, 0);
  }  
  hc(0, 0); //After we clear the display, return to the home position
}

void LcdInitialise()
{
  //reset
  RST=0;
  delay_us(10);
  RST=1;

  delay_ms(1000);
  //khoi dong
  LcdWrite(LCD_C, 0x21 );  //Tell LCD that extended commands follow
  LcdWrite(LCD_C, 0xBE );  //Set LCD Vop (Contrast): Try 0xB1(good @ 3.3V) or 0xBF if your display is too dark
  LcdWrite(LCD_C, 0x06 );  // Set Temp coefficent. //0x04
  LcdWrite(LCD_C, 0x13 );  //LCD bias mode 1:48: Try 0x13 or 0x14
  LcdWrite(LCD_C, 0x20 );  //We must send 0x20 before modifying the display control mode
  LcdWrite(LCD_C, 0x0C );  //Set display control, normal mode. 0x0D for inverse, 0x0C normal
}
//========================================================
//============================ Hien thi so 16 bits
void wn16(unsigned int so)
{
 unsigned char a[5],i;
 for(i=0;i<5;i++)
 {
 a[i]=so%10;        //a[0]= byte thap nhat
 so=so/10;
 }

  for(i=0;i<5;i++)
 {LcdCharacter(a[4-i]+0x30);}
}
//============================ Hien thi so 16 bits co dau
 void wn16s( int so)
{
 if(so<0){so=0-so; LcdCharacter('-');} else{ LcdCharacter(' ');}
 wn16(so);   
}
//============================ hien thi so 32bit co dau
 void wn32s( int so)
{
 char tmp[20];
 sprintf(tmp,"%d",so);
 LcdString(tmp);
}
//============================ hien thi so 32bit co dau
 void wnf( float so)
{
 char tmp[30];
 sprintf(tmp,"%0.2f",so);
 LcdString(tmp);
}

//============================ hien thi so 32bit co dau
 void wfmt(float so)
{
 char tmp[30];
 sprintf(tmp,"%0.2f",so);
 LcdString(tmp);
}
//========================================================
//========================================================
void SPIinit()
{
    SPCR |=1<<SPE | 1<<MSTR;                                         //if spi is used, uncomment this section out
    SPSR |=1<<SPI2X;
}
//========================================================
void LCDinit()
{
    LcdInitialise();
    LcdClear();
    LcdString(" <AKBOTKIT>");
}
//========================================================
#define ADC_VREF_TYPE 0x40
// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}
//========================================================
//========================================================
//===================================== TRUYEN THONG UART (bluetooth)
#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0)
      {
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
#endif
      rx_buffer_overflow=1;
      }
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
    if (tx_counter)
       {
       --tx_counter;
       UDR=tx_buffer[tx_rd_index++];
    #if TX_BUFFER_SIZE != 256
       if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
    #endif
       }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
    while (tx_counter == TX_BUFFER_SIZE);
    #asm("cli")
    if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
       {
       tx_buffer[tx_wr_index++]=c;
    #if TX_BUFFER_SIZE != 256
       if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
    #endif
       ++tx_counter;
       }
    else
       UDR=c;
    #asm("sei")
}
#pragma used-
#endif
void inituart()
{

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 38400
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x0C;
}
//=========================================== read encoder

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
     QEL++;

}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{

    QER++;
}
void initencoder()
{
    // External Interrupt(s) initialization
    // INT0: On
    // INT0 Mode: Falling Edge
    // INT1: On
    // INT1 Mode: Falling Edge
    // INT2: Off
    GICR|=0xC0;
    MCUCR=0x0A;
    MCUCSR=0x00;
    GIFR=0xC0;
    // Global enable interrupts
    
    //OCR1A=0-255; MOTOR LEFT
    //OCR1B=0-255; MOTOR RIGHT
}
//======================================== control motor
void MLtoi(unsigned char congsuat) //congsuat=0-100 (%)
{
    unsigned int k=255;
    k = k*congsuat/100;

    MLdir = 1;
    OCR1A = k;
}
//========================================================
void MLlui(unsigned char congsuat) //congsuat=0-100 (%)
{
    unsigned int k=255;
    k = k*congsuat/100;

    MLdir = 0;
    OCR1A = k;
}
//========================================================
void MLstop()
{
    MLdir = 1;
    OCR1A = 0;
}
//========================================================
//========================================================
void MRtoi(unsigned char congsuat) //congsuat=0-100 (%)
{
    unsigned int k=255;
    k = k*congsuat/100;

    MRdir = 1;
    OCR1B = k;
}
//========================================================
void MRlui(unsigned char congsuat) //congsuat=0-100 (%)
{
    unsigned int k=255;
    k = k*congsuat/100;

    MRdir = 0;
    OCR1B = k;
}
//========================================================
void MRstop()
{
    MRdir = 1;
    OCR1B = 0;
}
//========================================================
// update vi tri robot
//========================================================  
void updateRB() 
{
   unsigned char  i=0;
   if(nRF24L01_RxPacket(RxBuf)==1)         // Neu nhan duoc du lieu
     {
                     
        for( i=0;i<28;i++)
         {				 
             *(uint8_t *) ((uint8_t *)&rb + i)=RxBuf[i];
         }
             
         switch ((int)rb.id)
         {
              case 1: 
                  robot11=rb;
                  if(robot11.id==1) 
                  {
                   LEDR=!LEDR; 
                   hc(0,1);wnf(robot11.id);  
                   hc(0,30);wnf(robot11.x);   
                  }
                break;
              case 2: 
                  robot12=rb;
                  if(robot12.id==2) 
                  {
                   LEDR=!LEDR; 
                   hc(1,1);wnf(robot12.id);
                   hc(1,30);wnf(robot12.x);        
                  }
                break;
              case 3: 
                  robot13=rb;
                  if(robot13.id==3) 
                  {
                   LEDR=!LEDR; 
                   hc(2,1);wnf(robot13.id); 
                   hc(2,30);wnf(robot13.x);     
                  }
                break;
              case 4:
                  robot21=rb;
                  if(robot21.id==4) 
                  {
                   LEDR=!LEDR; 
                   hc(3,1);wnf(robot21.id); 
                   hc(3,30);wnf(robot21.x);     
                  }
                break;
              case 5:
                  robot22=rb;
                  if(robot22.id==5) 
                  {
                   LEDR=!LEDR; 
                   hc(4,1);wnf(robot22.id);
                   hc(4,30);wnf(robot22.x);      
                  }
                break;
              case 6:                     
                  robot23=rb;
                  if(robot23.id==6) 
                  {  
                      
                   LEDR=!LEDR; 
                   hc(5,1);wnf(robot23.id); 
                   hc(5,30);wnf(robot23.x);         
                  }
                break;
                   
         }	 
            
                     
     } 

}
void main(void)
{   
    unsigned int adctest;
    unsigned char i;    
    
    //------------- khai  bao chuc nang in out cua cac port
    DDRA    =0x00;
    PORTA   =0x00;
    DDRB    = 0b10111111;
    DDRC    = 0b11111100;
    DDRD    = 0b11110010;  
    
    
    //------------- khai  bao chuc nang cua adc
    // ADC initialization
    // ADC Clock frequency: 1000.000 kHz
    // ADC Voltage Reference: AVCC pin
    ADMUX=ADC_VREF_TYPE & 0xff;
    ADCSRA=0x83;
    
     //------------- khai  bao chuc nang cua bo timer dung lam PWM cho 2 dong co
    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 1000.000 kHz   //PWM 2KHz
    // Mode: Ph. correct PWM top=0x00FF
    // OC1A output: Non-Inv.
    // OC1B output: Non-Inv.
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer1 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A=0xA1;
    TCCR1B=0x02;
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;

    //OCR1A=0-255; MOTOR LEFT
    //OCR1B=0-255; MOTOR RIGHT
     for(i=0;i<2;i++)
    {
        LEDL=1; LEDR=1;
        delay_ms(100);
        LEDL=0; LEDR=0;
        delay_ms(100);
    }
    
    //------------- khai  bao su dung cua glcd
    SPIinit();
    LCDinit();

    MRtoi(100);
    MLtoi(100);
                   
    //------------- khai  bao su dung rf dung de cap nhat gia tri vi tri cua robot
    init_NRF24L01();      
    SetRX_Mode();  // chon kenh tan so phat, va dia chi phat trong file nRF14l01.c
    //------------ khai bao su dung encoder------------------
    initencoder(); //lay canh xuong  
    //------------  khai bao su dung uart
    inituart();
    #asm("sei")
    while (1)
    { 
       //-------------- lcd test -----------------------------
//       LcdClear();
//       LcdBitmap(SFEFlame);
//       delay_ms(1000); 
//       LcdClear();
//       LcdBitmap(SFEFlameBubble);
//       delay_ms(1000);

        //-------------- adc test ----------------------------- 
//       LcdClear();
//       adctest=read_adc(5);                          
//       hc(0,0);wn16(adctest);
//       hc(1,1);wn16(adctest);
//       hc(2,2);wn16(adctest);
//       delay_ms(1000);
       //-------------- rf test (vi tri robot) -----------------
      //   updateRB();  
//       //-------------- encoder test ---------------------------   
//         hc(5,0);
//         wn16(QEL);
//         hc(5,42);
//         wn16(QER);  
//       //-------------- IR TEST -----------------------------   
//        IRFL=read_adc(4);
//        IRFR=read_adc(5);
//        IRBL=read_adc(6);
//        IRLINE[0]=read_adc(0);
//        IRLINE[1]=read_adc(1);
//        IRLINE[2]=read_adc(2);
//        IRLINE[3]=read_adc(3);  
//        IRLINE[4]=read_adc(7); 
//        
//        hc(1,0); 
//        wn16(IRFL); 
//        hc(1,42); 
//        wn16(IRFR);
//        hc(2,0); 
//        wn16(IRBL);      
//        hc(3,0); 
//        wn16(IRLINE[0]); 
//        hc(3,42); 
//        wn16(IRLINE[1]);
//        hc(4,0); 
//        wn16(IRLINE[2]);
//        hc(4,42); 
//        wn16(IRLINE[3]);
//        hc(2,42); 
//        wn16(IRLINE[4]); 
       //-------------- UART TEST ----------------------------- 
          if (rx_counter)
          {
           LcdClear();
           hc(2,42); 
           LcdCharacter(getchar());
           //putchar(getchar());       
          }
    }
}




