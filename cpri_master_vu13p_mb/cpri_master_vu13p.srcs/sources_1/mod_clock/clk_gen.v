`timescale 1ns / 1ps


module clk_gen (
    input       wire             i_ext_rst                  ,     
    input       wire             i_fpga_sysclk50m           ,     
    input       wire             i_clk_122_88_mhz_p         ,   
    input       wire             i_clk_122_88_mhz_n         ,
    input       wire             i_clk_100mhz_n             ,
    input       wire             i_clk_100mhz_p             ,    
    output      wire             o_clk_ext_100mhz           ,
    output      wire             o_rst_ext_100mhz           ,
    output      wire             o_clk_ext_25mhz           ,
    output      wire             o_rst_ext_25mhz           ,
    output      wire             o_clk_ext_400mhz           , 
    output      wire             o_rst_ext_400mhz           ,         
    output      wire             o_clk_300                  ,
    output      wire             o_rst_300                  ,
    output      wire             o_clk_250                  ,
    output      wire             o_rst_250                  ,
    output      wire             o_clk_100                  ,
    output      wire             o_rst_100                  ,
    output      wire             o_clk_491_52               ,
    output      wire             o_rst_491_52               ,
    output      wire             o_clk_368_64               ,
    output      wire             o_rst_368_64               ,
    output      wire             o_clk_245_76               ,
    output      wire             o_rst_245_76               ,
    output      wire             o_clk_122_88               ,
    output      wire             o_rst_122_88               ,
    output      wire             o_clk_61_44                ,
    output      wire             o_rst_61_44                 
);


//---------------------------------------------------------------------------//

    wire            pl_clk_122_88_out        ; 
    wire            pl_clk_122_88_mmcm       ;                             
    wire            clk_locked               ;
    wire            rst_locked               ;
    wire            clk_locked_100m          ;
    wire            rst_locked_100m          ;
    wire            gt_clk_122_88            ;
//---------------------------------------------------------------------------//
    
    reg  [15:0]     locked_cnt               ;
    wire [31:0]     rst_tree                 ;    
    wire            vio_reset                ;
    wire            locked_gen1              ;             
    wire            rst_locked_gen1          ;             
     reg            sys_rst_300mhz           ;
  

//---------------------------------------------------------------------------//

//vio_pll vio_pll (
//  .clk(i_fpga_sysclk50m),              // input wire clk
//  .probe_in0(locked_gen1),  // input wire [0 : 0] probe_in0
//  .probe_in1(clk_locked)  // input wire [0 : 0] probe_in1
//);
    
clk_wiz_gen50m u_clk_wiz_gen50m
( 
   .clk_out1    (o_clk_ext_100mhz          ),
   .clk_out2    (o_clk_ext_25mhz          ),
   .clk_out3    (o_clk_ext_400mhz          ),
   .reset       (i_ext_rst                 ),//i_ext_rst,vio_reset   
   .locked      (locked_gen1               ),
   .clk_in1     (i_fpga_sysclk50m          )
                                          
 );
 
 assign rst_locked_gen1 = ~locked_gen1;

//vio_sys_reset u_vio_sys_reset
//(
//   .clk         (o_clk_ext_300mhz         ),  // input wire clk
//   .probe_out0  (vio_reset                 )   // output wire [0 : 0] probe_out4
//); 

////-----------------------------------------------------------
//always @(posedge o_clk_ext_300mhz)
//begin
//    if(!locked_gen1)
//        locked_cnt <= 16'd0;
//    else if(!locked_cnt[15])
//        locked_cnt <= locked_cnt + 1'b1;
//    else 
//        locked_cnt <= locked_cnt;
//end
//
//
//always @(posedge o_clk_ext_300mhz)
//begin
//    if(!locked_gen1)
//        sys_rst_300mhz <= 1'b1;
//    else if( locked_cnt<=20100)
//        sys_rst_300mhz <= 1'b1;
//    else 
//        sys_rst_300mhz <= 1'b0;
//end

//
//reset_tree u_reset_tree
//(
//  .clk    	       (o_clk_ext_300mhz            ),	
//  .rst    	       (sys_rst_300mhz|vio_reset     ),
//  .rst_out	       (rst_tree                     )
//); 



   rst_sync #
    (
    .BUF_MODE            (1'b0),
    .SYNC_SHIFTREG_WIDTH (8   )
    )u_ext_400_rst_sync
    (
    .clk            (o_clk_ext_400mhz          ),
    .rst            (i_ext_rst |rst_locked_gen1 ),
    .pll_lock       (locked_gen1                ),
    .o_rst          (o_rst_ext_400mhz           )
    );
 

    rst_sync #
    (
    .BUF_MODE            (1'b0),
    .SYNC_SHIFTREG_WIDTH (8   )
    )u_ext_250_rst_sync
    (
    .clk            (o_clk_ext_25mhz          ),
    .rst            (i_ext_rst |rst_locked_gen1 ),
    .pll_lock       (locked_gen1                ),
    .o_rst          (o_rst_ext_25mhz           )
    );
    

    rst_sync #
    (
    .BUF_MODE            (1'b0),
    .SYNC_SHIFTREG_WIDTH (8   )
    )u_ext_100_rst_sync
    (
    .clk            (o_clk_ext_100mhz           ),
    .rst            (i_ext_rst |rst_locked_gen1 ),
    .pll_lock       (locked_gen1                ),
    .o_rst          (o_rst_ext_100mhz           )
    );    
//---------------------------------------------------------------------------//


//----------------------------*****------------------------*****-----------------------------//
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// clk_out1__100.00000______0.000______50.0_______96.283_____76.967
// clk_out2__250.00000______0.000______50.0_______81.911_____76.967
// clk_out3__300.00000______0.000______50.0_______79.341_____76.967
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary_________100.000____________0.010
//
//  IBUFDS #(
//   .DIFF_TERM("FALSE"),         // Differential Termination
//   .IBUF_LOW_PWR("TRUE"),       // Low power="TRUE", Highest performance="FALSE" 
//   .IOSTANDARD("LVDS")       // Specify the input I/O standard
//  )                             
//  IBUFDS_pll_100 (             
//      .O(o_clk_100 ),    // 1-bit output: Buffer output
//      .I(i_clk_100mhz_p),   // 1-bit input: Diff_p buffer input (connect directly to top-level port)
//      .IB(i_clk_100mhz_n)   // 1-bit input: Diff_n buffer input (connect directly to top-level port)
//  );
//     
 
//  clk_wiz_gen u_clk_wiz_gen
//   (
//    // Clock out ports
//    .clk_out1(o_clk_100),     // output clk_out1
//    .clk_out2(o_clk_250),     // output clk_out2
//    .clk_out3(o_clk_300),     // output clk_out3
//    // Status and control signals
//    .reset(i_ext_rst), // input reset
//    .locked(clk_locked_100m),       // output locked
//   // Clock in ports     
//    .clk_in1_p(i_clk_100mhz_p),    // input clk_in1_p
//    .clk_in1_n(i_clk_100mhz_n)   // input clk_in1_n
//   
//);     
//
//assign rst_locked_100m = ~clk_locked_100m;
//
//
//
//    rst_sync #
//    (
//    .BUF_MODE            (1'b0),
//    .SYNC_SHIFTREG_WIDTH (8   )
//    )u300_rst_sync
//    (
//    .clk            (o_clk_300                  ),
//    .rst            (i_ext_rst |rst_locked_100m ),
//    .pll_lock       (clk_locked_100m            ),
//    .o_rst          (o_rst_300                  )
//    );
// 
//
//    rst_sync #
//    (
//    .BUF_MODE            (1'b0),
//    .SYNC_SHIFTREG_WIDTH (8   )
//    )u250_rst_sync
//    (
//    .clk            (o_clk_250                  ),
//    .rst            (i_ext_rst |rst_locked_100m ),
//    .pll_lock       (clk_locked_100m            ),
//    .o_rst          (o_rst_250                  )
//    );
//    
//
//    rst_sync #
//    (
//    .BUF_MODE            (1'b0),
//    .SYNC_SHIFTREG_WIDTH (8   )
//    )u100_rst_sync
//    (
//    .clk            (o_clk_100                  ),
//    .rst            (i_ext_rst |rst_locked_100m ),
//    .pll_lock       (clk_locked_100m            ),
//    .o_rst          (o_rst_100                  )
//    );    
    
    
//----------------------------*****------------------------*****-----------------------------//
//--PLL
  IBUFDS #(
   .DIFF_TERM("FALSE"),         // Differential Termination
   .IBUF_LOW_PWR("TRUE"),       // Low power="TRUE", Highest performance="FALSE" 
   .IOSTANDARD("LVDS")       // Specify the input I/O standard
  )                             
  IBUFDS_pll_inst (             
      .O(pl_clk_122_88_out),    // 1-bit output: Buffer output
      .I(i_clk_122_88_mhz_p),   // 1-bit input: Diff_p buffer input (connect directly to top-level port)
      .IB(i_clk_122_88_mhz_n)   // 1-bit input: Diff_n buffer input (connect directly to top-level port)
  );

BUFG BUFG_inst (
      .O(pl_clk_122_88_mmcm), // 1-bit output: Clock output
      .I(pl_clk_122_88_out)  // 1-bit input: Clock input
);
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// clk_out1__491.52000______0.000______50.0_______72.638_____74.849
// clk_out2__368.64000______0.000______50.0_______76.514_____74.849
// clk_out3__245.76000______0.000______50.0_______82.359_____74.849
// clk_out4__122.88000______0.000______50.0_______93.480_____74.849
// clk_out5__61.44000 ______0.000______50.0______106.189_____74.849

//REFCLK_HROW_CK_SEL=(2'b00). fs
//REFCLK_HROW_CK_SEL=(2'b01). fs/2

//IBUFDS_GTE4 #(
//   .REFCLK_EN_TX_PATH(1'b0),     // Refer to Transceiver User Guide
//   .REFCLK_HROW_CK_SEL(2'b00),   // Refer to Transceiver User Guide, 
//   .REFCLK_ICNTL_RX(2'b00)       // Refer to Transceiver User Guide
//)
//IBUFDS_GTE4_inst (
//   .O(gt_clk_122_88),                     // 1-bit output: Refer to Transceiver User Guide
//   .ODIV2(pl_clk_122_88_out ),            // 1-bit output: Refer to Transceiver User Guide, REFCLK_HROW_CK_SEL=(2'b01). fs/2
//   .CEB(1'b0),                            // 1-bit input: Refer to Transceiver User Guide
//   .I(i_clk_122_88_mhz_p),                // 1-bit input: Refer to Transceiver User Guide,Diff_p buffer input (connect directly to top-level port)
//   .IB(i_clk_122_88_mhz_n)                // 1-bit input: Refer to Transceiver User Guide,Diff_n buffer input (connect directly to top-level port)
//);



//BUFG_GT BUFG_GT_inst (
//      .O(pl_clk_122_88_mmcm), // 1-bit output:Buffer
//      .CE(1'b1),                   // 1-bit input: Buffer enable
//      .CEMASK(1'b0),               // 1-bit input: CE Mask
//      .CLR(1'b0),                  // 1-bit input: Asynchronous clear
//      .CLRMASK(1'b0),              // 1-bit input: CLR Mask
//      .DIV(3'b000),                // 3-bit input: Dynamic divide Value
//      .I(pl_clk_122_88_out)        // 1-bit input: Buffer
//);


  
    clk_mmcm_gen u_clk_mmcm_gen
    (
    // Clock out ports
    .clk_out1(o_clk_491_52),     // output clk_out1
    .clk_out2(o_clk_368_64),     // output clk_out2
    .clk_out3(o_clk_245_76),     // output clk_out3
    .clk_out4(o_clk_122_88),     // output clk_out4
    .clk_out5(o_clk_61_44 ),     // output clk_out5
    // Status and control signals
    .reset(i_ext_rst), // input reset
    .locked(clk_locked),       // output locked
   // Clock in ports
    .clk_in1(pl_clk_122_88_mmcm)                // input clk_in1   
    
//    .clk_in1_p(i_clk_122_88_mhz_p),  // input clk_in1_p
//    .clk_in1_n(i_clk_122_88_mhz_n)   // input clk_in1_n
);  
assign rst_locked = ~clk_locked;

    rst_sync #
    (
    .BUF_MODE            (1'b0),
    .SYNC_SHIFTREG_WIDTH (8   )
    )u0_rst_sync
    (
    .clk            (o_clk_491_52           ),
    .rst            (i_ext_rst|rst_locked   ),
    .pll_lock       (clk_locked             ),
    .o_rst          (o_rst_491_52           )
    );

    rst_sync #
    (
    .BUF_MODE            (1'b0),
    .SYNC_SHIFTREG_WIDTH (8   )
    )u1_rst_sync
    (
    .clk            (o_clk_368_64           ),
    .rst            (i_ext_rst|rst_locked   ),
    .pll_lock       (clk_locked             ),
    .o_rst          (o_rst_368_64           )
    );
    
    rst_sync #
    (
    .BUF_MODE            (1'b0),
    .SYNC_SHIFTREG_WIDTH (8   )
    )u2_rst_sync
    (
    .clk            (o_clk_245_76           ),
    .rst            (i_ext_rst|rst_locked   ),
    .pll_lock       (clk_locked             ),
    .o_rst          (o_rst_245_76           )
    );

    rst_sync #
    (
    .BUF_MODE            (1'b0),
    .SYNC_SHIFTREG_WIDTH (8   )
    )u3_rst_sync
    (
    .clk            (o_clk_122_88           ),
    .rst            (i_ext_rst|rst_locked   ),
    .pll_lock       (clk_locked             ),
    .o_rst          (o_rst_122_88           )
    );

    rst_sync #
    (
    .BUF_MODE            (1'b0),
    .SYNC_SHIFTREG_WIDTH (8   )
    )u4_rst_sync
    (
    .clk            (o_clk_61_44            ),
    .rst            (i_ext_rst|rst_locked   ),
    .pll_lock       (clk_locked             ),
    .o_rst          (o_rst_61_44            )
    );
    


endmodule
