`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2024 10:56:27 PM
// Design Name: 
// Module Name: rst_sync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rst_sync #
(
    parameter BUF_MODE  =2'b00,
    parameter integer SYNC_SHIFTREG_WIDTH = 8
)
(
	input		wire				clk,
	input		wire				rst,
	input   wire        pll_lock,

(* max_fanout = 120 *)	output		reg				o_rst
);

reg		[SYNC_SHIFTREG_WIDTH-1: 0]  rst_shift;

always @ (posedge clk or posedge rst)
begin
	if ( rst ) begin
        rst_shift <= {SYNC_SHIFTREG_WIDTH{1'b1}};
        o_rst     <= 1'b1 ;
    end
	else begin
		    rst_shift <= {rst_shift[SYNC_SHIFTREG_WIDTH-2: 0],~pll_lock};
        o_rst     <= rst_shift[SYNC_SHIFTREG_WIDTH-1];
    end
end


endmodule
