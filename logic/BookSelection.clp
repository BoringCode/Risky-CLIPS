	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Book Selection
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction compute-country-bonus (?c1 ?c2 ?c3 $?player-countries)
	(bind ?bonus 0)
	(progn$ (?book-country (create$ ?c1 ?c2 ?c3))
		(if (member$ ?book-country $?player-countries)
			then
				;(printout t "my country: " ?book-country crlf)
				(bind ?bonus (+ ?bonus 2.5))
				(assert (calculate-occupied-vulnerability ?book-country))
			else
				;(printout t "their country: " ?book-country crlf)
				(assert (calculate-enemy-vulnerability ?book-country))))
	(return ?bonus) )

(defrule find-countries (declare (salience 1))
	(game-phase (player ?p))
	(country (country-name ?c)(owner ?p))
	?my-countries <- (my-countries $?countries)
	(test (not (member$ ?c $?countries)))
	=>
	(retract ?my-countries)
	(assert (my-countries ?c $?countries)) )
	
	
(defrule all-one-kind
	(search-books)
	(my-countries $?countries)
	?c1 <- (victory-card (country ?co1) (type ?t) (idx ?i1))
	?c2 <- (victory-card (country ?co2&~?co1) (type ?t2&:(or (eq ?t2 ?t) (eq ?t2 wild))) (idx ?i2))
	?c3 <- (victory-card (country ?co3&~?co2&~?co1) (type ?t3&:(or (eq ?t3 ?t) (eq ?t3 wild))) (idx ?i3))
	(not (or (possible-book (countries ?co1 ?co2 ?co3))
			 (possible-book (countries ?co1 ?co3 ?co2))
			 (possible-book (countries ?co2 ?co1 ?co3))
			 (possible-book (countries ?co2 ?co3 ?co1))
			 (possible-book (countries ?co3 ?co1 ?co2))
			 (possible-book (countries ?co3 ?co2 ?co1))))
	=>
	;(printout t ?co1 " " ?co2 " " ?co3 " are all type " t crlf)
	(bind ?country-bonus (compute-country-bonus ?co1 ?co2 ?co3 $?countries))
	(assert (possible-book (countries ?co1 ?co2 ?co3) (CF ?country-bonus))) )
	
(defrule all-different-kind
	(search-books)
	(my-countries $?countries)
	?c1 <- (victory-card (country ?co1) (type ?t1&~wild) (idx ?i1))
	?c2 <- (victory-card (country ?co2&~?co1) (type ?t2&:(or (not (eq ?t2 ?t1)) (eq ?t2 wild))) (idx ?i2))
	?c3 <- (victory-card (country ?co3&~?co2&~?co1) (type ?t3&:(or (not (or (eq ?t3 ?t1) (eq ?t3 ?t2))) (eq ?t3 wild))) (idx ?i3)) 
	(not (or (possible-book (countries ?co1 ?co2 ?co3))
			 (possible-book (countries ?co1 ?co3 ?co2))
			 (possible-book (countries ?co2 ?co1 ?co3))
			 (possible-book (countries ?co2 ?co3 ?co1))
			 (possible-book (countries ?co3 ?co1 ?co2))
			 (possible-book (countries ?co3 ?co2 ?co1))))
	=>
	;(printout t ?co1 " " ?co2 " " ?co3 " are all different types " crlf)
	(bind ?country-bonus (compute-country-bonus ?co1 ?co2 ?co3 $?countries))
	(assert (possible-book (countries ?co1 ?co2 ?co3) (CF ?country-bonus))) )
	
(defrule calculate-occupied-vulnerability
	(game-phase (player ?p))
	?calculate-ratio <- (calculate-occupied-vulnerability ?my-country)
	(or (border (country-a ?enemy-country) (country-b ?my-country)) (border (country-a ?my-country) (country-b ?enemy-country)))
	(country (country-name ?my-country) (troops ?my-troops) (owner ?p))
	(country (country-name ?enemy-country) (troops ?enemy-troops) (owner ?e&~?p))
	=>
	(assert (ratio (/ ?enemy-troops ?my-troops) ?enemy-country ?my-country occupied)) )
	
(defrule calculate-enemy-vulnerability
	(game-phase (player ?p))
	?calculate-ratio <- (calculate-enemy-vulnerability ?enemy-country)
	(or (border (country-a ?my-country) (country-b ?enemy-country)) (border (country-a ?enemy-country) (country-b ?my-country)))
	(country (country-name ?my-country) (troops ?my-troops) (owner ?p))
	(country (country-name ?enemy-country) (troops ?enemy-troops) (owner ?e&~?p))
	=>
	(assert (ratio (/ ?my-troops ?enemy-troops) ?my-country ?enemy-country enemy)) )

	
(defrule vulnerable-book-card-country
	?possible-book <- (possible-book (countries $?book-countries) (CF ?CF) )
	(ratio ?value ?to-country ?from-country ?perspective)
	(test (member$ ?from-country $?book-countries))
	=>
	(if (> ?value 1.5)
		then
			(if (eq ?perspective enemy)
				then
					;(printout t "perspective: " ?perspective " country: " ?from-country ", is vunerable from " ?to-country crlf)
					(assert (book-with-neighboring-countries (countries $?book-countries) (CF ?CF) (change (* -1 ?value))))
				else
					;(printout t "perspective: " ?perspective " country: " ?to-country ", is vunerable from " ?from-country crlf)
					(assert (book-with-neighboring-countries (countries $?book-countries) (CF ?CF) (change ?value))))) )

(defrule remove-search-fact (declare (salience -1))
	?fact <- (search-books)
	=>
	(retract ?fact) )
	
(defrule remove-possible-books-with-changes (declare (salience -2))
	?possible-book <- (possible-book (countries $?book-countries) (CF ?CF) )
	(book-with-neighboring-countries (countries $?book-countries))
	=>
	(retract ?possible-book)
)

(defrule combine-books-with-neighboring-countries (declare (salience -3))
	?book-with-neighboring-countries-1 <- (book-with-neighboring-countries (countries $?countries) (CF ?bwnc1-CF) (change ?bwnc1-change))
	?book-with-neighboring-countries-2 <- (book-with-neighboring-countries (countries $?countries) (CF ?bwnc2-CF) (change ?bwnc2-change&~0))
	(test (not (eq ?book-with-neighboring-countries-1 ?book-with-neighboring-countries-2)))
	=>
	;(printout t "Combining book: " $?countries " CF1: " ?bwnc1-CF " Change1: " ?bwnc1-change " CF2: " ?bwnc2-CF " Change2: " ?bwnc2-change crlf )
	(retract ?book-with-neighboring-countries-1 ?book-with-neighboring-countries-2)
	(if (eq ?bwnc1-change 0)
		then
			(bind ?combined-cf (+ ?bwnc1-CF ?bwnc2-change))
		else
			(bind ?combined-cf (+ ?bwnc1-CF ?bwnc1-change ?bwnc2-change)))
	(assert (book-with-neighboring-countries (countries $?countries) (CF ?combined-cf) (change 0))) )
	
(defrule make-books-from-non-neighboring-countries (declare (salience -4))
	?possible-book <- (possible-book (countries ?co1 ?co2 ?co3) (CF ?CF) )
	(victory-card (country ?co1) (idx ?idx1))
	(victory-card (country ?co2) (idx ?idx2&~?idx1))
	(victory-card (country ?co3) (idx ?idx3&~?idx1&~?idx2))
	=>
	(retract ?possible-book)
	(assert (book ?CF ?idx1 ?idx2 ?idx3)) )


(defrule make-books (declare (salience -4))
		?book-with-neighboring-countries <- (book-with-neighboring-countries (countries ?co1 ?co2 ?co3) (CF ?CF) (change ?change))
		(victory-card (country ?co1) (idx ?idx1))
		(victory-card (country ?co2) (idx ?idx2&~?idx1))
		(victory-card (country ?co3) (idx ?idx3&~?idx1&~?idx2))
		=>
		(retract ?book-with-neighboring-countries)
		(assert (book (+ ?CF ?change) ?idx1 ?idx2 ?idx3)) )
	
(defrule pick-best-book (declare (salience -5))
	(book ?CF $?idxs)
	(not (book ?CF2&:(> ?CF2 ?CF) $?idxs2&~$?idxs))
	=>
	(assert (book-choice ?CF $?idxs)) )