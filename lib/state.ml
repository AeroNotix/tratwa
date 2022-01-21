(* TODO: Want to do something like controller.mli where we have some
   abstract state and this module just implements the state transition
   logic. *)

(* TODO: Perhaps instead want do something like where this module is
   parameterized by mesh and/or connector, and has internal mutable
   state. *)

(* TODO: Should this be in the candidate module *)

exception Not_implemented

module ServerMode = struct
  type t = Leader | Follower | Candidate
  let as_string t =
    match t with
    | Leader -> "leader"
    | Follower -> "follower"
    | Candidate -> "candidate"
end

module PeerLogIndex = Map.Make (struct
  type t = Candidate.t

  let compare = Candidate.compare
end)

type r = {
  id : Candidate.t;
  mutable commit_index : int;
  mutable current_term : int;
  mutable last_applied : int;
  mutable log : Logentry.t;
  mutable match_index : int PeerLogIndex.t;
  mutable next_index : int PeerLogIndex.t;
  mutable server_mode : ServerMode.t;
  mutable voted_for : Candidate.t option;
}

type t = r ref

(* TODO: Initialize state from persistent storage *)
let create (_config: Config.t) =
  ref {
    id = Candidate.create;
    commit_index = 0;
    current_term = 0;
    last_applied = 0;
    log = Logentry.create;
    match_index = PeerLogIndex.empty;
    next_index = PeerLogIndex.empty;
    server_mode = ServerMode.Follower;
    voted_for = None;
  }

let is_leader t =
  (!t).server_mode = ServerMode.Leader

let is_follower t =
  (!t).server_mode = ServerMode.Follower

let is_candidate t =
  (!t).server_mode = ServerMode.Candidate

let request_vote _t =
  raise Not_implemented

let append_entries t entries =
  (* TODO: I don't think these fields are correcetly mapped to what is
     being sent in the rpc *)
  Rpc.AppendEntries {
    term = (!t).current_term;
    leader_id = (!t).id;
    prev_log_index = (!t).commit_index;
    prev_log_term = (!t).last_applied;
    entries;
    leader_commit = (!t).commit_index;
  }

let become_candidate t =
  (!t).server_mode <- ServerMode.Candidate

let start_election t =
  (!t).current_term <- succ (!t.current_term);
  (!t).voted_for <- Some (!t).id;
  Rpc.RequestVote {
    term = (!t).current_term;
    candidate_id = (!t).id;
    last_log_index = (!t).commit_index;
    last_log_term = (!t).last_applied;
  }

let heartbeat_timeout t =
  match (!t).server_mode with
  | ServerMode.Follower ->
    become_candidate t;
    start_election t
  | ServerMode.Candidate ->
    start_election t
  | ServerMode.Leader ->
    Printf.printf "Leader timeout, would send heartbeats\n";
    append_entries t []

let print_state t =
  Printf.printf "Server State: %s\n" (ServerMode.as_string (!t).server_mode)
