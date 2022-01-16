type t

type next_state =
  (* SEE TODOs in state.ml, ended up not liking state.ml just being
     super generic/abstract and _returning_ the next state, since it
     would need another module to actually perform the
     transitions. Will implement a better FSM framework in another
     project. I think. *)
  | AcceptEntries
  | AcceptRequestVote
  | BecomeFollower
  | IgnoreRequestVote
  | SendFollowersHeartbeats
  | StartElection

val create : t
val is_leader : t -> bool
val is_follower : t -> bool
val is_candidate : t -> bool
val request_vote : t -> next_state
val append_entries : t -> Logentry.t list -> next_state
val heartbeat_timeout : t -> next_state
