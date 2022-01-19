module type Connector =
  sig
    type t
    val create: t
    val connect: t -> Peer.t -> unit
    val send_rpc: t -> Rpc.t -> Peer.t -> unit
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

module Make (Connector: Connector) : M with type connector = Connector.t
