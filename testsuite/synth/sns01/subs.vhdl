library ieee;
use ieee.std_logic_1164.all;

entity subs is
  port (
    li : integer;
    ri : integer;
    l4 : std_logic_vector (3 downto 0);
    r3 : std_logic_vector (2 downto 0);

    sub_u4u3u : out std_logic_vector (3 downto 0);
    sub_s4s3s : out std_logic_vector (3 downto 0);
    sub_u4s3s : out std_logic_vector (4 downto 0);
    sub_s4u3s : out std_logic_vector (3 downto 0);
    sub_u4iu  : out std_logic_vector (3 downto 0);
    sub_iu3u  : out std_logic_vector (2 downto 0);
    sub_s4is  : out std_logic_vector (3 downto 0);
    sub_is3s  : out std_logic_vector (2 downto 0);
    sub_u4lu  : out std_logic_vector (3 downto 0);
    sub_lu3u  : out std_logic_vector (2 downto 0);
    sub_s4ls  : out std_logic_vector (3 downto 0);
    sub_ls3s  : out std_logic_vector (2 downto 0);

    sub_u4u3v : out std_logic_vector (3 downto 0);
    sub_s4s3v : out std_logic_vector (3 downto 0);
    sub_u4s3v : out std_logic_vector (4 downto 0);
    sub_s4u3v : out std_logic_vector (3 downto 0);
    sub_u4iv  : out std_logic_vector (3 downto 0);
    sub_iu3v  : out std_logic_vector (2 downto 0);
    sub_s4iv  : out std_logic_vector (3 downto 0);
    sub_is3v  : out std_logic_vector (2 downto 0);
    sub_u4lv  : out std_logic_vector (3 downto 0);
    sub_lu3v  : out std_logic_vector (2 downto 0);
    sub_s4lv  : out std_logic_vector (3 downto 0);
    sub_ls3v  : out std_logic_vector (2 downto 0));
end subs;

library ieee;
use ieee.std_logic_arith.all;

architecture behav of subs is
begin
  sub_u4u3u <= std_logic_vector (unsigned'(unsigned(l4) - unsigned(r3)));
  sub_s4s3s <= std_logic_vector (signed'(signed(l4) - signed(r3)));
  sub_u4s3s <= std_logic_vector (signed'(unsigned(l4) - signed(r3)));
  sub_s4u3s <= std_logic_vector (signed'(signed(l4) - unsigned(r3)));
  sub_u4iu  <= std_logic_vector (unsigned'(unsigned(l4) - ri));
  sub_iu3u  <= std_logic_vector (unsigned'(li - unsigned(r3)));
  sub_s4is  <= std_logic_vector (signed'(signed(l4) - ri));
  sub_is3s  <= std_logic_vector (signed'(li - signed(r3)));
  sub_u4lu  <= std_logic_vector (unsigned'(unsigned(l4) - r3(0)));
  sub_lu3u  <= std_logic_vector (unsigned'(l4(0) - unsigned(r3)));
  sub_s4ls  <= std_logic_vector (signed'(signed(l4) - r3(0)));
  sub_ls3s  <= std_logic_vector (signed'(l4(0) - signed(r3)));

  sub_u4u3v <= unsigned(l4) - unsigned(r3);
  sub_s4s3v <= signed(l4) - signed(r3);
  sub_u4s3v <= unsigned(l4) - signed(r3);
  sub_s4u3v <= signed(l4) - unsigned(r3);
  sub_u4iv  <= unsigned(l4) - ri;
  sub_iu3v  <= li - unsigned(r3);
  sub_s4iv  <= signed(l4) - ri;
  sub_is3v  <= li - signed(r3);
  sub_u4lv  <= unsigned(l4) - r3(0);
  sub_lu3v  <= l4(0) - unsigned(r3);
  sub_s4lv  <= signed(l4) - r3(0);
  sub_ls3v  <= l4(0) - signed(r3);
end behav;
