set_property PACKAGE_PIN AV26 [get_ports i_fpga_sysclk50m]

###100M

set_property PACKAGE_PIN AV23 [get_ports i_clk_100mhz_p]
set_property PACKAGE_PIN AW23 [get_ports i_clk_100mhz_n]


###122.88M

set_property PACKAGE_PIN AV24 [get_ports i_clk_122_88_mhz_p]
set_property PACKAGE_PIN AW24 [get_ports i_clk_122_88_mhz_n]



###33.333M##

#create_clock -period 30.000 -name clk [get_ports FPGA_SYSCLK33]
set_property PACKAGE_PIN AY22 [get_ports FPGA_SYSCLK33]


##gtrefclk lock constraints

#bnak130
#bnak131


###--2

#set_property LOC GTYE4_CHANNEL_X0Y40 [get_cells {u_cpri_ch_3_0/ch0_cpri/U0/cpri_block_i/gt_and_clocks_i/cpri24gwshared_gt_i/inst/gen_gtwizard_gtye4_top.cpri24gwshared_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[11].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
set_property LOC GTYE4_CHANNEL_X0Y40 [get_cells {u1_cpri_top/u_cpri_ch_3_0/ch0_cpri/U0/cpri_block_i/gt_and_clocks_i/cpri24gwshared_gt_i/inst/gen_gtwizard_gtye4_top.cpri24gwshared_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[11].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
set_property PACKAGE_PIN U45 [get_ports {QSFP2_RXP[0]}]
set_property PACKAGE_PIN U46 [get_ports {QSFP2_RXN[0]}]
set_property PACKAGE_PIN U40 [get_ports {QSFP2_TXP[0]}]
set_property PACKAGE_PIN U41 [get_ports {QSFP2_TXN[0]}]
##--3



##//bank 126
#set_property PACKAGE_PIN  BE25	[get_ports FPGA_QSFP0_MODPRSL]
#set_property PACKAGE_PIN  BF25	[get_ports FPGA_QSFP0_INT_L]
#set_property PACKAGE_PIN  BB26	[get_ports FPGA_QSFP0_LPMODE]
#set_property PACKAGE_PIN  BB25	[get_ports FPGA_QSFP0_RESET_L]
#set_property PACKAGE_PIN  BA25	[get_ports FPGA_QSFP0_MODSEL]
##//bank 127
#set_property PACKAGE_PIN  AP24	[get_ports FPGA_QSFP1_MODPRSL]
#set_property PACKAGE_PIN  AL22	[get_ports FPGA_QSFP1_INT_L]
#set_property PACKAGE_PIN  AM21	[get_ports FPGA_QSFP1_LPMODE]
#set_property PACKAGE_PIN  AL21	[get_ports FPGA_QSFP1_RESET_L]
#set_property PACKAGE_PIN  AM22	[get_ports FPGA_QSFP1_MODSEL]
##//bank 130
set_property PACKAGE_PIN AU27 [get_ports FPGA_QSFP2_MODPRSL]
set_property PACKAGE_PIN AR27 [get_ports FPGA_QSFP2_INT_L]
set_property PACKAGE_PIN AT28 [get_ports FPGA_QSFP2_LPMODE]
set_property PACKAGE_PIN AR28 [get_ports FPGA_QSFP2_RESET_L]
set_property PACKAGE_PIN AT27 [get_ports FPGA_QSFP2_MODSEL]
##//bank 131
set_property PACKAGE_PIN BA28 [get_ports FPGA_QSFP3_MODPRSL]
set_property PACKAGE_PIN AY26 [get_ports FPGA_QSFP3_INT_L]
set_property PACKAGE_PIN AY28 [get_ports FPGA_QSFP3_LPMODE]
set_property PACKAGE_PIN AW28 [get_ports FPGA_QSFP3_RESET_L]
set_property PACKAGE_PIN AY27 [get_ports FPGA_QSFP3_MODSEL]


##//bank 130
set_property IOSTANDARD LVCMOS18 [get_ports FPGA_QSFP2_MODPRSL]
set_property IOSTANDARD LVCMOS18 [get_ports FPGA_QSFP2_INT_L]
set_property IOSTANDARD LVCMOS18 [get_ports FPGA_QSFP2_LPMODE]
set_property IOSTANDARD LVCMOS18 [get_ports FPGA_QSFP2_RESET_L]
set_property IOSTANDARD LVCMOS18 [get_ports FPGA_QSFP2_MODSEL]
##//bank 131
set_property IOSTANDARD LVCMOS18 [get_ports FPGA_QSFP3_MODPRSL]
set_property IOSTANDARD LVCMOS18 [get_ports FPGA_QSFP3_INT_L]
set_property IOSTANDARD LVCMOS18 [get_ports FPGA_QSFP3_LPMODE]
set_property IOSTANDARD LVCMOS18 [get_ports FPGA_QSFP3_RESET_L]
set_property IOSTANDARD LVCMOS18 [get_ports FPGA_QSFP3_MODSEL]

################################################################


set_property IOSTANDARD LVCMOS18 [get_ports i_fpga_sysclk50m]
set_property IOSTANDARD LVDS [get_ports i_clk_100mhz_p]
set_property IOSTANDARD LVDS [get_ports i_clk_100mhz_n]
set_property IOSTANDARD LVDS [get_ports i_clk_122_88_mhz_p]
set_property IOSTANDARD LVDS [get_ports i_clk_122_88_mhz_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports i_clk_122_88_mhz_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports i_clk_122_88_mhz_n]
set_property IOSTANDARD LVCMOS18 [get_ports FPGA_SYSCLK33]

set_property LOC GTYE4_CHANNEL_X0Y41 [get_cells {u1_cpri_top/u_cpri_ch_3_0/ch1_cpri/U0/gt_and_clocks_i/cpri_0_gt_i/inst/gen_gtwizard_gtye4_top.cpri_0_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[34].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
set_property PACKAGE_PIN T43 [get_ports {QSFP2_RXP[1]}]
set_property PACKAGE_PIN T44 [get_ports {QSFP2_RXN[1]}]
set_property PACKAGE_PIN T38 [get_ports {QSFP2_TXP[1]}]
set_property PACKAGE_PIN T39 [get_ports {QSFP2_TXN[1]}]
#set_property LOC GTYE4_CHANNEL_X0Y41 [get_cells -hierarchical -filter {NAME =~ *u_cpri_ch_3_0/ch1_cpri/*gen_gtwizard_gtye4.gen_channel_container[*].*gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
#set_property LOC GTYE4_CHANNEL_X1Y40 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[34].*gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
set_property PACKAGE_PIN R45 [get_ports {QSFP2_RXP[2]}]
set_property PACKAGE_PIN R46 [get_ports {QSFP2_RXN[2]}]
set_property PACKAGE_PIN R40 [get_ports {QSFP2_TXP[2]}]
set_property PACKAGE_PIN R41 [get_ports {QSFP2_TXN[2]}]
#set_property LOC GTYE4_CHANNEL_X0Y42 [get_cells -hierarchical -filter {NAME =~ *u_cpri_ch_3_0/ch2_cpri/*gen_gtwizard_gtye4.gen_channel_container[*].*gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
set_property PACKAGE_PIN P43 [get_ports {QSFP2_RXP[3]}]
set_property PACKAGE_PIN P44 [get_ports {QSFP2_RXN[3]}]
set_property PACKAGE_PIN P38 [get_ports {QSFP2_TXP[3]}]
set_property PACKAGE_PIN P39 [get_ports {QSFP2_TXN[3]}]
#set_property LOC GTYE4_CHANNEL_X0Y43 [get_cells -hierarchical -filter {NAME =~ *u_cpri_ch_3_0/ch3_cpri/*gen_gtwizard_gtye4.gen_channel_container[*].*gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
set_property PACKAGE_PIN N45 [get_ports {QSFP3_RXP[0]}]
set_property PACKAGE_PIN N46 [get_ports {QSFP3_RXN[0]}]
set_property PACKAGE_PIN N40 [get_ports {QSFP3_TXP[0]}]
set_property PACKAGE_PIN N41 [get_ports {QSFP3_TXN[0]}]
#set_property LOC GTYE4_CHANNEL_X0Y44 [get_cells -hierarchical -filter {NAME =~ *u_cpri_ch_7_4/ch0_cpri/*gen_gtwizard_gtye4.gen_channel_container[*].*gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
set_property PACKAGE_PIN M43 [get_ports {QSFP3_RXP[1]}]
set_property PACKAGE_PIN M44 [get_ports {QSFP3_RXN[1]}]
set_property PACKAGE_PIN M38 [get_ports {QSFP3_TXP[1]}]
set_property PACKAGE_PIN M39 [get_ports {QSFP3_TXN[1]}]
#set_property LOC GTYE4_CHANNEL_X0Y45 [get_cells -hierarchical -filter {NAME =~ *u_cpri_ch_7_4/ch1_cpri/*gen_gtwizard_gtye4.gen_channel_container[*].*gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
set_property PACKAGE_PIN L45 [get_ports {QSFP3_RXP[2]}]
set_property PACKAGE_PIN L46 [get_ports {QSFP3_RXN[2]}]
set_property PACKAGE_PIN L40 [get_ports {QSFP3_TXP[2]}]
set_property PACKAGE_PIN L41 [get_ports {QSFP3_TXN[2]}]
#set_property LOC GTYE4_CHANNEL_X0Y46 [get_cells -hierarchical -filter {NAME =~ *u_cpri_ch_7_4/ch2_cpri/*gen_gtwizard_gtye4.gen_channel_container[*].*gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
set_property PACKAGE_PIN K43 [get_ports {QSFP3_RXP[3]}]
set_property PACKAGE_PIN K44 [get_ports {QSFP3_RXN[3]}]
set_property PACKAGE_PIN J40 [get_ports {QSFP3_TXP[3]}]
set_property PACKAGE_PIN J41 [get_ports {QSFP3_TXN[3]}]
#set_property LOC GTYE4_CHANNEL_X0Y47 [get_cells -hierarchical -filter {NAME =~ *u_cpri_ch_7_4/ch3_cpri/*gen_gtwizard_gtye4.gen_channel_container[*].*gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
#set_property PACKAGE_PIN W37 [get_ports gty_refclk2n]
#set_property PACKAGE_PIN W36 [get_ports gty_refclk2p]
#set_property LOC GTYE4_COMMON_X0Y10 [get_cells -hierarchical -filter {NAME =~ *u_cpri_ch_3_0/IBUFDS_GTE4_inst}]

set_property PACKAGE_PIN N36 [get_ports gty_refclk2p]
set_property PACKAGE_PIN U36 [get_ports gty_refclk3p]

#set_property PACKAGE_PIN R37 [get_ports gty_refclk3n]
#set_property PACKAGE_PIN R36 [get_ports gty_refclk3p]
#set_property LOC GTYE4_COMMON_X0Y11 [get_cells -hierarchical -filter {NAME =~ *u_cpri_ch_7_4/IBUFDS_GTE4_inst}]


