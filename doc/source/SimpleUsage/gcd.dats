staload "lambda.sats"

dynload "lambda.dats"
dynload "lambda_env.dats"

val a = TMvar ("a")
val b = TMvar ("b")

val a_lt_b = TMopr2 ("<", a, b)
val b_eq_0 = TMopr2 ("=", b, TMint (0))

val g = TMvar ("g")
val g_b_a = TMapp (TMapp (g, b), a)
val g_c_b = TMapp (TMapp (g, TMopr2 ("-", a, b)), b)

val gcd = 
	TMfix ("g", "a", 
		TMlam ("b", TMif (a_lt_b, g_b_a, TMif (b_eq_0, a, g_c_b))))

val gcd_14_16 = TMapp (TMapp(gcd, TMint(14)), TMint(16))

implement main () = let
	val () = println! ("GCD (14, 16) = ", eval0 (gcd_14_16))
in
end