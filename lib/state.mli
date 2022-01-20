type t

val create : Config.t -> t

(* Stupid helpers, idk, felt useful, might delete later *)
val is_leader : t -> bool
val is_follower : t -> bool
val is_candidate : t -> bool

(* RPC methods directly from https://raft.github.io/raft.pdf *)
val request_vote : t -> unit
val append_entries : t -> Logentry.t list -> unit
val heartbeat_timeout : t -> unit
