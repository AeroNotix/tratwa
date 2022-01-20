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

module Make (Connector: Connector) : M
