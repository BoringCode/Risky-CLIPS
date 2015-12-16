(defrule find-friendly-surrounded-countries
        (reinforce-troops)
        (game-phase (player ?pname))
        (country (country-name ?my-country) (owner ?pname) (troops ?my-troops))
        (not (and
                (country (country-name ?enemy-country) (owner ?enemy&~?pname))
                (border (country-a ?my-country) (country-b ?enemy-country)))
        )
        =>
        (assert (friendly-surrounded-country ?my-country ?my-troops)) )

(defrule find-biggest-stronghold
        (logical
                (reinforce-troops)
                (friendly-surrounded-country ?biggest-country ?biggest-troops)
                (not (friendly-surrounded-country ?other-country&~?biggest-country ?other-troops&:(> ?other-troops ?biggest-troops)))
        )
        =>
        (assert (biggest-stronghold ?biggest-country ?biggest-troops)) )

(defrule create-stronghold-path (declare (salience -1))
        (reinforce-troops)
        (game-phase (player ?pname))
        (biggest-stronghold ?stronghold ?stronghold-troops)
        (country (country-name ?stronghold-border))
        (border (country-a ?stronghold) (country-b ?stronghold-border))
        (not (path-to-border (path ?stronghold-border $?others)))
        =>
        (assert (path-to-border (path ?stronghold-border))) )

(defrule find-border
        (game-phase (player ?pname))
        (path-to-border (path $?beginning ?last))
        (country (country-name ?enemy-country) (owner ?enemy&~?pname))
        (border (country-a ?last) (country-b ?enemy-country))
        =>
        (assert (found-path $?beginning ?last)) )

(defrule search-for-border
        (game-phase (player ?pname))
        ?path <- (path-to-border (path $?beginning ?last))
        (country (country-name ?owned-country) (owner ?pname))
        (border (country-a ?last) (country-b ?owned-country))
        =>
        (if (not (member$ ?owned-country (create$ ?beginning ?last)))
                then
                        (assert (path-to-border (path $?beginning ?last ?owned-country)))) )

(defrule fastest-path
        (logical
                (path-to-border (path ?first $?fast-path))
                (biggest-stronghold ?stronghold ?stronghold-troops)
                (not (path-to-border (path $?other-path&:(< (length$ ?other-path) (length$ (create$ ?first $?fast-path))))))
        )
        =>
        (assert (fastest-path $?fast-path) (reinforce-move ?stronghold ?first (- ?stronghold-troops 1))) )