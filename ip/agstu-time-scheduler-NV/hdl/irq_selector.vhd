-------------------------------------------------------------------------------
-- Title      : IRQ selector
-- Project    : 
-------------------------------------------------------------------------------
-- File       : irq_selector.vhd
-- Author     : Igor Parchakov  <igor_pa@live.com>
-- Company    : AGSTU
-- Created    : 2025-02-07
-- Last update: 2025-06-22
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: The component uses a simple arbitration to handle several irq sources
-- over one irq line
-------------------------------------------------------------------------------
-- Copyright (c) 2025 AGSTU
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2025-02-07  1.0      igor    Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity irq_selector is
  generic (
    height : natural := 4               -- number of input irq lines
    );
  port(
    clk      : in  std_logic
; reset_n    : in  std_logic
                                        -- 
; irq_in_mx  : in  std_logic_vector (height - 1 downto 0)
; ack_in_mx  : in  std_logic_vector (height - 1 downto 0)
; ack_in     : in  std_logic
; p_irq_out  : out std_logic
; vector_out : out natural range 0 to height - 1  --out std_logic_vector (height - 1 downto 0)  -- 
    );
end irq_selector;

architecture rtl of irq_selector is

  signal vector    : natural range 0 to height - 1;
  signal irq_sent  : std_logic_vector (height - 1 downto 0);
  signal irq_out   : std_logic := '0';
  signal out_delay : natural range 0 to 7 := 0;

begin

  selector : process (reset_n, clk)
  begin
    if reset_n = '0' then
      vector    <= 0;
      irq_out   <= '0';
      irq_sent  <= (others => '0');
      out_delay <= 0;
    elsif rising_edge(clk) then
                                        --
      if irq_out = '0' then
        if out_delay /= 0 then
          out_delay <= out_delay - 1;
        else
          scan :                        -- the line is free
          for i in 0 to height - 1 loop
            if (irq_sent(i) = '1') then
              exit;
            elsif (irq_in_mx(i) = '1') then
              -- sending irq
              irq_out     <= '1';
              vector      <= i;
              irq_sent(i) <= '1';
              exit;
            end if;
          end loop scan;
        end if;
      elsif ack_in = '1' then           -- line is still active
        out_delay <= 5;                 -- keep the line free for 6 clk cycles
        irq_out <= '0';
        vector  <= 0;
      end if;
      -- manage sent flag
      for i in 0 to height - 1 loop
        if (ack_in_mx(i) = '1') then
          irq_sent(i) <= '0';
        end if;
      end loop;
    end if;
  end process selector;

  vector_out <= vector;
  p_irq_out  <= irq_out;

end architecture rtl;
