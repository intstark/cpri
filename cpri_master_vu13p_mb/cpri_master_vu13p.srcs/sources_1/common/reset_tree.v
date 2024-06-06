`timescale 1ns / 1ps
/*
//----------------------------------------------------------------------------- 
//Copyright @2022 ,  zhongguancunchuangxinyuan. All rights reserved.
//Author(s)       :  zhangyunliang 
//Email           :  zhangyunliang@zgc-xnet.con
//Creation Date   :  2023-03-01
//File name       :  reset_tree.v
//-----------------------------------------------------------------------------
Module Name: reset_tree
Revision: 1.0
Signal description:
1) _i input
2) _o output
3) _n activ low
4) _dg debug signal 
5) _r delay or register
6) _s state mechine
*/
//////////////////////////////////////////////////////////////////////////////////

module reset_tree 
(
    input         clk    ,
    input         rst    ,
    output [31:0] rst_out 

) ;

    reg       rst_dly_1 = 1'b0 ; 
    reg       rst_dly_2 = 1'b0 ; 
    reg [2:0] rst_tree         ; 
    
    (* keep="true" *)(* max_fanout = 128 *)reg [31:0] rst_tree_net ;
    
    always @(posedge clk)
      begin 
        rst_dly_1 <= rst ;
        rst_dly_2 <= rst_dly_1 ;              
      end

    always @(posedge clk)
      begin               
        if( rst_dly_2 ==1'b1 )
            rst_tree <= 3'b111 ;
        else
            rst_tree <= {rst_tree[1:0], 1'b0} ;                                                             
      end 
    
    always @(posedge clk)
      begin                                                                    
        rst_tree_net <= {32{rst_tree[2]}} ;      
      end 
        
    assign  rst_out = rst_tree_net ;

endmodule     
