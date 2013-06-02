(* config.ml: Global configuration module implementation.

   Copyright (C) 2013 by Łukasz Czajka
*)

let rpath = ref []

let init () = ()

let path () = !rpath

let set_path lst = rpath := lst

let prepend_path str = rpath := str :: !rpath

let append_path str = rpath := !rpath @ [str]

let stdlib_path () = "./lib"

let dir_sep () = "/"