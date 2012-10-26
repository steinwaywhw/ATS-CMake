staload "lambda.sats"
dynload "lambda.dats"
dynload "lambda_env.dats"

val step = TMvar ("s")
val iter = TMvar ("i")
val limit = TMvar ("n")

val m = TMvar ("m")

val i_lt_n = TMopr2 ("<", iter, limit)
val i_plus_m = TMopr2 ("+", iter, TMapp (m, TMopr2 ("+", step, iter)))


val sum_m = TMfix ("m", "i", TMif (i_lt_n, i_plus_m, TMint (0)))

val sum_m_3 = TMlam ("n", TMapp (TMlam ("s", TMapp (sum_m, TMint(3))), TMint (3)))
val sum_m_5 = TMlam ("n", TMapp (TMlam ("s", TMapp (sum_m, TMint(5))), TMint (5)))
val sum_m_15 = TMlam ("n", TMapp (TMlam ("s", TMapp (sum_m, TMint(15))), TMint (15)))

val sum_3 = TMapp (sum_m_3, TMvar ("n"))
val sum_5 = TMapp (sum_m_5, TMvar ("n"))
val sum_15 = TMapp (sum_m_15, TMvar ("n"))

val sum = TMlam ("n", TMopr2 ("-", TMopr2 ("+", sum_3, sum_5), sum_15))

implement main () = let
	val () = println! ("sum (1000) = ", eval0 (TMapp (sum, TMint (1000))))
in
end