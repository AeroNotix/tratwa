module type M =
sig
  type t
  val create: float -> (unit -> unit) -> t
  val start: t -> unit
  val stop: t -> unit
  val now: t -> unit
end

module Fake = struct
  type t = (unit -> unit)
  let create _period f = f
  let start _t = ()
  let stop _t = ()
  let now t = t ()
end

module Make(Timer: M) = struct
  include Timer
end
