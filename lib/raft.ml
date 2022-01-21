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
= struct

  type timer = Timer.t
  type connector = Connector.t

  type r = {
    timer: timer option;
    connector: connector;
    config: Config.t;
    peers: Connector.peer list;
    local: State.t;
  }

  type t = r ref

  let broadcast (_t: t) (_m: Rpc.t) =
    ()

  let heartbeat_timeout t =
    print_endline "heartbeat timeout";
    broadcast t (State.heartbeat_timeout (!t).local)

  let create (config: Config.t) =
    let local = State.create config
    and connector = Connector.create config in
    let peers = Connector.connect connector in
    let raft_state = ref {
        timer = None;
        connector;
        config;
        peers;
        local;
      } in
    let timer = Timer.create 30. (fun () -> heartbeat_timeout raft_state) in
    raft_state := { !raft_state with timer = Some timer };
    raft_state

  let num_connected _t =
    0

  let start t =
    Timer.start (Option.get (!t).timer)

  let timer t = Option.get (!t).timer

  let connector t = (!t).connector

  let state t = (!t).local
end
