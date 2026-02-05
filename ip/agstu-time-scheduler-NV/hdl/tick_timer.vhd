-------------------------------------------------------------------------------
-- Title      : time scheduler component
-- Project    : 
-------------------------------------------------------------------------------
-- File       : time_scheduler.vhd
-- Author     : Igor Parchakov  
-- Company    : 
-- Created    : 2025-01-17
-- Last update: 2025-06-20
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
      g_timer_limit : natural := 2 * 5 * 1000 * 1000
      --                         |2 * 100 ms
      );
  port
    (
      reset_timer_n : in  std_logic;
      clk           : in  std_logic;
      reset_n       : in  std_logic;
      counter_en    : in  std_logic;
      tick          : out std_logic;
      timer_data    : out std_logic_vector(31 downto 0)
      );
end tick_function;

-- Function of tick pulse generator. Period of pulses - g_timer_limit
-- Pulse width - g_timer_limit / 2.
architecture tick_top_rtl of tick_function is

  signal period_counter, period_counter_clk : unsigned(31 downto 0) := (others => '0');

  signal period_done : std_logic := '1';

  constant t_period      : unsigned := to_unsigned(g_timer_limit - 1, period_counter'length);
  constant t_pulse_width : unsigned := shift_right(t_period, 1);

  signal tick_local : std_logic := '0';  --std_logic;

begin

  --
  -- period_counter <= (others => '0') when (reset_n = '0') else
  --                   period_counter_clk when rising_edge(clk);

  -- period_counter_clk <= (others => '0') when (reset_timer_n = '0') or (period_done = '1') else
  --                       period_counter + 1 when counter_en = '1' else
  --                       period_counter;

  -- period_done <= '1' when (period_counter = t_period) else
  --                '0';
  process(clk, reset_n)
  begin
      if reset_n = '0' then
        period_counter <= (others => '0');
    elsif rising_edge(clk) then
      if reset_timer_n = '0' or period_done = '1' then
        period_counter <= (others => '0');
      elsif counter_en = '1' then
        period_counter <= period_counter + 1;
      else
        period_counter <= period_counter;
      end if;
    end if;
  end process;

period_done <= '1' when (period_counter = t_period) else
                  '0';
  tick_local <= '1' when (period_counter < t_pulse_width) else
                '0';

  tick <= tick_local;

  timer_data <= std_logic_vector(period_counter);

end tick_top_rtl;
