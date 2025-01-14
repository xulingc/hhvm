(*
 * Copyright (c) 2013-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the "hack" directory of this source tree.
 *
 *)

#use "utils.ml"

(**
 * Computes some build identifiers based on the current commit. These IDs are
 * used to ensure that clients and servers are the same version, even between
 * releases. For example, if you build revision A and start a server, then check
 * out and build revision B, it's convenient for the server to restart itself
 * using revision B.
 *
 * This fails gracefully when neither hg nor git are installed, or when neither
 * .hg nor .git exist (e.g. when building from a tarball). This is fine because
 * you can't move between commits in such a snapshot.
 *)
let () =
  let out_file = Sys.argv.(1) in
  let rev =
    try read_process_output "git" [|"git"; "rev-parse"; "HEAD"|]
    with Failure _ ->
      (* If buck is available, do what buck would have done, i.e. return an 
      empty version. Saved state loading relies on that, unfortunately. *)
      try 
        let _ = read_process_output "buck" [|"buck"; "--version"|] in
        ""
      with Failure _ ->
        try read_process_output "hg" [|"hg"; "log"; "-r"; "."; "--template"; "{node}\\n"|]
        with Failure _ -> ""
  in
  let time =
    try read_process_output "git" [|"git"; "log"; "-1"; "--pretty=tformat:%ct"|]
    with Failure _ ->
      try
        let raw = read_process_output "hg" [|"hg"; "log"; "-r"; "."; "-T"; "{date|hgdate}\\n"|] in
        String.sub raw 0 (String.index raw ' ')
      with
      | Failure _ -> "0"
      | Not_found -> "0"
  in
  let content = Printf.sprintf
    "const char* const BuildInfo_kRevision = %S;\nconst unsigned long BuildInfo_kRevisionCommitTimeUnix = %sul;\nconst char* const BuildInfo_kBuildMode = %S;\n"
    rev time "" (* not implemented *) in
  let do_dump =
    not (Sys.file_exists out_file) || string_of_file out_file <> content in
  if do_dump then
    with_out_channel out_file @@ fun oc ->
    output_string oc content
