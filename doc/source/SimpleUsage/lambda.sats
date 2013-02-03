(*
//
//
// Implementing a simple language based on lambda-calculus
//
//
*)

(* ****** ****** *)

typedef vname = string

datatype term =
  | TMvar of vname
  | TMlam of (vname(*x*), term(*t*)) // lam x.t
  | TMapp of (term, term)
//
  | TMint of int
  | TMstring of string
//
  | TMfix of (vname(*f*), vname(*x*), term(*t*)) // fix f(x).t
  | TMlet of (vname(*x*), term(*t1*), term(*t2*)) // let x = t1 in t2 end
//
  | TMopr of (string(*name*), termlst)
//
  | TMif of (term(*cond*), term(*then*), term(*else*))
// end of [term]

where termlst = List (term)

(* ****** ****** *)

fun TMopr2 (opr: string, t1: term, t2: term): term

(* ****** ****** *)

abstype env // abstract for run-time environments

(* ****** ****** *)

datatype value =
  | VALint of int
  | VALstring of string
  | VALvoid of ()
  | VALclo of (env, term)
  | VALarray of (array0 (value))

where valuelst = List (value)

(* ****** ****** *)

val VALtrue : value
val VALfalse : value
fun value_bool (b: bool): value

(* ****** ****** *)
//
fun fprint_value (out: FILEref, v: value): void
//
fun print_value (v: value): void
overload print with print_value
//
(* ****** ****** *)

fun make_env_nil (): env

fun insert_env (env: env, x: vname, v: value): env
fun lookup_env (env: env, x: vname): Option (value)

(* ****** ****** *)

(*
val I : term
val K : term
val S : term
*)

fun fprint_term (out: FILEref, t: term): void
fun print_term (t: term): void
overload print with print_term

(*
fun subst0 (t0: term, x: vname, t: term): term
*)

fun eval0 (t: term): value

(* ****** ****** *)

fun eval (env: env, t: term): value

(* ****** ****** *)

(* end of [lambda.sats] *)