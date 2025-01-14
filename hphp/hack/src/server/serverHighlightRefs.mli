(*
 * Copyright (c) 2015, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the "hack" directory of this source tree.
 *
 *)

val go :
  string * int * int -> TypecheckerOptions.t -> ServerHighlightRefsTypes.result

(* For serverless IDE *)
val go_ctx :
  ctx:Provider_context.t ->
  entry:Provider_context.entry ->
  line:int ->
  column:int ->
  tcopt:TypecheckerOptions.t ->
  ServerHighlightRefsTypes.result
