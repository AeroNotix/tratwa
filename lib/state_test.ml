module TestConnector : Mesh.Connector = struct
  type t = unit
  let create = ()
  let sent_messages = ref []
  let connect (_connector: t) (_peer: Peer.t) = ()
  let send_rpc (_connector: t) (_rpc: Rpc.t) (peer: Peer.t) =
    sent_messages := List.cons peer !sent_messages
end

module TestState = State.Make(
    Mesh.Make(TestConnector)
  )

let%test _ =
  (* Two states created by the same module are not the same value *)
  let a = TestState.create () in
  let b = TestState.create () in
  !a = !b

let%test _ =
  let s = TestState.create () in
  (* When a heartbeat timeout is reached, a follower converts to a
     candidate *)
  TestState.heartbeat_timeout s;
  TestState.is_candidate s

let%test _ =
  let module S = State.Make(
    Mesh.Make(TestConnector)
  ) in
 true
