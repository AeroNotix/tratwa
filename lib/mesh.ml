module type Connector =
  sig
    type t
    val create: t
    val connect: t -> Peer.t -> unit
  end

module type M =
  sig
    type t
    type connector
    val create: Config.t -> t
    val start: t -> connector -> unit
    val broadcast: t -> Rpc.t -> unit
    val num_connected: t -> int
  end

module Make(Connector: Connector) = struct
  type connector = Connector.t
  type t = { peers: Peer.t list }

  let create (_c: Config.t) =
    { peers = [] }

  let start { peers : _ } connector =
    List.iter (Connector.connect connector) peers

  let broadcast (_t: t) (_m: Rpc.t) =
    ()

  let num_connected _t =
    0
end
