let test_config =
  let config = Config.create in
  (* Unit tests just use the in-memory Connector, so the peer list is
     just a foobar list *)
  { config with peers = (List.init 3 (fun _ -> "peer")) }

module TestConnector : Raft.Connector = struct
  type peer = State.t
  type t = Config.t * (peer * Rpc.t) list ref

  let create config = (config, ref [])

  let connect ((connector, _): t) =
    (* In the test connector, we just create a bunch of additional states *)
    List.init (List.length connector.peers) (fun _ -> State.create connector)

  let send_rpc ((_, messages): t) (rpc: Rpc.t) (peer: peer) =
    (* In the test connector, we store each RPC being sent *)
    messages := List.cons (peer, rpc) !messages;
    print_endline "Hello there\n"
end

module Timer = Timer.Make(Timer.Fake)
module TestRaft = Raft.Make(TestConnector) (Timer)

let%test _ =
  let a = TestRaft.create test_config in
  let b = TestRaft.create test_config in
  (* Two rafts created by the same module are not the same reference *)
  not (a == b)

let%test _ =
  let raft = TestRaft.create test_config in
  TestRaft.start raft;
  (* Triggering a heartbeat timeout transistions a raft peer to a Candidate *)
  let was_follower = State.is_follower (TestRaft.state raft) in
  Timer.now (TestRaft.timer raft);
  was_follower = State.is_candidate (TestRaft.state raft)
