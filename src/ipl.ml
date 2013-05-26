(* ipl.ml: IPL main program.

   Copyright (C) 2013 by Łukasz Czajka
*)

let f_interactive = ref false;;
let f_vanilla = ref false;;
let file_count = ref 0;;
let runtime_path = ref "runtime/core.ipl";;

let get_lexbuf name chan =
  let lexbuf = Lexing.from_channel chan
  in
  let pos = lexbuf.Lexing.lex_curr_p
  in
  lexbuf.Lexing.lex_curr_p <- { Lexing.pos_fname = name; Lexing.pos_lnum = pos.Lexing.pos_lnum;
                                Lexing.pos_bol = pos.Lexing.pos_bol; Lexing.pos_cnum = pos.Lexing.pos_cnum };
  lexbuf

let run_repl name chan =
  let env = ref Env.empty
  in
  let last_lineno = ref (-1)
  in
  let prompt lineno =
    if lineno > !last_lineno then
      begin
        print_string "> ";
        flush stdout;
      end;
    last_lineno := lineno
  in
  let evaluate node lineno =
    let value = Eval.eval_in node !env
    in
    print_endline (Node.to_string value);
    prompt lineno
  and declare node lineno =
    let value = Eval.eval_in node !env
    in
    env := Env.push !env value;
    print_endline (Node.to_string value);
    prompt lineno
  in
  print_endline "\tIPL version 0.0.1";
  print_endline "\tCopyright (C) 2013 by Lukasz Czajka";
  print_newline ();
  print_string "> ";
  flush stdout;
  let lexbuf = get_lexbuf name chan
  in
  if !f_vanilla then
    ignore (Parser.parse_repl [lexbuf] evaluate declare)
  else
    let runtime_lexbuf = get_lexbuf !runtime_path (open_in !runtime_path)
    in
    ignore (Parser.parse_repl [runtime_lexbuf; lexbuf] evaluate declare)

let run name chan =
  let lexbuf = get_lexbuf name chan
  in
  file_count := !file_count + 1;
  let node =
    if !f_vanilla then
      Parser.parse [lexbuf]
    else
      let runtime_lexbuf = get_lexbuf !runtime_path (open_in !runtime_path)
      in
      Parser.parse [runtime_lexbuf; lexbuf]
  in
  if Error.error_count () + Error.fatal_count () = 0 then
    ignore (Eval.eval node);

;;

let argspec = [ ("-i", Arg.Set(f_interactive), "\t\t\tInteractive (repl) mode");
                (("--interactive", Arg.Set(f_interactive), "\tInteractive (repl) mode"));
                (("--vanilla", Arg.Set(f_vanilla), "\t\tDon't preload the standard runtime"));
                (("-R", Arg.String(fun s -> f_vanilla := false; runtime_path := s), "\t\t\tSet runtime path"));
                (("--runtime", Arg.String(fun s -> f_vanilla := false; runtime_path := s), "\t\tSet runtime path"))
              ]
in
try
  Arg.parse argspec (fun filename -> run filename (open_in filename)) "usage: ipl [file.ipl]";
  if !file_count = 0 then
    begin
      if !f_interactive then
        run_repl "stdin" stdin
      else
        run "stdin" stdin
    end
with
| Sys_error(msg) ->
    Error.fatal msg; exit 1
