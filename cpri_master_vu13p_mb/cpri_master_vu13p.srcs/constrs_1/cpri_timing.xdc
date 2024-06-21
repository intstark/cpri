create_clock -period 20.000 [get_ports i_fpga_sysclk50m]
create_clock -period 10.000 [get_ports i_clk_100mhz_p]
create_clock -period 8.138 [get_ports i_clk_122_88_mhz_p]

# Transceiver reference clock
create_clock -period 4.069 -name refclk_b130 [get_ports gty_refclk2p]
create_clock -period 4.069 -name refclk_b131 [get_ports gty_refclk3p]


# The following GT Common input ports change with line rate, to avoid Vivado warnings set to absolute value for timing analysis.
#set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ SDM0DATA[*]} -of [get_cells -hier -filter {name =~ *gt*e*_common_gen.GT*E*_COMMON_PRIM_INST}]]
#
set_false_path -from [get_pins {u*_cpri_top/*.nodebfn_valid_reg[*]/C}] -to [get_pins {u*_cpri_top/*.gnrl_nodebfn_valid/bit_pipe_reg[*]/D}]

set_false_path -from [get_pins {u*_cpri_top/u_cpri_ch*/ch*_cpri/U0/cpri_i/cpri_i/link_manager_i/stat_code_i_reg[*]/C}] -to [get_pins {u*_cpri_top/IQ_ETH_GEN*.nodebfn_valid_reg[*]/D}]
set_false_path -from [get_pins {u*_cpri_top/u_cpri_ch*/ch*_cpri/U0/*/cpri_i/cpri_i/link_manager_i/stat_code_i_reg[*]/C}] -to [get_pins {u*_cpri_top/IQ_ETH_GEN*.nodebfn_valid_reg[*]/D}]

set_false_path -from [get_pins {u*_sys_tbu/u_sys_frame_info_gen*/o_frame_num_reg[*]/C}] -to [get_pins {u*_cpri_top/u*_iq_gen_tbu/o_nodebfn_tx_nr_reg[*]/D}]
set_false_path -from [get_pins u*_sys_tbu/u_sys_frame_info_gen*/o_frame_head_reg/C] -to [get_pins u*_cpri_top/u*_iq_gen_tbu/ref_10ms_hd*/D]
set_false_path -from [get_pins {u1_cpri_top/u_cpri*/u_tx_pole_vio/inst/PROBE_OUT_ALL_INST/G_PROBE_OUT[*].PROBE_OUT*_INST/Probe_out_reg[*]/C}] 
set_false_path -from [get_pins {u1_cpri_top/vio_top/inst/PROBE_OUT_ALL_INST/G_PROBE_OUT[0].PROBE_OUT0_INST/Probe_out_reg[0]/C}] -to [get_pins u*_cpri_top/u_clk_gen/u*_rst_sync/*rst*/PRE]
#set_false_path -from [get_pins {IQ_ETH_GEN*.nodebfn_valid_reg[*]/C}] -to [get_pins {IQ_ETH_GEN*.u_eth_mii_test/mii_state_reg[*]/CE}]
#set_false_path -from [get_pins {IQ_ETH_GEN*.nodebfn_valid_reg[*]/C}] -to [get_pins {IQ_ETH_GEN*.u_eth_mii_test/frame_fcs_reg[*]/R}]
#set_false_path -from [get_pins {IQ_ETH_GEN*.nodebfn_valid_reg[*]/C}] -to [get_pins {IQ_ETH_GEN*.u_eth_mii_test/frame_fcs_reg[*]/CE}]

set_false_path -to [get_pins u_ila*/inst/PROBE_PIPE.shift_probes*/D]
# The following GT Common input ports change with line rate, to avoid Vivado warnings set to absolute value for timing analysis.
#set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ SDM0DATA[*]} -of [get_cells -hier -filter {name =~ *gt*e*_common_gen.GT*E*_COMMON_PRIM_INST}]]