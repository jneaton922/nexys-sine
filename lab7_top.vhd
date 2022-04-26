

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2022 08:31:17 PM
-- Design Name: 
-- Module Name: lab5_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.all;

-- top level entity
entity lab7_top is
  Port (
    clk : in std_logic;
    reset_sw : in std_logic
  );
end lab7_top;

-- top-level arch
architecture arch of lab7_top is

    component sine_lut_dds
    port (
    aclk: in std_logic;
    s_axis_phase_tvalid : in std_logic;
    s_axis_tdata : in std_logic_vector(7 downto 0); --8 bit PHASE resolution
    m_axis_data_tvalid : out std_logic;
    m_axis_data_tdata: out std_logic_vector(15 downto 0)
    );
    end component;

begin

end arch;
