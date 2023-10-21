--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Fall 2022
-- File:	signalAcquire.vhd
--
-- Purp: Tie the datapath and control unit together
--
-- Documentation:	No help
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
					-- Include any packages that are instantiated


entity signalAcquire is
    PORT ( clk : in  STD_LOGIC;
           resetn : in  STD_LOGIC;
		   btn: in	STD_LOGIC_VECTOR(2 downto 0);
		   an7606data: in STD_LOGIC_VECTOR(15 downto 0);
		   an7606convst, an7606cs, an7606rd, an7606reset: out STD_LOGIC;
		   an7606od: out STD_LOGIC_VECTOR(2 downto 0);
		   an7606busy : in STD_LOGIC;
		   reg0Magnitude: out STD_LOGIC_VECTOR(3 downto 0));		   
end signalAcquire;

architecture behavior of signalAcquire is
	-- output of cu
	signal cw: STD_LOGIC_VECTOR(CW_WIDTH-1 downto 0);
	-- input to cu
	signal sw: STD_LOGIC_VECTOR(SW_WIDTH-1 downto 0);
	
	-- 3/5 of sw
	signal sw_dp: STD_LOGIC_VECTOR(DATAPATH_SW_WIDTH - 1 downto 0);
	
	-- the other 2/5 of sw
	signal trigger: STD_LOGIC;
	signal busy: STD_LOGIC;

	-- rfData
	signal rfData: STD_LOGIC_VECTOR(15 downto 0);

begin

	-- four comparators and a button process
	-- and the cu and dp

	-- DP
	dpsw: signalAcquire_Datapath
	   port map (  	clk => clk,
	               	resetn => resetn, 
	               	cw => cw, 
	               	sw => sw_dp,
				   	an7606data => an7606data,
				   	rfAddr => "000", -- check if this is the right way
				   	rfData => rfData);
	
	-- CU
	cusw: signalAcquire_Fsm
	   port map(  	clk => clk,
	            	resetn => resetn, 
	               	cw => cw, 
	               	sw => sw);

	-- comparators
	comp4: genericCompare
		GENERIC MAP(8)
		PORT MAP(	x => FOURTH_THRESHOLD_CONSTANT,
					y => rfData,
					g => reg0Magnitude(3),
					l => open,
					e => open);

	comp3: genericCompare
		GENERIC MAP(8)
		PORT MAP(	x => THIRD_THRESHOLD_CONSTANT,
					y => rfData,
					g => reg0Magnitude(2),
					l => open,
					e => open);

	comp2: genericCompare
		GENERIC MAP(8)
		PORT MAP(	x => SECOND_THRESHOLD_CONSTANT,
					y => rfData,
					g => reg0Magnitude(1),
					l => open,
					e => open);

	comp1: genericCompare
		GENERIC MAP(8)
		PORT MAP(	x => FIRST_THRESHOLD_CONSTANT,
					y => rfData,
					g => reg0Magnitude(0),
					l => open,
					e => open);

end behavior;
