(deftemplate victory-card
	(slot country)
	(slot type)
	(slot idx) )

(deftemplate country
	(slot country-name)
	(slot continent)
	(slot owner)
	(slot troops) )
	
(deftemplate possible-book
	(multislot countries)
	(slot CF)	)
	
(deftemplate book-with-neighboring-countries
	(multislot countries)
	(slot CF)
	(slot change) )

(deftemplate game-phase
	(slot player)
	(slot turn-num)
	(slot book-reward) )
	
(deftemplate border
	(slot country-a)
	(slot country-b) )
	
(deftemplate choice-score
	(slot score)
	(slot country))
		
(deftemplate add-value
	(slot value)
	(slot country-name))
	
(deftemplate user-choice
	(slot score)
	(slot country-name))
	
(deffacts testFacts
	;; All borders for countries in Risk
	(border (country-a  North-Africa ) (country-b  Brazil ))
	(border (country-a  North-Africa ) (country-b  Western-Europe ))
	(border (country-a  North-Africa ) (country-b  Southern-Europe ))
	(border (country-a  North-Africa ) (country-b  Egypt ))
	(border (country-a  North-Africa ) (country-b  East-Africa ))
	(border (country-a  North-Africa ) (country-b  Central-Africa ))
	(border (country-a  Ural ) (country-b  Russia ))
	(border (country-a  Ural ) (country-b  Siberia ))
	(border (country-a  Ural ) (country-b  China ))
	(border (country-a  Ural ) (country-b  Afghanistan ))
	(border (country-a  Afghanistan ) (country-b  Russia ))
	(border (country-a  Afghanistan ) (country-b  Ural ))
	(border (country-a  Afghanistan ) (country-b  China ))
	(border (country-a  Afghanistan ) (country-b  India ))
	(border (country-a  Afghanistan ) (country-b  Middle-East ))
	(border (country-a  Western-Europe ) (country-b  Great-Britain ))
	(border (country-a  Western-Europe ) (country-b  Northern-Europe ))
	(border (country-a  Western-Europe ) (country-b  Southern-Europe ))
	(border (country-a  Western-Europe ) (country-b  North-Africa ))
	(border (country-a  Greenland ) (country-b  Northwest-Territory ))
	(border (country-a  Greenland ) (country-b  Ontario ))
	(border (country-a  Greenland ) (country-b  Eastern-Canada ))
	(border (country-a  Greenland ) (country-b  Iceland ))
	(border (country-a  East-Africa ) (country-b  Middle-East ))
	(border (country-a  East-Africa ) (country-b  Central-Africa ))
	(border (country-a  East-Africa ) (country-b  Madagascar ))
	(border (country-a  East-Africa ) (country-b  Egypt ))
	(border (country-a  East-Africa ) (country-b  South-Africa ))
	(border (country-a  East-Africa ) (country-b  North-Africa ))
	(border (country-a  Indonesia ) (country-b  Southeast-Asia ))
	(border (country-a  Indonesia ) (country-b  Western-Australia ))
	(border (country-a  Indonesia ) (country-b  New-Guinea ))
	(border (country-a  China ) (country-b  Mongolia ))
	(border (country-a  China ) (country-b  Southeast-Asia ))
	(border (country-a  China ) (country-b  India ))
	(border (country-a  China ) (country-b  Afghanistan ))
	(border (country-a  China ) (country-b  Ural ))
	(border (country-a  China ) (country-b  Siberia ))
	(border (country-a  Japan ) (country-b  Kamchatka ))
	(border (country-a  Japan ) (country-b  Mongolia ))
	(border (country-a  Kamchatka ) (country-b  Alaska ))
	(border (country-a  Kamchatka ) (country-b  Japan ))
	(border (country-a  Kamchatka ) (country-b  Yakutsk ))
	(border (country-a  Kamchatka ) (country-b  Irkutsk ))
	(border (country-a  Kamchatka ) (country-b  Mongolia ))
	(border (country-a  Argentina ) (country-b  Peru ))
	(border (country-a  Argentina ) (country-b  Brazil ))
	(border (country-a  Alberta ) (country-b  Alaska ))
	(border (country-a  Alberta ) (country-b  Northwest-Territory ))
	(border (country-a  Alberta ) (country-b  Ontario ))
	(border (country-a  Alberta ) (country-b  Western-United-States ))
	(border (country-a  Alaska ) (country-b  Kamchatka ))
	(border (country-a  Alaska ) (country-b  Northwest-Territory ))
	(border (country-a  Alaska ) (country-b  Alberta ))
	(border (country-a  Eastern-Australia ) (country-b  New-Guinea ))
	(border (country-a  Eastern-Australia ) (country-b  Western-Australia ))
	(border (country-a  Southeast-Asia ) (country-b  Indonesia ))
	(border (country-a  Southeast-Asia ) (country-b  India ))
	(border (country-a  Southeast-Asia ) (country-b  China ))
	(border (country-a  Iceland ) (country-b  Greenland ))
	(border (country-a  Iceland ) (country-b  Scandinavia ))
	(border (country-a  Iceland ) (country-b  Great-Britain ))
	(border (country-a  Scandinavia ) (country-b  Iceland ))
	(border (country-a  Scandinavia ) (country-b  Russia ))
	(border (country-a  Scandinavia ) (country-b  Northern-Europe ))
	(border (country-a  Scandinavia ) (country-b  Great-Britain ))
	(border (country-a  South-Africa ) (country-b  Central-Africa ))
	(border (country-a  South-Africa ) (country-b  East-Africa ))
	(border (country-a  South-Africa ) (country-b  Madagascar ))
	(border (country-a  Western-United-States ) (country-b  Alberta ))
	(border (country-a  Western-United-States ) (country-b  Ontario ))
	(border (country-a  Western-United-States ) (country-b  Eastern-United-States ))
	(border (country-a  Western-United-States ) (country-b  Central-America ))
	(border (country-a  Eastern-United-States ) (country-b  Ontario ))
	(border (country-a  Eastern-United-States ) (country-b  Eastern-Canada ))
	(border (country-a  Eastern-United-States ) (country-b  Western-United-States ))
	(border (country-a  Eastern-United-States ) (country-b  Central-America ))
	(border (country-a  Yakutsk ) (country-b  Siberia ))
	(border (country-a  Yakutsk ) (country-b  Irkutsk ))
	(border (country-a  Yakutsk ) (country-b  Kamchatka ))
	(border (country-a  Irkutsk ) (country-b  Siberia ))
	(border (country-a  Irkutsk ) (country-b  Yakutsk ))
	(border (country-a  Irkutsk ) (country-b  Kamchatka ))
	(border (country-a  Irkutsk ) (country-b  Mongolia ))
	(border (country-a  Central-America ) (country-b  Western-United-States ))
	(border (country-a  Central-America ) (country-b  Eastern-United-States ))
	(border (country-a  Central-America ) (country-b  Venezuela ))
	(border (country-a  New-Guinea ) (country-b  Eastern-Australia ))
	(border (country-a  New-Guinea ) (country-b  Western-Australia ))
	(border (country-a  New-Guinea ) (country-b  Indonesia ))
	(border (country-a  Great-Britain ) (country-b  Iceland ))
	(border (country-a  Great-Britain ) (country-b  Scandinavia ))
	(border (country-a  Great-Britain ) (country-b  Northern-Europe ))
	(border (country-a  Great-Britain ) (country-b  Western-Europe ))
	(border (country-a  Venezuela ) (country-b  Central-America ))
	(border (country-a  Venezuela ) (country-b  Peru ))
	(border (country-a  Venezuela ) (country-b  Brazil ))
	(border (country-a  Ontario ) (country-b  Greenland ))
	(border (country-a  Ontario ) (country-b  Alberta ))
	(border (country-a  Ontario ) (country-b  Western-United-States ))
	(border (country-a  Ontario ) (country-b  Eastern-United-States ))
	(border (country-a  Ontario ) (country-b  Eastern-Canada ))
	(border (country-a  Ontario ) (country-b  Northwest-Territory ))
	(border (country-a  Central-Africa ) (country-b  North-Africa ))
	(border (country-a  Central-Africa ) (country-b  East-Africa ))
	(border (country-a  Central-Africa ) (country-b  South-Africa ))
	(border (country-a  Brazil ) (country-b  Argentina ))
	(border (country-a  Brazil ) (country-b  Peru ))
	(border (country-a  Brazil ) (country-b  Venezuela ))
	(border (country-a  Brazil ) (country-b  North-Africa ))
	(border (country-a  India ) (country-b  Middle-East ))
	(border (country-a  India ) (country-b  Afghanistan ))
	(border (country-a  India ) (country-b  China ))
	(border (country-a  India ) (country-b  Southeast-Asia ))
	(border (country-a  Northern-Europe ) (country-b  Great-Britain ))
	(border (country-a  Northern-Europe ) (country-b  Scandinavia ))
	(border (country-a  Northern-Europe ) (country-b  Russia ))
	(border (country-a  Northern-Europe ) (country-b  Southern-Europe ))
	(border (country-a  Northern-Europe ) (country-b  Western-Europe ))
	(border (country-a  Middle-East ) (country-b  Southern-Europe ))
	(border (country-a  Middle-East ) (country-b  Russia ))
	(border (country-a  Middle-East ) (country-b  Afghanistan ))
	(border (country-a  Middle-East ) (country-b  India ))
	(border (country-a  Middle-East ) (country-b  East-Africa ))
	(border (country-a  Middle-East ) (country-b  Egypt ))
	(border (country-a  Northwest-Territory ) (country-b  Alaska ))
	(border (country-a  Northwest-Territory ) (country-b  Alberta ))
	(border (country-a  Northwest-Territory ) (country-b  Ontario ))
	(border (country-a  Northwest-Territory ) (country-b  Greenland ))
	(border (country-a  Mongolia ) (country-b  Japan ))
	(border (country-a  Mongolia ) (country-b  Kamchatka ))
	(border (country-a  Mongolia ) (country-b  China ))
	(border (country-a  Mongolia ) (country-b  Siberia ))
	(border (country-a  Mongolia ) (country-b  Irkutsk ))
	(border (country-a  Madagascar ) (country-b  South-Africa ))
	(border (country-a  Madagascar ) (country-b  East-Africa ))
	(border (country-a  Egypt ) (country-b  Southern-Europe ))
	(border (country-a  Egypt ) (country-b  Middle-East ))
	(border (country-a  Egypt ) (country-b  East-Africa ))
	(border (country-a  Egypt ) (country-b  North-Africa ))
	(border (country-a  Eastern-Canada ) (country-b  Eastern-United-States ))
	(border (country-a  Eastern-Canada ) (country-b  Ontario ))
	(border (country-a  Eastern-Canada ) (country-b  Greenland ))
	(border (country-a  Siberia ) (country-b  Ural ))
	(border (country-a  Siberia ) (country-b  Yakutsk ))
	(border (country-a  Siberia ) (country-b  Irkutsk ))
	(border (country-a  Siberia ) (country-b  Mongolia ))
	(border (country-a  Siberia ) (country-b  China ))
	(border (country-a  Southern-Europe ) (country-b  Western-Europe ))
	(border (country-a  Southern-Europe ) (country-b  Northern-Europe ))
	(border (country-a  Southern-Europe ) (country-b  Russia ))
	(border (country-a  Southern-Europe ) (country-b  Middle-East ))
	(border (country-a  Southern-Europe ) (country-b  Egypt ))
	(border (country-a  Southern-Europe ) (country-b  North-Africa ))
	(border (country-a  Western-Australia ) (country-b  Indonesia ))
	(border (country-a  Western-Australia ) (country-b  Eastern-Australia ))
	(border (country-a  Western-Australia ) (country-b  New-Guinea ))
	(border (country-a  Russia ) (country-b  Southern-Europe ))
	(border (country-a  Russia ) (country-b  Northern-Europe ))
	(border (country-a  Russia ) (country-b  Scandinavia ))
	(border (country-a  Russia ) (country-b  Ural ))
	(border (country-a  Russia ) (country-b  Afghanistan ))
	(border (country-a  Russia ) (country-b  Middle-East ))
	(border (country-a  Peru ) (country-b  Argentina ))
	(border (country-a  Peru ) (country-b  Brazil ))
	(border (country-a  Peru ) (country-b  Venezuela ))

	
	
	; Debugging purposes
	;(country (country-name Egypt) (continent europe) (owner 1) (troops 4))
	;(country (country-name Iceland) (continent europe) (owner 2) (troops 8))
	;(country (country-name Ontario) (continent africa) (owner 2) (troops 18))
	;(country (country-name Middle-East) (continent australia) (owner 1) (troops 2))
	;(country (country-name alaska) (continent north-america) (owner 1) (troops 2))
	;(country (country-name russia) (continent asia) (owner 2) (troops 20))
	
	;(victory-card (country Egypt) (type infantry) (idx 0))
	;(victory-card (country Iceland) (type artillery) (idx 1))
	;(victory-card (country Ontario) (type wild) (idx 2))
	;(victory-card (country Middle-East) (type wild) (idx 3))
	;(victory-card (country alaska) (type cavalry) (idx 4))

	(my-countries)
	
	; Send in game phase
	(game-phase (player 1) (turn-num 20) (book-reward 8)) 
	
	(user-choice (score -15) (country-name nil))	)

	
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
	
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Army Placement
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
;; don't place in country surrounded by own countries
;focus in countries that are touching other owned countries
;ratio against enemies in continent/adjacent

	
;;;;; Value for continents	
;; Should be refactored

(defrule add-Australia-value
	(game-phase (player ?p))
	(country (owner ?p) (country-name ?country-name) (continent Australia))
	=>
	(assert (add-value (country-name ?country-name) (value 11))))
	
(defrule create-score (declare (salience 10))
	(place-army)
	(game-phase (player ?p))
	(country (owner ?p) (country-name ?country-name))
	=>
	(assert (choice-score (score 0) (country ?country-name))))
	
(defrule add-South-America-value
	(game-phase (player ?p))
	(country (owner ?p) (country-name ?country-name) (continent South-America))
	=>
	(assert (add-value (country-name ?country-name) (value 8))))
	
(defrule add-Asia-value
	(game-phase (player ?p))
	(country (owner ?p) (country-name ?country-name) (continent Asia))
	=>
	(assert (add-value (country-name ?country-name) (value 2))))

(defrule add-North-America-value
	(game-phase (player ?p))
	(country (owner ?p) (country-name ?country-name) (continent North-America))
	=>
	(assert (add-value (country-name ?country-name) (value 5))))

(defrule add-Africa-value
	(game-phase (player ?p))
	(country (owner ?p) (country-name ?country-name) (continent Africa))
	=>
	(assert (add-value (country-name ?country-name) (value 7))))
	
(defrule add-Europe-value
	(game-phase (player ?p))
	(country (owner ?p) (country-name ?country-name) (continent Europe))
	=>
	(assert (add-value (country-name ?country-name) (value 6))))
	
	
;;;; adds value to owned adjacent countries
(defrule add-adj-value
	(game-phase (player ?p))
	(country (owner ?p) (country-name ?country-name))
	(country (owner ?p) (country-name ?country-name2&~country-name))
	(or (border (country-a ?country-name) (country-b ?country-name2)) (border (country-a ?country-name2) (country-b ?country-name)))
	=>
	(assert (add-value (country-name ?country-name) (value 5))))
	
;;;; ensure surrounded country does not receive troops
(defrule sub-surrounded-value (declare (salience -1))
	(game-phase (player ?p))
	(country (owner ?p) (country-name ?country-name))
	(forall (border (country-a ?country-name) (country-b ?country-name2))
		(country (owner ?p) (country-name ?country-name2)))
	=>
	(assert (add-value (country-name ?country-name) (value -10)))
	(assert (remove-add-values ?country-name)) )

(defrule clear-add-values (declare (salience -1))
	(remove-add-values ?country-name)
	?adder <- (add-value (country-name ?country-name) (value ?val&~-10))
	=>
	(retract ?adder) )


(defrule add-value-score (declare (salience -2))
	(game-phase (player ?p))
	(country (owner ?p) (country-name ?country-name))
	?addval <- (add-value (country-name ?country-name) (value ?val))
	?score <- (choice-score (country ?country-name) (score ?num))
	=>
	(retract ?addval)
	(modify ?score (score (+ ?num ?val))))
		
(defrule find-highest-val (declare (salience -3))
	?u <- (user-choice (score ?user-val) (country-name ?cname))
	?choice <-(choice-score (country ?country-name) (score ?choice-val))
	(test (> ?choice-val ?user-val))
	=>
	(retract ?choice)
	(modify ?u (score ?choice-val) (country-name ?country-name)) )	