/*
* function.h
*
* Created: 18/09/2015 10:15:57 AM
*  Author: Dinh Mahone
*/

#include <avr/io.h>
#define F_CPU 8000000UL
#include <util/delay.h>
#include <avr/interrupt.h>
#include "nRF24L01.h"

#define cbi(port, bit) (port) &= ~(1 << (bit))
#define sbi(port, bit) (port) |=  (1 << (bit))

#define ADC_VREF_TYPE 0x40

void InitADC()
{
	// ADC initialization
	// ADC Clock frequency: 1000.000 kHz
	// ADC Voltage Reference: AVCC pin
	ADMUX=ADC_VREF_TYPE & 0xff;
	ADCSRA=0x83;
}
unsigned int read_adc(unsigned char adc_input)
{
	ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	// Delay needed for the stabilization of the ADC input voltage
	_delay_us(10);
	// Start the AD conversion
	ADCSRA|=0x40;
	// Wait for the AD conversion to complete
	while ((ADCSRA & 0x10)==0);
	ADCSRA|=0x10;
	return ADCW;
}

void InitSPI()
{
	SPCR |=1<<SPE | 1<<MSTR;                                         //if spi is used, uncomment this section out
	SPSR |=1<<SPI2X;
}

void InitUART()
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
void InitEncoder()
{
	// Dem 24 xung / 1 vong banh xe
	// External Interrupt(s) initialization
	// INT0: On
	// INT0 Mode: Any change
	// INT1: On
	// INT1 Mode: Any change
	// INT2: Off
	GICR|=0xC0;
	MCUCR=0x05;
	MCUCSR=0x00;
	GIFR=0xC0;
	// Global enable interrupts

	//OCR1A=0-255; MOTOR LEFT
	//OCR1B=0-255; MOTOR RIGHT
}
void InitPort()
{
	DDRA    = 0xFF;
	DDRB    = 0b10111111;
	DDRC    = 0b11111100;
	DDRD    = 0b11110010;
}
void InitTimer()
{
	TCCR0=(1<<WGM01) | (1<<CS01)| (1<<CS00);							// Mode 2 CTC,  Prescaler = 264
	OCR0=62;												// 0.5ms
	TIMSK=(1<<OCIE0);
	
	TCCR1A = (1<<COM1A1)|(1<<COM1B1)|(1<<WGM11);			// SET OCR1A & OCR1B at BOTTOM, CLEAR at Compare Match (Non-invert), Mode 14 Fast PWM
	TCCR1B = (1<<WGM13)|(1<<WGM12)|(1<<CS11);				// Prescaler = 8
	ICR1 = 10000;											// Time Period = 10ms
	OCR1A=0;
	OCR1B=0;
	//TIMSK |= (1<<OCIE1A)| (1<<OCIE1B);
}
void init_MCU()
{
	cli();
	InitADC();
	InitEncoder();
	InitPort();
	InitSPI();
	InitTimer();
	InitUART();
	init_NRF24L01();
	SetRX_Mode();
	sei();
}


void speed(int left, int right)
{
	if(left>=0)
	{
		sbi(PORTC,6);
		OCR1A =  left*100;
	}
	else
	{
		cbi(PORTC,6);
		OCR1A = -left*100;
	}
	
	if(right>=0)
	{
		sbi(PORTC,7);
		OCR1B =  right*100;
	}
	else
	{
		cbi(PORTC,7);
		OCR1B = -right*100;
	}
}