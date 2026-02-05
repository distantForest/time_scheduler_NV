-------------------------------------------------------------------------------
-- Title      : Period controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : period_controller.vhd
-- Author     : Igor Parchakov  
-- Company    : 
-- Created    : 2025-01-20
-- Last update: 2025-06-24
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Period controller manages period counter on tick
-- positive front.
-------------------------------------------------------------------------------
-- Copyright (c) 2025 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2025-01-20  1.0      igor    Created
-- 2025-04-06  1.0.1    igor    tested
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library work;

package pack_period is
  function log2ceil(
    arg : natural)
    return natural;
end package pack_period;

package body pack_period is

  function log2ceil(arg : natural) return natural is
    variable tmp : positive := 1;
    variable log : natural  := 0;
  begin
    if arg = 1 then return 0; end if;
    while arg > tmp loop
      tmp := tmp * 2;
      log := log + 1;
    end loop;
    return log;
  end function;
end package body pack_period;

use work.pack_period.all;
use work.counter_types.all;
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity period_controller is
  generic (
    counter_height : integer := 4;      -- number of periods
    tick_length    : integer := 25 * 1000 * 1000;  -- tick length
    per0           : integer := 2;
    per1           : integer := 3;
    per2           : integer := 4;
    per3           : integer := 5;
    per4           : integer := 6;
    per5           : integer := 7;
    per6           : integer := 8;
    per7           : integer := 9;
    per8           : integer := 10;
    per9           : integer := 11;
    per10          : integer := 12;
    per11          : integer := 13;
    per12          : integer := 14;
    per13          : integer := 15;
    per14          : integer := 16;
    per15          : integer := 17
    );
  port (
    clk        : in  std_logic;         -- system clock
    reset_n    : in  std_logic;         -- system reset
    p0_irq_out : out std_logic;         -- IRQ output
    cs_n       : in  std_logic;         -- IP component address
    addr       : in  std_logic_vector(log2ceil(counter_height + 4) - 1 downto 0);  -- Using addr_width here
    write_n    : in  std_logic;
    read_n     : in  std_logic;
    din        : in  std_logic_vector(31 downto 0);
    dout       : out std_logic_vector(31 downto 0)
  );
  subtype p_index_range is natural range 0 to counter_height - 1;
  subtype p_bit_range is unsigned (31 downto 0);
  subtype p_addr_range is unsigned (addr'length - 1 downto 0);
end entity period_controller;

architecture count_ticks_rtl of period_controller is
  
  component counter_module is
    generic (
      counter_height : natural);
    port (
      tick_front    : in  std_logic;
      reset_n       : in  std_logic;
      clk           : in  std_logic;
      period_length : in  counter_array(counter_height - 1 downto 0);
      p_counter_irq : out std_logic_vector(counter_height -1 downto 0));
  end component counter_module;
  
  component tick_function is
    generic (
      g_timer_limit : integer);
    port (
      reset_timer_n : in  std_logic;
      clk           : in  std_logic;
      reset_n       : in  std_logic;
      counter_en    : in  std_logic;
      tick          : out std_logic;
      timer_data    : out std_logic_vector(31 downto 0));
  end component tick_function;

  component irq_selector is
    generic (
      height : natural                  -- number of input irq lines
      );
    port(
      clk    : in  std_logic
; reset_n    : in  std_logic
                                        -- 
; irq_in_mx  : in  std_logic_vector (height - 1 downto 0)
; ack_in_mx  : in  std_logic_vector (height - 1 downto 0)
; ack_in     : in  std_logic
; p_irq_out  : out std_logic
; vector_out : out natural range 0 to height - 1
      );
  end component irq_selector;


  type period_array is array (p_index_range) of unsigned (31 downto 0);  --integer;      
  type integer_array is array (natural range 0 to 15) of unsigned (31 downto 0);  --integer;
  -- signal period_counters : period_array;
  signal period_length   : counter_array(counter_height - 1 downto 0);
  signal period_index    : p_index_range;
  signal p_vector        : p_index_range;  -- natural range 0 to counter_height - 1;

  constant p_irq_enable_reg_addr : p_addr_range := to_unsigned(0, p_addr_range'length);
  constant p_irq_ack_reg_addr    : p_addr_range := to_unsigned(1, p_addr_range'length);
  constant p_irq_vector_reg_addr : p_addr_range := to_unsigned(2, p_addr_range'length);
  constant p_irq_cs_reg_addr     : p_addr_range := to_unsigned(3, p_addr_range'length);
  constant p_limits_addr         : p_addr_range := to_unsigned(4, p_addr_range'length);
  constant period_init : integer_array := (  -- fill 
-- constants period length
    to_unsigned(per0 - 1, p_bit_range'length),
    to_unsigned(per1 - 1, p_bit_range'length),
    to_unsigned(per2 - 1, p_bit_range'length),
    to_unsigned(per3 - 1, p_bit_range'length),
    to_unsigned(per4 - 1, p_bit_range'length),
    to_unsigned(per5 - 1, p_bit_range'length),
    to_unsigned(per6 - 1, p_bit_range'length),
    to_unsigned(per7 - 1, p_bit_range'length),
    to_unsigned(per8 - 1, p_bit_range'length),
    to_unsigned(per9 - 1, p_bit_range'length),
    to_unsigned(per10 - 1, p_bit_range'length),
    to_unsigned(per11 - 1, p_bit_range'length),
    to_unsigned(per12 - 1, p_bit_range'length),
    to_unsigned(per13 - 1, p_bit_range'length),
    to_unsigned(per14 - 1, p_bit_range'length),
    to_unsigned(per15 - 1, p_bit_range'length)
    );
  signal counter_p0                      : integer                                       := 0;
  signal timer_data                      : std_logic_vector(31 downto 0);
  signal tick, tick_front, tick_ack      : std_logic;
  signal p0_counter_irq, p0_irq          : std_logic                                     := '0';  --IRQ channel 0
  signal p_counter_irq, p_irq, p_irq_ack : std_logic_vector(counter_height - 1 downto 0) := (others => '0');

  signal p_irq_ack_reg        : std_logic_vector(31 downto 0);
  signal p_irq_enable_reg     : std_logic_vector(31 downto 0);
  signal p_irq_vector_reg     : std_logic_vector(31 downto 0);
  signal p_irq_ack_gl         : std_logic;

  signal read_irq_enable_reg   : std_logic;
  signal read_irq_vector_reg   : std_logic;
  signal read_period_limit_reg : std_logic;

  -- signal write_regs : std_logic;
  
  signal p_counter_run : std_logic := '0';


begin  --architecture count_ticks
  
  counter_module_1: entity work.counter_module
    generic map (
      counter_height => counter_height)
    port map (
      tick_front    => tick_front,
      reset_n       => reset_n,
      clk           => clk,
      period_length => period_length,
      p_counter_irq => p_counter_irq);
  
  -- instance "tick_function_1"
  tick_function_1 : entity work.tick_function
    generic map (
      g_timer_limit => tick_length)
    port map (
      reset_timer_n => '1',
      clk           => clk,
      reset_n       => reset_n,
      counter_en    => p_counter_run, --'1',
      tick          => tick,
      timer_data    => timer_data);

  irq_selector_1 : irq_selector
    generic map (
      height => counter_height)
    port map (
      clk        => clk,
      reset_n    => reset_n,
      irq_in_mx  => p_irq,
      ack_in_mx  => p_irq_ack,
      ack_in     => p_irq_ack_gl,
      p_irq_out  => p0_irq_out,
      vector_out => p_vector);

  -- tick positive front extraction
  front_extraction : process (clk, reset_n)
  begin
    if reset_n = '0' then
      tick_front <= '0';
      tick_ack   <= '0';
    elsif rising_edge(clk) then
      if tick_ack = '0' and tick = '1' then
        tick_front <= '1';
      else
        tick_front <= '0';
      end if;
      tick_ack <= tick;
    end if;
  end process front_extraction;
  
-- Avalon bus write operations
  write_control_status_register : process (clk, reset_n)
  begin
    if reset_n = '0' then
      p_counter_run <= '0';
    elsif rising_edge(clk) then
      if cs_n = '0' and write_n = '0' and
        (unsigned(addr) = p_irq_cs_reg_addr) then
        -- write control status register
        p_counter_run <= din(0);
      end if;
    end if;
  end process write_control_status_register;
  
  write_irq_enable_register : process (clk, reset_n)
  begin
    if reset_n = '0' then
      p_irq_enable_reg <= (others => '0');
    elsif rising_edge(clk) then
      if cs_n = '0' and write_n = '0' and
        (unsigned(addr) = p_irq_enable_reg_addr) then
        p_irq_enable_reg <= din;
      end if;
    end if;
  end process write_irq_enable_register;

    write_global_acnowledge : process (clk, reset_n)
    begin
      if reset_n = '0' then
        p_irq_vector_reg <= (others => '0');
        p_irq_ack_gl     <= '0';
      elsif rising_edge(clk) then
        p_irq_ack_gl     <= '0';
        if cs_n = '0' and write_n = '0' and
          (unsigned(addr) = p_irq_vector_reg_addr) then
          -- write global acknowlege
          p_irq_ack_gl     <= '1';
          p_irq_vector_reg <= din;
        end if;
      end if;
    end process write_global_acnowledge;
    
  write_irq_acnowledge : process (clk, reset_n)
  -- write irq acknowlege
  begin
    if reset_n = '0' then
      p_irq_ack <= (others => '0');
    elsif rising_edge(clk) then
      p_irq_ack <= (others => '0');
      if cs_n = '0' and write_n = '0' and
        (unsigned(addr) = p_irq_ack_reg_addr) then
        check_ack :
        for i in period_length'range loop
          if din(i) = '1' then
            p_irq_ack(i) <= '1';  -- give positive pulse one clk in length
          end if;
        end loop check_ack;
      end if;
    end if;
  end process write_irq_acnowledge;

  
  write_period_limits : process (clk, reset_n)
    variable bus_write : std_logic := '0';
  begin-- write period limits
    if reset_n = '0' then
      for i in period_length'range loop
        period_length(i) <= period_init(i);
      end loop;
    elsif rising_edge(clk) then
      if cs_n = '0' and write_n = '0' and
        (unsigned(addr) > p_limits_addr) and (unsigned(addr) < (p_limits_addr + counter_height)) then
        if p_counter_run = '0' then
          period_length(to_integer(unsigned(addr)) - to_integer(p_limits_addr)) <= unsigned(din);
        end if;
      end if;
    end if;
  end process write_period_limits;

  -- manage interrupt request
  manage_irq : process(clk, reset_n)

  begin
    if reset_n = '0' then
      p_irq <= (others => '0');
    elsif rising_edge(clk) then
      check_irq :
      for i in p_index_range loop
        if (p_irq_enable_reg(i) = '1') then
          if (p_counter_irq(i) = '1') then
            p_irq(i) <= '1';
          end if;
          if p_irq_ack(i) = '1' then
            p_irq(i) <= '0';
          end if;
        else
          p_irq(i) <= '0';
        end if;
      end loop check_irq;
    end if;

  end process manage_irq;

  --avalon bus read interface
  read_irq_enable_reg <= '1' when ((cs_n = '0') and (read_n = '0') and
                                   (unsigned(addr) = p_irq_enable_reg_addr)) else
                         '0';

  read_irq_vector_reg <= '1' when ((cs_n = '0') and (read_n = '0') and
                                   (unsigned(addr) = p_irq_vector_reg_addr)) else
                         '0';
  read_period_limit_reg <= '1' when ((cs_n = '0') and (read_n = '0') and
                                     (unsigned(addr) >= p_limits_addr) and
                                     (unsigned(addr) < (p_limits_addr + counter_height))) else
                           '0';

  dout <= p_irq_enable_reg when read_irq_enable_reg = '1' else
          std_logic_vector(to_unsigned(p_vector, dout'length)) when read_irq_vector_reg = '1' else
          std_logic_vector(period_length(to_integer(unsigned(addr)) -
                                         to_integer(p_limits_addr))) when read_period_limit_reg = '1' else
          (others => '0');

end architecture count_ticks_rtl;
