(*
** computing Fibonacci numbers
*)

staload "lambda.sats"

(* ****** ****** *)

dynload "lambda.dats"
dynload "lambda_env.dats"

(* ****** ****** *)
//
val f = TMvar "f"
val x = TMvar "x"
//
val _0 = TMint (0)
val _1 = TMint (1)
val _2 = TMint (2)
//
val _cond = TMopr2 (">=", x, _2) // x >= 2
val _then = TMopr2 ("+", TMapp (f, TMopr2 ("-", x, _1)), TMapp (f, TMopr2 ("-", x, _2)))
val _else = x // x
//
val fib = TMfix ("f", "x", TMif (_cond, _then, _else))
//
(* ****** ****** *)

val fib10 =
  TMapp (fib, TMint (10))
val ans = eval0 (fib10)

val () = println! ("fib10 = ", ans)

(* ****** ****** *)

implement main () = ()

(* ****** ****** *)

(* end of [test_fib.dats] *)