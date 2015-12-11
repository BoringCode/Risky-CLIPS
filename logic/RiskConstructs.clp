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
	;(game-phase (player 1) (turn-num 20) (book-reward 8))

	(user-choice (score -15) (country-name nil))	)