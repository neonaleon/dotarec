(deffunction subsetdp (?sub ?set) 
	(if (eq 0 (length$ ?sub)) 
		then (return TRUE))
	(bind ?x (member$ (nth$ 1 ?sub) ?set))
	(if ?x 
		then (return (subsetdp (rest$ ?sub) (delete$ ?set ?x ?x))))
	FALSE)
	
(deffunction remove-subset (?sub ?set) 
	(if (eq 0 (length$ ?sub)) 
		then (return ?set))
	(bind ?x (member$ (nth$ 1 ?sub) ?set))
	(if ?x 
		then (return (remove-subset (rest$ ?sub) (delete$ ?set ?x ?x))))
	FALSE)	