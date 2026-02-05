-------------------------------------------------------------------------------
-- Title      : counter module
-- Project    : 
-------------------------------------------------------------------------------
-- File       : per_counter.vhd
-- Author     : Igor Parchakov  <igor@fedora>
-- Company    : AGSTU
-- Created    : 2025-06-21
-- Last update: 2025-06-21
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: vounts ticks
-------------------------------------------------------------------------------
-- Copyright (c) 2025 AGSTU
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2025-06-21  1.0      igor	Created
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library work;

package counter_types is

  type counter_array is array (natural range <>) of unsigned (31 downto 0); 

end package counter_types;

use work.counter_types.all;
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;



entity counter_module is
  
  generic (
    counter_height : natural := 4);     -- number of counters

  port (
    tick_front    : in  std_logic;
    reset_n       : in  std_logic;      -- system reset
    clk           : in  std_logic;      -- system clock
    period_length : in counter_array(counter_height - 1 downto 0);  -- IRQs if counters reach limits
    p_counter_irq : out std_logic_vector(counter_height -1 downto 0));
    

end entity counter_module;


architecture rtl of counter_module is

  signal period_counters : counter_array(counter_height - 1 downto 0) := (others => (others => '0'));
  
begin  -- architecture rtl

  

  -- count ticks
  count_ticks : process (clk, reset_n)

  begin
    if reset_n = '0' then
      period_counters <= (others => (others => '0'));
      p_counter_irq   <= (others => '0');
    elsif rising_edge(clk) then
      p_counter_irq <= (others => '0');
      if tick_front = '1' then
        -- update counters
        update_counters :
        for i in period_counters'range loop
          if period_counters(i) = period_length(i) then  --issue irq
            period_counters(i) <= (others => '0');
            p_counter_irq(i)   <= '1';
          else
            period_counters(i) <= period_counters(i) + 1;
          end if;
        end loop update_counters;
      end if;
    end if;

  end process count_ticks;
end architecture rtl;
