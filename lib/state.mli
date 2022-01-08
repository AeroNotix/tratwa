type t

val create : t

val request_vote : t -> unit

val append_entries : t -> Logentry.t list -> unit
