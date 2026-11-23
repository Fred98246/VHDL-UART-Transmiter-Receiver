library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_T is
port(

i_clk: in std_logic;
i_TX_start: in std_logic;
i_TX_byte: in std_logic_vector(7 downto 0);
o_TX_serial:out std_logic;
o_TX_done: out std_logic;
o_TX_active: out std_logic

);
end entity UART_T;

architecture RTX of UART_T is 

type t_SM_main is (TX_idle, TX_start_bit, TX_data_bit, TX_end_bit, TX_cleanup);

signal r_SM_Main : t_SM_Main := TX_idle;
constant g_clks_per_bit : integer := 434;
signal r_clk_count : integer range 0 to g_clks_per_bit - 1 := 0;
signal r_bit_index : integer range 0 to 7 := 0; 

signal r_TX_Data   : std_logic_vector(7 downto 0) := (others => '0');
signal r_TX_Serial : std_logic := '1'; -- UART line defaults high
signal r_TX_Done   : std_logic := '0';

begin

UART_T: process(i_clk)

begin

	if rising_edge (i_clk) then
		
		case r_SM_main is
		
			when TX_idle =>
			
			r_clk_count <= 0;
			r_bit_index <= 0;
			r_TX_Done <= '0';
			r_TX_Serial <= '1';
			o_TX_active <= '0';
				
					if (i_TX_start = '1') then
						r_TX_Data <= i_TX_byte;
						r_SM_main <= TX_start_bit;
					else 
						r_SM_main <= TX_idle;
					end if;
				
			when TX_start_bit =>
			
			r_TX_Serial <= '0';
			o_TX_active <= '1';
				
				if(r_clk_count = g_clks_per_bit-1) then
					r_SM_main <= TX_data_bit;
					r_clk_count <= 0;
				else
					r_SM_main <= TX_start_bit;
					r_clk_count <= r_clk_count + 1;
				end if;
				
			when TX_data_bit =>

				r_TX_Serial <= r_TX_Data(r_bit_index);
			
				if (r_clk_count < g_clks_per_bit-1) then
					r_clk_count <= r_clk_count + 1;
					r_SM_main <= TX_data_bit;
				else
					r_clk_count <= 0;
					
					if(r_bit_index < 7) then
						r_bit_index <= r_bit_index + 1;
					else
						r_bit_index <= 0;
						r_SM_main <= TX_end_bit;
					end if;
					
				end if;
					
			when TX_end_bit =>
			
				r_TX_Serial <= '1';
				
				if (r_clk_count < g_clks_per_bit-1) then
					r_clk_count <= r_clk_count + 1;
					r_SM_main <= TX_end_bit;
				else 
					r_clk_count <= 0;
					r_SM_main <= TX_cleanup;
				end if;
				
			when TX_cleanup =>
			
				r_TX_Done <= '1';
				o_TX_active <= '0';
				r_SM_main <= TX_idle;
				
			when others =>
				r_SM_Main <= TX_Idle;
				
			end case;
			
	end if;
	
end process;

o_TX_serial <= r_TX_Serial;
o_TX_done <= r_TX_Done;

end architecture RTX;