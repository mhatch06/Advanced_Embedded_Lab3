--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Feb 3, 2015
-- Modified:	Sept 2022
-- File:	lab2_datapath.vhdl
-- HW:	Lab 2
--	Crs:	ECE 383 and EENG 498
--
-- Purp: The datapath for the audio O'scope
--
-- Documentation:	No help, though I used an example from my Digital
--						Design text book.
--
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
------------------------------------------------------------------------- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.signalAcquire_Package.all;
use work.basicBuildingBlocksVhdl.all;	

entity signalAcquire_Datapath is
    PORT ( clk : in  STD_LOGIC;
           resetn : in  STD_LOGIC;
		   cw : in STD_LOGIC_VECTOR(CW_WIDTH -1 downto 0);
		   sw : out STD_LOGIC_VECTOR(DATAPATH_SW_WIDTH - 1 downto 0);
		   an7606data: in STD_LOGIC_VECTOR(15 downto 0);
		   rfAddr: in STD_LOGIC_VECTOR(2 downto 0);
		   rfData: out STD_LOGIC_VECTOR(15 downto 0) );
end signalAcquire_Datapath;

architecture behavior of signalAcquire_Datapath is

	signal longCount : STD_LOGIC_VECTOR(23 downto 0);
	signal shortCount : STD_LOGIC_VECTOR(15 downto 0);
	signal rfCount : STD_LOGIC_VECTOR(3 downto 0);

begin

	longCounterInstantiation : genericCounter
	GENERIC MAP (24)
	PORT MAP ( 	clk => clk,
				resetn => resetn,
				c => cw(CW_LONG_COUNTER_BIT_1 downto CW_LONG_COUNTER_BIT_0),
				d => (others => '0'),
				q => longCount);
			
	longCompareInstantiation: genericCompare
	GENERIC MAP(24)
	PORT MAP(   x => "0x00FFFF",
				y => longCount,
				g => open,
				l => open,
				e => sw(SHORT_DELAY_DONE_SW_BIT_INDEX));

	shortCounterInstantiation : genericCounter
	GENERIC MAP (16)
	PORT MAP ( 	clk => clk,
				resetn => resetn,
				c => cw(CW_SHORT_COUNTER_BIT_1 downto CW_SHORT_COUNTER_BIT_0),
				d => (others => '0'),
				q => shortCount);

	longCompareInstantiation: genericCompare
	GENERIC MAP(24)
	PORT MAP(   x => "0x00FFFF",
				y => longCount,
				g => open,
				l => open,
				e => sw(SHORT_DELAY_DONE_SW_BIT_INDEX));

	rfCounterInstantiation : genericCounter
	GENERIC MAP (4)
	PORT MAP ( 	clk => clk,
				resetn => resetn,
				c => cw(CW_RF_COUNTER_BIT_1 downto CW_RF_COUNTER_BIT_0),
				d => (others => '0'),
				q => rfCount);

	
end behavior;
