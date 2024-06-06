
#include <stdio.h>

#define XPAR_M00_AXI_BASEADDR 0x40000000
#define XPAR_M01_AXI_BASEADDR 0x40100000
#define XPAR_M02_AXI_BASEADDR 0x40200000
#define XPAR_M03_AXI_BASEADDR 0x40300000
typedef unsigned int u32;


u32 Xil_In32(u32 Addr)
{

    if(Addr == 0x40000000)
    {
        return 0x0000000f;
    }
    else if (Addr == 0x4000003C)
    {
        return 0x00000002;
    } 
    else if (Addr == 0x40000058)
    {
        return 0x00000003;
    }
    else if (Addr == 0x4000006C)
    {
        return 0x00000004;
    } 
    else if (Addr == 0x40100000)
    {
        return 0x0000000F;
    }
    else if (Addr == 0x4010003C)
    {
        return 0x83bc02a1;
    } 
    else if (Addr == 0x40100058)
    {
        return 0x0a9f0860;
    }
    else if (Addr == 0x4010006C)
    {
        return 0x0000001F;
    } else {
        return 0x11111111;
    }
    
}

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

    printf("----------------------------------------------------\n\r");
    printf("rsfec_frac_delay: \t%x\n\r", rsfec_frac_delay);

    printf("gearbox_tx_delay: \t%x\n\r", gearbox_tx_delay);
    printf("gearbox_rx_delay: \t%x\n\r", gearbox_rx_delay);

    printf("r21_coarse delay: \t%x\n\r", r21_coarse);
    printf("cdc_rx_fifo_delay: \t%x\n\r", cdc_fifo_delay);
    printf("----------------------------------------------------\n\r");

    delay_vec_ui[0] = (float)r21_coarse*66;
    delay_vec_ui[1] = (float)cdc_fifo_delay*66/128;
    delay_vec_ui[2] = (float)gearbox_tx_delay/8;
    delay_vec_ui[3] = (float)gearbox_rx_delay/8;
    delay_vec_ui[4] = (float)rsfec_frac_delay;


    master_delay = delay_vec_ui[0] - (delay_vec_ui[1] + delay_vec_ui[2] + delay_vec_ui[3] + delay_vec_ui[4] + gtye4_tx_delay + gtye4_rx_delay + datapath_fix_delay + rsfec_fix_delay + lane_rate_delay);
    
    printf("%.1f %.1f %.1f %.1f %.1f\n\r",delay_vec_ui[0],delay_vec_ui[1],delay_vec_ui[2],delay_vec_ui[3],delay_vec_ui[4]);
    printf("master_delay(UI): %.1f\n\r", master_delay);
    printf("----------------------------------------------------\n\r");


    return master_delay;
}


void main()
{
    printf("Hello World\n\r");
    printf("Successfully ran Hello World application\n\r"); 
    printf("----------------------------------------------------\n\r");

    int lane = 1;

    u32 link_status = check_link_status(lane);

    int try_counts = 0;
    while(link_status != 0x0000000F){
        link_status = check_link_status(lane);
        try_counts++;
        if(try_counts > 60){
            printf("Link is not up(link status=%x)!\n\r",link_status);
            break;
        }
    }

    if(link_status == 0x0000000F){
        printf("Link is up!\n\r");

        u32 *data = ReadDelayReg(lane);
        printf("%x %x %x %x\n\r", data[0], data[1], data[2], data[3]);

        float master_delay = cpri_master_delay_calc(data);
    }
}