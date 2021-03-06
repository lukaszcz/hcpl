(* quote.mli: Operations on quoted nodes interface.

Copyright (C) 2013 by Łukasz Czajka

*)

val correct_lambda : Node.t -> Node.t

val quote : Node.t -> Env.t -> int (* env_len *) -> Node.t
(* 'occurs_check node1 node2' checks if 'node1' occurs inside 'node2' *)
val occurs_check : Node.t -> Node.t -> bool
(* 'subst node node1 node2' substitutes 'node2' for all occurences of 'node1' in 'node' *)
val subst : Node.t -> Node.t -> Node.t -> Node.t
(* lift node node1 = (\x . (subst node node1 x)) node1 *)
val lift : Node.t -> Node.t -> Node.t
val lift_marked : Node.t -> Node.t -> Node.t
val close : Node.t -> Node.t
val get_free_vars : Node.t -> Utils.IntSet.t
val largest_frame : Node.t -> int
val eta_reduce : Node.t -> Node.t
