(*
//
//
// Implementing a simple language based on lambda-calculus
//
//
*)

(* ****** ****** *)

staload "lambda.sats"

(* ****** ****** *)

assume env = List @(vname, value)

(* ****** ****** *)

implement
make_env_nil () = list_nil ()

(* ****** ****** *)

implement
insert_env (env, x, v) = list_cons ((x, v), env)

(* ****** ****** *)

implement
lookup_env
  (env, x0) = (
  case+ env of
  | list_cons (xv, env1) =>
      if x0 = xv.0 then Some (xv.1) else lookup_env (env1, x0)
  | list_nil () => None ()
) // end of [lookup_env]

(* ****** ****** *)

(* end of [lambda_env.dats] *)