
-- Copyright (C) 1996 Morgan Kaufmann Publishers, Inc

-- This file is part of VESTs (Vhdl tESTs).

-- VESTs is free software; you can redistribute it and/or modify it
-- under the terms of the GNU General Public License as published by the
-- Free Software Foundation; either version 2 of the License, or (at
-- your option) any later version. 

-- VESTs is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-- FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
-- for more details. 

-- You should have received a copy of the GNU General Public License
-- along with VESTs; if not, write to the Free Software Foundation,
-- Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 

-- ---------------------------------------------------------------------
--
-- $Id: ch_19_source.vhd,v 1.2 2001-10-24 22:18:13 paw Exp $
-- $Revision: 1.2 $
--
-- ---------------------------------------------------------------------

library qsim;
library random;

use qsim.qsim_types.all, random.random.all;

entity source is

  generic ( name : string;
            distribution : distribution_type;
            mean_inter_arrival_time : delay_length;
            seed : seed_type;
            time_unit : delay_length := ns;
            info_file_name : string := "info_file.dat" );

  port ( out_arc : out arc_type;
         info_detail : in info_detail_type );

end entity source;
