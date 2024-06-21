

module param_rec_mem(
    input                           i_clk               ,
    input          [3:0][3:0]       i_stat_code         ,

    output         [  31: 0]        o_mem_addr          ,
    output         [  31: 0]        o_mem_din           ,
    input          [  31: 0]        i_mem_dout          ,
    output                          o_mem_en            ,
    output                          o_mem_rst           ,
    output         [   3: 0]        o_mem_we            ,
    output         [  31: 0]        o_gpio

);


localparam SLAVE0_TOFFSET_ADDR = 32'h0000_0000;
localparam SLAVE1_TOFFSET_ADDR = 32'h0000_0001;



reg            [  31: 0]        mem_addr            ;
reg                             mem_en              ;
reg                             mem_rst             ;
reg            [  31: 0]        mem_din             ;
reg            [   3: 0]        mem_we              ;
reg                             link_is_up          ;

wire           [  31: 0]        vio_slave_delay     ;
wire           [  31: 0]        vio_gpio            ;
reg            [  31: 0]        slave_delay         ;
reg                             mem_wr_done         ;
reg            [   7: 0]        dly_cnt             ;
reg            [  31: 0]        gpio_dout           ;




always @(posedge i_clk) begin
    if(&i_stat_code)
        link_is_up <= 1'b1;
    else
        link_is_up <= 1'b0;
end


always @(posedge i_clk) begin
    if(vio_slave_delay != slave_delay)
        mem_en <= 1'b1;
    else
        mem_en <= 1'b0;
end

always @(posedge i_clk) begin
    if(mem_en)
        mem_wr_done <= 1'b1;
    else if(mem_wr_done) begin
        if(dly_cnt==8'hff)
            mem_wr_done <= 1'b0;
        else
            dly_cnt <= dly_cnt + 8'd1;
    end else begin
        dly_cnt <= 8'd0;
    end
end


always @(posedge i_clk) begin
    gpio_dout <= vio_gpio | {31'b0, mem_wr_done};
end


always @(posedge i_clk) begin
    slave_delay <= vio_slave_delay;
end


always @ (posedge i_clk)begin
    mem_addr  <= SLAVE1_TOFFSET_ADDR;
    mem_din   <= vio_slave_delay;
    mem_we    <= 4'b1111;
    mem_rst   <= 1'b0;
end




assign o_mem_addr = mem_addr ;
assign o_mem_en   = mem_en   ;
assign o_mem_din  = mem_din  ;
assign o_mem_we   = mem_we   ;
assign o_mem_rst  = mem_rst  ;
assign o_gpio     = gpio_dout;


vio_gpio_wrap                           vio_gpio_wrap(
    .clk                                (i_clk              ),
    .probe_out0                         (vio_slave_delay    ),
    .probe_out1                         (vio_gpio           ) 
);


ila_param_mem                           ila_param_mem(
    .clk                                (i_clk              ),

    .probe0                             (i_mem_dout         ),
    .probe1                             (mem_addr           ),
    .probe2                             (mem_din            ),
    .probe3                             (mem_we             ),
    .probe4                             (mem_rst            ),
    .probe5                             (mem_en             ) 
);







endmodule
