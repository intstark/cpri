--------------------------------------------------------------------------
-- Title      : Clocking
-- Project    : cpri_v8_11_5
--------------------------------------------------------------------------
-- File       : cpri_clocking.vhd
-- Author     : Xilinx
--------------------------------------------------------------------------
-- Description: This file contains all the clocking required for sharing
--              clocks with other cores.
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library cpri_v8_11_5;
use cpri_v8_11_5.all;

entity cpri_slave_0_clocking is
  port (
    reset                 : in  std_logic;
    stable_clk            : in  std_logic;
    txoutclk_in           : in  std_logic;
    rxoutclk_in           : in  std_logic;
    mmcm_reset            : in  std_logic;
    txresetdone_in        : in  std_logic;
    phase_alignment_done  : in  std_logic;
    enable                : in  std_logic;
    speed_select          : in  std_logic_vector(14 downto 0);
    clk_out               : out std_logic;
    txusrclk              : out std_logic;
    clk_ok                : out std_logic;
    recclk_out            : out std_logic;
    userclk_tx_reset      : in  std_logic;
    userclk_rx_reset      : in  std_logic;
    reset_phalignment_out : out std_logic);
end cpri_slave_0_clocking;

architecture rtl of cpri_slave_0_clocking is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";

  component cpri_slave_0_reset_synchronizer is
    port (
      reset_in  : in  std_logic;
      clk       : in  std_logic;
      reset_out : out std_logic);
  end component;

  -------------- Signals Declaration --------------

  signal mmcm_rst_i               : std_logic;
  signal tx_sync_rst              : std_logic := '1';
  signal phase_alignment_done_r   : std_logic := '0';
  signal bufg_div                 : std_logic_vector(2 downto 0);
  signal bufg_div2                : std_logic_vector(2 downto 0);
  signal speed_select_r           : std_logic_vector(14 downto 0) := (others => '0');
  signal txresetdone_in_sync      : std_logic;
  signal txusrclk2                : std_logic;
  signal rxusrclk2                : std_logic;
  attribute dont_touch : string;
  attribute dont_touch of txusrclk2 : signal is "true";

begin

  mmcm_rst_i <= mmcm_reset;

  txusrclk2_bufg0 : BUFG_GT
    port map (
      I       => txoutclk_in,
      CE      => '1',
      CEMASK  => '0',
      CLR     => userclk_tx_reset,
      CLRMASK => '0',
      DIV     => bufg_div2,
      O       => txusrclk2);

  txusrclk_bufg0 : BUFG_GT
    port map (
      I       => txoutclk_in,
      CE      => '1',
      CEMASK  => '0',
      CLR     => userclk_tx_reset,
      CLRMASK => '0',
      DIV     => bufg_div,
      O       => txusrclk);

  speed_select_r_gen : process(stable_clk)
  begin
    if rising_edge(stable_clk) then
      speed_select_r <= speed_select;
    end if;
  end process speed_select_r_gen;

  bufg_div <= "011" when speed_select_r  = "000000000000001" else
              "001" when speed_select_r  = "000000000000010" else
              "000";

  bufg_div2 <= "111" when speed_select_r = "000000000000001" else
               "011" when speed_select_r = "000000000000010" else
               "001" when speed_select_r(6 downto 2) /= "00000" else
               "000";

  -- Rx clocking
  rxusrclk_bufg0 : BUFG_GT
    port map (
      I       => rxoutclk_in,
      CE      => '1',
      CEMASK  => '0',
      CLR     => userclk_rx_reset,
      CLRMASK => '0',
      DIV     => "000",
      O       => rxusrclk2);

  recclk_out <= rxusrclk2;

  -- System clock (core logic clock and most user logic)
  clk_out   <= txusrclk2;

  txresetdone_in_sync_i : cpri_slave_0_reset_synchronizer
    port map (
      reset_in  => txresetdone_in,
      clk       => stable_clk,
      reset_out => txresetdone_in_sync);

  process(stable_clk)
  begin
    if rising_edge(stable_clk) then
      if speed_select(14 downto 7) /= "00000000" then
        reset_phalignment_out <= '1';
      else
        reset_phalignment_out <= not(txresetdone_in_sync);
      end if;
    end if;
  end process;

  tx_phase_alignment_done_sync_i : cpri_slave_0_reset_synchronizer
    port map (
      reset_in  => phase_alignment_done,
      clk       => txusrclk2,
      reset_out => phase_alignment_done_r);

  -- Tx Sync reset held until Tx clocks OK and GTX Tx Reset done
  tx_sync_rst_gen : process(txusrclk2)
  begin
    if rising_edge(txusrclk2) then
      if txresetdone_in = '1' and phase_alignment_done_r = '1' then
        tx_sync_rst <= '0';
      else
        tx_sync_rst <= '1';
      end if;
    end if;
  end process tx_sync_rst_gen;

  -- output tx_clk domain reset
  clk_ok  <=  not(tx_sync_rst);

end rtl;
