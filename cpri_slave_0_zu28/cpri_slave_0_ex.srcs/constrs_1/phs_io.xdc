
set_property PACKAGE_PIN Y31 [get_ports refclk1_p]


#------------------ SFP 0 1 2 3 ------------------

set_property PACKAGE_PIN  Y35     [get_ports {sfp_txp[0]}]
set_property PACKAGE_PIN  AA38    [get_ports {sfp_rxp[0]}]
set_property PACKAGE_PIN  V35     [get_ports {sfp_txp[1]}]
set_property PACKAGE_PIN  W38     [get_ports {sfp_rxp[1]}]
set_property PACKAGE_PIN  T35     [get_ports {sfp_txp[2]}]
set_property PACKAGE_PIN  U38     [get_ports {sfp_rxp[2]}]
set_property PACKAGE_PIN  R33     [get_ports {sfp_txp[3]}]
set_property PACKAGE_PIN  R38     [get_ports {sfp_rxp[3]}]

#--tx_disable_b=0 OPEN

set_property PACKAGE_PIN G12      [get_ports {sfp_tx_disable[0]}]
set_property PACKAGE_PIN G10      [get_ports {sfp_tx_disable[1]}]
set_property PACKAGE_PIN K12      [get_ports {sfp_tx_disable[2]}]
set_property PACKAGE_PIN J7       [get_ports {sfp_tx_disable[3]}]
set_property IOSTANDARD LVCMOS12  [get_ports {sfp_tx_disable[0]}]
set_property IOSTANDARD LVCMOS12  [get_ports {sfp_tx_disable[1]}]
set_property IOSTANDARD LVCMOS12  [get_ports {sfp_tx_disable[2]}]
set_property IOSTANDARD LVCMOS12  [get_ports {sfp_tx_disable[3]}]

set_property PACKAGE_PIN AM15 [get_ports {i_sysclk_p[0]}]
set_property PACKAGE_PIN AL17 [get_ports {i_sysclk_p[1]}]
set_property IOSTANDARD LVDS  [get_ports {i_sysclk_p[*]}]

set_property PACKAGE_PIN AW14 [get_ports o_recclk_p]
set_property IOSTANDARD LVDS  [get_ports o_recclk_p]

set_property PACKAGE_PIN AV16     [get_ports io_zynq_iic_scl]
set_property PACKAGE_PIN AV13     [get_ports io_zynq_iic_sda]
set_property IOSTANDARD LVCMOS18  [get_ports io_zynq_iic_scl]
set_property IOSTANDARD LVCMOS18  [get_ports io_zynq_iic_sda]