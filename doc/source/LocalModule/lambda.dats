(*
//
//
// Implementing a simple language based on lambda-calculus
//
//
*)

(* ****** ****** *)

staload UN = "prelude/SATS/unsafe.sats"

(* ****** ****** *)

staload _(*anon*) = "prelude/DATS/array0.dats"

(* ****** ****** *)

staload "lambda.sats"

(* ****** ****** *)

#define nil list_nil
#define :: list_cons
#define cons list_cons

(* ****** ****** *)

implement
TMopr2 (opr, t1, t2) = TMopr (opr, t1 :: t2 :: nil ())

(* ****** ****** *)

implement VALtrue = VALint (1)
implement VALfalse = VALint (0)

implement
value_bool (b) = if b then VALtrue else VALfalse

(* ****** ****** *)

implement
fprint_value
  (out, v) = let
in
//
case+ v of
| VALint (i) => fprintf (out, "VALint(%i)", @(i))
| VALstring (s) => fprintf (out, "VALstring(%s)", @(s))
| VALvoid () => fprintf (out, "VALvoid()", @())
//
| VALclo _ => fprintf (out, "VALclo(...)", @())
//
| VALarray _ => fprintf (out, "VALarray(...)", @())
//
end // end of [fprint_value]

implement
print_value (v) = fprint_value (stdout_ref, v)
  
(* ****** ****** *)

implement
eval0 (t0) = let
  val env = make_env_nil () in eval (env, t0)
end // end of [eval0]

(* ****** ****** *)

exception EVAL_VAR of string

exception EVAL_APP_FUN of ()

exception EVAL_OPR of string
exception EVAL_OPR_ARG of (string)

exception EVAL_IF_COND of ()

(* ****** ****** *)

extern
fun evalist (env: env, ts: termlst): valuelst

(* ****** ****** *)

extern fun eval_var (env: env, t0: term): value
extern fun eval_opr (env: env, t0: term): value
extern fun eval_app (env: env, t0: term): value

(* ****** ****** *)

implement
eval (env, t0) = let
//
// val () = println! ("eval: t0 = ", t0)
//
in
//
case+ t0 of
//
| TMvar _ => eval_var (env, t0)
| TMlam _ => VALclo (env, t0)
| TMapp _ => eval_app (env, t0)
//
| TMint (i) => VALint (i)
| TMstring (str) => VALstring (str)
//
| TMfix _ => VALclo (env, t0)
| TMlet
    (x, t1, t2) => let
    val v1 = eval (env, t1)
    val env = insert_env (env, x, v1)
  in
    eval (env, t2)
  end // end of [TMlet]
//
| TMopr _ => eval_opr (env, t0)
//
| TMif (
    t_cond, t_then, t_else
  ) => let
    val v_cond = eval (env, t_cond)
  in
    case+ v_cond of
    | VALint (i) =>
        if i > 0 then eval (env, t_then) else eval (env, t_else)
      // end of [TMint]
    | _ => let
        val () = (
          prerr "eval: TMif: cond is not a boolean."
        ) // end of [val]
        val () = prerr_newline ()
      in
        $raise EVAL_IF_COND ()
      end // end of [_]
  end // end of [TMif]
//
end // end of [eval]

(* ****** ****** *)

implement
evalist
  (env, ts) = let
in
//
case+ ts of
| list_cons (t, ts) =>
    list_cons (eval (env, t), evalist (env, ts))
| list_nil () => list_nil ()
//
end // end of [evalist]

(* ****** ****** *)

implement
eval_var
  (env, t0) = let
  val- TMvar (x0) = t0
  val opt = lookup_env (env, x0)
in
  case+ opt of
  | Some (v) => v
  | None () => let
      val () = (
        prerr "The variable ["; prerr x0; prerr "] is unrecognized."
      ) // end of [val]
      val () = prerr_newline ()
    in
      $raise EVAL_VAR (x0)
    end // end of [None]
end // end of [eval_var]

(* ****** ****** *)

exception ILLEGAL_ARG of string

(* ****** ****** *)

fun arrmake (n: int): value =
  if n >= 0 then
    VALarray (array0_make_elt ($UN.cast2size(n), VALvoid))
  else
    $raise ILLEGAL_ARG ("arrmake")
  // end of [if]
// end of [arrmake]

(* ****** ****** *)

fun arrget
  (A: array0 (value), n: int): value =
  if n >= 0 then
    array0_get_elt_at (A, $UN.cast2size(n))
  else 
    $raise ILLEGAL_ARG ("arrget")
  // end of [if]

fun arrset (
  A: array0 (value), n: int, x: value
) : value =
  if n >= 0 then let
    val () = array0_set_elt_at (A, $UN.cast2size(n), x)
  in
    VALvoid ()
  end else
    $raise ILLEGAL_ARG ("arrset")
  // end of [if]

(* ****** ****** *)

implement
eval_opr
  (env, t0) = let
//
val- TMopr (opr, ts) = t0
val vs = evalist (env, ts)
//
in
//
case+ opr of
//
| "+" => (
  case+ vs of
  | VALint i1 :: VALint i2 :: nil () => VALint (i1+i2)
  | _ => $raise EVAL_OPR_ARG (opr)
  )
| "-" => (
  case+ vs of
  | VALint i1 :: VALint i2 :: nil () => VALint (i1-i2)
  | _ => $raise EVAL_OPR_ARG (opr)
  )
//
| "*" => (
  case+ vs of
  | VALint i1 :: VALint i2 :: nil () => VALint (i1*i2)
  | _ => $raise EVAL_OPR_ARG (opr)
  )
| "/" => (
  case+ vs of
  | VALint i1 :: VALint i2 :: nil () => VALint (i1/i2)
  | _ => $raise EVAL_OPR_ARG (opr)
  )
| "%" => (
  case+ vs of
  | VALint i1 :: VALint i2 :: nil () => VALint (i1 mod i2)
  | _ => $raise EVAL_OPR_ARG (opr)
  )
//
| "<" => (
  case+ vs of
  | VALint i1 :: VALint i2 :: nil () => value_bool (i1 < i2)
  | _ => $raise EVAL_OPR_ARG (opr)
  )
| "<=" => (
  case+ vs of
  | VALint i1 :: VALint i2 :: nil () => value_bool (i1 <= i2)
  | _ => $raise EVAL_OPR_ARG (opr)
  )
| ">" => (
  case+ vs of
  | VALint i1 :: VALint i2 :: nil () => value_bool (i1 > i2)
  | _ => $raise EVAL_OPR_ARG (opr)
  )
| ">=" => (
  case+ vs of
  | VALint i1 :: VALint i2 :: nil () => value_bool (i1 >= i2)
  | _ => $raise EVAL_OPR_ARG (opr)
  )
| "=" => (
  case+ vs of
  | VALint i1 :: VALint i2 :: nil () => value_bool (i1 = i2)
  | _ => $raise EVAL_OPR_ARG (opr)
  )
| "!=" => (
  case+ vs of
  | VALint i1 :: VALint i2 :: nil () => value_bool (i1 != i2)
  | _ => $raise EVAL_OPR_ARG (opr)
  )
//
| "arrmake" => (
  case+ vs of
  | VALint (n) :: nil () => arrmake (n)
  | _ => $raise EVAL_OPR_ARG (opr)
  )
| "arrget" => (
  case+ vs of
  | VALarray (A) :: VALint (i) :: nil () => arrget (A, i)
  | _ => $raise EVAL_OPR_ARG (opr)
  )
| "arrset" => (
  case+ vs of
  | VALarray (A) :: VALint (i) :: x :: nil () => arrset (A, i, x)
  | _ => $raise EVAL_OPR_ARG (opr)
  )
//
| _ => let
    val () = (
      prerr "The operator ["; prerr opr; prerr "] is not supported."
    ) // end of [val]
    val () = prerr_newline ()
  in
    $raise EVAL_OPR (opr)
  end // end of [_]
//
end // end of [eval_opr]

(* ****** ****** *)

implement
eval_app
  (env, t0) = let
  val- TMapp (t1, t2) = t0
  val v1 = eval (env, t1)
  val v2 = eval (env, t2)
in
  case+ v1 of
  | VALclo (env, t) => (
    case+ t of
    | TMlam
        (x, t_body) => let
        val env = insert_env (env, x, v2)
      in
        eval (env, t_body)
      end
    | TMfix (f, x, t_body) => let
        val env = insert_env (env, f, v1)
        val env = insert_env (env, x, v2)
      in
        eval (env, t_body)
      end
    | _ => let
        val () = assertloc (false) in exit (1)
      end // end of [_]
    )
  | _ => $raise EVAL_APP_FUN ()
end // end of [TMapp]

(* ****** ****** *)

(* end of [lambda.dats] *)