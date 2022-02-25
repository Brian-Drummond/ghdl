--  Bug handling
--  Copyright (C) 2002, 2003, 2004, 2005 Tristan Gingold
--
--  This program is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program.  If not, see <gnu.org/licenses>.

with Ada.Command_Line; use Ada.Command_Line;
with GNAT.Directory_Operations;
with Simple_IO; use Simple_IO;
with Version;

package body Bug is
   --  Declared in the files generated by gnatbind.
   --  Note: since the string is exported with C convension, there is no way
   --  to know the length (gnat1 crashes if the string is unconstrained).
   --  Hopefully, the format of the string seems to be fixed.
   --  We don't use GNAT.Compiler_Version because it doesn't exist
   --   in gnat 3.15p
   GNAT_Version : constant String (1 .. 31 + 15);
   pragma Import (C, GNAT_Version, "__gnat_version");

   function Get_Gnat_Version return String
   is
      C : Character;
   begin
      for I in GNAT_Version'Range loop
         C := GNAT_Version (I);
         case C is
            when ' '
              | 'A' .. 'Z'
              | 'a' .. 'z'
              | '0' .. '9'
              | ':'
              | '-'
              | '.'
              | '(' =>
               --  Accept only a few printable characters.
               --  Underscore is excluded since the next bytes after
               --  GNAT_Version is Ada_Main_Program_Name, which often starts
               --  with _ada_.
               null;
            when ')' =>
               return GNAT_Version (1 .. I);
            when others =>
               return GNAT_Version (1 .. I - 1);
         end case;
      end loop;
      return GNAT_Version;
   end Get_Gnat_Version;

   procedure Disp_Bug_Box (Except : Exception_Occurrence)
   is
      Id : Exception_Id;
   begin
      New_Line_Err;
      Put_Line_Err
        ("******************** GHDL Bug occurred ***************************");
      Put_Line_Err
        ("Please report this bug on https://github.com/ghdl/ghdl/issues");
      Put_Line_Err ( "GHDL release: " &
         Version.Ghdl_Ver & ' ' & Version.Ghdl_Release
      );
      Put_Line_Err ("Compiled with " & Get_Gnat_Version);
      Put_Line_Err ("Target: " & Standard'Target_Name);
      Put_Line_Err (GNAT.Directory_Operations.Get_Current_Dir);
      --Put_Line
      --  ("Program name: " & Command_Name);
      --Put_Line
      --  ("Program arguments:");
      --for I in 1 .. Argument_Count loop
      --   Put_Line ("  " & Argument (I));
      --end loop;
      Put_Line_Err ("Command line:");
      Put_Err (Command_Name);
      for I in 1 .. Argument_Count loop
         Put_Err (' ');
         Put_Err (Argument (I));
      end loop;
      New_Line_Err;
      Id := Exception_Identity (Except);
      if Id /= Null_Id then
         Put_Line_Err ("Exception " & Exception_Name (Id) & " raised");
         --Put_Line ("exception message: " & Exception_Message (Except));
         Put_Line_Err ("Exception information:");
         Put_Err (Exception_Information (Except));
      end if;
      Put_Line_Err
        ("******************************************************************");
   end Disp_Bug_Box;
end Bug;
