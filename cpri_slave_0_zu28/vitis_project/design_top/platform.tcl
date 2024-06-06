# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct D:\ZJYJY\Product\ZU28DR\cpri_slave_0_ex\vitis_project\design_top\platform.tcl
# 
# OR launch xsct and run below command.
# source D:\ZJYJY\Product\ZU28DR\cpri_slave_0_ex\vitis_project\design_top\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {design_top}\
-hw {D:\ZJYJY\Product\ZU28DR\cpri_slave_0_ex\vitis_project\design_top.xsa}\
-fsbl-target {psu_cortexr5_0} -out {D:/ZJYJY/Product/ZU28DR/cpri_slave_0_ex/vitis_project}

platform write
domain create -name {standalone_psu_cortexr5_0} -display-name {standalone_psu_cortexr5_0} -os {standalone} -proc {psu_cortexr5_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {design_top}
domain active {zynqmp_fsbl}
domain active {zynqmp_pmufw}
domain active {standalone_psu_cortexr5_0}
platform generate -quick
platform generate
platform generate
platform generate
