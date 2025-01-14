(*
 * Copyright (c) 2015, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the "hack" directory of this source tree.
 *
 *)

(** Module "naming" a program.
 * Get all the global names
 *)

module GEnv : sig
  val get_full_pos : FileInfo.pos * string -> Pos.t * string

  val type_pos : string -> Pos.t option

  val type_canon_name : string -> string option

  val type_info : string -> (Pos.t * Naming_table.type_of_type) option

  val fun_pos : string -> Pos.t option

  val fun_canon_name : string -> string option

  val typedef_pos : string -> Pos.t option

  val gconst_pos : string -> Pos.t option
end

(* Function building the original naming environment.
 * This pass "declares" all the global names. The only checks done
 * here are whether an entity name was already bound (e.g. when
 * two files define the same function).
 * It all the entities passed as parameters and adds them to the shared heap.
 *)
val make_env :
  funs:FileInfo.id list ->
  classes:FileInfo.id list ->
  record_defs:FileInfo.id list ->
  typedefs:FileInfo.id list ->
  consts:FileInfo.id list ->
  unit

(* Removing declarations *)
val remove_decls :
  funs:SSet.t ->
  classes:SSet.t ->
  record_defs:SSet.t ->
  typedefs:SSet.t ->
  consts:SSet.t ->
  unit

val ndecl_file_fast :
  Relative_path.t ->
  funs:SSet.t ->
  classes:SSet.t ->
  record_defs:SSet.t ->
  typedefs:SSet.t ->
  consts:SSet.t ->
  unit

val ndecl_file :
  Relative_path.t -> FileInfo.t -> Errors.t * Relative_path.Set.t
