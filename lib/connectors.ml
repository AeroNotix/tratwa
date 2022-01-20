module SMap = Map.Make(String)

(* InMemory is special-case in that we _create_ peers here. InMemory
   is more for testing the algorithm, *)
module InMemory : Raft.Connector = struct
  type t = Config.t ref
  type peer = State.t
  let create (config: Config.t) = ref config
  let connect (connector: t) =
    List.init (List.length (!connector).peers) (fun _ -> State.create !connector)

  let send_rpc (_connector: t) (_rpc: Rpc.t) (_peer: peer) = ()
end

module Tcp : Raft.Connector = struct
  type t = string SMap.t ref
  (* This peer type will eventually be something like perhaps a TCP
     socket, or a string which represents a hostname, to send HTTP
     requests to. Depends how the remote implementation will end up. I
     kind of like the idea of a built-in HTTP client between raft
     peers. *)
  type peer = State.t
  let create _config = ref SMap.empty
  let connect (_connector: t) = []
  let send_rpc (_connector: t) (_rpc: Rpc.t) (_peer: peer) = ()
end
