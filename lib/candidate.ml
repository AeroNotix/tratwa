type t = Uuidm.t

let compare = Uuidm.compare

let create =
  Uuidm.v4_gen (Stdlib.Random.get_state ()) ()
