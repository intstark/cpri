

create_hw_axi_txn rd_txn_lite [get_hw_axis hw_axi_1] -address 00000034 -data 00004000 -type write -force ; run_hw_axi rd_txn_lite ;
create_hw_axi_txn rd_txn_lite [get_hw_axis hw_axi_1] -address 00100034 -data 00004000 -type write -force ; run_hw_axi rd_txn_lite ;
create_hw_axi_txn rd_txn_lite [get_hw_axis hw_axi_1] -address 00200034 -data 00004000 -type write -force ; run_hw_axi rd_txn_lite ;
create_hw_axi_txn rd_txn_lite [get_hw_axis hw_axi_1] -address 00300034 -data 00004000 -type write -force ; run_hw_axi rd_txn_lite ;

create_hw_axi_txn rd_txn_lite [get_hw_axis hw_axi_1] -address 00000038 -data 80000000 -type write -force ; run_hw_axi rd_txn_lite ;
create_hw_axi_txn rd_txn_lite [get_hw_axis hw_axi_1] -address 00100038 -data 80000000 -type write -force ; run_hw_axi rd_txn_lite ;
create_hw_axi_txn rd_txn_lite [get_hw_axis hw_axi_1] -address 00200038 -data 80000000 -type write -force ; run_hw_axi rd_txn_lite ;
create_hw_axi_txn rd_txn_lite [get_hw_axis hw_axi_1] -address 00300038 -data 80000000 -type write -force ; run_hw_axi rd_txn_lite ;

create_hw_axi_txn rd_txn_lite [get_hw_axis hw_axi_1] -address 00000038 -data 00000000 -type write -force ; run_hw_axi rd_txn_lite ;
create_hw_axi_txn rd_txn_lite [get_hw_axis hw_axi_1] -address 00100038 -data 00000000 -type write -force ; run_hw_axi rd_txn_lite ;
create_hw_axi_txn rd_txn_lite [get_hw_axis hw_axi_1] -address 00200038 -data 00000000 -type write -force ; run_hw_axi rd_txn_lite ;
create_hw_axi_txn rd_txn_lite [get_hw_axis hw_axi_1] -address 00300038 -data 00000000 -type write -force ; run_hw_axi rd_txn_lite ;
