#----------------------------------------------------------------------
# Title      : Example top level constraints for CPRI
# Project    : cpri_v8_11_17
#----------------------------------------------------------------------
# File       : cpri_example.xdc
# Author     : AMD
#----------------------------------------------------------------------
# Description: User Constraint file for the CPRI example design.
#----------------------------------------------------------------------
# (c) Copyright 2023 Advanced Micro Devices, Inc. All rights reserved.
#
# This file contains confidential and proprietary information
# of AMD and is protected under U.S. and international copyright
# and other intellectual property laws.
#
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# AMD, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# (2) AMD shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or AMD had been advised of the
# possibility of the same.
#
# CRITICAL APPLICATIONS
# AMD products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of AMD products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.
#----------------------------------------------------------------------

# Transceiver reference clock
create_clock -name refclk -period 4.069 [get_ports refclk_p]

# The following GT Common input ports change with line rate, to avoid Vivado warnings set to absolute value for timing analysis.
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ SDM0DATA[*]} -of [get_cells -hier -filter {name =~ *gt*e*_common_gen.GT*E*_COMMON_PRIM_INST}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ SDM1DATA[*]} -of [get_cells -hier -filter {name =~ *gt*e*_common_gen.GT*E*_COMMON_PRIM_INST}]]

# The following BUFG_GT input pins change with line rate, to avoid Vivado warnings set to absolute value for timing analysis.
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[2]} -of [get_cells -hier -filter {name =~ *txusrclk_bufg0}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[1]} -of [get_cells -hier -filter {name =~ *txusrclk_bufg0}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[0]} -of [get_cells -hier -filter {name =~ *txusrclk_bufg0}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[2]} -of [get_cells -hier -filter {name =~ *txusrclk2_bufg0}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[1]} -of [get_cells -hier -filter {name =~ *txusrclk2_bufg0}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[0]} -of [get_cells -hier -filter {name =~ *txusrclk2_bufg0}]]

# Auxiliary clock
create_clock -name aux_clk -period 10.000 [get_ports s_axi_aclk]

# Reset block clock
# Slower than transceiver user clock @ lowest supported line rate
create_clock -name reset_block_clk -period 20.000 [get_ports gtwiz_reset_clk_freerun_in]

# Ethernet clock
create_clock -name eth_ref_clk -period 40.000 [get_ports eth_ref_clk]

# High resolution clock
create_clock -name hires_clk -period 2.631 [get_ports hires_clk]


################################################################################
# Example Transceiver Location Constraints.
# The GT and Refclk locations are selected in the CPRI GUI, but can be overriden here.
# Place the reference clock IBUFDS in the same clocking region as the common block.
# Full details of available transceiver locations can be found in the UltraScale documentation.
# These are example constraints, please use correct locations for your chosen device.
#set_property LOC GTYE4_CHANNEL_X1Y10 [get_cells cpri_block_i/cpri_i/U0/gt_and_clocks_i/cpri_0_gt_i/inst/gen_gtwizard_gtye4_top.cpri_0_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[*].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTHE3_CHANNEL_PRIM_INST]
set_property LOC GTYE4_COMMON_X1Y10 [get_cells refclk_ibufds]

# Example design IO constraints
set_false_path -from [get_pins -filter {REF_PIN_NAME =~ C} -of [get_cells recclkout_gen]] -to [get_ports recclk_out]
