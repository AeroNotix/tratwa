module SMap = Map.Make(String)

(* InMemory is special-case in that we _create_ peers here. InMemory
   is more for testing the algorithm, *)
module InMemory : Mesh.Connector = struct
  type t = State.t SMap.t ref
  let create = ref SMap.empty
  let connect (_connector: t) (_peer: Peer.t) =
    ()
  let send_rpc (_connector: t) (_rpc: Rpc.t) (_peer: Peer.t) = ()
end

module Tcp : Mesh.Connector = struct
  type t = string SMap.t ref
  let create = ref SMap.empty
  let connect (_connector: t) (_peer: Peer.t) = ()
  let send_rpc (_connector: t) (_rpc: Rpc.t) (_peer: Peer.t) = ()
end
