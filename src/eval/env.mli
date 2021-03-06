(* env.mli: Evaluation environment interface.

Copyright (C) 2013 by Łukasz Czajka

*)

type t = Node.t list

val empty : t
(* indices are zero-based *)
val nth : t -> int -> Node.t
val push : t -> Node.t -> t
val pop_n : t -> int -> t
val push_n : t -> Node.t -> int -> t
val length : t -> int
