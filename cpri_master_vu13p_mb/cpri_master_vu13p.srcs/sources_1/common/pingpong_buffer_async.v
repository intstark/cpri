//Author(s)       :  zhangyunliang 
//Email           :  zhangyunliang@zgc-xnet.con
//Creation Date   :  2022-10-12
//File name       :  pingpong_buffer.v
//-----------------------------------------------------------------------------
//Detailed Description :                                                     
//
//
//
//-----------------------------------------------------------------------------


module pingpong_buffer_async #(
    parameter integer sel                    =   1  ,
    parameter integer WDATA_WIDTH            =   32  ,
    parameter integer WADDR_WIDTH            =   32  ,   
    parameter integer RDATA_WIDTH            =   32  ,
    parameter integer RADDR_WIDTH            =   32  ,
    parameter integer INFO_DATA              =   16  ,
    parameter integer FREE_SIZE              =   2   ,       
    parameter integer EXP_BIT                =   10  ,
    parameter integer READ_LATENCY           =   3   ,
    parameter integer BYTE_WRITE_WIDTH_A     =   8     


    )
    (
    input  wire                         wclk        ,    
    input  wire                         rst         ,
    input  wire                         wen         ,                                        
    input  wire[WADDR_WIDTH-1:0]        waddr       ,
    input  wire[WDATA_WIDTH*sel-1:0]    wdata       ,
    input  wire                         wlast       ,
    input  wire[INFO_DATA-1:0]	        winfo			  ,	  
    input  wire[RADDR_WIDTH-1:0]        raddr       ,
    input  wire                         rclk        ,
    input  wire                         rrdy        ,
    output wire[RDATA_WIDTH*sel-1:0]    rdata       ,
    output wire                         rvld        ,
    output wire[INFO_DATA-1:0]	        rinfo       ,
    output reg [FREE_SIZE-1:0]          free_size    //--2bit
    
    );

wire			                                  wea0,wea1;
reg       [FREE_SIZE-1:0]                   high_waddr;//--1
reg       [FREE_SIZE-1:0]                   high_raddr;//--1 
wire	    [RDATA_WIDTH*sel-1:0]	            doutb0,doutb1;
reg       rp_out_sel,rp_out_sel_d1,rp_out_sel_d2;

//------------------------------------------------------------------------------//
//--free_size
//--the total number of odd and even buffers can write two packets of data
always @ (posedge wclk)
    begin
        if (rst == 1'b1)
            free_size <= {1'b1,{FREE_SIZE-1{1'b0}}}; 
        else
            begin
                case ({rrdy,wlast})
                    2'b01:  begin
                              if(free_size != {FREE_SIZE{1'b0}})
                                free_size <= free_size - 1'b1;                                
                            end
                    2'b10:  begin
                              if(free_size != {1'b1,{FREE_SIZE-1{1'b0}}})
                                free_size <= free_size + 1'b1;
                            end
                    default:free_size <= free_size;//2'b11
                endcase
            end
    end

//------------------------------------------------------------------------------//
//--write 
always @ (posedge wclk)
    begin
        if (rst == 1'b1)
            high_waddr <= 1'd0;//{FREE_SIZE-1{1'b0}}
        else
            begin
                if (wlast && free_size != {FREE_SIZE{1'b0}})
                    high_waddr <= high_waddr + 1'b1;
                else
                    high_waddr <= high_waddr;
            end
    end



//------------------------------------------------------------------------------//
//--read 
always @ (posedge rclk)
    begin
        if (rst == 1'b1)
            high_raddr <= 1'd0;//{FREE_SIZE-1{1'b0}}
        else
            begin
                if (rrdy && free_size !={1'b1,{FREE_SIZE-1{1'b0}}} )
                    high_raddr <= high_raddr + 1'b1;  
                else
                    high_raddr <= high_raddr;
            end
    end




assign wea0   =    wen & (~high_waddr[0]);
assign wea1   =    wen & high_waddr[0];




//------------------------------------------------------------------------------//
//--BRAM
//------------------------------------------------------//--even
//--31:0
 ASYNC_Dual_Port_RAM_XPM
  #(    
     .MEMORY_SIZE          (WDATA_WIDTH*(2**EXP_BIT)                ),
     .WDATA_WIDTH          (WDATA_WIDTH                             ),
     .WADDR_WIDTH          (WADDR_WIDTH                             ),
     .RDATA_WIDTH          (RDATA_WIDTH                             ),
     .RADDR_WIDTH          (RADDR_WIDTH                             ),
     .READ_LATENCY         (READ_LATENCY                            ),
     .BYTE_WRITE_WIDTH_A   (BYTE_WRITE_WIDTH_A                      )     
 ) 
 INST_CP_SDP_DRAM_32_1024_EVEN_31_0                                          
 (                                                                   
     .wclk                 (wclk                                    ),
     .wea                  ({(WDATA_WIDTH/BYTE_WRITE_WIDTH_A){wea0}}),
     .addra                (waddr                                   ),     
     .dina                 (wdata[31:0]                             ),
     .rclk                 (rclk                                    ),    
     .addrb                (raddr                                   ),
     .doutb                (doutb0[31:0]                            )
 );  
//--63:32
 ASYNC_Dual_Port_RAM_XPM
  #(    
     .MEMORY_SIZE          (WDATA_WIDTH*(2**EXP_BIT)                ),
     .WDATA_WIDTH          (WDATA_WIDTH                             ),
     .WADDR_WIDTH          (WADDR_WIDTH                             ),
     .RDATA_WIDTH          (RDATA_WIDTH                             ),
     .RADDR_WIDTH          (RADDR_WIDTH                             ),
     .READ_LATENCY         (READ_LATENCY                            ),
     .BYTE_WRITE_WIDTH_A   (BYTE_WRITE_WIDTH_A                      )     
 ) 
 INST_CP_SDP_DRAM_32_1024_EVEN_63_32                                          
 (                                                                   
     .wclk                 (wclk                                    ),
     .wea                  ({(WDATA_WIDTH/BYTE_WRITE_WIDTH_A){wea0}}),
     .addra                (waddr                                   ),     
     .dina                 (wdata[63:32]                            ),
     .rclk                 (rclk                                    ),    
     .addrb                (raddr                                   ),
     .doutb                (doutb0[63:32]                           )
 );  



//------------------------------------------------------//--odd
//--31:0
 ASYNC_Dual_Port_RAM_XPM 
 #(    
     .MEMORY_SIZE          (WDATA_WIDTH*(2**EXP_BIT)                ),
     .WDATA_WIDTH          (WDATA_WIDTH                             ),
     .WADDR_WIDTH          (WADDR_WIDTH                             ),
     .RDATA_WIDTH          (RDATA_WIDTH                             ),
     .RADDR_WIDTH          (RADDR_WIDTH                             ),
     .READ_LATENCY         (READ_LATENCY                            ),
     .BYTE_WRITE_WIDTH_A   (BYTE_WRITE_WIDTH_A                      )     
 ) 
 INST_CP_SDP_DRAM_32_1024_ODD_31_0                                          
 (                                                                   
     .wclk                 (wclk                                    ),
     .wea                  ({(WDATA_WIDTH/BYTE_WRITE_WIDTH_A){wea1}}),
     .addra                (waddr                                   ),     
     .dina                 (wdata[31:0]                             ),
     .rclk                 (rclk                                    ),         
     .addrb                (raddr                                   ),
     .doutb                (doutb1[31:0]                            )
 );  
//--63:32 
 ASYNC_Dual_Port_RAM_XPM 
 #(    
     .MEMORY_SIZE          (WDATA_WIDTH*(2**EXP_BIT)                ),
     .WDATA_WIDTH          (WDATA_WIDTH                             ),
     .WADDR_WIDTH          (WADDR_WIDTH                             ),
     .RDATA_WIDTH          (RDATA_WIDTH                             ),
     .RADDR_WIDTH          (RADDR_WIDTH                             ),
     .READ_LATENCY         (READ_LATENCY                            ),
     .BYTE_WRITE_WIDTH_A   (BYTE_WRITE_WIDTH_A                      )     
 ) 
 INST_CP_SDP_DRAM_32_1024_ODD_63_32                                          
 (                                                                   
     .wclk                 (wclk                                    ),
     .wea                  ({(WDATA_WIDTH/BYTE_WRITE_WIDTH_A){wea1}}),
     .addra                (waddr                                   ),     
     .dina                 (wdata[63:32]                            ),
     .rclk                 (rclk                                    ),         
     .addrb                (raddr                                   ),
     .doutb                (doutb1[63:32]                           )
 ); 

//------------------------------------------------------------------------------//
//--FIFO--fwft
//------------------------------------------------------//--even


FIFO_ASYNC_XPM #(
    .FIFO_DEPTH            (16                                      ),
    .DATA_WIDTH            (1                                       )
)INST_FIFO_BUFFER_CTRL                                             
(                                                                   
    .rst                   (rst                                     ),
    .wclk                  (wclk                                    ),
    .wr_en                 (wlast                                   ),
    .din                   (wlast                                   ),
    .rclk                  (rclk                                    ),        
    .rd_en                 (rrdy                                    ),
    .dout                  (                                        ),
    .dout_valid            (rvld                                    ),
    .almost_empty          (                                        ),
    .almost_full           (                                        ),
    .empty                 (                                        ),
    .full                  (                                        )
);

//------------------------------------------------------//--odd


FIFO_ASYNC_XPM #(
    .FIFO_DEPTH            (16                                      ),
    .DATA_WIDTH            (INFO_DATA                               )
)INST_FIFO_BUFFER_INFO                                            
(                                                                   
    .rst                   (rst                                     ),
    .wclk                  (wclk                                    ),
    .wr_en                 (wlast                                   ),
    .din                   (winfo                                   ),
    .rclk                  (rclk                                    ),    
    .rd_en                 (rrdy                                    ),
    .dout                  (rinfo                                   ),
    .dout_valid            (                                        ),
    .almost_empty          (                                        ),
    .almost_full           (                                        ),
    .empty                 (                                        ),
    .full                  (                                        )
);

always @ (posedge rclk)
begin
    rp_out_sel    <= high_raddr[0];
    rp_out_sel_d1 <= rp_out_sel;
    rp_out_sel_d2 <= rp_out_sel_d1;
end

assign rdata = rp_out_sel_d2?doutb1:doutb0;



endmodule
