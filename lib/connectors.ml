module SMap = Map.Make(String)

module DoNothing : Mesh.Connector = struct
  type t = unit
  let create = ()
  let connect (_connector: t) (_peer: Peer.t) = ()
end

(* InMemory is special-case in that we _create_ peers here. InMemory
   is more for testing the algorithm, *)
module InMemory : Mesh.Connector = struct
  type t = State.t SMap.t ref
  let create = ref SMap.empty
  let connect (_connector: t) (_peer: Peer.t) =
    ()
end

module Tcp : Mesh.Connector = struct
  type t = string SMap.t ref
  let create = ref SMap.empty
  let connect (_connector: t) (_peer: Peer.t) = ()
end
