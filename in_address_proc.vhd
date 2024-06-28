library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.my_util.all;
entity in_address_proc is
	port (
		address : in unsigned(11 downto 0);
		o : out amatrix
	);
end in_address_proc;

architecture Behavioral of in_address_proc is
	-- Given an address as input return a kernel matrix corresponding to that input.
	signal i : integer;
	signal j : integer;

begin
	i <= to_integer(address / 64);
	j <= to_integer(address mod 64);
    o <= (((i - 1) * 64 + j - 1, 
    (i - 1) * 64 + j, 
    (i - 1) * 64 + j + 1), 
    (i * 64 + j - 1, 
    i * 64 + j, 
    i * 64 + j + 1), 
    ((i + 1) * 64 + j - 1, (i + 1) * 64 + j, (i + 1) * 64 + j + 1));
end Behavioral;