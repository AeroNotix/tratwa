(* TODO: Should this be in the candidate module *)
module PeerLogIndex = Map.Make(
  struct
    type t = Candidate.t
    let compare = Candidate.compare
  end)

exception Not_implemented
exception Should_be_impossible

type server_mode =
  | Leader
  | Follower
  | Candidate

type next_state =
  | AcceptEntries
  | AcceptRequestVote
  | BecomeFollower
  | IgnoreRequestVote
  | SendFollowersHeartbeats
  | StartElection

type t = {
  mutable commit_index : int;
  mutable current_term : int;
  mutable last_applied : int;
  mutable log          : Logentry.t;
  mutable match_index  : int PeerLogIndex.t;
  mutable next_index   : int PeerLogIndex.t;
  mutable server_mode  : server_mode;
  mutable voted_for    : Candidate.t option;
}

(* TODO: Initialize state from persistent storage *)
let create = {
  commit_index = 0;
  current_term = 0;
  last_applied = 0;
  log = Logentry.create;
  match_index = PeerLogIndex.empty;
  next_index = PeerLogIndex.empty;
  server_mode = Follower;
  voted_for = None;
}

let is_leader {server_mode; _} =
  server_mode = Leader

let is_follower {server_mode; _} =
  server_mode = Follower

let is_candidate {server_mode; _} =
  server_mode = Candidate

let request_vote = function
  | { server_mode=Candidate; _}                   -> IgnoreRequestVote
  | { server_mode=Follower; voted_for=None; _}    -> AcceptRequestVote
  | { server_mode=Follower; voted_for=Some(_); _} -> IgnoreRequestVote
  | { server_mode=Leader; _}                      -> SendFollowersHeartbeats

let append_entries (t: t) (_entries: Logentry.t list) =
  match t with
  | { server_mode=Candidate; _} -> AcceptEntries
  | { server_mode=Follower; _}  -> AcceptEntries
  | { server_mode=Leader; _}    -> raise Should_be_impossible

let heartbeat_timeout = function
  | { server_mode=Candidate; _} -> StartElection
  | { server_mode=Follower; _}  -> StartElection
  | { server_mode=Leader; _}    -> SendFollowersHeartbeats
