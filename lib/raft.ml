module type Connector =
  sig
    type t
    val connect: t -> Peer.t -> unit
    val create: Config.t -> t
    val send_rpc: t -> Rpc.t -> Peer.t -> unit
  end

module type M =
  sig
    type t
    val broadcast: t -> Rpc.t -> unit
    val create: Config.t -> t
    val num_connected: t -> int
    val start: t -> unit
  end

module Make (Connector: Connector) = struct
  type r = {
    connector: Connector.t;
    config: Config.t;
    peers: Peer.t list;
    local: State.t list;
  }

  type t = r ref

  let broadcast (_t: t) (_m: Rpc.t) =
    ()

  let create (config: Config.t) =
    let local = [State.create config] in
    let connector = Connector.create config in
    ref {
      connector;
      config;
      peers = config.peers;
      local = local;
    }

  let num_connected _t =
    0

  let start t =
    List.iter (Connector.connect (!t).connector) (!t).peers
end
