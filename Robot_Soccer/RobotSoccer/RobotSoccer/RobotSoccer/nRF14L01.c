#include <avr/io.h>
#include <string.h>
#include "nRF24L01.h"
#define F_CPU 8000000UL
#include <util/delay.h>
//#include <spi.h>

#define cbi(port, bit) (port) &= ~(1 << (bit))
#define sbi(port, bit) (port) |=  (1 << (bit))

#define CSN    2
#define CE     3
#define SCK    7
#define MISO   6 
#define MOSI   5
//********************************************************************************
//unsigned char const TX_ADDRESS[TX_ADR_WIDTH]= {0x34,0x43,0x10,0x10,0x01};	//
//unsigned char const RX_ADDRESS[RX_ADR_WIDTH]= {0x34,0x43,0x10,0x10,0x01};	//
unsigned char const TX_ADDRESS[TX_ADR_WIDTH]= {0xE7,0xE7,0xE7,0xE7,0xE7};	// dia chi phat du lieu
unsigned char const RX_ADDRESS[RX_ADR_WIDTH]= {0xE7,0xE7,0xE7,0xE7,0xE7};	// dia chi nhan du lieu
//****************************************************************************************
//*NRF24L01
//***************************************************************************************/

unsigned char spi(unsigned char data)
{
	SPDR=data;
	while ((SPSR & (1<<SPIF))==0);
	return SPDR;
}
void init_NRF24L01(void)
{
    //init SPI
    SPCR=0x51; //set this to 0x50 for 1 mbits 
    SPSR=0x00; 
    
    //inerDelay_us(100);
    _delay_us(100);
 	cbi(PORTC,CE);//CE=0;    // chip enable
 	sbi(PORTC,CSN);//CSN=1;   // Spi disable
 	//SCK=0;   // Spi clock line init high
	SPI_Write_Buf(WRITE_REG + TX_ADDR, TX_ADDRESS, TX_ADR_WIDTH);    //
	SPI_Write_Buf(WRITE_REG + RX_ADDR_P0, RX_ADDRESS, RX_ADR_WIDTH); //
	SPI_RW_Reg(WRITE_REG + EN_AA, 0x00);      // EN P0, 2-->P1
	SPI_RW_Reg(WRITE_REG + EN_RXADDR, 0x01);  //Enable data P0
	SPI_RW_Reg(WRITE_REG + RF_CH, 2);        // Chanel 0 RF = 2400 + RF_CH* (1or 2 M)
	SPI_RW_Reg(WRITE_REG + RX_PW_P0, RX_PLOAD_WIDTH); // Do rong data truyen 32 byte
	SPI_RW_Reg(WRITE_REG + RF_SETUP, 0x07);   		// 1M, 0dbm
	SPI_RW_Reg(WRITE_REG + CONFIG, 0x0e);   		 // Enable CRC, 2 byte CRC, Send

}
/****************************************************************************************************/
//unsigned char SPI_RW(unsigned char Buff)
//NRF24L01
/****************************************************************************************************/
unsigned char SPI_RW(unsigned char Buff)
{
   return spi(Buff);    
}
/****************************************************************************************************/
//unsigned char SPI_Read(unsigned char reg)
//NRF24L01
/****************************************************************************************************/
unsigned char SPI_Read(unsigned char reg)
{
	unsigned char reg_val;

	cbi(PORTC,CSN);//CSN = 0;                // CSN low, initialize SPI communication...
	SPI_RW(reg);            // Select register to read from..
	reg_val = SPI_RW(0);    // ..then read registervalue
	sbi(PORTC,CSN);//CSN = 1;                // CSN high, terminate SPI communication

	return(reg_val);        // return register value
}
/****************************************************************************************************/
//unsigned char SPI_RW_Reg(unsigned char reg, unsigned char value)
/****************************************************************************************************/
unsigned char SPI_RW_Reg(unsigned char reg, unsigned char value)
{
	unsigned char status;

	cbi(PORTC,CSN);//CSN = 0;                   // CSN low, init SPI transaction
	status = SPI_RW(reg);      // select register
	SPI_RW(value);             // ..and write value to it..
	sbi(PORTC,CSN);//CSN = 1;                   // CSN high again

	return(status);            // return nRF24L01 status uchar
}
/****************************************************************************************************/
//unsigned char SPI_Read_Buf(unsigned char reg, unsigned char *pBuf, unsigned char uchars)
//
/****************************************************************************************************/
unsigned char SPI_Read_Buf(unsigned char reg, unsigned char *pBuf, unsigned char uchars)
{
	unsigned char status,uchar_ctr;

	cbi(PORTC,CSN);//CSN = 0;                    		// Set CSN low, init SPI tranaction
	status = SPI_RW(reg);       		// Select register to write to and read status uchar

	for(uchar_ctr=0;uchar_ctr<uchars;uchar_ctr++)
		pBuf[uchar_ctr] = SPI_RW(0);    //

	sbi(PORTC,CSN);//CSN = 1;

	return(status);                    // return nRF24L01 status uchar
}
/*********************************************************************************************************/
//uint SPI_Write_Buf(uchar reg, uchar *pBuf, uchar uchars)
/*****************************************************************************************************/
unsigned char SPI_Write_Buf(unsigned char reg, unsigned char *pBuf, unsigned uchars)
{
	unsigned char status,uchar_ctr;
	cbi(PORTC,CSN);//CSN = 0;            //SPI
	status = SPI_RW(reg);
	for(uchar_ctr=0; uchar_ctr<uchars; uchar_ctr++) //
	SPI_RW(*pBuf++);
	sbi(PORTC,CSN);//CSN = 1;           //SPI
	return(status);    //
}
/****************************************************************************************************/
//void SetRX_Mode(void)
//
/****************************************************************************************************/
void SetRX_Mode(void)
{
	cbi(PORTC,CE);//CE=0;
	SPI_RW_Reg(WRITE_REG + CONFIG, 0x07);   		// enable power up and prx
	sbi(PORTC,CE);//CE = 1;
	_delay_us(130);    //
}
/****************************************************************************************************/
//void SetTX_Mode(void)
//
/****************************************************************************************************/
void SetTX_Mode(void)
{
	cbi(PORTC,CE);//CE=0;
	SPI_RW_Reg(WRITE_REG + CONFIG, 0x0e);   		// Enable CRC, 2 byte CRC, Send
	sbi(PORTC,CE);//CE = 1;
	_delay_us(130);    //
}

/******************************************************************************************************/
//unsigned char nRF24L01_RxPacket(unsigned char* rx_buf)
/******************************************************************************************************/
unsigned char nRF24L01_RxPacket(unsigned char* rx_buf)
{
    unsigned char revale=0;
    unsigned char sta;
	sta=SPI_Read(STATUS);	// Read Status 
	//if(RX_DR)				// Data in RX FIFO
    if((sta&0x40)!=0)		// Data in RX FIFO
	{
	    cbi(PORTC,CE);//CE = 0; 			//SPI
		SPI_Read_Buf(RD_RX_PLOAD,rx_buf,TX_PLOAD_WIDTH);// read receive payload from RX_FIFO buffer
		revale =1;	
	}
	SPI_RW_Reg(WRITE_REG+STATUS,sta); 
    sbi(PORTC,CE);//CE = 1; 			//SPI  
	return revale;
}
/***********************************************************************************************************/
//void nRF24L01_TxPacket(unsigned char * tx_buf)
//
/**********************************************************************************************************/
void nRF24L01_TxPacket(unsigned char * tx_buf)
{
	cbi(PORTC,CE);//CE=0;		
	SPI_Write_Buf(WRITE_REG + RX_ADDR_P0, TX_ADDRESS, TX_ADR_WIDTH); // Send Address
	SPI_Write_Buf(WR_TX_PLOAD, tx_buf, TX_PLOAD_WIDTH); 			 //send data
	SPI_RW_Reg(WRITE_REG + CONFIG, 0x0e);   		 // Send Out
	sbi(PORTC,CE);//CE=1;		 
}

// --------------------END OF FILE------------------------
// -------------------------------------------------------