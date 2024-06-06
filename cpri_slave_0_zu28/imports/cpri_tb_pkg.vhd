-----------------------------------------------------------------------
-- Title      : Testbench Package for CPRI tests
-- Project    : cpri_v8_11_5
-----------------------------------------------------------------------
-- File       : cpri_tb_pkg.vhd
-- Author     : Xilinx
-------------------------------------------------------------------------------
-- Description: Testbench harness package.
--              This provides various management i/f procedure and defines
--              the necessary constants.
-------------------------------------------------------------------------------
-- (c) Copyright 2004 - 2019 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES. 
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package cpri_tb_pkg is

type do_typ is (mgmnt_read, mgmnt_write);
subtype add_typ is std_logic_vector(11 downto 0);
subtype stat_typ is std_logic_vector(3 downto 0);
subtype stat_alarm_typ is std_logic;
subtype speed_typ is std_logic_vector(14 downto 0);
subtype hdlc_typ is std_logic_vector(2 downto 0);
subtype dat_typ is std_logic_vector(31 downto 0);
subtype proto_typ is std_logic_vector(7 downto 0);
subtype txalarms_typ is std_logic_vector(27 downto 0);
subtype eth_ptr_typ is std_logic_vector(5 downto 0);
subtype reset_field_typ is std_logic;
subtype sdi_typ is std_logic;
subtype seed_typ is std_logic_vector(30 downto 0);
subtype fec_error_inj_rate_typ is std_logic_vector(3 downto 0);
subtype fec_error_inj_seed_typ is std_logic_vector(5 downto 0);

-- CPRI Management address map
constant STATUS_CODE_AND_ALARM        : add_typ := x"000";
constant MISC_STATUS                  : add_typ := x"004";
constant CURRENT_HDLC_RATE            : add_typ := x"008";
constant CURRENT_ETHERNET_POINTER     : add_typ := x"00C";
constant RCV_SUBCHAN2_WORD0           : add_typ := x"010";
constant RCV_SUBCHAN2_WORD1           : add_typ := x"014";
constant RCV_SUBCHAN2_WORD2           : add_typ := x"018";
constant RCV_SUBCHAN2_WORD3           : add_typ := x"01C";
constant ETHERNET_RESET_REQ           : add_typ := x"020";
constant RESERVED1                    : add_typ := x"024";
constant PREF_HDLC_RATE               : add_typ := x"028";
constant PREF_ETHERNET_POINTER        : add_typ := x"02C";
constant CURRENT_LINE_SPEED           : add_typ := x"030";
constant LINE_SPEED_CAPABILITY        : add_typ := x"034";
constant TX_CPRI_ALARMS               : add_typ := x"038";
constant RESERVED2                    : add_typ := x"03C";
constant CURRENT_PROTOCOL_VER         : add_typ := x"040";
constant PREF_PROTOCOL_VER            : add_typ := x"044";
constant TX_SEED                      : add_typ := x"048";
constant RX_SEED                      : add_typ := x"04C";
constant IQ_FRAME_COUNT               : add_typ := x"100";
constant RX_NODEBFN_NUMBER            : add_typ := x"104";
constant IQ_ERROR_COUNT               : add_typ := x"108";
constant HDLC_BIT_COUNT               : add_typ := x"10C";
constant HDLC_ERROR_COUNT             : add_typ := x"110";
constant VENDOR_WORD_COUNT            : add_typ := x"114";
constant VENDOR_ERROR_COUNT           : add_typ := x"118";
constant ETH_TRANSMIT_COUNT           : add_typ := x"11C";
constant ETH_RECEIVE_COUNT            : add_typ := x"120";
constant ETH_ERROR_COUNT              : add_typ := x"124";
constant FEC_CONTROL                  : add_typ := x"07C";

constant CPRI_PROTOCOL_V1             : std_logic_vector(7 downto 0) := "00000001";

constant HDLC_NOHDLC                  : hdlc_typ := "000";
constant HDLC_240                     : hdlc_typ := "001";
constant HDLC_480                     : hdlc_typ := "010";
constant HDLC_960                     : hdlc_typ := "011";
constant HDLC_1920                    : hdlc_typ := "100";
constant HDLC_2400                    : hdlc_typ := "101";
constant HDLC_FAST                    : hdlc_typ := "110";

constant STAT_RESET                   : stat_typ := "0000";
constant STAT_L1SYN                   : stat_typ := "0001";
constant STAT_PROTO                   : stat_typ := "0010";
constant STAT_L2SET                   : stat_typ := "0011";
constant STAT_PASSI                   : stat_typ := "1011";
constant STAT_OPERA                   : stat_typ := "1111";

constant SLAVE_TX_ENABLE_BIT          : integer := 8;
constant ALARM_BIT                    : integer := 4;
constant HDLC_RATE                    : integer := 16;
constant SDI_BIT                      : integer := 2;
constant CPRI_LINK_RESET_BIT          : integer := 0;

constant SPEED_CAP_RESET              : speed_typ := "000000000000000";
constant SPEED_CAP_614                : speed_typ := "000000000000001";
constant SPEED_CAP_1228               : speed_typ := "000000000000011";
constant SPEED_CAP_2457               : speed_typ := "000000000000111";
constant SPEED_CAP_3072               : speed_typ := "000000000001111";
constant SPEED_CAP_4915               : speed_typ := "000000000011111";
constant SPEED_CAP_6144               : speed_typ := "000000000111111";
constant SPEED_CAP_9830               : speed_typ := "000000001111111";
constant SPEED_CAP_10137              : speed_typ := "000000011111111";
constant SPEED_CAP_8110               : speed_typ := "000000111111111";
constant SPEED_CAP_12165              : speed_typ := "000001111111111";
constant SPEED_CAP_24330              : speed_typ := "000011100000000";
constant SPEED_CAP_24330ALL           : speed_typ := "000011111111111";
constant SPEED_CAP_24330F             : speed_typ := "111111111111111";

constant SPEED_614                    : speed_typ := "000000000000001";
constant SPEED_1228                   : speed_typ := "000000000000010";
constant SPEED_2457                   : speed_typ := "000000000000100";
constant SPEED_3072                   : speed_typ := "000000000001000";
constant SPEED_4915                   : speed_typ := "000000000010000";
constant SPEED_6144                   : speed_typ := "000000000100000";
constant SPEED_9830                   : speed_typ := "000000001000000";
constant SPEED_10137                  : speed_typ := "000000010000000";
constant SPEED_8110                   : speed_typ := "000000100000000";
constant SPEED_12165                  : speed_typ := "000001000000000";
constant SPEED_24330                  : speed_typ := "000010000000000";
constant SPEED_8110F                  : speed_typ := "000100000000000";
constant SPEED_10137F                 : speed_typ := "001000000000000";
constant SPEED_12165F                 : speed_typ := "010000000000000";
constant SPEED_24330F                 : speed_typ := "100000000000000";

constant PREAMBLE_LENGTH              : integer := 14;

type to_mgmnt_typ is record
    do               : do_typ;
    s_axi_awaddr     : std_logic_vector (11 downto 0);
    s_axi_awvalid    : std_logic;
    s_axi_wdata      : dat_typ;
    s_axi_wvalid     : std_logic;
    s_axi_bready     : std_logic;
    s_axi_araddr     : std_logic_vector (11 downto 0);
    s_axi_arvalid    : std_logic;
    s_axi_rready     : std_logic;
end record;

type frm_mgmnt_typ is record
    s_axi_awready    : std_logic;
    s_axi_wready     : std_logic;
    s_axi_bresp      : std_logic_vector(1 downto 0);
    s_axi_bvalid     : std_logic;
    s_axi_arready    : std_logic;
    s_axi_rdata      : dat_typ;
    s_axi_rresp      : std_logic_vector(1 downto 0);
    s_axi_rvalid     : std_logic;
end record;

type reset_typ is record
    reset   : std_logic;
end record;

procedure read(
  addr : in add_typ;
  data : out dat_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure write(
  addr : in add_typ;
  data : in dat_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);
procedure axi_read_addr(
  addr : in add_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure axi_read_data(
  data : out dat_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure axi_write(
  addr : in add_typ;
  data : in dat_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure read_rcvd_protocol_version(
  ver : out proto_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure read_rcvd_seed(
  seed : out seed_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure read_rcvd_hdlc_rate(
  rate : out hdlc_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure read_status_code(
  status : out stat_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure read_status_alarm(
  alarm : out stat_alarm_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure write_speed_capability(
  speed : in speed_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure read_current_speed(
  speed : out speed_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure read_tx_cpri_alarms(
  txalarms : out txalarms_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure read_reset(
  reset : out reset_field_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure read_sdi(
  sdi   : out sdi_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure read_hdlc(
  hdlc   : out hdlc_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure read_current_eth_ptr(
  eth_ptr   : out eth_ptr_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure write_set_sdi(
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure write_clear_sdi(
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure write_clear_hdlc_rate_adapt(
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure write_set_hdlc_rate_adapt(
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure write_set_ti_mod(
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure write_set_reset_request(
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure write_clear_reset_request(
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure write_slave_tx_enable(
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure write_pref_hdlc(
  hdlc : in hdlc_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure write_pref_protocol(
  prot : in proto_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure write_seed(
  seed : in seed_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure write_pref_eth_ptr(
  eth_ptr : in eth_ptr_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure write_fec_error_injection_rate(
  err_rate : in fec_error_inj_rate_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

procedure write_fec_error_injection_seed(
  err_seed : in fec_error_inj_seed_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ);

-- Utility procedures
procedure reset(
        signal to_reset : out reset_typ );

signal to_mgmnt       : to_mgmnt_typ :=(do_typ(mgmnt_read), STATUS_CODE_AND_ALARM, '0', (others => '0'), '0', '0', (others => '0'), '0', '0');
signal frm_mgmnt      : frm_mgmnt_typ;
signal to_reset       : reset_typ;

end package cpri_tb_pkg;

package body cpri_tb_pkg is

procedure axi_read_data(
  data : out dat_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
begin
  wait for 1 ps;

  to_mgmnt.s_axi_rready  <= '1';

  if frm_mgmnt.s_axi_rvalid /= '1' then
    wait until frm_mgmnt.s_axi_rvalid = '1';
  end if;
  data             := frm_mgmnt.s_axi_rdata;
  wait for 8.000 ns;

  to_mgmnt.s_axi_rready  <= '0';
  wait for 8.000 ns;

end procedure axi_read_data;

procedure axi_read_addr(
  addr : in add_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
begin
  wait for 1 ps;

  to_mgmnt.s_axi_araddr  <= addr;
  to_mgmnt.s_axi_arvalid <= '1';

  if frm_mgmnt.s_axi_arready /= '1' then
    wait until frm_mgmnt.s_axi_arready = '1';
  end if;
  wait for 8.000 ns;

  to_mgmnt.s_axi_arvalid <= '0';
  to_mgmnt.s_axi_araddr  <= (others => '0');
  wait for 8.000 ns;

end procedure axi_read_addr;

procedure read (
  addr : in  add_typ;
  data : out dat_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is

begin
  to_mgmnt.do            <= mgmnt_read;
  axi_read_addr(addr, to_mgmnt, frm_mgmnt);
  axi_read_data(data, to_mgmnt, frm_mgmnt);

end procedure read;

procedure axi_write(
  addr : in add_typ;
  data : in dat_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
begin
  wait for 1 ps;

  to_mgmnt.s_axi_awaddr  <= addr;
  to_mgmnt.s_axi_awvalid <= '1';
  to_mgmnt.s_axi_wdata   <= data;
  to_mgmnt.s_axi_wvalid  <= '1';
  to_mgmnt.s_axi_bready  <= '0';

  if frm_mgmnt.s_axi_awready /= '1' then
    wait until frm_mgmnt.s_axi_awready = '1';
  end if;
  if frm_mgmnt.s_axi_wready /= '1' then
    wait until frm_mgmnt.s_axi_wready = '1';
  end if;
  wait for 8.000 ns;

  to_mgmnt.s_axi_awvalid <= '0';
  to_mgmnt.s_axi_awaddr  <= (others => '0');
  to_mgmnt.s_axi_wvalid  <= '0';
  to_mgmnt.s_axi_wdata   <= (others => '0');
  wait for 8.000 ns;

  if frm_mgmnt.s_axi_bvalid /= '1' then
    wait until frm_mgmnt.s_axi_bvalid = '1';
  end if;
  wait for 8.000 ns;

  to_mgmnt.s_axi_bready  <= '1';
  wait for 8.000 ns;
  to_mgmnt.s_axi_bready  <= '0';
  wait for 8.000 ns;

end procedure axi_write;

procedure write(
  addr : in add_typ;
  data : in dat_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
begin
  to_mgmnt.do            <= mgmnt_write;
  axi_write(addr, data, to_mgmnt, frm_mgmnt);

end procedure write;


procedure read_rcvd_protocol_version(
  ver : out proto_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ;
begin
    read( RCV_SUBCHAN2_WORD0, mgmnt_data, to_mgmnt, frm_mgmnt);
    ver := mgmnt_data(proto_typ'range);
end procedure read_rcvd_protocol_version;

procedure read_rcvd_seed(
  seed : out seed_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ;
begin
    read( RX_SEED, mgmnt_data, to_mgmnt, frm_mgmnt);
    seed := mgmnt_data(seed_typ'range);
end procedure read_rcvd_seed;

procedure read_rcvd_hdlc_rate(
  rate : out hdlc_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ;
begin
    read( RCV_SUBCHAN2_WORD1, mgmnt_data, to_mgmnt, frm_mgmnt);
    rate := mgmnt_data(hdlc_typ'range);
end procedure read_rcvd_hdlc_rate;

procedure read_status_code(
  status : out stat_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ;
begin
    read( STATUS_CODE_AND_ALARM, mgmnt_data, to_mgmnt, frm_mgmnt);
    status := mgmnt_data(stat_typ'range);
end procedure read_status_code;

procedure read_status_alarm(
  alarm : out stat_alarm_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ;
begin
    read( STATUS_CODE_AND_ALARM, mgmnt_data, to_mgmnt, frm_mgmnt);
    alarm := mgmnt_data(ALARM_BIT);
end procedure read_status_alarm;

procedure read_current_speed(
  speed : out speed_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ;
begin
    read( CURRENT_LINE_SPEED, mgmnt_data, to_mgmnt, frm_mgmnt);
    speed := mgmnt_data(speed_typ'range);
end procedure read_current_speed;

procedure read_tx_cpri_alarms(
  txalarms : out txalarms_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ;
begin
    read( TX_CPRI_ALARMS, mgmnt_data, to_mgmnt, frm_mgmnt);
    txalarms := mgmnt_data(txalarms_typ'range);
end procedure read_tx_cpri_alarms;

procedure read_reset(
  reset : out reset_field_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ;
begin
    read( TX_CPRI_ALARMS, mgmnt_data, to_mgmnt, frm_mgmnt);
    reset := mgmnt_data(CPRI_LINK_RESET_BIT);
end procedure read_reset;

procedure read_sdi(
  sdi : out sdi_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ;
begin
    read( TX_CPRI_ALARMS, mgmnt_data, to_mgmnt, frm_mgmnt);
    sdi := mgmnt_data(SDI_BIT);
end procedure read_sdi;

procedure read_hdlc(
  hdlc   : out hdlc_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ;
begin
    read( CURRENT_HDLC_RATE, mgmnt_data, to_mgmnt, frm_mgmnt);
    hdlc := mgmnt_data(hdlc_typ'range);
end procedure read_hdlc;

procedure read_current_eth_ptr(
  eth_ptr   : out eth_ptr_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ;
begin
    read( CURRENT_ETHERNET_POINTER, mgmnt_data, to_mgmnt, frm_mgmnt);
    eth_ptr := mgmnt_data(eth_ptr_typ'range);
end procedure read_current_eth_ptr;

procedure write_speed_capability(
  speed : in speed_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
     variable mgmnt_data : dat_typ := (others => '0');
begin
    mgmnt_data(speed'range) := speed;
    write( LINE_SPEED_CAPABILITY, mgmnt_data, to_mgmnt, frm_mgmnt);
end procedure write_speed_capability;

procedure write_set_ti_mod(
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ := (others => '0');
    variable txalarms : txalarms_typ := (others => '0');
begin
    read_tx_cpri_alarms(txalarms, to_mgmnt, frm_mgmnt);
    mgmnt_data(txalarms'range) := txalarms;
    mgmnt_data(30) := '1';
    write( TX_CPRI_ALARMS, mgmnt_data, to_mgmnt, frm_mgmnt);
end procedure write_set_ti_mod;

procedure write_set_reset_request(
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ := (others => '0');
    variable txalarms : txalarms_typ := (others => '0');
begin
    read_tx_cpri_alarms(txalarms, to_mgmnt, frm_mgmnt);
    mgmnt_data(txalarms'range) := txalarms;
    mgmnt_data(0) := '1';
    write( TX_CPRI_ALARMS, mgmnt_data, to_mgmnt, frm_mgmnt);
end procedure write_set_reset_request;

procedure write_slave_tx_enable(
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ := (others => '0');
    variable txalarms : txalarms_typ := (others => '0');
begin
    read_tx_cpri_alarms(txalarms, to_mgmnt, frm_mgmnt);
    mgmnt_data(txalarms'range) := txalarms;
    mgmnt_data(SLAVE_TX_ENABLE_BIT) := '1';
    write( TX_CPRI_ALARMS, mgmnt_data, to_mgmnt, frm_mgmnt);
end procedure write_slave_tx_enable;

procedure write_clear_reset_request(
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ := (others => '0');
    variable txalarms : txalarms_typ := (others => '0');
begin
    read_tx_cpri_alarms(txalarms, to_mgmnt, frm_mgmnt);
    mgmnt_data(txalarms'range) := txalarms;
    mgmnt_data(CPRI_LINK_RESET_BIT) := '0';
    write( TX_CPRI_ALARMS, mgmnt_data, to_mgmnt, frm_mgmnt);
end procedure write_clear_reset_request;

procedure write_set_sdi(
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ := (others => '0');
    variable txalarms : txalarms_typ := (others => '0');
begin
    read_tx_cpri_alarms(txalarms, to_mgmnt, frm_mgmnt);
    mgmnt_data(txalarms'range) := txalarms;
    mgmnt_data(SDI_BIT) := '1';
    write( TX_CPRI_ALARMS, mgmnt_data, to_mgmnt, frm_mgmnt);
end procedure write_set_sdi;

procedure write_clear_sdi(
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ := (others => '0');
    variable txalarms : txalarms_typ := (others => '0');
begin
    read_tx_cpri_alarms(txalarms, to_mgmnt, frm_mgmnt);
    mgmnt_data(txalarms'range) := txalarms;
    mgmnt_data(SDI_BIT) := '0';
    write( TX_CPRI_ALARMS, mgmnt_data, to_mgmnt, frm_mgmnt);
end procedure write_clear_sdi;

procedure write_clear_hdlc_rate_adapt(
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ := (others => '0');
    variable txalarms : txalarms_typ := (others => '0');
begin
    read_tx_cpri_alarms(txalarms, to_mgmnt, frm_mgmnt);
    mgmnt_data(txalarms'range) := txalarms;
    mgmnt_data(HDLC_RATE) := '0';
    write( TX_CPRI_ALARMS, mgmnt_data, to_mgmnt, frm_mgmnt);
end procedure write_clear_hdlc_rate_adapt;

procedure write_set_hdlc_rate_adapt(
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ := (others => '0');
    variable txalarms : txalarms_typ := (others => '0');
begin
    read_tx_cpri_alarms(txalarms, to_mgmnt, frm_mgmnt);
    mgmnt_data(txalarms'range) := txalarms;
    mgmnt_data(HDLC_RATE) := '1';
    write( TX_CPRI_ALARMS, mgmnt_data, to_mgmnt, frm_mgmnt);
end procedure write_set_hdlc_rate_adapt;

procedure write_pref_hdlc(
        hdlc : in hdlc_typ;
    signal to_mgmnt : out to_mgmnt_typ;
    signal frm_mgmnt : in frm_mgmnt_typ) is
      variable mgmnt_data : dat_typ := (others => '0');
begin
    mgmnt_data(hdlc_typ'range) := hdlc;
    write( PREF_HDLC_RATE, mgmnt_data, to_mgmnt, frm_mgmnt);
end procedure write_pref_hdlc;

procedure write_pref_protocol(
        prot : in proto_typ;
    signal to_mgmnt : out to_mgmnt_typ;
    signal frm_mgmnt : in frm_mgmnt_typ) is
      variable mgmnt_data : dat_typ := (others => '0');
begin
    mgmnt_data(proto_typ'range) := prot;
    write( PREF_PROTOCOL_VER, mgmnt_data, to_mgmnt, frm_mgmnt);
end procedure write_pref_protocol;

procedure write_seed(
        seed : in seed_typ;
    signal to_mgmnt : out to_mgmnt_typ;
    signal frm_mgmnt : in frm_mgmnt_typ) is
      variable mgmnt_data : dat_typ := (others => '0');
begin
    mgmnt_data(seed_typ'range) := seed;
    write( TX_SEED, mgmnt_data, to_mgmnt, frm_mgmnt);
end procedure write_seed;

procedure write_pref_eth_ptr(
        eth_ptr : in eth_ptr_typ;
    signal to_mgmnt : out to_mgmnt_typ;
    signal frm_mgmnt : in frm_mgmnt_typ) is
      variable mgmnt_data : dat_typ := (others => '0');
begin
    mgmnt_data(eth_ptr_typ'range) := eth_ptr;
    write( PREF_ETHERNET_POINTER, mgmnt_data, to_mgmnt, frm_mgmnt);
end procedure write_pref_eth_ptr;

procedure write_fec_error_injection_rate(
        err_rate : in fec_error_inj_rate_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ := (others => '0');
begin
  case err_rate is
    when "0000" =>
      mgmnt_data(fec_error_inj_rate_typ'range) := "0000";
    when "0001" =>
      mgmnt_data(fec_error_inj_rate_typ'range) := "0001";
    when "0010" =>
      mgmnt_data(fec_error_inj_rate_typ'range) := "0010";
    when "0100" =>
      mgmnt_data(fec_error_inj_rate_typ'range) := "0100";
    when "1000" =>
      mgmnt_data(fec_error_inj_rate_typ'range) := "1000";
    when "1111" =>
      mgmnt_data(fec_error_inj_rate_typ'range) := "1111";
    when others =>
      mgmnt_data(fec_error_inj_rate_typ'range) := "0000";
  end case;
  write(FEC_CONTROL, mgmnt_data, to_mgmnt, frm_mgmnt);
end procedure write_fec_error_injection_rate;

procedure write_fec_error_injection_seed(
        err_seed : in fec_error_inj_seed_typ;
  signal to_mgmnt : out to_mgmnt_typ;
  signal frm_mgmnt : in frm_mgmnt_typ) is
    variable mgmnt_data : dat_typ := (others => '0');
begin
  read(FEC_CONTROL, mgmnt_data, to_mgmnt, frm_mgmnt);
  mgmnt_data(9 downto 4) := err_seed;
  write(FEC_CONTROL, mgmnt_data, to_mgmnt, frm_mgmnt);
end procedure write_fec_error_injection_seed;

--Utility Procedures
procedure reset(
      signal to_reset : out reset_typ ) is
begin
    to_reset.reset <= '1', '0' after 200 ns;
end procedure reset;
end  package body cpri_tb_pkg;
