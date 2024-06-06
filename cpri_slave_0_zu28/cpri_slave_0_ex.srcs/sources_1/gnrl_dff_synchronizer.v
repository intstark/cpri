//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/08 10:05:13
// Design Name: 
// Module Name: gnrl_dff_synchronizer
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
`timescale 1ns / 1ps



module gnrl_dff_synchronizer # (STAGES = 2)(
    input   i_clk,
    input   i_bit,
    output  o_bit
);

(* ASYNC_REG = "True" *) reg  [STAGES-1:0]    bit_pipe = {STAGES{1'b0}};


always @ (posedge i_clk)begin
    bit_pipe <= {bit_pipe[STAGES-2:0],i_bit};
end

assign o_bit = bit_pipe[STAGES-1];


endmodule