(deffunction subsetdp (?sub ?set) 
	(if (eq 0 (length$ ?sub)) 
		then (return TRUE))
	(bind ?x (member$ (nth$ 1 ?sub) ?set))
	(if ?x 
		then (return (subsetdp (rest$ ?sub) (delete$ ?set ?x ?x))))
	FALSE)