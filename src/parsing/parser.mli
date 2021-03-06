(* parser.mli: Parser interface.

   Copyright (C) 2013 by Łukasz Czajka
*)

val parse : Lexing.lexbuf -> Lexing.lexbuf option (* core runtime lexbuf *) -> Node.t Symbol.Map.t * Node.t

val parse_repl : Lexing.lexbuf -> Lexing.lexbuf option (* core runtime lexbuf *) ->
  (Node.t -> int (* line number *) -> unit) (* eval handler *) ->
  (Node.t -> int (* line number *) -> unit) (* decl handler *) -> Node.t Symbol.Map.t * Node.t
(* The eval handler is invoked for every top-level statement and every
   immediate top-level let. The decl handler is invoked for every
   non-immediate top-level let (with the value of this let) -- the
   value passed should be evaluated and pushed onto the
   environment. *)
