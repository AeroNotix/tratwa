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

module Make (Connector: Connector) : M
