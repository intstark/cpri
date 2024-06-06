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
#include "xil_io.h"

/************************** Function Declaration ******************************/
u32 check_link_status(int lane );
u32 * ReadDelayReg(int lane);
int LaneSpeedInit();
float  cpri_master_delay_calc(u32 data[4]);


/************************** Function Definition ******************************/



/*****************************************************************************/
/**
*
* @brief    Readback CPRI register 0x0��Check if CPRI status is F
*
*
* @param	int lane(0-3)
*
* @return	read back data
*
******************************************************************************/
u32 check_link_status(int lane ){

    u32 rd_value;
    u32 *reg = (u32*)(XPAR_M00_AXI_BASEADDR);

    switch(lane){
        case 0 : reg = (u32*)(XPAR_M00_AXI_BASEADDR);break;
        case 1 : reg = (u32*)(XPAR_M01_AXI_BASEADDR);break;
        case 2 : reg = (u32*)(XPAR_M02_AXI_BASEADDR);break;
        case 3 : reg = (u32*)(XPAR_M03_AXI_BASEADDR);break;
        default: reg = (u32*)(XPAR_M00_AXI_BASEADDR);break;
    }

    rd_value = Xil_In32((u32)(reg));

    return rd_value;
}

/*****************************************************************************/
/**
*
* @brief    Read Xilinx CPRI delay related registers
*           XPAR_M00_AXI_BASEADDR
*
* @param	int lane(0-3)
*
* @return	read back data
*
******************************************************************************/
u32 * ReadDelayReg(int lane){

    static u32 rd_value[4];
    u32 *reg = (u32*)(XPAR_M00_AXI_BASEADDR);

    switch(lane){
        case 0 : reg = (u32*)(XPAR_M00_AXI_BASEADDR);break;
        case 1 : reg = (u32*)(XPAR_M01_AXI_BASEADDR);break;
        case 2 : reg = (u32*)(XPAR_M02_AXI_BASEADDR);break;
        case 3 : reg = (u32*)(XPAR_M03_AXI_BASEADDR);break;
        default: reg = (u32*)(XPAR_M00_AXI_BASEADDR);break;
    }

    rd_value[0] = Xil_In32((u32)(reg + 0x00));  // 0x00
    rd_value[1] = Xil_In32((u32)(reg + 0x0f));  // 0x0F
    rd_value[2] = Xil_In32((u32)(reg + 0x16));  // 0x16
    rd_value[3] = Xil_In32((u32)(reg + 0x1b));  // 0x1B

    return (u32*) rd_value;
}


/*****************************************************************************/
/**
*
* @brief    Write 0x0D register to config Lane Speed Capability
*           XPAR_M00_AXI_BASEADDR
*
*
* @return	None.
*
******************************************************************************/
int LaneSpeedInit(){

    // Enable 24G+FEC Only
    Xil_Out32((u32)((u32*)(XPAR_M00_AXI_BASEADDR) + 0x0D),0x4000);
    Xil_Out32((u32)((u32*)(XPAR_M01_AXI_BASEADDR) + 0x0D),0x4000);
    Xil_Out32((u32)((u32*)(XPAR_M02_AXI_BASEADDR) + 0x0D),0x4000);
    Xil_Out32((u32)((u32*)(XPAR_M03_AXI_BASEADDR) + 0x0D),0x4000);
    print("Set lane speed to 0x4000\n\r");

    // soft reset
    Xil_Out32((u32)((u32*)(XPAR_M00_AXI_BASEADDR) + 0x0E),0x80000000);
    Xil_Out32((u32)((u32*)(XPAR_M01_AXI_BASEADDR) + 0x0E),0x80000000);
    Xil_Out32((u32)((u32*)(XPAR_M02_AXI_BASEADDR) + 0x0E),0x80000000);
    Xil_Out32((u32)((u32*)(XPAR_M03_AXI_BASEADDR) + 0x0E),0x80000000);


    // release soft reset
    Xil_Out32((u32)((u32*)(XPAR_M00_AXI_BASEADDR) + 0x0E),0x00000000);
    Xil_Out32((u32)((u32*)(XPAR_M01_AXI_BASEADDR) + 0x0E),0x00000000);
    Xil_Out32((u32)((u32*)(XPAR_M02_AXI_BASEADDR) + 0x0E),0x00000000);
    Xil_Out32((u32)((u32*)(XPAR_M03_AXI_BASEADDR) + 0x0E),0x00000000);
    print("Lane speed set done, Soft reset done\n\r");

    return 0;
}

/*****************************************************************************/
/**
*
* @brief    Convert CPRI delay register to UI cycle,
*           calculate the total CPRI master T14 delay
*
* @param	CPRI register read back data in format {0x0F,0x16,0x1B}
*
* @return	CPRI master T14 delay
*
******************************************************************************/
float  cpri_master_delay_calc(u32 data[4]){

    // fix delay constant for GTYE4 + FEC
    float gtye4_tx_delay = 213.5;
    float gtye4_rx_delay = 352.0;
    float datapath_fix_delay = 990.0;
    float rsfec_fix_delay = 14123.0;
    float lane_rate_delay = 22.0;

    float master_delay = 0.0;
    float delay_vec_ui[5];


    // get indivisual part of delay
    u32 r21_coarse = data[1] & 0x3FFFF;
    u32 cdc_fifo_delay = (data[1] & 0xFFFC0000) >> 18;

    u32 gearbox_tx_delay = data[2] & 0xFFFF;
    u32 gearbox_rx_delay = (data[2] & 0xFFFF0000) >> 16;

    u32 rsfec_frac_delay = (data[3] & 0xFE) >> 1;

    xil_printf("----------------------------------------------------\n\r");
    xil_printf("rsfec_frac_delay: \t%x\n\r", rsfec_frac_delay);

    xil_printf("gearbox_tx_delay: \t%x\n\r", gearbox_tx_delay);
    xil_printf("gearbox_rx_delay: \t%x\n\r", gearbox_rx_delay);

    xil_printf("r21_coarse delay: \t%x\n\r", r21_coarse);
    xil_printf("cdc_rx_fifo_delay: \t%x\n\r", cdc_fifo_delay);
    xil_printf("----------------------------------------------------\n\r");

    delay_vec_ui[0] = (float)r21_coarse*66;
    delay_vec_ui[1] = (float)cdc_fifo_delay*66/128;
    delay_vec_ui[2] = (float)gearbox_tx_delay/8;
    delay_vec_ui[3] = (float)gearbox_rx_delay/8;
    delay_vec_ui[4] = (float)rsfec_frac_delay;


    master_delay = delay_vec_ui[0] - (delay_vec_ui[1] + delay_vec_ui[2] + delay_vec_ui[3] + delay_vec_ui[4] + gtye4_tx_delay + gtye4_rx_delay + datapath_fix_delay + rsfec_fix_delay + lane_rate_delay);

    xil_printf("%.1f %.1f %.1f %.1f %.1f\n\r",delay_vec_ui[0],delay_vec_ui[1],delay_vec_ui[2],delay_vec_ui[3],delay_vec_ui[4]);
    xil_printf("master_delay: %d\n\r", (u32)(master_delay));
    xil_printf("----------------------------------------------------\n\r");


    return master_delay;
}




/*****************************************************************************/
/**
*
* @brief    Main
*
*
* @return	None.
*
******************************************************************************/
int main()
{
    init_platform();

    print("Hello World\n\r");
    print("Successfully ran Hello World application\n\r");
    print("----------------------------------------------------\n\r");

    //--------------------------------------------------------------------------
    // Config Lane Speed Capability
    //--------------------------------------------------------------------------
    LaneSpeedInit();
    sleep(2);


    //--------------------------------------------------------------------------
    // LANE 0
    //--------------------------------------------------------------------------
    int lane = 0;

    // Lane status check
    u32 link_status = check_link_status(lane);

    int try_counts = 0;
    while(link_status != 0x0000000F){
        link_status = check_link_status(lane);
        try_counts++;
        if(try_counts > 60){
        	xil_printf("Link is not up(link status=%x)!\n\r",link_status);
            break;
        }
        sleep(1);
    }

    // CPRI delay calculate
    if(link_status == 0x0000000F){
    	xil_printf("Link is up!\n\r");

        u32 *data = ReadDelayReg(lane);
        xil_printf("%x %x %x %x\n\r", data[0], data[1], data[2], data[3]);

        float master_delay = cpri_master_delay_calc(data);
    }



    cleanup_platform();
    return 0;
}




