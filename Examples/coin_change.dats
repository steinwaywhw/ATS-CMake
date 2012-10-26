staload "lambda.sats"

dynload "lambda.dats"
dynload "lambda_env.dats"

#define :: list_cons
#define nil list_nil

val sum = TMvar ("sum")
val n = TMvar ("n")

val sum_gt_0 = TMopr (">", sum :: TMint (0) :: nil())
val n_gte_0 = TMopr (">=", n :: TMint (0) :: nil())
val sum_lt_0 = TMopr ("<", sum :: TMint(0) :: nil())
val do_change_n_minus_1 = TMapp (TMapp (TMvar ("f"), sum), TMopr2 ("-", n, TMint (1)))
val do_change_n = TMapp (TMapp (TMvar ("f"), TMopr2 ("-", sum, TMopr ("arrget", TMvar ("coins") :: n :: nil()))), n)

val init = 
	TMlam ("term", 
		TMlet ("coins", TMopr ("arrmake", TMint (4) :: nil()), 
			TMlet ("_", TMopr ("arrset", TMvar ("coins") :: TMint (0) :: TMint (1) :: nil()), 
				TMlet ("_", TMopr ("arrset", TMvar ("coins") :: TMint (1) :: TMint (5) :: nil()),
					TMlet ("_", TMopr ("arrset", TMvar ("coins") :: TMint (2) :: TMint (10) :: nil()),
						TMlet ("_", TMopr ("arrset", TMvar ("coins") :: TMint (3) :: TMint (25) :: nil()),
	TMvar ("term")))))))

val do_change = 
	TMfix ("f", "sum", 
		TMlam ("n", 
			TMif (sum_gt_0, 
				TMif (n_gte_0, 
					TMopr2 ("+", do_change_n_minus_1, do_change_n),
					TMint (0)),
				TMif (sum_lt_0, TMint (0), TMint (1)))))

val change = TMlam ("sum", TMapp (TMapp (
	TMlet ("coins", TMopr ("arrmake", TMint (4) :: nil()), 
			TMlet ("_", TMopr ("arrset", TMvar ("coins") :: TMint (0) :: TMint (1) :: nil()), 
				TMlet ("_", TMopr ("arrset", TMvar ("coins") :: TMint (1) :: TMint (5) :: nil()),
					TMlet ("_", TMopr ("arrset", TMvar ("coins") :: TMint (2) :: TMint (10) :: nil()),
						TMlet ("_", TMopr ("arrset", TMvar ("coins") :: TMint (3) :: TMint (25) :: nil()),
							do_change)))))
						, sum), TMint (3)))

val change_100 = TMapp (change, TMint (100))



implement main () = let
	val () = println! ("CHANGE (100) = ", eval0 (change_100))
in
end
			
