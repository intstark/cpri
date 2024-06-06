-----------------------------------------------------------------------
-- Title      : CPRI Example Design Synchronizers
-- Project    : cpri_v8_11_17
-----------------------------------------------------------------------
-- File       : cpri_example_sync.vhd
-- Author     : AMD
-----------------------------------------------------------------------
-- Description: Synchronizes stat_speed onto core_clk and rec_clk domains.
--              Synchronizes various frame and error counters from the
--              example design modules onto the aux clock domain.
-----------------------------------------------------------------------
-- (c) Copyright 2023 Advanced Micro Devices, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of AMD and is protected under U.S. and international copyright
-- and other intellectual property laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- AMD, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) AMD shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or AMD had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- AMD products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of AMD products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library xpm;
use xpm.vcomponents.all;

entity cpri_example_sync is
  port (
    core_clk                 : in  std_logic;
    core_reset               : in  std_logic;
    aux_clk                  : in  std_logic;
    aux_reset                : in  std_logic;
    eth_clk                  : in  std_logic;
    eth_reset                : in  std_logic;
    rec_clk                  : in  std_logic;
    -- Inputs  
    iq_frame_count           : in  std_logic_vector(31 downto 0);
    iq_error_count           : in  std_logic_vector(31 downto 0);
    nodebfn_rx_nr_store      : in  std_logic_vector(11 downto 0);
    hdlc_bit_count           : in  std_logic_vector(31 downto 0);
    hdlc_error_count         : in  std_logic_vector(31 downto 0);
    vs_word_count            : in  std_logic_vector(31 downto 0);
    vs_error_count           : in  std_logic_vector(31 downto 0);
    eth_tx_count             : in  std_logic_vector(31 downto 0);
    eth_rx_count             : in  std_logic_vector(31 downto 0);
    eth_error_count          : in  std_logic_vector(31 downto 0);
    stat_speed               : in  std_logic_vector(14 downto 0);
    -- Synchronized outputs
    iq_frame_count_sync      : out std_logic_vector(31 downto 0);
    iq_error_count_sync      : out std_logic_vector(31 downto 0);
    nodebfn_rx_nr_store_sync : out std_logic_vector(11 downto 0);
    hdlc_bit_count_sync      : out std_logic_vector(31 downto 0);
    hdlc_error_count_sync    : out std_logic_vector(31 downto 0);
    vs_word_count_sync       : out std_logic_vector(31 downto 0);
    vs_error_count_sync      : out std_logic_vector(31 downto 0);
    eth_tx_count_sync        : out std_logic_vector(31 downto 0);
    eth_rx_count_sync        : out std_logic_vector(31 downto 0);
    eth_error_count_sync     : out std_logic_vector(31 downto 0);
    stat_speed_core_clk      : out std_logic_vector(14 downto 0);
    stat_speed_rec_clk       : out std_logic_vector(14 downto 0));
end entity cpri_example_sync;


architecture rtl of cpri_example_sync is

  signal src_send_speed_core : std_logic;
  signal src_rcv_speed_core  : std_logic;
  signal src_send_speed_rec  : std_logic;
  signal src_rcv_speed_rec   : std_logic;
  signal src_send_iq_frame   : std_logic;
  signal src_rcv_iq_frame    : std_logic;
  signal src_send_iq_err     : std_logic;
  signal src_rcv_iq_err      : std_logic;
  signal src_send_nodebfn    : std_logic;
  signal src_rcv_nodebfn     : std_logic;
  signal src_send_hdlc_bit   : std_logic;
  signal src_rcv_hdlc_bit    : std_logic;
  signal src_send_hdlc_err   : std_logic;
  signal src_rcv_hdlc_err    : std_logic;
  signal src_send_vs_word    : std_logic;
  signal src_rcv_vs_word     : std_logic;
  signal src_send_vs_err     : std_logic;
  signal src_rcv_vs_err      : std_logic;
  signal src_send_eth_tx     : std_logic;
  signal src_rcv_eth_tx      : std_logic;
  signal src_send_eth_rx     : std_logic;
  signal src_rcv_eth_rx      : std_logic;
  signal src_send_eth_err    : std_logic;
  signal src_rcv_eth_err     : std_logic;

begin

  -- stat_speed onto core_clk
  speed_core_sync_i : xpm_cdc_handshake
    generic map (
      DEST_EXT_HSK   => 0,  -- Internal handshake on destination clock domain
      DEST_SYNC_FF   => 4,
      INIT_SYNC_FF   => 0,
      SIM_ASSERT_CHK => 0,
      SRC_SYNC_FF    => 4,
      WIDTH          => 15)
    port map (
      src_clk        => aux_clk,
      src_in         => stat_speed,
      src_send       => src_send_speed_core,
      src_rcv        => src_rcv_speed_core,
      dest_clk       => core_clk,
      dest_out       => stat_speed_core_clk,
      dest_req       => open,
      dest_ack       => '0');

  process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      if aux_reset = '0' then
        src_send_speed_core <= '1';
      elsif src_rcv_speed_core = '1' then
        src_send_speed_core <= '0';
      else
        src_send_speed_core <= '1';
      end if;
    end if;
  end process;

  -- stat_speed onto rec_clk
  speed_rec_sync_i : xpm_cdc_handshake
    generic map (
      DEST_EXT_HSK   => 0,  -- Internal handshake on destination clock domain
      DEST_SYNC_FF   => 4,
      INIT_SYNC_FF   => 0,
      SIM_ASSERT_CHK => 0,
      SRC_SYNC_FF    => 4,
      WIDTH          => 15)
    port map (
      src_clk        => aux_clk,
      src_in         => stat_speed,
      src_send       => src_send_speed_rec,
      src_rcv        => src_rcv_speed_rec,
      dest_clk       => rec_clk,
      dest_out       => stat_speed_rec_clk,
      dest_req       => open,
      dest_ack       => '0');

  process(aux_clk)
  begin
    if rising_edge(aux_clk) then
      if aux_reset = '0' then
        src_send_speed_rec <= '1';
      elsif src_rcv_speed_rec = '1' then
        src_send_speed_rec <= '0';
      else
        src_send_speed_rec <= '1';
      end if;
    end if;
  end process;

  -- IQ frame counter onto aux_clk
  iq_frame_sync_i : xpm_cdc_handshake
    generic map (
      DEST_EXT_HSK   => 0,  -- Internal handshake on destination clock domain
      DEST_SYNC_FF   => 4,
      INIT_SYNC_FF   => 0,
      SIM_ASSERT_CHK => 0,
      SRC_SYNC_FF    => 4,
      WIDTH          => 32)
    port map (
      src_clk        => core_clk,
      src_in         => iq_frame_count,
      src_send       => src_send_iq_frame,
      src_rcv        => src_rcv_iq_frame,
      dest_clk       => aux_clk,
      dest_out       => iq_frame_count_sync,
      dest_req       => open,
      dest_ack       => '0');

  process(core_clk)
  begin
    if rising_edge(core_clk) then
      if core_reset = '1' then
        src_send_iq_frame <= '1';
      elsif src_rcv_iq_frame = '1' then
        src_send_iq_frame <= '0';
      else
        src_send_iq_frame <= '1';
      end if;
    end if;
  end process;

  -- IQ error counter onto aux_clk
  iq_error_sync_i : xpm_cdc_handshake
    generic map (
      DEST_EXT_HSK   => 0,  -- Internal handshake on destination clock domain
      DEST_SYNC_FF   => 4,
      INIT_SYNC_FF   => 0,
      SIM_ASSERT_CHK => 0,
      SRC_SYNC_FF    => 4,
      WIDTH          => 32)
    port map (
      src_clk        => core_clk,
      src_in         => iq_error_count,
      src_send       => src_send_iq_err,
      src_rcv        => src_rcv_iq_err,
      dest_clk       => aux_clk,
      dest_out       => iq_error_count_sync,
      dest_req       => open,
      dest_ack       => '0');

  process(core_clk)
  begin
    if rising_edge(core_clk) then
      if core_reset = '1' then
        src_send_iq_err <= '1';
      elsif src_rcv_iq_err = '1' then
        src_send_iq_err <= '0';
      else
        src_send_iq_err <= '1';
      end if;
    end if;
  end process;

  -- nodebfn_rx_nr_store counter onto aux_clk
  nodebfn_sync_i : xpm_cdc_handshake
    generic map (
      DEST_EXT_HSK   => 0,  -- Internal handshake on destination clock domain
      DEST_SYNC_FF   => 4,
      INIT_SYNC_FF   => 0,
      SIM_ASSERT_CHK => 0,
      SRC_SYNC_FF    => 4,
      WIDTH          => 12)
    port map (
      src_clk        => core_clk,
      src_in         => nodebfn_rx_nr_store,
      src_send       => src_send_nodebfn,
      src_rcv        => src_rcv_nodebfn,
      dest_clk       => aux_clk,
      dest_out       => nodebfn_rx_nr_store_sync,
      dest_req       => open,
      dest_ack       => '0');

  process(core_clk)
  begin
    if rising_edge(core_clk) then
      if core_reset = '1' then
        src_send_nodebfn <= '1';
      elsif src_rcv_nodebfn = '1' then
        src_send_nodebfn <= '0';
      else
        src_send_nodebfn <= '1';
      end if;
    end if;
  end process;

  -- HDLC bit counter onto aux_clk
  hdlc_bit_sync_i : xpm_cdc_handshake
    generic map (
      DEST_EXT_HSK   => 0,  -- Internal handshake on destination clock domain
      DEST_SYNC_FF   => 4,
      INIT_SYNC_FF   => 0,
      SIM_ASSERT_CHK => 0,
      SRC_SYNC_FF    => 4,
      WIDTH          => 32)
    port map (
      src_clk        => core_clk,
      src_in         => hdlc_bit_count,
      src_send       => src_send_hdlc_bit,
      src_rcv        => src_rcv_hdlc_bit,
      dest_clk       => aux_clk,
      dest_out       => hdlc_bit_count_sync,
      dest_req       => open,
      dest_ack       => '0');

  process(core_clk)
  begin
    if rising_edge(core_clk) then
      if core_reset = '1' then
        src_send_hdlc_bit <= '1';
      elsif src_rcv_hdlc_bit = '1' then
        src_send_hdlc_bit <= '0';
      else
        src_send_hdlc_bit <= '1';
      end if;
    end if;
  end process;

  -- HDLC error counter onto aux_clk
  hdlc_error_sync_i : xpm_cdc_handshake
    generic map (
      DEST_EXT_HSK   => 0,  -- Internal handshake on destination clock domain
      DEST_SYNC_FF   => 4,
      INIT_SYNC_FF   => 0,
      SIM_ASSERT_CHK => 0,
      SRC_SYNC_FF    => 4,
      WIDTH          => 32)
    port map (
      src_clk        => core_clk,
      src_in         => hdlc_error_count,
      src_send       => src_send_hdlc_err,
      src_rcv        => src_rcv_hdlc_err,
      dest_clk       => aux_clk,
      dest_out       => hdlc_error_count_sync,
      dest_req       => open,
      dest_ack       => '0');

  process(core_clk)
  begin
    if rising_edge(core_clk) then
      if core_reset = '1' then
        src_send_hdlc_err <= '1';
      elsif src_rcv_hdlc_err = '1' then
        src_send_hdlc_err <= '0';
      else
        src_send_hdlc_err <= '1';
      end if;
    end if;
  end process;

  -- vs word counter onto aux_clk
  vs_word_sync_i : xpm_cdc_handshake
    generic map (
      DEST_EXT_HSK   => 0,  -- Internal handshake on destination clock domain
      DEST_SYNC_FF   => 4,
      INIT_SYNC_FF   => 0,
      SIM_ASSERT_CHK => 0,
      SRC_SYNC_FF    => 4,
      WIDTH          => 32)
    port map (
      src_clk        => core_clk,
      src_in         => vs_word_count,
      src_send       => src_send_vs_word,
      src_rcv        => src_rcv_vs_word,
      dest_clk       => aux_clk,
      dest_out       => vs_word_count_sync,
      dest_req       => open,
      dest_ack       => '0');

  process(core_clk)
  begin
    if rising_edge(core_clk) then
      if core_reset = '1' then
        src_send_vs_word <= '1';
      elsif src_rcv_vs_word = '1' then
        src_send_vs_word <= '0';
      else
        src_send_vs_word <= '1';
      end if;
    end if;
  end process;

  -- vs error counter onto aux_clk
  vs_error_sync_i : xpm_cdc_handshake
    generic map (
      DEST_EXT_HSK   => 0,  -- Internal handshake on destination clock domain
      DEST_SYNC_FF   => 4,
      INIT_SYNC_FF   => 0,
      SIM_ASSERT_CHK => 0,
      SRC_SYNC_FF    => 4,
      WIDTH          => 32)
    port map (
      src_clk        => core_clk,
      src_in         => vs_error_count,
      src_send       => src_send_vs_err,
      src_rcv        => src_rcv_vs_err,
      dest_clk       => aux_clk,
      dest_out       => vs_error_count_sync,
      dest_req       => open,
      dest_ack       => '0');

  process(core_clk)
  begin
    if rising_edge(core_clk) then
      if core_reset = '1' then
        src_send_vs_err <= '1';
      elsif src_rcv_vs_err = '1' then
        src_send_vs_err <= '0';
      else
        src_send_vs_err <= '1';
      end if;
    end if;
  end process;


  -- eth_tx_counter onto aux_clk
  eth_tx_sync_i : xpm_cdc_handshake
    generic map (
      DEST_EXT_HSK   => 0,  -- Internal handshake on destination clock domain
      DEST_SYNC_FF   => 4,
      INIT_SYNC_FF   => 0,
      SIM_ASSERT_CHK => 0,
      SRC_SYNC_FF    => 4,
      WIDTH          => 32)
    port map (
      src_clk        => eth_clk,
      src_in         => eth_tx_count,
      src_send       => src_send_eth_tx,
      src_rcv        => src_rcv_eth_tx,
      dest_clk       => aux_clk,
      dest_out       => eth_tx_count_sync,
      dest_req       => open,
      dest_ack       => '0');

  process(eth_clk)
  begin
    if rising_edge(eth_clk) then
      if eth_reset = '1' then
        src_send_eth_tx <= '1';
      elsif src_rcv_eth_tx = '1' then
        src_send_eth_tx <= '0';
      else
        src_send_eth_tx <= '1';
      end if;
    end if;
  end process;

  -- eth_rx_counter onto aux_clk
  eth_rx_sync_i : xpm_cdc_handshake
    generic map (
      DEST_EXT_HSK   => 0,  -- Internal handshake on destination clock domain
      DEST_SYNC_FF   => 4,
      INIT_SYNC_FF   => 0,
      SIM_ASSERT_CHK => 0,
      SRC_SYNC_FF    => 4,
      WIDTH          => 32)
    port map (
      src_clk        => eth_clk,
      src_in         => eth_rx_count,
      src_send       => src_send_eth_rx,
      src_rcv        => src_rcv_eth_rx,
      dest_clk       => aux_clk,
      dest_out       => eth_rx_count_sync,
      dest_req       => open,
      dest_ack       => '0');

  process(eth_clk)
  begin
    if rising_edge(eth_clk) then
      if eth_reset = '1' then
        src_send_eth_rx <= '1';
      elsif src_rcv_eth_rx = '1' then
        src_send_eth_rx <= '0';
      else
        src_send_eth_rx <= '1';
      end if;
    end if;
  end process;

  -- eth_error_counter onto aux_clk
  eth_error_sync_i : xpm_cdc_handshake
    generic map (
      DEST_EXT_HSK   => 0,  -- Internal handshake on destination clock domain
      DEST_SYNC_FF   => 4,
      INIT_SYNC_FF   => 0,
      SIM_ASSERT_CHK => 0,
      SRC_SYNC_FF    => 4,
      WIDTH          => 32)
    port map (
      src_clk        => eth_clk,
      src_in         => eth_error_count,
      src_send       => src_send_eth_err,
      src_rcv        => src_rcv_eth_err,
      dest_clk       => aux_clk,
      dest_out       => eth_error_count_sync,
      dest_req       => open,
      dest_ack       => '0');

  process(eth_clk)
  begin
    if rising_edge(eth_clk) then
      if eth_reset = '1' then
        src_send_eth_err <= '1';
      elsif src_rcv_eth_err = '1' then
        src_send_eth_err <= '0';
      else
        src_send_eth_err <= '1';
      end if;
    end if;
  end process;

end rtl;
