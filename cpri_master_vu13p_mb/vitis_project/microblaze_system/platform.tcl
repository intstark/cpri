# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct E:\ZJYJY\Product\VU13P\prj\STD_CPRI_LEE\cpri_master_vu13p_mb\vitis_project\microblaze_system\platform.tcl
# 
# OR launch xsct and run below command.
# source E:\ZJYJY\Product\VU13P\prj\STD_CPRI_LEE\cpri_master_vu13p_mb\vitis_project\microblaze_system\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {microblaze_system}\
-hw {E:\ZJYJY\Product\VU13P\prj\STD_CPRI_LEE\cpri_master_vu13p_mb\vitis_project\bbu_top.xsa}\
-proc {microblaze_0} -os {standalone} -fsbl-target {psu_cortexa53_0} -out {E:/ZJYJY/Product/VU13P/prj/STD_CPRI_LEE/cpri_master_vu13p_mb/vitis_project}

platform write
platform generate -domains 
platform active {microblaze_system}
platform generate
platform active {microblaze_system}
platform config -updatehw {E:/ZJYJY/Product/VU13P/prj/STD_CPRI_LEE/cpri_master_vu13p_mb/vitis_project/bbu_top.xsa}
bsp reload
catch {bsp regenerate}
platform clean
platform generate
platform active {microblaze_system}
platform config -updatehw {E:/ZJYJY/Product/VU13P/prj/STD_CPRI_LEE/cpri_master_vu13p_mb20240604/vitis_project/bbu_top.xsa}
platform active {microblaze_system}
platform generate -domains 
platform config -updatehw {E:/ZJYJY/Product/VU13P/prj/STD_CPRI_LEE/cpri_master_vu13p_mb/vitis_project/bbu_top.xsa}
bsp reload
catch {bsp regenerate}
platform clean
platform generate
platform active {microblaze_system}
platform config -updatehw {E:/ZJYJY/Product/VU13P/prj/STD_CPRI_LEE/cpri_master_vu13p_mb/vitis_project/bbu_top.xsa}
bsp reload
catch {bsp regenerate}
platform clean
platform generate
bsp reload
catch {bsp regenerate}
platform clean
platform generate
platform clean
platform generate
platform active {microblaze_system}
platform generate -domains 
platform generate
platform active {microblaze_system}
platform config -updatehw {E:/ZJYJY/Product/VU13P/prj/STD_CPRI_LEE/cpri_master_vu13p_mb/vitis_project/bbu_top.xsa}
bsp reload
catch {bsp regenerate}
platform clean
platform generate
platform active {microblaze_system}
platform config -updatehw {E:/ZJYJY/Product/VU13P/prj/STD_CPRI_LEE/cpri_master_vu13p_mb/vitis_project/bbu_top.xsa}
bsp reload
catch {bsp regenerate}
platform clean
platform generate
platform active {microblaze_system}
platform config -updatehw {E:/ZJYJY/Product/VU13P/prj/STD_CPRI_LEE/cpri_master_vu13p_mb/vitis_project/bbu_top.xsa}
bsp reload
catch {bsp regenerate}
platform clean
platform generate
