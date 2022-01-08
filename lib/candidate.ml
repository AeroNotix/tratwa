type t = Uuidm.t

let create =
  Uuidm.v4_gen (Stdlib.Random.get_state ()) ()
