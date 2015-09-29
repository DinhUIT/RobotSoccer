/*
* RobotSoccer.c
*
* Created: 18/09/2015 10:12:37 AM
*  Author: Dinh Mahone
*/


#include <avr/io.h>
#include <avr/interrupt.h>
#include "function.h"

#define cbi(port, bit) (port) &= ~(1 << (bit))
#define sbi(port, bit) (port) |=  (1 << (bit))

#define LED_L_ON sbi(PORTC,4)
#define LED_L_OFF cbi(PORTC,4)
#define LED_R_ON sbi(PORTC,5)
#define LED_R_OFF cbi(PORTC,5)
#define LED_L_BLINK if((PORTC>>4)&0x01) cbi(PORTC,4); else sbi(PORTC,4);



#define ROBOT_ID 4
#define SAN_ID   1  //CHON HUONG TAN CONG LA X >0;
#define 	M_PI   3.14159265358979323846	/* pi */
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

// This flag is set on USART Receiver buffer overflow
uint8_t rx_buffer_overflow;

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];
#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];
#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

//========================================= bien doc ENCODER
unsigned int QEL=0;
unsigned int QER=0;

//
//char getchar(void)
//{
	//char data;
	//while (rx_counter==0);
	//data=rx_buffer[rx_rd_index++];
	//#if RX_BUFFER_SIZE != 256
	//if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	//#endif
	//cli();
	//--rx_counter;
	//sei();
	//return data;
//}
//
//void putchar_(char c)
//{
	//while (tx_counter == TX_BUFFER_SIZE);
	//cli();
	//if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	//{
		//tx_buffer[tx_wr_index++]=c;
		//#if TX_BUFFER_SIZE != 256
		//if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
		//#endif
		//++tx_counter;
	//}
	//else
	//UDR=c;
	//sei();
//}


unsigned char RxBuf[32]; 
volatile unsigned int cmdCtrlRobot,idRobot;
robot rb,robotctrl;
unsigned char readposition()
{
	unsigned char  i=0;
	unsigned flagstatus=0;
	
	if(nRF24L01_RxPacket(RxBuf)==1)         // Neu nhan duoc du lieu
	{
		for( i=0;i<28;i++)
		{
			*(uint8_t *) ((uint8_t *)&rb + i)=RxBuf[i];
		}
		
		idRobot = fmod(rb.id,10); // doc id
		cmdCtrlRobot = (int)rb.id/10; // doc ma lenh
	}
	  if(idRobot==ROBOT_ID)
	  {
		 // LEDL=!LEDL;
		  cmdCtrlRobot = (int)rb.id/10; // doc ma lenh
		  flagstatus=1;
		  robotctrl=rb;
	  }
	return flagstatus;
}


float errangle=0, distance=0,orentation=0;
int flagtancong=1;
int offsetphongthu=0;
int goctancong=0;
float offestsanco=0;

void calcvitri(float x,float y)
{
	float ahx,ahy,aox,aoy,dah,dao,ahay,cosgoc,anpla0,anpla1,detaanpla;
	ahx = robotctrl.ox-robotctrl.x;
	ahy = robotctrl.oy-robotctrl.y;
	aox = x-robotctrl.x;
	aoy = y-robotctrl.y;
	dah = sqrt(ahx*ahx+ahy*ahy)  ;
	dao = sqrt(aox*aox+aoy*aoy)  ;
	ahay= ahx*aox+ahy*aoy;
	cosgoc = ahay/(dah*dao);
	
	anpla0 = atan2(ahy,ahx);
	anpla1 = atan2(aoy,aox);
	detaanpla= anpla0-anpla1;
	
	errangle = acos(cosgoc)*180/3.14;
	if(((detaanpla>0)&&(detaanpla <M_PI))|| (detaanpla <-M_PI))  // xet truong hop goc ben phai
	{
		errangle = - errangle; // ben phai
	}
	else
	{
		errangle = errangle;   // ben trai
		
	}
	distance = sqrt(aox*3.48*aox*3.48+aoy*2.89*aoy*2.89); //tinh khoang cach
	orentation = atan2(ahy,ahx)*180/M_PI + offestsanco;//tinh huong ra goc
	if(( 0 < orentation && orentation < 74) ||   ( 0 > orentation && orentation > -80) )
	{
		if(SAN_ID == 1)// phan san duong
		{
			flagtancong=0;
			offsetphongthu = 70 ;
			goctancong = 180;
		}
		else // phan san am
		{
			flagtancong=1;
			
		}
	}else
	{
		if(SAN_ID == 1)
		{
			flagtancong=1;
		}
		else
		{
			flagtancong=0;
			offsetphongthu = -70 ;
			goctancong = 0;
		}
	}
	
}

void ctrrobot()
{
    if(readposition()==1)//co du lieu moi
    { 
		if(cmdCtrlRobot ==8)
		{
			speed(100,100);
			LED_L_ON;
		}
		else
		{
			speed(0,0);
			LED_L_OFF;
		}
	}
}


int main(void)
{
	init_MCU();
	LED_R_ON;

	speed(0,0);
	while(1)
	{
		ctrrobot();
	}
}


ISR(USART_TXC_vect)
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
ISR(USART_RXC_vect)
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

ISR(INT0_vect)
{
	
}
ISR(INT1_vect)
{
	
}
ISR(TIMER0_COMP_vect)
{
	
}