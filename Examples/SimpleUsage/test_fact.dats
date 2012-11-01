(*
** factorial function
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
//
val _cond = TMopr2 (">", x, _0) // x > 0
val _then = TMopr2 ("*", x, TMapp (f, TMopr2 ("-", x, _1))) // x * f(x-1)
val _else = _1 // 1
//
val fact = TMfix ("f", "x", TMif (_cond, _then, _else))
//
(* ****** ****** *)

val fact10 =
  TMapp (fact, TMint (10))
val ans = eval0 (fact10)

val () = println! ("fact10 = ", ans)

(* ****** ****** *)

implement main () = ()

(* ****** ****** *)

(* end of [test_fact.dats] *)