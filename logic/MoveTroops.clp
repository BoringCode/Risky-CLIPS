(defrule find-move-ratios
        (move-troops)
        (game-phase (player ?pname))
        (last-attack (from ?from-country))
        (country (country-name ?from-country) (owner ?pname) (troops ?from-troops))
        (border (country-a ?from-country) (country-b ?enemy-country))
        (country (country-name ?enemy-country) (owner ~?pname) (troops ?enemy-troops))
        =>
        (assert (potential-threat ?from-country ?enemy-country (/ ?from-troops ?enemy-troops) (- ?fromtroops (* ?enemytroops 1.5)))) )

(defrule find-biggest-threat
        (logical
                (move-troops)
                (potential-threat ?from-country ?enemy-country ?ratio ?troops-to-move)
                (not (potential-threat ?from-country ?other-enemy-country&~?enemy-country ?otherRatio&:(< ?otherRatio ?ratio))) ) 
        =>
        (assert (move-troop-amount (?troops-to-move))) )

