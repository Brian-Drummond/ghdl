
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    
library work;
    use work.wb_pkg.all;

package memory_map_pkg is
 
  type memory_map_i_t is record
    dmn    : dmn_t;
    wb_M2S : wb_M2S_t;
    reg    : array_t; 
  end record;

  type memory_map_o_t is record
    wb_S2M : wb_S2M_t;
    en     : std_ulogic_vector;
    reg    : array_t; 
  end record;
  
end memory_map_pkg;
--#############################################################################
--=============================================================================
--#############################################################################
package body memory_map_pkg is

end package body memory_map_pkg;
--#######################################################################################
--#######################################################################################
--#######################################################################################
--#######################################################################################
--#######################################################################################
