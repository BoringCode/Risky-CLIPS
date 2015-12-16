# Bradley Rosenfeld, Austin Munn, Matt Hall, and Noah Drabinsky

from riskStructs import *
import random
from lib.ClipsWrapper import *

clp = CLIPS()
clp.load("logic/RiskConstructs.clp")
clp.load("logic/BookSelection.clp")
clp.load("logic/ArmyPlacement.clp")
clp.load("logic/Attack.clp")
clp.load("logic/MoveTroops.clp")
clp.load("logic/Reinforce.clp")

lastAttack = [False, False]

def getPlayerCountryList(player,countryD):
    countryList=[]
    for countryKey in countryD:
        if countryD[countryKey]["owner"]==player:
            countryList.append(countryKey)
    return countryList

def atLeastOneAdjacentEnemy(countryKey,player,countryD):
    enemies = []
    for country in adjacentCountriesD[countryKey]:
        if countryD[country]["owner"]!=player:
            cdict = {"country": [
                {"country-name": country},
                {"owner": countryD[country]["owner"]},
                {"troops": countryD[country]["armies"]}
            ]}
            enemies.append(cdict)
    return enemies

def hasPickedABook(playerD,player,indexList):
    artCount=0
    infCount=0
    cavCount=0
    wildCount=0
    if len(indexList)< 3:
        return False
    cards=[]
    for idx in indexList:
        cards.append(playerD[player]["cards"][idx])
    for card in cards:
        if card[1]=="artillery":
            artCount+=1
        elif card[1]=="infantry":
            infCount+=1
        elif card[1]=="cavalry":
            cavCount+=1
        else:
            wildCount+=1
    #Check for three of a kind
    if artCount>=3 or infCount>=3 or cavCount>=3:
        return True
    if artCount>=1 and infCount>=1 and cavCount>=1:
        return True
    if wildCount>=1:
        return True
    return False

def attackFromCountry(player,countryD,bookArmiesBonusList,playerDMe,manual=False):
    countryList=[]
    for countryKey in countryD:
        if countryD[countryKey]["owner"]==player and countryD[countryKey]["armies"]>=2:
            enemies = atLeastOneAdjacentEnemy(countryKey,player,countryD)
            if len(enemies) > 0:
                cdict = {"country": [
                    {"country-name": countryKey},
                    {"owner": countryD[countryKey]["owner"]},
                    {"troops": countryD[countryKey]["armies"]}
                ]}
                countryList.append(cdict)
                countryList = countryList + enemies
    if not manual: #AUTO
        facts = countryList
        facts.append("attack")
        gamePhase = {"game-phase":[{"player": player}, {"turn-num": 1}, {"book-reward": bookArmiesBonusList[0]}]}
        facts.append(gamePhase)
        clp.reset()
        clp.assertFacts(facts)
        clp.run()
        facts = clp.facts()
        attackCountry = False
        for factID in facts:
            if "attack-from-country" in facts[factID]:
                attackCountry = facts[factID]["attack-from-country"][0].replace("-", " ")
                break
        if not attackCountry:
            return "NO ATTACK"
        else:
            attackFrom = attackCountry
            lastAttack[0] = attackFrom
            return attackCountry

def attackToCountry(player,countryD,bookArmiesBonusList,playerDMe,attackFromCountry,manual=False):
    #given the country attacking from
    #get the list of attached countries
    facts=[]
    facts.append({
        "country": {
            "country-name": attackFromCountry,
            "owner": player,
            "troops": countryD[attackFromCountry]["armies"]
        }
    })
    for eachCountry in adjacentCountriesD[attackFromCountry]:
        if countryD[eachCountry]["owner"]!=player:
            cdict = {"country": [
                {"country-name": eachCountry},
                {"owner": countryD[eachCountry]["owner"]},
                {"troops": countryD[eachCountry]["armies"]}
            ]}
            facts.append(cdict)
    if not manual: #AUTOMATIC
        facts = clp.facts()
        attackCountry = False
        for factID in facts:
            if "attack-to-country" in facts[factID]:
                attackCountry = facts[factID]["attack-to-country"][0].replace("-", " ")
                break
        attackTo = attackCountry
        lastAttack[1] = attackTo
        return attackCountry,countryD[attackCountry]["owner"]

def continueAttack(player,countryD,bookArmiesBonusList,playerDMe,manual=False):
    facts = clp.facts()
    attackFromCountry = False
    attackToCountry = False
    #Find the country we are attacking, we have to do this because Dr. White isn't sending us this data already
    for factID in facts:
        if "attack-from-country" in facts[factID]:
            attackFromCountry = facts[factID]["attack-from-country"][0].replace("-", " ")
        if "attack-to-country" in facts[factID]:
            attackToCountry = facts[factID]["attack-to-country"][0].replace("-", " ")
        if attackFromCountry and attackToCountry: break
    facts = []
    facts.append({
        "country": {
            "country-name": attackFromCountry,
            "owner": countryD[attackFromCountry]["owner"],
            "troops": countryD[attackFromCountry]["armies"]
        }
    })
    facts.append({
        "country": {
            "country-name": attackToCountry,
            "owner": countryD[attackToCountry]["owner"],
            "troops": countryD[attackToCountry]["armies"]
        }
    })
    facts.append("attack")
    gamePhase = {"game-phase":[{"player": player}, {"turn-num": 1}, {"book-reward": bookArmiesBonusList[0]}]}
    facts.append(gamePhase)
    clp.reset()
    clp.assertFacts(facts)
    clp.run()
    facts = clp.facts()
    continueAttacking = False
    for factID in facts:
        if "attack-from-country" in facts[factID]:
            continueAttacking = True
            break
    if continueAttacking:
        return ""
    else:
        return "RETREAT"
        
def getBookCardIndices(player,countryD,bookArmiesBonusList,playerDMe,manual=False):
    print("IN PLAYER",player)
    listOfCardIndicesToPlay=[]
    if manual: #MANUAL
        while not hasPickedABook(playerDMe,player,listOfCardIndicesToPlay):
            idx=0
            for card in playerDMe[player]["cards"]:
                print(str(idx)+".",card)
                idx+=1
            print(str(idx)+".","DO NOT play a book")
            for i in range(3):
                answer="-1"
                while int(answer)<0 or int(answer)>idx or int(answer) in listOfCardIndicesToPlay:
                    answer=input("Play card => ")
                if int(answer)==idx:
                    return []
                else:
                    listOfCardIndicesToPlay.append(int(answer))
            if not hasPickedABook(playerDMe,player,listOfCardIndicesToPlay):
                listOfCardIndicesToPlay=[]
    else: #AUTOMATIC
        cards = playerDMe[player]["cards"]
        facts = ["search-books"]
        gamePhase = {"game-phase":[{"player": player}, {"turn-num": 1}, {"book-reward": bookArmiesBonusList[0]}]}
        facts.append(gamePhase)
        for country in countryD:
            # continent curently not necessary in logic
            countryFact = {"country":[{"country-name": country}, {"continent": "null"}, {"owner": countryD[country]["owner"]}, {"troops": countryD[country]["armies"]}]}
            facts.append(countryFact)
        for i in range(len(cards)):
            card = {"victory-card": [{"country": cards[i][0]}, {"type": cards[i][1]}, {"idx": i}]}
            facts.append(card)
        clp.reset()
        clp.assertFacts(facts)
        clp.run()
        facts = clp.facts()
        indexStringList = []
        # Get last fact (facts[list(facts.keys())] and indexes of book from choice {'book-choice': ['15.0', '4', '1', '0']}
        for factID in facts:
            if "book-choice" in facts[factID]:
                indexStringList = facts[factID]["book-choice"][1:]
                break
        #indexStringList = facts[list(facts.keys())[-1]]['book-choice'][1:]
        if indexStringList:
            for idx in indexStringList:
                listOfCardIndicesToPlay.append(int(idx))
    return listOfCardIndicesToPlay

def tookCountryMoveArmiesHowMany(player,countryD,bookArmiesBonusList,playerDMe,attackFrom,manual=False):
    if manual: #MANUAL
        #clp.printFacts()
        howManyToMove = input("\nHow many of the " + str(countryD[attackFrom]["armies"]-1) + " armies would you like to move? => ")    
        if howManyToMove=="":
            howManyToMove=countryD[attackFrom]["armies"]-1
        else:
            howManyToMove=int(howManyToMove)                
        while howManyToMove<1 or howManyToMove>countryD[attackFrom]["armies"]-1:
            print("Invalid number of armies to move!!")
            howManyToMove=input("How many of the " + str(countryD[attackFrom]["armies"]-1) + " armies would you like to move? => ")
            if howManyToMove=="":
                howManyToMove=countryD[attackFrom]["armies"]-1
            else:
                howManyToMove=int(howManyToMove)
    else: #AUTOMATIC
        attackFact = {"last-attack":[{"from": lastAttack[0]}, {"to": lastAttack[1]}]}
        gamePhase = {"game-phase":[{"player": player}, {"turn-num": 1}, {"book-reward": bookArmiesBonusList[0]}]}
        facts = ["move-troops"]
        facts.append(attackFact)
        facts.append(gamePhase)
        for country in countryD:
            # continent curently not necessary in logic
            countryFact = {"country":[{"country-name": country}, {"continent": "null"}, {"owner": countryD[country]["owner"]}, {"troops": countryD[country]["armies"]}]}
            facts.append(countryFact)
        clp.reset()
        clp.assertFacts(facts)
        clp.run()
        facts = clp.facts()
        #clp.printFacts()
        moveAmount = "none"
        for factID in facts:
            if "move-troop-amount" in facts[factID]:
                moveAmount = int(float(facts[factID]["move-troop-amount"][0]))
                break
        # No move amount created because country is surrounded by friendlies
        if moveAmount == "none":
            moveAmount = countryD[attackFrom]["armies"]-1
        elif moveAmount < 1:
            moveAmount = 1
        howManyToMove = moveAmount
    return howManyToMove

def troopMove(player,countryD,bookArmiesBonusList,playerDMe,manual=False):
    fromCountry=""
    toCountry=""
    howManyToMove=0
    if manual: #MANUAL
        troopMovementCandidateFromList=[]
        for countryKey in countryD:
            if countryD[countryKey]["owner"]==player and countryD[countryKey]["armies"]>1:
                for eachCountry in adjacentCountriesD[countryKey]:
                    if countryD[eachCountry]["owner"]==player:
                        if countryKey not in troopMovementCandidateFromList:
                            troopMovementCandidateFromList.append(countryKey)
        print("0. NO TROOP MOVEMENT")
        for idx in range(0,len(troopMovementCandidateFromList)):
            print(str(idx+1)+". "+ troopMovementCandidateFromList[idx])
        fromChoice = -1
        while fromChoice<0 or fromChoice>len(troopMovementCandidateFromList):
            fromChoice=input("Troop Movement From? ")
            if fromChoice.isnumeric() and fromChoice !="0":
                fromChoice=int(fromChoice)-1
            elif fromChoice=="":
                return "","",0
            else:
                return "","",0
        fromCountry=troopMovementCandidateFromList[fromChoice]
        troopMovementCandidateToList=[]
        for each in adjacentCountriesD[troopMovementCandidateFromList[fromChoice]]:
            if countryD[each]["owner"] == player:
                troopMovementCandidateToList.append(each)
        for idx in range(0,len(troopMovementCandidateToList)):
            print(str(idx)+". "+ troopMovementCandidateToList[idx])
        toChoice=-1
        while toChoice<0 or toChoice>len(troopMovementCandidateToList):
            toChoice=input("Troop Movement TO? ")
            if toChoice.isnumeric():
                toChoice=int(toChoice)-1
            elif toChoice=="":
                toChoice=0
            else:
                return "","",0
        toCountry=troopMovementCandidateToList[toChoice]
        howManyToMove=-1
        while howManyToMove<0 or howManyToMove>countryD[troopMovementCandidateFromList[fromChoice]]["armies"]-1:
            howManyToMove=input("\nHow many of the " + str(countryD[fromCountry]["armies"]-1) + " armies would you like to move? => ")
            if howManyToMove.isnumeric():
                howManyToMove=int(howManyToMove)
            else:
                howManyToMove=countryD[troopMovementCandidateFromList[fromChoice]]["armies"]-1
    else: #AUTOMATIC
        gamePhase = {"game-phase":[{"player": player}, {"turn-num": 1}, {"book-reward": bookArmiesBonusList[0]}]}
        facts = ["reinforce-troops"]
        facts.append(gamePhase)
        for country in countryD:
            countryFact = {"country":[{"country-name": country}, {"continent": "null"}, {"owner": countryD[country]["owner"]}, {"troops": countryD[country]["armies"]}]}
            facts.append(countryFact)
        clp.reset()
        clp.assertFacts(facts)
        clp.run()
        facts = clp.facts()
        clp.printFacts()
        for factID in facts:
            if "reinforce-move" in facts[factID]:
                reinforce = facts[factID]["reinforce-move"]
                fromCountry = reinforce[0].replace("-", " ")
                toCountry = reinforce[1].replace("-", " ")
                howManyToMove = int(reinforce[2])
                break
        #print("********",fromCountry,toCountry,howManyToMove)
        #input("You should be reinforcing.")
        pass
    return fromCountry,toCountry,howManyToMove

def placeArmies(player,countryD,bookArmiesBonusList,playerDMe,manual=False):
    print("PLAYER:",player)
    countryList=getPlayerCountryList(player,countryD)
    if manual: #MANUAL
        for index in range(len(countryList)):
            print(index,countryList[index])
        countryIndex=-1
        while countryIndex<0 or countryIndex>=len(countryList):
            valIn=input("Player "+str(player)+", WHERE do you wish to place armies? => ")
            if valIn=="":
                countryIndex=0
            elif valIn.isnumeric():
                countryIndex=int(valIn)
            else:
                countryIndex=0
        numberOfArmiesToPlace=-1
        while numberOfArmiesToPlace<1 or numberOfArmiesToPlace>playerDMe[player]["armies"]:
            valIn=input("HOW MANY of the " + str(playerDMe[player]["armies"]) + " armies do you wish to place in "+countryList[countryIndex]+" => ")
            if valIn=="":
                numberOfArmiesToPlace=playerDMe[player]["armies"]
            elif valIn.isnumeric():
                numberOfArmiesToPlace=int(valIn)
            else:
                numberOfArmiesToPlace=0
    else: #AUTOMATIC
        facts = []
        facts.append("place-army")
        gamePhase = {"game-phase":[{"player": player}, {"turn-num": 1}, {"book-reward": bookArmiesBonusList[0]}]}
        facts.append(gamePhase)
        for country in countryD:
            for continent in continentD:
                if country in continentD[continent]:
                    countryFact = {"country":[{"country-name": country}, {"continent": continent}, {"owner": countryD[country]["owner"]}, {"troops": countryD[country]["armies"]}]}
                    facts.append(countryFact)
        clp.reset()
        clp.assertFacts(facts)
        clp.run()
        facts = clp.facts()
        # Get last fact (facts[list(facts.keys())] and indexes of book from choice {'book-choice': ['15.0', '4', '1', '0']}
        choice = facts[list(facts.keys())[-1]]['user-choice'][1]['country-name']
        choice = " ".join(choice.split("-"))
        countryIndex = countryList.index(choice)
        if playerDMe[player]["armies"] > 2:
            numberOfArmiesToPlace = 3
        else:
            numberOfArmiesToPlace = 1
    return countryList[countryIndex], numberOfArmiesToPlace
