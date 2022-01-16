type t
type next_state

val create : t
val is_leader : t -> bool
val is_follower : t -> bool
val is_candidate : t -> bool
val request_vote : t -> next_state
val append_entries : t -> Logentry.t list -> next_state
val heartbeat_timeout : t -> next_state
