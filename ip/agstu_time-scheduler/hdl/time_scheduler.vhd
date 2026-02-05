-------------------------------------------------------------------------------
-- Title      : time scheduler component
-- Project    : 
-------------------------------------------------------------------------------
-- File       : time_scheduler.vhd
-- Author     : Igor Parchakov  
-- Company    : 
-- Created    : 2025-01-17
-- Last update: 2025-01-17
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2025 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2025-01-17  0.0.1      igor  Created
-------------------------------------------------------------------------------




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 
entity tick_function is
  generic
    (
      g_timer_limit : integer := 2 * 5 * 1000 * 1000
      --                         |2 * 100 ms  
      );
  port
    (
      reset_timer : in  std_logic;
      clk         : in  std_logic;
      reset_n     : in  std_logic;
      counter_en  : in  std_logic;
      tick        : out std_logic;
      timer_data  : out std_logic_vector(31 downto 0)
      );
end tick_function;

-- HW_function_process handled the function in timer component
architecture tick_top_rtl of tick_function is
  signal counter, count_on_clk    : unsigned(31 downto 0) := (others => '0');
  signal reset_timer_local        : std_logic := '0';
  signal tick_local, tick_local_on_clk : std_logic := '0';  --std_logic;

begin
  counter <= (others => '0') when (reset_n = '0') else
             count_on_clk when rising_edge(clk);

  count_on_clk <= (others => '0') when (reset_timer = '0') or (reset_timer_local = '0') else
                  counter + 1 when counter_en = '1' else
                  counter     when counter_en = '0';

  timer_data <= std_logic_vector(counter);

  reset_timer_local <= '0' when (counter = to_unsigned(g_timer_limit, counter'length)) else
                       '1';

  tick_local <= '0' when (reset_n = '0') else
                tick_local_on_clk when rising_edge(clk);

  tick_local_on_clk <= not tick_local when (reset_timer_local = '0') else
                       tick_local;

  tick <= tick_local;
  
end tick_top_rtl;
