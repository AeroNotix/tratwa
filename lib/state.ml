module CandidateNextIndexMap = Map.Make(Int)

exception Not_implemented

type server_mode =
  (* TODO: Unused (for now) | Leader *)
  | Follower
  | Candidate

type t =
  { mutable server_mode  : server_mode;
    mutable current_term : int;
    mutable voted_for    : Candidate.t;
    mutable log          : Logentry.t;
    mutable commit_index : int;
    mutable last_applied : int;
    (* TODO: Want to use a map to logentry indexes for these, figure out how to express a record's field is a map *)
    (* mutable next_index   : CandidateNextIndexMap *)
    (* mutable match_index   : CandidateNextIndexMap *)
  }

let create =
  (* TODO: Initialize state from persistent storage *)
  { server_mode = Follower;
    current_term = 0;
    voted_for = Candidate.create;
    log = Logentry.create;
    commit_index = 0;
    last_applied = 0;
  }

let request_vote {server_mode; _} =
  assert (server_mode = Candidate)

let append_entries (_t: t) (_entries: Logentry.t list) = raise Not_implemented
