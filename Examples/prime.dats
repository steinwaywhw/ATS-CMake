staload "lambda.sats"

dynload "lambda.dats"
dynload "lambda_env.dats"

#define :: list_cons
#define nil list_nil



val arr = TMvar ("arr")
val p = TMvar ("p")
val q = TMvar ("q")
val k = TMvar ("k")
val n = TMvar ("n")
val N = TMvar ("N")

val is_prime_stop = 
	TMopr2 (">", 
		TMopr2 ("arrget", arr, q), 
		TMopr2 ("/", k, TMint (2)))

val can_div = 
	TMopr2 ("=", 
		TMopr2 ("%", k, TMopr2 ("arrget", arr, q)), 
		TMint(0))



val do_is_prime =  
	TMfix ("f", "q", 
		TMif (is_prime_stop, TMint (1), 
			TMif (can_div, TMint (0), 
				TMapp (TMvar ("f"), TMopr2 ("+", q, TMint (1))))))

val is_prime = TMlam ("k", TMapp (do_is_prime, TMint (0)))


val set_and_get = 
	TMlet ("z", TMopr ("arrset", arr :: p :: n :: nil()), 
		TMapp (
			TMapp (
				TMvar("g"), 
				TMopr2 ("+", p, TMint (1))), 
			TMopr2 ("+", n, TMint (2))))

val get = 
	TMapp (
		TMapp (TMvar ("g"), p), 
		TMopr2 ("+", n, TMint (2)))


val do_compute_arr = 
	TMfix ("g", "p", TMlam ("n", 
		TMif (TMopr2 (">", n, N), p, 
			TMif (TMapp (is_prime, n), set_and_get, get))))
	

val compute_arr = 
			TMapp (
				TMapp (do_compute_arr, TMint (1)), 
				TMint (3))


val do_sum = 
	TMfix ("s", "p", 
		TMif ( TMopr2 ("<", p, TMint (0)), 
			TMint (0), 
			TMopr2 ("+", 
				TMopr2 ("arrget", arr, p), 
				TMapp (TMvar ("s"), TMopr2 ("-", p, TMint (1))))))

val sum = 
	TMlam ("N", 
		TMlet ("arr", TMopr ("arrmake", N :: nil()), 
			TMlet ("z", TMopr ("arrset", arr :: TMint (0) :: TMint (2) :: nil ()),
				TMapp (do_sum, TMopr2 ("-", compute_arr, TMint (1) )))))

val sum_1000 = TMapp (sum, TMint (1000))

implement main () = let
	val () = println! ("PRIME_SUM (1000) = ", eval0 (sum_1000))
in
end
			
