-------------------------------------------------------------------------------
-- Title      : Testbench for design "period_controller"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : period_controller_tb.vhd
-- Author     : Igor Parchakov  <igor@fedora>
-- Company    : AGSTU
-- Created    : 2025-04-03
-- Last update: 2025-04-05
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2025 AGSTU
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2025-04-03  1.0      igor	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.pack_period.ALL;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library modelsim_lib;
use modelsim_lib.util.all;

-------------------------------------------------------------------------------

entity period_controller_tb is

end entity period_controller_tb;

-------------------------------------------------------------------------------

architecture modelsim of period_controller_tb is

  --types
  type bus_operation is (IDLE, READ, WRITE);
  type t_OPERATION_REQUEST is record
    op_kind       : bus_operation;
    op_address    : integer;
    op_data_read  : std_logic_vector(31 downto 0);
    op_data_write : std_logic_vector(31 downto 0);
  end record t_OPERATION_REQUEST;


  -- component generics
  constant counter_height : integer := 3;
  constant tick_length    : integer := 27;--25 * 1000 * 1000;
  constant per0           : integer := 3;
  constant per1           : integer := 7;
  constant per2           : integer := 16;
  constant per3           : integer := 279;
  constant per4           : integer := 5;
  constant per5           : integer := 6;
  constant per6           : integer := 7;
  constant per7           : integer := 8;
  constant per8           : integer := 9;
  constant per9           : integer := 10;
  constant per10          : integer := 11;
  constant per11          : integer := 12;
  constant per12          : integer := 13;
  constant per13          : integer := 14;
  constant per14          : integer := 15;
  constant per15          : integer := 16;

  constant p_irq_enable_reg_addr : natural := 0;
  constant p_irq_ack_reg_addr : natural := 1;
  constant p_irq_vector_reg_addr : natural := 2;
  constant p_irq_cs_reg_addr : natural := 3;
  constant p_limits_addr : natural := 4;


  -- component ports
--  signal clk        : std_logic;
  signal reset_n    : std_logic;
  signal p0_irq_out : std_logic;
  signal cs_n       : std_logic;
  signal addr       : std_logic_vector(log2ceil(counter_height + 4) - 1 downto 0);
  signal write_n    : std_logic;
  signal read_n     : std_logic;
  signal din        : std_logic_vector(31 downto 0);
  signal dout       : std_logic_vector(31 downto 0);


  
  -- clock
  signal Clk : std_logic := '1';

--  signal bus_done_n : std_logic;
  signal vector_reg_op : bus_operation := IDLE;
--  signal bus_data_read : std_logic_vector(31 downto 0);
--  signal bus_data_write : std_logic_vector(31 downto 0);
  signal bus_address: integer;
  signal do_read : std_logic := '0';
  signal do_operation : bus_operation;

  signal test_seq_operations : t_OPERATION_REQUEST;

  signal irq_resp_operations : t_OPERATION_REQUEST;
  signal func_resp_operations0 : t_OPERATION_REQUEST;
  signal func_resp_operations1 : t_OPERATION_REQUEST;
  signal func_resp_operations2 : t_OPERATION_REQUEST;

  signal vector : natural range 0 to counter_height -1;
  signal irq_front:std_logic;

  signal function_0, function_0r : std_logic := '0';
  signal function_1, function_1r : std_logic := '0';
  signal function_2, function_2r : std_logic := '0';
  
    -- Wait for a given number of clock cycles
  procedure wait_cycles(cycles : integer) is
  begin
    for i in 0 to cycles loop
      wait until clk = '1';
      wait until clk = '0';
    end loop;
  end procedure;

  procedure bus_read(
    address             :     integer;  --    std_logic_vector(log2ceil(counter_height + 4) - 1 downto 0);
    signal address_out  : out std_logic_vector(log2ceil(counter_height + 4) - 1 downto 0);
    signal cs_n         : out std_logic;
    signal read_n       : out std_logic;
    signal write_n       : out std_logic;
    signal data_read    : out std_logic_vector(31 downto 0);
    signal data_write   : in  std_logic_vector(31 downto 0);
    signal clk, reset_n : in  std_logic;
    signal data_out     : in  std_logic_vector(31 downto 0);
    signal data_in      : out std_logic_vector(31 downto 0);
    signal do_operation : in  bus_operation;
    signal operation    : out bus_operation
    )
  is
  begin
--      wait until do_operation'event;
      Read_Operation :
      if do_operation = READ then
        -- wait until (do_read = '1') and (clk = '1');
        -- wait until clk = '1';
        operation   <= READ;
        address_out <= std_logic_vector(to_unsigned(address, address_out'length));
        cs_n        <= '0';
        read_n      <= '0';
        wait until clk = '0';
        wait until clk = '1';
        data_read   <= data_out;
        cs_n        <= '1';
        read_n      <= '1';
        wait until clk = '1';
        address_out <= (others => 'X');
        operation   <= IDLE;
        wait until do_operation = IDLE;
      elsif do_operation = WRITE then
        operation   <= WRITE;
        address_out <= std_logic_vector(to_unsigned(address, address_out'length));
        cs_n        <= '0';
        write_n     <= '0';
        wait until clk'event and (clk = '1');
        data_in     <= data_write;
        wait until clk'event and (clk = '1');
        cs_n        <= '1';
        write_n     <= '1';
        data_in     <= (others => 'X');
        address_out <= (others => 'X');
        operation   <= IDLE;
        wait until do_operation = IDLE;
      end if Read_Operation;
  end procedure;


begin  -- architecture modelsim

  -- component instantiation
  DUT: entity work.period_controller
    generic map (
      counter_height => counter_height,
      tick_length    => tick_length,
      per0           => per0,
      per1           => per1,
      per2           => per2,
      per3           => per3,
      per4           => per4,
      per5           => per5,
      per6           => per6,
      per7           => per7,
      per8           => per8,
      per9           => per9,
      per10          => per10,
      per11          => per11,
      per12          => per12,
      per13          => per13,
      per14          => per14,
      per15          => per15)
    port map (
      clk        => clk,
      reset_n    => reset_n,
      p0_irq_out => p0_irq_out,
      cs_n       => cs_n,
      addr       => addr,
      write_n    => write_n,
      read_n     => read_n,
      din        => din,
      dout       => dout);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- reset component
  Reset_Proc : process
  begin
    reset_n <= '0';
    wait for 160 ns;
    reset_n <= '1';
    wait;
  end process Reset_Proc;
      
  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here

    wait until Clk = '1';
  end process WaveGen_Proc;

-- bus reead operation
  Read_Bus_Proc : process
--    (reset_n, cs_n, read_n, write_n, Clk, addr)
  begin
    wait until clk = '0';
    if reset_n = '0' then
      addr          <= (others => '0');
      cs_n          <= '1';
      read_n        <= '1';
      write_n        <= '1';
      din           <= (others => '0');
      vector_reg_op <= IDLE;
    else
      wait until test_seq_operations.op_kind'event or 
                 irq_resp_operations.op_kind'event or
                 func_resp_operations0'event or
                 func_resp_operations1'event or
                 func_resp_operations2'event 
                  ;
      if test_seq_operations.op_kind'event then
        modelsim.bus_read(
          address      => test_seq_operations.op_address,
          address_out  => addr,
          cs_n         => cs_n,
          read_n       => read_n,
          write_n      => write_n,
          data_read    => test_seq_operations.op_data_read,
          data_write   => test_seq_operations.op_data_write,
          clk          => Clk, reset_n => reset_n
, data_out             => dout, data_in => din,
          do_operation => test_seq_operations.op_kind,
          operation    => vector_reg_op
          );
      elsif irq_resp_operations.op_kind'event then
        modelsim.bus_read(
          address      => irq_resp_operations.op_address,
          address_out  => addr,
          cs_n         => cs_n,
          read_n       => read_n,
          write_n      => write_n,
          data_read    => irq_resp_operations.op_data_read,
          data_write   => irq_resp_operations.op_data_write,
          clk          => Clk, reset_n => reset_n
, data_out             => dout, data_in => din,
          do_operation => irq_resp_operations.op_kind,
          operation    => vector_reg_op
          );
      elsif func_resp_operations0.op_kind'event then
        modelsim.bus_read(
          address      => func_resp_operations0.op_address,
          address_out  => addr,
          cs_n         => cs_n,
          read_n       => read_n,
          write_n      => write_n,
          data_read    => func_resp_operations0.op_data_read,
          data_write   => func_resp_operations0.op_data_write,
          clk          => Clk, reset_n => reset_n
, data_out             => dout, data_in => din,
          do_operation => func_resp_operations0.op_kind,
          operation    => vector_reg_op
          );
      elsif func_resp_operations1.op_kind'event then
        modelsim.bus_read(
          address      => func_resp_operations1.op_address,
          address_out  => addr,
          cs_n         => cs_n,
          read_n       => read_n,
          write_n      => write_n,
          data_read    => func_resp_operations1.op_data_read,
          data_write   => func_resp_operations1.op_data_write,
          clk          => Clk, reset_n => reset_n
, data_out             => dout, data_in => din,
          do_operation => func_resp_operations1.op_kind,
          operation    => vector_reg_op
          );
      elsif func_resp_operations2.op_kind'event then
        modelsim.bus_read(
          address      => func_resp_operations2.op_address,
          address_out  => addr,
          cs_n         => cs_n,
          read_n       => read_n,
          write_n      => write_n,
          data_read    => func_resp_operations2.op_data_read,
          data_write   => func_resp_operations2.op_data_write,
          clk          => Clk, reset_n => reset_n
, data_out             => dout, data_in => din,
          do_operation => func_resp_operations2.op_kind,
          operation    => vector_reg_op
          );
        null;
      end if;
    end if;
  --   wait;
  end process Read_Bus_Proc;

  -- test sequence
  Test_Sequence : process
  begin
    wait until clk = '0';
-- reset test sequence 
    do_read <= '0';
    test_seq_operations.op_kind <= IDLE;
    wait until reset_n = '1';

    wait_cycles(7);
    
    -- read interrupt enable register
    test_seq_operations.op_address <= 0;
    test_seq_operations.op_kind <= READ;
    wait until vector_reg_op = IDLE;
    test_seq_operations.op_kind <= IDLE;

    wait_cycles(3);
    
-- write 1 to interrupt enable register
    test_seq_operations.op_data_write <=
      std_logic_vector(to_unsigned(7,test_seq_operations.op_data_write'length));
    test_seq_operations.op_kind <= WRITE;
    wait until vector_reg_op = IDLE;
    test_seq_operations.op_kind <= IDLE;

    wait_cycles(3);
    -- run the component
    test_seq_operations.op_data_write <=
      std_logic_vector(to_unsigned(1,test_seq_operations.op_data_write'length));
    test_seq_operations.op_address <= p_irq_cs_reg_addr;
    test_seq_operations.op_kind <= WRITE;
    wait until vector_reg_op = IDLE;
    test_seq_operations.op_kind <= IDLE;
    

    wait;
  end process Test_Sequence;
    
  --interrupt service
  Interrupt_Service_Proc : process
  --   (reset_n, Clk)
  begin
    wait until clk = '0';
    if reset_n = '0' then
      vector                      <= 0;
      irq_front                   <= '0';
      irq_resp_operations.op_kind <= IDLE;

    else
      wait until clk = '1'; -- clk'event and (clk = '1');
--if rising_edge(Clk) then
         if (function_0r = '0') then 
            if (function_0 = '1') then
             wait until function_0r = '1';
            end if;
         end if;
         function_0 <= '0';
         if (function_1r = '0') then
           if (function_1 = '1') then
             wait until function_1r = '1';
           end if;
         end if;
         function_1 <= '0';
         if (function_2r = '0') then
           if (function_2 = '1') then
             wait until function_2r = '1';
           end if;
         end if;
         function_2 <= '0';
      if (p0_irq_out = '1') then
        irq_front <= '1';
        if (irq_front = '0') then
          -- serve interrupt
          wait_cycles(9);
          -- read irq vector
          irq_resp_operations.op_address            <= p_irq_vector_reg_addr;
          irq_resp_operations.op_kind               <= READ;
          wait until vector_reg_op = IDLE;
          vector                                    <= to_integer(unsigned(irq_resp_operations.op_data_read));
          irq_resp_operations.op_kind               <= IDLE;

          wait_cycles(3);
          -- acknowledge
          irq_resp_operations.op_data_write         <= (others => '0');
          irq_resp_operations.op_address            <= p_irq_vector_reg_addr;
          irq_resp_operations.op_kind               <= WRITE;
          wait until vector_reg_op = IDLE;
          irq_resp_operations.op_kind               <= IDLE;
          -- do isr
          wait_cycles(1);
          --
          case vector is
            when 0 =>
              function_0 <= '1';
            when 1 =>
              function_1 <= '1';
            when 2 =>
              function_2 <= '1';
            when others =>
              wait until clk = '0';
          end case;
          
--          -- acknowledge by vector
--          irq_resp_operations.op_data_write         <= (others => '0');
--          irq_resp_operations.op_data_write(vector) <= '1';
--          irq_resp_operations.op_address            <= p_irq_ack_reg_addr;
--          irq_resp_operations.op_kind               <= WRITE;
--          wait until vector_reg_op = IDLE;
--          irq_resp_operations.op_kind               <= IDLE;
        end if;
      else
        irq_front <= '0';
      end if;
    end if;

  end process Interrupt_Service_Proc;

  Period_function_0 : process
  --   (reset_n, Clk)
  begin
    wait until clk = '0';
    if reset_n = '0' then
--
      function_0r <= '0';
    else
      wait until clk'event and (clk = '1');
--if rising_edge(Clk) then
      if function_0 = '1' then
        function_0r <= '1';
        wait_cycles(1);
        wait_cycles(30);
         -- acknowledge by vector
         func_resp_operations0.op_data_write         <= (others => '0');
         func_resp_operations0.op_data_write(0) <= '1';
         func_resp_operations0.op_address            <= p_irq_ack_reg_addr;
         func_resp_operations0.op_kind               <= WRITE;
         wait until vector_reg_op = IDLE;
         func_resp_operations0.op_kind               <= IDLE;
        function_0r <= '0';
      end if;
    end if;
  end process Period_function_0;                

  Period_function_1 : process
  --   (reset_n, Clk)
  begin
    wait until clk = '0';
    if reset_n = '0' then
--      vector                      <= 0;
--      irq_front                   <= '0';
--      irq_resp_operations.op_kind <= IDLE;
      function_1r <= '0';
--
    else
      wait until clk'event and (clk = '1');
--if rising_edge(Clk) then
      if function_1 = '1' then
        function_1r <= '1';
        wait_cycles(1);
        wait_cycles(30);
         -- acknowledge by vector
         func_resp_operations1.op_data_write         <= (others => '0');
         func_resp_operations1.op_data_write(1) <= '1';
         func_resp_operations1.op_address            <= p_irq_ack_reg_addr;
         func_resp_operations1.op_kind               <= WRITE;
         wait until vector_reg_op = IDLE;
         func_resp_operations1.op_kind               <= IDLE;

        function_1r <= '0';
      end if;
    end if;
  end process Period_function_1;                

  Period_function_2 : process
  --   (reset_n, Clk)
  begin
    wait until clk = '0';
    if reset_n = '0' then
--      vector                      <= 0;
--      irq_front                   <= '0';
--      irq_resp_operations.op_kind <= IDLE;
      function_2r <= '0';
--
    else
      wait until clk'event and (clk = '1');
--if rising_edge(Clk) then
      if function_2 = '1' then
        function_2r <= '1';
        wait_cycles(1);
        wait_cycles(30);
         -- acknowledge by vector
         func_resp_operations2.op_data_write         <= (others => '0');
         func_resp_operations2.op_data_write(2) <= '1';
         func_resp_operations2.op_address            <= p_irq_ack_reg_addr;
         func_resp_operations2.op_kind               <= WRITE;
         wait until vector_reg_op = IDLE;
         func_resp_operations2.op_kind               <= IDLE;

        function_2r <= '0';
      end if;
    end if;
  end process Period_function_2;                


end architecture modelsim;

-------------------------------------------------------------------------------

configuration period_controller_tb_modelsim_cfg of period_controller_tb is
  for modelsim
  end for;
end period_controller_tb_modelsim_cfg;

-------------------------------------------------------------------------------
