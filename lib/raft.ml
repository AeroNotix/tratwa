module type Connector =
  sig
    type t
    type peer
    val connect: t -> peer list
    val create: Config.t -> t
    val send_rpc: t -> Rpc.t -> peer -> unit
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
    peers: Connector.peer list;
    local: State.t list;
  }

  type t = r ref

  let broadcast (_t: t) (_m: Rpc.t) =
    ()

  let create (config: Config.t) =
    let local = [State.create config] in
    let connector = Connector.create config in
    let peers = Connector.connect connector in
    ref {
      connector;
      config;
      peers;
      local;
    }

  let num_connected _t =
    0

  let start _t = ()
end
