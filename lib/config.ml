type mode =
  | Memory
  | Tcp
[@@deriving yojson]

type t =
  {
    mesh_mode: mode;
    peers: string list
  } [@@deriving yojson]

let of_file path =
  of_yojson ( Yojson.Safe.from_file path )

let create = {
  mesh_mode = Memory;
  peers = [];
}
