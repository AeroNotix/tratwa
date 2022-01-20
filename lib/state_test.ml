module TestConnector : Raft.Connector = struct
  type t = unit
  let create _config = ()
  let sent_messages = ref []
  let connect (_connector: t) (_peer: Peer.t) = ()
  let send_rpc (_connector: t) (_rpc: Rpc.t) (peer: Peer.t) =
    sent_messages := List.cons peer !sent_messages
end

module TestRaft = Raft.Make(TestConnector)

let%test _ =
  let a = TestRaft.create (Config.create) in
  let b = TestRaft.create (Config.create) in
  (* Two rafts created by the same module are not the same reference *)
  (not (a == b) &&
   (* But they are equal *)
   (a = b))
