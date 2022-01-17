
(* TODO: Want to do something like mesh.mli where we have some
   abstract state and this module just implements the state transition
   logic. *)

(* TODO: Perhaps instead want do something like where this module is
   parameterized by mesh and/or connector, and has internal mutable
   state. *)

(* TODO: Should this be in the candidate module *)

module ServerMode = struct
  type t = Leader | Follower | Candidate
end

module PeerLogIndex = Map.Make (struct
  type t = Candidate.t

  let compare = Candidate.compare
end)

type t = {
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

module type M =
  sig
    type nonrec t = t ref
    type mesh

    val create : t
    (* Stupid helpers, idk, felt useful, might delete later *)
    val is_leader : t -> bool
    val is_follower : t -> bool
    val is_candidate : t -> bool
    (* RPC methods directly from https://raft.github.io/raft.pdf *)
    val request_vote : t -> unit
    val append_entries : t -> Logentry.t list -> unit
    val heartbeat_timeout : t -> unit
  end

module Make(Mesh: Mesh.M) : M = struct
  type nonrec t = t ref
  type mesh = Mesh.t

  exception Not_implemented

  (* TODO: Initialize state from persistent storage *)
  let create =
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

  let append_entries (_t : t) (_entries : Logentry.t list) =
    raise Not_implemented

  let heartbeat_timeout t =
    match (!t).server_mode with
    | ServerMode.Follower ->
      (!t).server_mode <- ServerMode.Candidate
    | ServerMode.Candidate ->
      Printf.printf "Candidate timeout\n"
    | ServerMode.Leader ->
      Printf.printf "Leader timeout, would send heartbeats\n"

end
