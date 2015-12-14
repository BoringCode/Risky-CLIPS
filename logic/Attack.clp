(defrule find-attack-ratios
	(attack)
	(game-phase (player ?pname))
	(country (country-name ?player-country) (owner ?pname) (troops ?player-troops))
	(border (country-a ?player-country) (country-b ?enemy-country))
	(country (country-name ?enemy-country) (owner ~?pname) (troops ?enemy-troops))
	=>
	(assert (potential-attack ?player-country ?enemy-country (/ ?player-troops ?enemy-troops))))

(defrule find-best-attack
	(logical 
		(attack)
		(potential-attack ?player-country ?enemy-country ?ratio)
		(test (> ?ratio 1.3))
		(not (potential-attack ?other-player-country ?some-country ?otherRatio&:(> ?otherRatio ?ratio))))
	=>
	(assert (attack-to-country ?enemy-country))
	(assert (attack-from-country ?player-country)))