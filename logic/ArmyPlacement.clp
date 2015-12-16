
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Army Placement
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
;; don't place in country surrounded by own countries
;focus in countries that are touching other owned countries
;ratio against enemies in continent/adjacent

	
;;;;; Value for continents	
;; Should be refactored

(defrule add-continent-value
	(place-army)
	(game-phase (player ?p))
	(country (owner ?p) (country-name ?country-name) (continent ?continent))
	(continent-value ?continent ?value)
	=>
	(assert (add-value (country-name ?country-name) (value ?value))))
	
(defrule create-score (declare (salience 10))
	(place-army)
	(place-army)
	(game-phase (player ?p))
	(country (owner ?p) (country-name ?country-name))
	=>
	(assert (choice-score (score 0) (country ?country-name))))	
	
;;;; adds value to owned adjacent countries
(defrule add-adj-value
	(place-army)
	(game-phase (player ?p))
	(country (owner ?p) (country-name ?country-name))
	(country (owner ?p) (country-name ?country-name2&~country-name))
	(or (border (country-a ?country-name) (country-b ?country-name2)) (border (country-a ?country-name2) (country-b ?country-name)))
	=>
	(assert (add-value (country-name ?country-name) (value 5))))
	
;;;; ensure surrounded country does not receive troops
(defrule sub-surrounded-value (declare (salience -1))
	(place-army)
	(game-phase (player ?p))
	(country (owner ?p) (country-name ?country-name))
	(forall (border (country-a ?country-name) (country-b ?country-name2))
		(country (owner ?p) (country-name ?country-name2)))
	=>
	(assert (add-value (country-name ?country-name) (value -10)))
	(assert (remove-add-values ?country-name)) )

(defrule clear-add-values (declare (salience -1))
	(place-army)
	(remove-add-values ?country-name)
	?adder <- (add-value (country-name ?country-name) (value ?val&~-10))
	=>
	(retract ?adder) )


(defrule add-value-score (declare (salience -2))
	(place-army)
	(game-phase (player ?p))
	(country (owner ?p) (country-name ?country-name))
	?addval <- (add-value (country-name ?country-name) (value ?val))
	?score <- (choice-score (country ?country-name) (score ?num))
	=>
	(retract ?addval)
	(modify ?score (score (+ ?num ?val))))
		
(defrule find-highest-val (declare (salience -3))
	(place-army)
	?u <- (user-choice (score ?user-val) (country-name ?cname))
	?choice <-(choice-score (country ?country-name) (score ?choice-val))
	(test (> ?choice-val ?user-val))
	=>
	(retract ?choice)
	(modify ?u (score ?choice-val) (country-name ?country-name)) )	