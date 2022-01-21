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
  type connector
  type timer

  val broadcast: t -> Rpc.t -> unit
  val create: Config.t -> t
  val num_connected: t -> int
  val start: t -> unit

  (* Available for tests *)
  val timer: t -> timer
  val connector: t -> connector
  val state: t -> State.t
end

module Make
    (Connector: Connector)
    (Timer: Timer.M)
  : M
    with type connector = Connector.t
    with type timer = Timer.t
