let test_config =
  let config = Config.create in
  (* Unit tests just use the in-memory Connector, so the peer list is
     just a foobar list *)
  { config with peers = (List.init 3 (fun _ -> "peer")) }

module TestConnector : Raft.Connector = struct
  type t = Config.t
  type peer = State.t
  let sent_messages = ref []

  let create config = config

  let connect (connector: t) =
    (* In the test connector, we just create a bunch of additional states *)
    List.init (List.length connector.peers) (fun _ -> State.create connector)

  let send_rpc (_connector: t) (_rpc: Rpc.t) (peer: peer) =
    (* In the test connector, we store each RPC being sent *)
    sent_messages := List.cons peer !sent_messages
end

module TestRaft = Raft.Make(TestConnector)

let%test _ =
  let a = TestRaft.create test_config in
  let b = TestRaft.create test_config in
  (* Two rafts created by the same module are not the same reference *)
  (not (a == b) &&
   (* But they are equal *)
   (a = b))
