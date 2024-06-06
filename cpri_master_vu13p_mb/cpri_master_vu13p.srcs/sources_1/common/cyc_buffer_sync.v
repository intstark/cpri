//Author(s)       :  zhangyunliang 
//Email           :  zhangyunliang@zgc-xnet.con
//Creation Date   :  2022-10-12
//File name       :  cyc_buffer_sync.v
//-----------------------------------------------------------------------------
//Detailed Description :                                                     
//
//
//
//-----------------------------------------------------------------------------
module cyc_buffer_sync #(
    parameter integer WDATA_WIDTH        =  512 ,
    parameter integer WADDR_WIDTH        =  10  ,
    parameter integer RDATA_WIDTH        =  256 ,
    parameter integer RADDR_WIDTH        =  11  ,
    parameter integer READ_LATENCY       =  3   ,
    parameter integer BYTE_WRITE_WIDTH   =  8   ,   
    parameter integer INFOW              =  79  ,
    parameter integer RAM_TYPE           =  1
    )
    (
    input  wire                  syn_rst,
    input  wire                  clk,
    input  wire[WADDR_WIDTH-1:0] wp_addr,
    input  wire[WDATA_WIDTH-1:0] wp_data,
    input  wire                  wp_wen,
    input  wire                  wp_wlast,
    input  wire[WADDR_WIDTH-1:0] wp_len,
    input  wire[INFOW-1:0]       wp_info,
    output reg [WADDR_WIDTH:0]   free_size,
    input  wire                  wp_vld,

    input  wire[RADDR_WIDTH-1:0] rp_addr,
    output wire[RDATA_WIDTH-1:0] rp_data,
    output reg [WADDR_WIDTH-1:0] rp_len,
    output wire                  rp_vld,
    output wire[INFOW-1:0]       rp_info,
    input  wire                  rp_rdy
    );

function integer clogb2 (input integer bit_depth);              
begin                                                           
  for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
    bit_depth = bit_depth >> 1;                                 
  end                                                           
endfunction 

localparam integer LSH_BIT = clogb2(WDATA_WIDTH/RDATA_WIDTH - 1);
localparam integer RSH_BIT = clogb2(RDATA_WIDTH/WDATA_WIDTH - 1);

wire[WADDR_WIDTH-1:0]    cyc_len;
reg                     rp_rdy_d1;  
reg                     wp_wlast_d1;
reg [4:0]               cyc_length;
reg [4:0]               wp_length;
reg [4:0]               wbadr;
wire[4:0]               waddr;
reg [4:0]               rbadr;
wire[4:0]               raddr;





always @ (posedge clk)
    begin
        if (syn_rst == 1'b1)
            free_size[WADDR_WIDTH-6:0] <= {(WADDR_WIDTH-5){1'b0}};
        else
            free_size[WADDR_WIDTH-6:0] <= {(WADDR_WIDTH-5){1'b0}};
    end

//--
always @ (posedge clk)
    begin
        rp_rdy_d1        <= rp_rdy;
        wp_wlast_d1      <= wp_wlast;
    end

always @ (posedge clk)
    begin
        wp_length[4:0]    <= wp_len[WADDR_WIDTH-1:WADDR_WIDTH-5]   + (|wp_len[WADDR_WIDTH-6:0]);
        cyc_length[4:0]   <= cyc_len[WADDR_WIDTH-1:WADDR_WIDTH-5]  + (|cyc_len[WADDR_WIDTH-6:0]);        
    end

always @ (posedge clk)
    begin
        rp_len        <= cyc_len;
    end


always @ (posedge clk)
    begin
        if (syn_rst == 1'b1)
            free_size[WADDR_WIDTH:WADDR_WIDTH-5] <= 6'd32;
        else
            begin
                case ({rp_rdy_d1,wp_wlast_d1})
                    2'b01:  free_size[WADDR_WIDTH:WADDR_WIDTH-5] <= free_size[WADDR_WIDTH:WADDR_WIDTH-5] - {1'b0,wp_length[4:0]};
                    2'b10:  free_size[WADDR_WIDTH:WADDR_WIDTH-5] <= free_size[WADDR_WIDTH:WADDR_WIDTH-5] + {1'b0,cyc_length[4:0]};
                    2'b11:  free_size[WADDR_WIDTH:WADDR_WIDTH-5] <= free_size[WADDR_WIDTH:WADDR_WIDTH-5] + {1'b0,cyc_length[4:0]} - {1'b0,wp_length[4:0]};
                    default:free_size[WADDR_WIDTH:WADDR_WIDTH-5] <= free_size[WADDR_WIDTH:WADDR_WIDTH-5];
                endcase
            end
    end



//************************WP_PORT

always @ (posedge clk)
    begin
        if (syn_rst == 1'b1)
            wbadr[4:0] <= 5'd0;
        else
            begin
                if (wp_wlast)
                    wbadr[4:0] <= wbadr[4:0] + wp_len[WADDR_WIDTH-1:WADDR_WIDTH-5] + (|wp_len[WADDR_WIDTH-6:0]);       
                else
                    wbadr[4:0] <= wbadr[4:0];
            end
    end

assign waddr[4:0] = wp_addr[WADDR_WIDTH-1:WADDR_WIDTH-5] + wbadr[4:0]; 


//*****************RP_PORT
always @ (posedge clk)
    begin
        if (syn_rst == 1'b1)
            rbadr[4:0] <= 5'd0;
        else
            begin
                if (rp_rdy)
                    rbadr[4:0] <= rbadr[4:0] + cyc_len[WADDR_WIDTH-1:WADDR_WIDTH-5] + (|cyc_len[WADDR_WIDTH-6:0]);     
                else
                    rbadr[4:0] <= rbadr[4:0];
            end
    end

assign raddr[4:0] = rp_addr[RADDR_WIDTH-1:RADDR_WIDTH-5] + rbadr[4:0]; 


//------------------------------------------------------------------------------//
//-LENGTH-1
FIFO_SYNC_XPM #(
    .FIFO_DEPTH            (32                ),
    .DATA_WIDTH            (WADDR_WIDTH        )
)INST_LENGTH_1                                             
(                                                                   
    .rst                   (syn_rst           ),
    .clk                   (clk               ),
    .wr_en                 (wp_wlast          ),
    .din                   (wp_len            ),
    .rd_en                 (rp_rdy            ),
    .dout                  (cyc_len           ),
    .dout_valid            (                  ),
    .almost_empty          (                  ),
    .almost_full           (                  ),
    .empty                 (                  ),
    .full                  (                  )
);                                            
                                     

//------------------------------------------------------------------------------//
//-INFO
FIFO_SYNC_XPM #(
    .FIFO_DEPTH            (32                ),
    .DATA_WIDTH            (INFOW             )
)INST_INFO                                            
(                                                                   
    .rst                   (syn_rst           ),
    .clk                   (clk               ),
    .wr_en                 (wp_wlast          ),
    .din                   (wp_info           ),
    .rd_en                 (rp_rdy            ),
    .dout                  (rp_info           ),
    .dout_valid            (rp_vld            ),
    .almost_empty          (                  ),
    .almost_full           (                  ),
    .empty                 (                  ),
    .full                  (                  )
);    




//---------------------------------------------------------------------------//
//--MEMORY_TYPE 
generate 

begin :MEMORY_TYPE               
if (RAM_TYPE == 0) 

//------------------------------------------------------------------------------//
//--DRAM

 Simple_Dual_Port_DRAM_XPM
  #(    
     .MEMORY_SIZE          (WDATA_WIDTH*(2**WADDR_WIDTH)            ),
     .WDATA_WIDTH          (WDATA_WIDTH                             ),
     .WADDR_WIDTH          (WADDR_WIDTH                             ),
     .RDATA_WIDTH          (RDATA_WIDTH                             ),
     .RADDR_WIDTH          (RADDR_WIDTH                             ),
     .READ_LATENCY         (READ_LATENCY                            ),
     .BYTE_WRITE_WIDTH_A   (BYTE_WRITE_WIDTH                        )     
 ) 
 INST_DRAM                                         
 (                                                                   
     .clk                  (clk                                     ),
     .wea                  ({(WDATA_WIDTH/BYTE_WRITE_WIDTH){wp_wen}}),
     .addra                ({waddr[4:0],wp_addr[WADDR_WIDTH-6:0]}   ),     
     .dina                 (wp_data                                 ),
     .addrb                ({raddr[4:0],rp_addr[RADDR_WIDTH-6:0]}   ),
     .doutb                (rp_data                                 )
 );  
   
 
else if (RAM_TYPE == 1) 
    
//------------------------------------------------------------------------------//
//--BRAM

 Simple_Dual_Port_BRAM_XPM
  #(    
     .MEMORY_SIZE          (WDATA_WIDTH*(2**WADDR_WIDTH)            ),
     .WDATA_WIDTH          (WDATA_WIDTH                             ),
     .WADDR_WIDTH          (WADDR_WIDTH                             ),
     .RDATA_WIDTH          (RDATA_WIDTH                             ),
     .RADDR_WIDTH          (RADDR_WIDTH                             ),
     .READ_LATENCY         (READ_LATENCY                            ),
     .BYTE_WRITE_WIDTH_A   (BYTE_WRITE_WIDTH                        )     
 ) 
 INST_BRAM                                        
 (                                                                   
     .clk                  (clk                                     ),
     .wea                  ({(WDATA_WIDTH/BYTE_WRITE_WIDTH){wp_wen}}),
     .addra                ({waddr[4:0],wp_addr[WADDR_WIDTH-6:0]}   ),     
     .dina                 (wp_data                                 ),
     .addrb                ({raddr[4:0],rp_addr[RADDR_WIDTH-6:0]}   ),
     .doutb                (rp_data                                 )
 );     

else 
//------------------------------------------------------------------------------//
//--URAM

 Simple_Dual_Port_URAM_XPM
  #(    
     .MEMORY_SIZE          (WDATA_WIDTH*(2**WADDR_WIDTH)            ),
     .WDATA_WIDTH          (WDATA_WIDTH                             ),
     .WADDR_WIDTH          (WADDR_WIDTH                             ),
     .RDATA_WIDTH          (RDATA_WIDTH                             ),
     .RADDR_WIDTH          (RADDR_WIDTH                             ),
     .READ_LATENCY         (READ_LATENCY                            ),
     .BYTE_WRITE_WIDTH_A   (BYTE_WRITE_WIDTH                        )     
 ) 
 INST_URAM                                         
 (                                                                   
     .clk                  (clk                                     ),
     .wea                  ({(WDATA_WIDTH/BYTE_WRITE_WIDTH){wp_wen}}),
     .addra                ({waddr[4:0],wp_addr[WADDR_WIDTH-6:0]}   ),     
     .dina                 (wp_data                                 ),
     .addrb                ({raddr[4:0],rp_addr[RADDR_WIDTH-6:0]}   ),
     .doutb                (rp_data                                 )
 ); 


end

endgenerate

//---------------------------------------------------------------------------//




endmodule
