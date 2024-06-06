/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xgpio.h"

#include "xiic.h"
#include "xiic_l.h"
#include "xiicps.h"
#include "Si5382A-RevE-CPRI-Registers_in15p36.h"
//#include "Si5382A-RevE-CPRI-Registers_in184p32.h"



/************************** Constant Definitions ******************************/

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define IIC_BASE_ADDRESS	XPAR_IIC_0_BASEADDR
#define IIC_DEVICE_ID		XPAR_XIICPS_0_DEVICE_ID
#define IIC_SLAVE_ADDR		0x74
#define IIC_I2CSPI_ADDR		0x2F
#define IIC_SI5382_ADDR		0x68

#define XRFDC_ADC_OR_DAC		0U
#define XRFdc_DEVICE_ID			XPAR_XRFDC_0_DEVICE_ID

#define GPIO_EXAMPLE_DEVICE_ID  XPAR_GPIO_0_DEVICE_ID


#define START_ADDRESS		0

#define IIC_RDBUF_SIZE		6
#define SEND_COUNT			2
#define RECEIVE_COUNT   	2


#define BUF_LEN 				(10)
#define I2C_SCLK_RATE_I2CMUX 	600000U

#define SI5382_I2C_DEVICE (XPAR_XIICPS_1_DEVICE_ID)

#define I2C_MUXADDR		(0x74)
#define SI5382_MUXVAL	(0x10)
#define SI5382_ADDR		(0x68)
#define SI5382_ID 		(0x5382)

/*
 * The following constant is used to wait after an LED is turned on to make
 * sure that it is visible to the human eye.  This constant might need to be
 * tuned for faster or slower processor speeds.
 */
#define LED_DELAY     10000000

/*
 * The following constant is used to determine which channel of the GPIO is
 * used for the LED if there are 2 channels supported.
 */
#define LED_CHANNEL 1

/************************** Variable Definitions ******************************/

volatile u8 TransmitComplete;
volatile u8 ReceiveComplete;

u8 WriteBuffer[SEND_COUNT];	/* Write buffer for writing a page. */
u8 ReadBuffer[RECEIVE_COUNT];	/* Read buffer for reading a page. */


XIic IicInstance;		  /* The instance of the IIC device */

XGpio Gpio; 			/* The Instance of the GPIO Driver */



/************************** Function Declaration ******************************/

void GpioConfig(u16 DEVICE_ID);



/************************** Function Definition ******************************/

void GpioConfig(u16 DEVICE_ID){

	int Status;
	volatile int Delay;
	u8 LED;

	/* Initialize the GPIO driver */
	Status = XGpio_Initialize(&Gpio, DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Gpio Initialization Failed\r\n");
		return XST_FAILURE;
	}

	/* Set the direction for all signals as inputs except the LED output */
	XGpio_SetDataDirection(&Gpio, LED_CHANNEL, ~LED);

	/* Loop forever blinking the LED */

	u8 spark;

	for(spark=0;spark<8;spark=spark+1){

		LED=1<<spark;

		XGpio_DiscreteWrite(&Gpio, LED_CHANNEL, LED);

		/* Wait a small amount of time so the LED is visible */
		for (Delay = 0; Delay < LED_DELAY; Delay++);

		/* Clear the LED bit */
		XGpio_DiscreteClear(&Gpio, LED_CHANNEL, LED);

		/* Wait a small amount of time so the LED is visible */
		for (Delay = 0; Delay < LED_DELAY; Delay++);

		printf("LED=%d\n\r",LED);
	}

	XGpio_DiscreteWrite(&Gpio, LED_CHANNEL, LED);

}



static void SendHandler(XIic *InstancePtr)
{
	TransmitComplete = 0;
}

static void ReceiveHandler(XIic *InstancePtr)
{
	ReceiveComplete = 0;
}

static void StatusHandler(XIic *InstancePtr, int Event)
{

}


static int lastPage = -1;
static int lastSlaveAddr = -1;

/** Assumes that mux/bus speed is properly set */
static u32 write_si5382_register(XIicPs *I2cInstPtr, int slaveAddr, int reg, u8 *writedata, int len)
{
	u8 buffer[258];
	u32 Status = XST_SUCCESS;
	int page = ((reg >> 8) & 0xff);
	int i;

	/* Set the device Current Page (if needed) */
	if (page != lastPage || slaveAddr != lastSlaveAddr ) {
		buffer[0U] = 1;
		buffer[1U] = (u8)page;

		printf("Si5382 0x%x setting page to 0x%x\n\r", slaveAddr, buffer[1U]);

		Status = XIicPs_MasterSendPolled(I2cInstPtr,
				buffer, 2U, slaveAddr);
		if (Status != XST_SUCCESS) {
			printf("Si5382 0x%x Setting page %d failed (0x%x)\n\r",
					slaveAddr, buffer[1U], Status);
				goto END;
		}
		while (XIicPs_BusIsBusy(I2cInstPtr) == TRUE) {/* Wait for bus to idle */}
		lastPage = page;
		lastSlaveAddr = slaveAddr;
	}
	/* Copy Data to write and send to device */
	buffer[0U] = reg & 0XFF;
	for (i = 0; i < len; i++) {
		buffer[1 + i] = writedata[i];
	}
	Status = XIicPs_MasterSendPolled(I2cInstPtr, buffer, len+1, slaveAddr);
	if (Status != XST_SUCCESS) {
		printf("Si5382 Write of Register Data FAILED  (0x%x)\n\r", Status);
		goto END;
	}
	while (XIicPs_BusIsBusy(I2cInstPtr) == TRUE) {/* Wait for bus to idle */}

END:
	return Status;
}


static u32 read_si5382_register(XIicPs *I2cInstPtr, int slaveAddr, int reg, u8 *readbuf, int len)
{
	u32 Status = XST_SUCCESS;

	/* Write all the address data to the Si5382 */
	Status = write_si5382_register(I2cInstPtr, slaveAddr, reg, NULL, 0);
	if (XST_SUCCESS != Status) {
		printf("Si5382 Set register values for read failed (0x%x)\n\r", Status);
		goto END;

	}
	/* Read the data from the device */
	Status = XIicPs_MasterRecvPolled(I2cInstPtr, readbuf, len, slaveAddr);
	if (Status != XST_SUCCESS) {
		printf("Si5382 Polled Recv for data read FAILED  (0x%x)\n\r", Status);
		goto END;
	}
	while (XIicPs_BusIsBusy(I2cInstPtr) == TRUE) {/* Wait for bus to idle */}

END:
	return Status;
}



u32 Si5382_Program(void)
{
	XIicPs I2cInstancePs;
	XIicPs_Config *I2cCfgPtr;
	u8 WriteBuffer[BUF_LEN] = {0U};
	u8 ReadBuffer[BUF_LEN] = {0U};
	u32 SlaveAddr;
	u32 id;
	s32 Status;
	u32 UStatus;
	int idx;

	/* Initialize the I2C driver so that it is ready to use */
	I2cCfgPtr = XIicPs_LookupConfig(SI5382_I2C_DEVICE);
	if (I2cCfgPtr == NULL) {
		printf("Si5382 XFSBL_ERROR_I2C_INIT\r\n");
		goto END;
	}

	Status = XIicPs_CfgInitialize(&I2cInstancePs, I2cCfgPtr,
			I2cCfgPtr->BaseAddress);
	if (Status != XST_SUCCESS) {
		printf("Si5382 XFSBL_ERROR_I2C_INIT\r\n");
		goto END;
	}

	/* Change the I2C serial clock rate */
	Status = XIicPs_SetSClk(&I2cInstancePs, I2C_SCLK_RATE_I2CMUX);
	if (Status != XST_SUCCESS) {
		printf("Si5382 XFSBL_ERROR_I2C_SET_SCLK\r\n");
		goto END;
	}

	WriteBuffer[0U] = SI5382_MUXVAL;
	SlaveAddr = I2C_MUXADDR;
	Status = XIicPs_MasterSendPolled(&I2cInstancePs,
			WriteBuffer, 1U, SlaveAddr);
	if (Status != XST_SUCCESS) {
		printf("SI5382 set MUX failed (%x)\n\r", Status);
		goto END;
	}
	while (XIicPs_BusIsBusy(&I2cInstancePs) == TRUE) {/* Wait for bus to idle */}

	printf("Si5382 MUX is set\n\r");

	/* Verify that this is actually a 5382 */
	SlaveAddr = SI5382_ADDR;
	Status = read_si5382_register(&I2cInstancePs, SlaveAddr, 2, ReadBuffer, 2);
	id = (u32)ReadBuffer[1] << 8 | (u32)ReadBuffer[0];
	if (id != SI5382_ID) {
		printf("Si5382 identifier is incorrect (0x%x)\n\r", id);
		goto END;
	}

	for (idx = 0; si5382a_reve_registers[idx].address != 0xffff ||
					si5382a_reve_registers[idx].value != 0xff ; idx ++) {
		/* Address of CMDADDRESS performs a non I2C transaction */
		if (si5382a_reve_registers[idx].address == 0xffff) {
			switch(si5382a_reve_registers[idx].value ) {
			case 0xfe:
				printf("Si5382 Sleeping 700 mS\n\r");
				usleep(700000);
				break;
			default:
				printf("Si5382 Unknown Command Action 0x%x, punting \n\r");
				goto END;
			}
			continue;
		}
		printf("Si5382 (idx=%d) writing address 0x%x = 0x%x\n\r",
				idx, si5382a_reve_registers[idx].address, si5382a_reve_registers[idx].value);
		Status = write_si5382_register(&I2cInstancePs,
										SlaveAddr,
										si5382a_reve_registers[idx].address,
										&si5382a_reve_registers[idx].value,
										1);
		if (Status != XST_SUCCESS) {
			printf("Si5382 XFSBL_ERROR_I2C_SET_SCLK\r\n");
			goto END;
		}
	}
	printf("#--------------------------------------------------\r\n");
	printf("# Si5382 Configured\r\n");
	printf("#--------------------------------------------------\r\n");

	int i;
	u8 RDREG[3]={0x0000, 0x000A, 0x0012};
	// ID
	Status = read_si5382_register(&I2cInstancePs, SlaveAddr, RDREG[0], ReadBuffer, 10);
	for(i=0;i<sizeof(ReadBuffer);i++){
		printf("ReadBuffer[%d] 0x%x = 0x%x\n\r", i, RDREG[0]+i, ReadBuffer[i]);
	}

	// PLL STATUS
	Status = read_si5382_register(&I2cInstancePs, SlaveAddr, RDREG[1], ReadBuffer, 10);
	for(i=0;i<sizeof(ReadBuffer);i++){
		printf("ReadBuffer[%d] 0x%x = 0x%x\n\r", i, RDREG[1]+i, ReadBuffer[i]);
	}

	printf("#------------------------WAIT-----------------------\r\n");

	sleep(60);
	Status = read_si5382_register(&I2cInstancePs, SlaveAddr, RDREG[1], ReadBuffer, 10);
	for(i=0;i<sizeof(ReadBuffer);i++){
		printf("ReadBuffer[%d] 0x%x = 0x%x\n\r", i, RDREG[1]+i, ReadBuffer[i]);
	}

	printf("#----------------------READ DONE--------------------\r\n");

END:
	return UStatus;

}



int main()
{
    init_platform();

    print("***************** Hello R5 *****************\n\r");

	print("Here goes the GPIO testing\n\r");

	GpioConfig(GPIO_EXAMPLE_DEVICE_ID);

	Si5382_Program();


	sleep(1);


    cleanup_platform();

    return 0;
}
