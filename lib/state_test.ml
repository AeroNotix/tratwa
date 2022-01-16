let%test _ =
  (* State starts in follower mode *)
  let s = State.create in
  State.is_follower s

let%test _ =
  (* State starts in follower mode *)
  let s = State.create in
  not (State.is_candidate s)

let%test _ =
  (* State starts in follower mode *)
  let s = State.create in
  not (State.is_leader s)

let%test _ =
  (* A follower will start an election if it times out, SEE TODOs IN
     state.ml *)
  State.heartbeat_timeout (State.create) = State.StartElection