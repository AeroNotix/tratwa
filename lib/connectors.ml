module SMap = Map.Make(String)

module InMemory : Mesh.Connector = struct
  type t = State.t SMap.t ref
  let create = ref SMap.empty
  let connect (connector: t) (_peer: Peer.t) =
(* InMemory is special-case in that we _create_ peers here. InMemory
   is more for testing the algorithm, so we just create a bunch of
   peers here. *)
    let peer = State.create in
    connector := SMap.add "hello" peer !connector
end

module Tcp : Mesh.Connector = struct
  type t = string SMap.t ref
  let create = ref SMap.empty
  let connect (_connector: t) (_peer: Peer.t) = ()
end
