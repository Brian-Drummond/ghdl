--  DO NOT MODIFY - this file was generated from:
--  ortho_nodes.common.ads and ortho_gcc.private.ads
--
--  GCC back-end for ortho.
--  Copyright (C) 2002-1014 Tristan Gingold
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
with System;
with Interfaces; use Interfaces;
with Ortho_Ident;
use Ortho_Ident;

--  Interface to create nodes.
package Ortho_Gcc is

--  Start of common part

   type O_Enode is private;
   type O_Cnode is private;
   type O_Lnode is private;
   type O_Tnode is private;
   type O_Snode is private;
   type O_Dnode is private;
   type O_Gnode is private;
   type O_Fnode is private;

   O_Cnode_Null : constant O_Cnode;
   O_Dnode_Null : constant O_Dnode;
   O_Gnode_Null : constant O_Gnode;
   O_Enode_Null : constant O_Enode;
   O_Fnode_Null : constant O_Fnode;
   O_Lnode_Null : constant O_Lnode;
   O_Snode_Null : constant O_Snode;
   O_Tnode_Null : constant O_Tnode;

   --  True if the code generated supports nested subprograms.
   Has_Nested_Subprograms : constant Boolean;

   ------------------------
   --  Type definitions  --
   ------------------------

   type O_Element_List is limited private;

   --  Build a record type.
   procedure Start_Record_Type (Elements : out O_Element_List);
   --  Add a field in the record.  Unconstrained fields must be at the end,
   --  and cannot be followed by a constrained one.
   procedure New_Record_Field
     (Elements : in out O_Element_List;
      El : out O_Fnode;
      Ident : O_Ident; Etype : O_Tnode);
   --  Finish the record type.
   procedure Finish_Record_Type
     (Elements : in out O_Element_List; Res : out O_Tnode);

   type O_Element_Sublist is limited private;

   --  Build a record subtype.
   --  Re-declare only unconstrained fields with a subtype of them.
   procedure Start_Record_Subtype
     (Rtype : O_Tnode; Elements : out O_Element_Sublist);
   procedure New_Subrecord_Field
     (Elements : in out O_Element_Sublist; El : out O_Fnode; Etype : O_Tnode);
   procedure Finish_Record_Subtype
     (Elements : in out O_Element_Sublist; Res : out O_Tnode);

   -- Build an uncomplete record type:
   -- First call NEW_UNCOMPLETE_RECORD_TYPE, which returns a record type.
   -- This type can be declared or used to define access types on it.
   -- Then, complete (if necessary) the record type, by calling
   -- START_UNCOMPLETE_RECORD_TYPE, NEW_RECORD_FIELD and FINISH_RECORD_TYPE.
   procedure New_Uncomplete_Record_Type (Res : out O_Tnode);
   procedure Start_Uncomplete_Record_Type (Res : O_Tnode;
                                           Elements : out O_Element_List);

   --  Build an union type.
   procedure Start_Union_Type (Elements : out O_Element_List);
   procedure New_Union_Field
     (Elements : in out O_Element_List;
      El : out O_Fnode;
      Ident : O_Ident;
      Etype : O_Tnode);
   procedure Finish_Union_Type
     (Elements : in out O_Element_List; Res : out O_Tnode);

   --  Build an access type.
   --  DTYPE may be O_tnode_null in order to build an incomplete access type.
   --  It is completed with finish_access_type.
   function New_Access_Type (Dtype : O_Tnode) return O_Tnode;
   procedure Finish_Access_Type (Atype : O_Tnode; Dtype : O_Tnode);

   --  Build an array type.
   --  The array is not constrained and unidimensional.
   function New_Array_Type (El_Type : O_Tnode; Index_Type : O_Tnode)
     return O_Tnode;

   --  Build a constrained array type.
   function New_Array_Subtype
     (Atype : O_Tnode; El_Type : O_Tnode; Length : O_Cnode) return O_Tnode;

   --  Build a scalar type; size may be 8, 16, 32 or 64.
   function New_Unsigned_Type (Size : Natural) return O_Tnode;
   function New_Signed_Type (Size : Natural) return O_Tnode;

   --  Build a float type.
   function New_Float_Type return O_Tnode;

   --  Build a boolean type.
   procedure New_Boolean_Type (Res : out O_Tnode;
                               False_Id : O_Ident;
                               False_E : out O_Cnode;
                               True_Id : O_Ident;
                               True_E : out O_Cnode);

   --  Create an enumeration
   type O_Enum_List is limited private;

   --  Elements are declared in order, the first is ordered from 0.
   procedure Start_Enum_Type (List : out O_Enum_List; Size : Natural);
   procedure New_Enum_Literal (List : in out O_Enum_List;
                               Ident : O_Ident; Res : out O_Cnode);
   procedure Finish_Enum_Type (List : in out O_Enum_List; Res : out O_Tnode);

   ----------------
   --  Literals  --
   ----------------

   --  Create a literal from an integer.
   function New_Signed_Literal (Ltype : O_Tnode; Value : Integer_64)
     return O_Cnode;
   function New_Unsigned_Literal (Ltype : O_Tnode; Value : Unsigned_64)
     return O_Cnode;

   function New_Float_Literal (Ltype : O_Tnode; Value : IEEE_Float_64)
     return O_Cnode;

   --  Create a null access literal.
   function New_Null_Access (Ltype : O_Tnode) return O_Cnode;

   --  Create a literal with default (null) values.  Can only be used to
   --  define the initial value of a static decalaration.
   function New_Default_Value (Ltype : O_Tnode) return O_Cnode;

   --  Build a record/array aggregate.
   --  The aggregate is constant, and therefore can be only used to initialize
   --  constant declaration.
   --  ATYPE must be either a record type or an array subtype.
   --  Elements must be added in the order, and must be literals or aggregates.
   type O_Record_Aggr_List is limited private;
   type O_Array_Aggr_List is limited private;

   procedure Start_Record_Aggr (List : out O_Record_Aggr_List;
                                Atype : O_Tnode);
   procedure New_Record_Aggr_El (List : in out O_Record_Aggr_List;
                                 Value : O_Cnode);
   procedure Finish_Record_Aggr (List : in out O_Record_Aggr_List;
                                 Res : out O_Cnode);

   procedure Start_Array_Aggr
     (List : out O_Array_Aggr_List; Atype : O_Tnode; Len : Unsigned_32);
   procedure New_Array_Aggr_El (List : in out O_Array_Aggr_List;
                                Value : O_Cnode);
   procedure Finish_Array_Aggr (List : in out O_Array_Aggr_List;
                                Res : out O_Cnode);

   --  Build an union aggregate.
   function New_Union_Aggr (Atype : O_Tnode; Field : O_Fnode; Value : O_Cnode)
                           return O_Cnode;

   --  Returns the size in bytes of ATYPE.  The result is a literal of
   --  unsigned type RTYPE
   --  ATYPE cannot be an unconstrained type.
   function New_Sizeof (Atype : O_Tnode; Rtype : O_Tnode) return O_Cnode;

   --  Get the size of the bounded part of a record.
   function New_Record_Sizeof
     (Atype : O_Tnode; Rtype : O_Tnode) return O_Cnode;

   --  Returns the alignment in bytes for ATYPE.  The result is a literal of
   --  unsgined type RTYPE.
   function New_Alignof (Atype : O_Tnode; Rtype : O_Tnode) return O_Cnode;

   --  Returns the offset of FIELD in its record ATYPE.  The result is a
   --  literal of unsigned type or access type RTYPE.
   function New_Offsetof (Atype : O_Tnode; Field : O_Fnode; Rtype : O_Tnode)
                         return O_Cnode;

   --  Get the address of a subprogram.
   function New_Subprogram_Address (Subprg : O_Dnode; Atype : O_Tnode)
                                   return O_Cnode;

   --  Get the address of LVALUE.
   --  ATYPE must be a type access whose designated type is the type of LVALUE.
   --  FIXME: what about arrays.
   function New_Global_Address (Lvalue : O_Gnode; Atype : O_Tnode)
                               return O_Cnode;

   --  Same as New_Address but without any restriction.
   function New_Global_Unchecked_Address (Lvalue : O_Gnode; Atype : O_Tnode)
                                         return O_Cnode;

   -------------------
   --  Expressions  --
   -------------------

   type ON_Op_Kind is
     (
      --  Not an operation; invalid.
      ON_Nil,

      --  Dyadic operations.
      ON_Add_Ov,                --  ON_Dyadic_Op_Kind
      ON_Sub_Ov,                --  ON_Dyadic_Op_Kind
      ON_Mul_Ov,                --  ON_Dyadic_Op_Kind
      ON_Div_Ov,                --  ON_Dyadic_Op_Kind
      ON_Rem_Ov,                --  ON_Dyadic_Op_Kind
      ON_Mod_Ov,                --  ON_Dyadic_Op_Kind

      --  Binary operations.
      ON_And,                   --  ON_Dyadic_Op_Kind
      ON_Or,                    --  ON_Dyadic_Op_Kind
      ON_Xor,                   --  ON_Dyadic_Op_Kind

      --  Monadic operations.
      ON_Not,                   --  ON_Monadic_Op_Kind
      ON_Neg_Ov,                --  ON_Monadic_Op_Kind
      ON_Abs_Ov,                --  ON_Monadic_Op_Kind

      --  Comparaisons
      ON_Eq,                    --  ON_Compare_Op_Kind
      ON_Neq,                   --  ON_Compare_Op_Kind
      ON_Le,                    --  ON_Compare_Op_Kind
      ON_Lt,                    --  ON_Compare_Op_Kind
      ON_Ge,                    --  ON_Compare_Op_Kind
      ON_Gt                     --  ON_Compare_Op_Kind
      );

   subtype ON_Dyadic_Op_Kind is ON_Op_Kind range ON_Add_Ov .. ON_Xor;
   subtype ON_Monadic_Op_Kind is ON_Op_Kind range ON_Not .. ON_Abs_Ov;
   subtype ON_Compare_Op_Kind is ON_Op_Kind range ON_Eq .. ON_Gt;

   type O_Storage is (O_Storage_External,
                      O_Storage_Public,
                      O_Storage_Private,
                      O_Storage_Local);
   --  Specifies the storage kind of a declaration.
   --  O_STORAGE_EXTERNAL:
   --    The declaration do not either reserve memory nor generate code, and
   --    is imported either from an other file or from a later place in the
   --    current file.
   --  O_STORAGE_PUBLIC, O_STORAGE_PRIVATE:
   --    The declaration reserves memory or generates code.
   --    With O_STORAGE_PUBLIC, the declaration is exported outside of the
   --    file while with O_STORAGE_PRIVATE, the declaration is local to the
   --    file.

   Type_Error : exception;
   Syntax_Error : exception;

   --  Create a value from a literal.
   function New_Lit (Lit : O_Cnode) return O_Enode;

   --  Create a dyadic operation.
   --  Left and right nodes must have the same type.
   --  Binary operation is allowed only on boolean types.
   --  The result is of the type of the operands.
   function New_Dyadic_Op (Kind : ON_Dyadic_Op_Kind; Left, Right : O_Enode)
     return O_Enode;

   --  Create a monadic operation.
   --  Result is of the type of operand.
   function New_Monadic_Op (Kind : ON_Monadic_Op_Kind; Operand : O_Enode)
     return O_Enode;

   --  Create a comparaison operator.
   --  NTYPE is the type of the result and must be a boolean type.
   function New_Compare_Op
     (Kind : ON_Compare_Op_Kind; Left, Right : O_Enode; Ntype : O_Tnode)
     return O_Enode;


   type O_Inter_List is limited private;
   type O_Assoc_List is limited private;
   type O_If_Block is limited private;
   type O_Case_Block is limited private;


   --  Get an element of an array.
   --  INDEX must be of the type of the array index.
   function New_Indexed_Element (Arr : O_Lnode; Index : O_Enode)
     return O_Lnode;

   --  Get a slice of an array; this is equivalent to a conversion between
   --  an array or an array subtype and an array subtype.
   --  RES_TYPE must be an array_sub_type whose base type is the same as the
   --  base type of ARR.
   --  INDEX must be of the type of the array index.
   function New_Slice (Arr : O_Lnode; Res_Type : O_Tnode; Index : O_Enode)
                      return O_Lnode;

   --  Get an element of a record or a union.
   --  Type of REC must be a record or a union type.
   function New_Selected_Element (Rec : O_Lnode; El : O_Fnode)
                                 return O_Lnode;

   function New_Global_Selected_Element (Rec : O_Gnode; El : O_Fnode)
                                        return O_Gnode;

   --  Reference an access.
   --  Type of ACC must be an access type.
   function New_Access_Element (Acc : O_Enode) return O_Lnode;

   --  Do a conversion.
   --  Allowed conversions are:
   --  FIXME: to write.
   function New_Convert_Ov (Val : O_Enode; Rtype : O_Tnode) return O_Enode;
   function New_Convert (Val : O_Enode; Rtype : O_Tnode) return O_Enode;

   --  Get the address of LVALUE.
   --  ATYPE must be a type access whose designated type is the type of LVALUE.
   --  FIXME: what about arrays.
   function New_Address (Lvalue : O_Lnode; Atype : O_Tnode) return O_Enode;

   --  Same as New_Address but without any restriction.
   function New_Unchecked_Address (Lvalue : O_Lnode; Atype : O_Tnode)
     return O_Enode;

   --  Get the value of an Lvalue.
   function New_Value (Lvalue : O_Lnode) return O_Enode;
   function New_Obj_Value (Obj : O_Dnode) return O_Enode;

   --  Get an lvalue from a declaration.
   function New_Obj (Obj : O_Dnode) return O_Lnode;

   --  Get a global lvalue from a declaration.
   function New_Global (Decl : O_Dnode) return O_Gnode;

   --  Return a pointer of type RTPE to SIZE bytes allocated on the stack.
   function New_Alloca (Rtype : O_Tnode; Size : O_Enode) return O_Enode;

   --  Declare a type.
   --  This simply gives a name to a type.
   procedure New_Type_Decl (Ident : O_Ident; Atype : O_Tnode);

   ---------------------
   --  Declarations.  --
   ---------------------

   --  Filename of the next declaration.
   procedure New_Debug_Filename_Decl (Filename : String);

   --  Line number of the next declaration.
   procedure New_Debug_Line_Decl (Line : Natural);

   --  Add a comment in the declarative region.
   procedure New_Debug_Comment_Decl (Comment : String);

   --  Declare a constant.
   --  This simply gives a name to a constant value or aggregate.
   --  A constant cannot be modified and its storage cannot be local.
   --  ATYPE must be constrained.
   procedure New_Const_Decl
     (Res : out O_Dnode;
      Ident : O_Ident;
      Storage : O_Storage;
      Atype : O_Tnode);

   --  Set the value of a non-external constant or variable.
   procedure Start_Init_Value (Decl : in out O_Dnode);
   procedure Finish_Init_Value (Decl : in out O_Dnode; Val : O_Cnode);

   --  Create a variable declaration.
   --  A variable can be local only inside a function.
   --  ATYPE must be constrained.
   procedure New_Var_Decl
     (Res : out O_Dnode;
      Ident : O_Ident;
      Storage : O_Storage;
      Atype : O_Tnode);

   --  Start a subprogram declaration.
   --  Note: nested subprograms are allowed, ie o_storage_local subprograms can
   --   be declared inside a subprograms.  It is not allowed to declare
   --   o_storage_external subprograms inside a subprograms.
   --  Return type and interfaces cannot be a composite type.
   procedure Start_Function_Decl
     (Interfaces : out O_Inter_List;
      Ident : O_Ident;
      Storage : O_Storage;
      Rtype : O_Tnode);
   --  For a subprogram without return value.
   procedure Start_Procedure_Decl
     (Interfaces : out O_Inter_List;
      Ident : O_Ident;
      Storage : O_Storage);

   --  Add an interface declaration to INTERFACES.
   procedure New_Interface_Decl
     (Interfaces : in out O_Inter_List;
      Res : out O_Dnode;
      Ident : O_Ident;
      Atype : O_Tnode);
   --  Finish the function declaration, get the node and a statement list.
   procedure Finish_Subprogram_Decl
     (Interfaces : in out O_Inter_List; Res : out O_Dnode);
   --  Start a subprogram body.
   --  Note: the declaration may have an external storage, in this case it
   --  becomes public.
   procedure Start_Subprogram_Body (Func : O_Dnode);
   --  Finish a subprogram body.
   procedure Finish_Subprogram_Body;


   -------------------
   --  Statements.  --
   -------------------

   --  Add a line number as a statement.
   procedure New_Debug_Line_Stmt (Line : Natural);

   --  Add a comment as a statement.
   procedure New_Debug_Comment_Stmt (Comment : String);

   --  Start a declarative region.
   procedure Start_Declare_Stmt;
   procedure Finish_Declare_Stmt;

   --  Create a function call or a procedure call.
   procedure Start_Association (Assocs : out O_Assoc_List; Subprg : O_Dnode);
   procedure New_Association (Assocs : in out O_Assoc_List; Val : O_Enode);
   function New_Function_Call (Assocs : O_Assoc_List) return O_Enode;
   procedure New_Procedure_Call (Assocs : in out O_Assoc_List);

   --  Assign VALUE to TARGET, type must be the same or compatible.
   --  FIXME: what about slice assignment?
   procedure New_Assign_Stmt (Target : O_Lnode; Value : O_Enode);

   --  Exit from the subprogram and return VALUE.
   procedure New_Return_Stmt (Value : O_Enode);
   --  Exit from the subprogram, which doesn't return value.
   procedure New_Return_Stmt;

   --  Build an IF statement.
   procedure Start_If_Stmt (Block : in out O_If_Block; Cond : O_Enode);
   procedure New_Else_Stmt (Block : in out O_If_Block);
   procedure Finish_If_Stmt (Block : in out O_If_Block);

   --  Create a infinite loop statement.
   procedure Start_Loop_Stmt (Label : out O_Snode);
   procedure Finish_Loop_Stmt (Label : in out O_Snode);

   --  Exit from a loop stmt or from a for stmt.
   procedure New_Exit_Stmt (L : O_Snode);
   --  Go to the start of a loop stmt or of a for stmt.
   --  Loops/Fors between L and the current points are exited.
   procedure New_Next_Stmt (L : O_Snode);

   --  Case statement.
   --  VALUE is the selector and must be a discrete type.
   procedure Start_Case_Stmt (Block : in out O_Case_Block; Value : O_Enode);
   --  A choice branch is composed of expr, range or default choices.
   --  A choice branch is enclosed between a Start_Choice and a Finish_Choice.
   --  The statements are after the finish_choice.
   procedure Start_Choice (Block : in out O_Case_Block);
   procedure New_Expr_Choice (Block : in out O_Case_Block; Expr : O_Cnode);
   procedure New_Range_Choice (Block : in out O_Case_Block;
                               Low, High : O_Cnode);
   procedure New_Default_Choice (Block : in out O_Case_Block);
   procedure Finish_Choice (Block : in out O_Case_Block);
   procedure Finish_Case_Stmt (Block : in out O_Case_Block);

--  End of common part
private
   --  GCC supports nested subprograms.
   Has_Nested_Subprograms : constant Boolean := True;

   pragma Convention (C, O_Storage);
   --   pragma Convention (C, ON_Op_Kind);

   subtype Tree is System.Address;
   NULL_TREE : constant Tree := System.Null_Address;

   subtype Vec_Ptr is System.Address;

   type O_Cnode is new Tree;
   type O_Enode is new Tree;
   type O_Lnode is new Tree;
   type O_Gnode is new Tree;
   type O_Tnode is new Tree;
   type O_Fnode is new Tree;
   type O_Dnode is new Tree;
   type O_Snode is record
      Beg_Label : Tree;
      End_Label : Tree;
   end record;
   pragma Convention (C, O_Snode);

   O_Cnode_Null : constant O_Cnode := O_Cnode (NULL_TREE);
   O_Enode_Null : constant O_Enode := O_Enode (NULL_TREE);
   O_Lnode_Null : constant O_Lnode := O_Lnode (NULL_TREE);
   O_Gnode_Null : constant O_Gnode := O_Gnode (NULL_TREE);
   O_Tnode_Null : constant O_Tnode := O_Tnode (NULL_TREE);
   O_Fnode_Null : constant O_Fnode := O_Fnode (NULL_TREE);
   O_Snode_Null : constant O_Snode := (NULL_TREE, NULL_TREE);
   O_Dnode_Null : constant O_Dnode := O_Dnode (NULL_TREE);

   pragma Inline (New_Lit);
   pragma Inline (New_Obj);
   pragma Inline (New_Obj_Value);

   --  Efficiently append element EL to a chain.
   --  FIRST is the first element of the chain (must NULL_TREE if the chain
   --   is empty),
   --  LAST is the last element of the chain (idem).
   type Chain_Constr_Type is record
      First : Tree;
      Last : Tree;
   end record;
   pragma Convention (C, Chain_Constr_Type);
   procedure Chain_Init (Constr : out Chain_Constr_Type);
   pragma Import (C, Chain_Init);
   procedure Chain_Append (Constr : in out Chain_Constr_Type; El : Tree);
   pragma Import (C, Chain_Append);

   --  Efficiently append element EL to a list.
   type List_Constr_Type is record
      First : Tree;
      Last : Tree;
   end record;
   pragma Convention (C, List_Constr_Type);
   procedure List_Init (Constr : out List_Constr_Type);
   pragma Import (C, List_Init);
   procedure List_Append (Constr : in out List_Constr_Type; El : Tree);
   pragma Import (C, List_Append, "ortho_list_append");

   type O_Loop_Block is record
      Beg_Label : Tree;
      End_Label : Tree;
   end record;
   pragma Convention (C, O_Loop_Block);

   type O_Inter_List is record
      Ident : O_Ident;
      Storage : O_Storage;
      --  Return type.
      Rtype : O_Tnode;
      --  List of parameter types.
      Param_List : List_Constr_Type;
      --  Chain of parameters declarations.
      Param_Chain : Chain_Constr_Type;
   end record;
   pragma Convention (C, O_Inter_List);

   type O_Element_List is record
      Res : Tree;
      Chain : Chain_Constr_Type;
   end record;
   pragma Convention (C, O_Element_List);

   type O_Element_Sublist is record
      Base : Tree;
      Field : Tree;
      Res : Tree;
      Chain : Chain_Constr_Type;
   end record;
   pragma Convention (C, O_Element_Sublist);

   type O_Case_Block is record
      Prev_Stmts : Tree;
      Case_Type : Tree;
      End_Label : Tree;
      Add_Break : Integer;
   end record;
   pragma Convention (C, O_Case_Block);

   type O_If_Block is record
      Prev_Stmts : Tree;
      If_Stmt : Tree;
   end record;
   pragma Convention (C, O_If_Block);

   type O_Aggr_List is record
      Atype : Tree;
      Chain : Chain_Constr_Type;
   end record;

   type O_Record_Aggr_List is record
      Atype : Tree;
      Afield : Tree;
      Vec : Vec_Ptr;
   end record;
   pragma Convention (C, O_Record_Aggr_List);

   type O_Array_Aggr_List is record
      Atype : Tree;
      Vec : Vec_Ptr;
   end record;
   pragma Convention (C, O_Array_Aggr_List);

   type O_Assoc_List is record
      Subprg : Tree;
      List : List_Constr_Type;
   end record;
   pragma Convention (C, O_Assoc_List);

   type O_Enum_List is record
      --  The enumeral_type node.
      Res : Tree;
      --  Chain of literals.
      Chain : Chain_Constr_Type;
      --  Numeral value (from 0 to nbr - 1) of the next literal to be declared.
      Num : Natural;
      --  Size of the enumeration type.
      Size : Natural;
   end record;
   pragma Convention (C, O_Enum_List);

   pragma Import (C, New_Dyadic_Op);
   pragma Import (C, New_Monadic_Op);
   pragma Import (C, New_Compare_Op);

   pragma Import (C, New_Convert_Ov);
   pragma Import (C, New_Convert);
   pragma Import (C, New_Alloca);

   pragma Import (C, New_Signed_Literal);
   pragma Import (C, New_Unsigned_Literal);
   pragma Import (C, New_Float_Literal);
   pragma Import (C, New_Null_Access);

   pragma Import (C, Start_Record_Type);
   pragma Import (C, New_Record_Field);
   pragma Import (C, Finish_Record_Type);

   pragma Import (C, Start_Record_Subtype);
   pragma Import (C, New_Subrecord_Field);
   pragma Import (C, Finish_Record_Subtype);

   pragma Import (C, New_Uncomplete_Record_Type);
   pragma Import (C, Start_Uncomplete_Record_Type);

   pragma Import (C, Start_Union_Type);
   pragma Import (C, New_Union_Field);
   pragma Import (C, Finish_Union_Type);

   pragma Import (C, New_Unsigned_Type);
   pragma Import (C, New_Signed_Type);
   pragma Import (C, New_Float_Type);

   pragma Import (C, New_Access_Type);
   pragma Import (C, Finish_Access_Type);

   pragma Import (C, New_Array_Type);
   pragma Import (C, New_Array_Subtype);

   pragma Import (C, New_Boolean_Type);
   pragma Import (C, Start_Enum_Type);
   pragma Import (C, New_Enum_Literal);
   pragma Import (C, Finish_Enum_Type);

   pragma Import (C, Start_Record_Aggr);
   pragma Import (C, New_Record_Aggr_El);
   pragma Import (C, Finish_Record_Aggr);
   pragma Import (C, Start_Array_Aggr);
   pragma Import (C, New_Array_Aggr_El);
   pragma Import (C, Finish_Array_Aggr);
   pragma Import (C, New_Union_Aggr);
   pragma Import (C, New_Default_Value);

   pragma Import (C, New_Indexed_Element);
   pragma Import (C, New_Slice);
   pragma Import (C, New_Selected_Element);
   pragma Import (C, New_Access_Element);

   pragma Import (C, New_Sizeof);
   pragma Import (C, New_Record_Sizeof);
   pragma Import (C, New_Alignof);
   pragma Import (C, New_Offsetof);

   pragma Import (C, New_Address);
   pragma Import (C, New_Global_Address);
   pragma Import (C, New_Unchecked_Address);
   pragma Import (C, New_Global_Unchecked_Address);
   pragma Import (C, New_Subprogram_Address);

   pragma Import (C, New_Value);

   pragma Import (C, New_Type_Decl);
   pragma Import (C, New_Debug_Line_Decl);
   pragma Import (C, New_Const_Decl);
   pragma Import (C, New_Var_Decl);

   pragma Import (C, Start_Init_Value);
   pragma Import (C, Finish_Init_Value);

   pragma Import (C, Start_Function_Decl);
   pragma Import (C, Start_Procedure_Decl);
   pragma Import (C, New_Interface_Decl);
   pragma Import (C, Finish_Subprogram_Decl);

   pragma Import (C, Start_Subprogram_Body);
   pragma Import (C, Finish_Subprogram_Body);

   pragma Import (C, New_Debug_Line_Stmt);
   pragma Import (C, Start_Declare_Stmt);
   pragma Import (C, Finish_Declare_Stmt);
   pragma Import (C, Start_Association);
   pragma Import (C, New_Association);
   pragma Import (C, New_Function_Call);
   pragma Import (C, New_Procedure_Call);

   pragma Import (C, New_Assign_Stmt);

   pragma Import (C, Start_If_Stmt);
   pragma Import (C, New_Else_Stmt);
   pragma Import (C, Finish_If_Stmt);

   pragma Import (C, New_Return_Stmt);
   pragma Import_Procedure (New_Return_Stmt,
                              "new_func_return_stmt", (O_Enode));
   pragma Import_Procedure (New_Return_Stmt,
                              "new_proc_return_stmt", null);

   pragma Import (C, Start_Loop_Stmt);
   pragma Import (C, Finish_Loop_Stmt);
   pragma Import (C, New_Exit_Stmt);
   pragma Import (C, New_Next_Stmt);

   pragma Import (C, Start_Case_Stmt);
   pragma Import (C, Start_Choice);
   pragma Import (C, New_Expr_Choice);
   pragma Import (C, New_Range_Choice);
   pragma Import (C, New_Default_Choice);
   pragma Import (C, Finish_Choice);
   pragma Import (C, Finish_Case_Stmt);
end Ortho_Gcc;
