create_clock -period 10.000 [get_ports i_sysclk_p[0]]
create_clock -period 4.000  [get_ports i_sysclk_p[1]]

# Transceiver reference clock
create_clock -name refclk0_b128 -period 4.069 [get_ports refclk0_p]
create_clock -name refclk1_b128 -period 4.069 [get_ports refclk1_p]

set_false_path -from [get_pins {*/*.nodebfn_valid_reg[*]/C}] -to [get_pins {*/*.gnrl_nodebfn_valid/bit_pipe_reg[*]/D}]
set_false_path -from [get_pins {*/cpri_ch*/U0/cpri_i/cpri_i/link_manager_i/stat_code_i_reg[*]/C}] -to [get_pins {*/iq_test_patten[*].nodebfn_valid_reg[*]/D}]
set_false_path -from [get_pins {*/cpri_ch*/cpri_i/U0/cpri_i/cpri_i/link_manager_i/stat_code_i_reg[*]/C}] -to [get_pins {*/iq_test_patten[*].nodebfn_valid_reg[*]/D}]

# The following BUFG_GT input pins change with line rate, to avoid Vivado warnings set to absolute value for timing analysis.
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[2]} -of [get_cells -hier -filter {name =~ *txusrclk_bufg0}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[1]} -of [get_cells -hier -filter {name =~ *txusrclk_bufg0}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[0]} -of [get_cells -hier -filter {name =~ *txusrclk_bufg0}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[2]} -of [get_cells -hier -filter {name =~ *txusrclk2_bufg0}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[1]} -of [get_cells -hier -filter {name =~ *txusrclk2_bufg0}]]
set_case_analysis 0 [get_pins -filter {REF_PIN_NAME =~ DIV[0]} -of [get_cells -hier -filter {name =~ *txusrclk2_bufg0}]]