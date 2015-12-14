# Bradley Rosenfeld, Austin Munn, Matt Hall, and Noah Drabinsky

from riskStructs import *
import random
from lib.ClipsWrapper import *

clp = CLIPS()
clp.load("logic/RiskConstructs.clp")
clp.load("logic/BookSelection.clp")
clp.load("logic/ArmyPlacement.clp")
clp.load("logic/Attack.clp")

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
        facts.append("attack-from")
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
        print(attackCountry)
        input()
        if not attackCountry:
            return "NO ATTACK"
        else:
            return attackCountry

def attackToCountry(player,countryD,bookArmiesBonusList,playerDMe,attackFromCountry,manual=False):
    #given the country attacking from
    #get the list of attached countries
    possiblesList=[]
    for eachCountry in adjacentCountriesD[attackFromCountry]:
        if countryD[eachCountry]["owner"]!=player:
            possiblesList.append(eachCountry)
    if manual: #MANUAL
        for index in range(len(possiblesList)):
            print(str(index)+".",possiblesList[index])
        choice=-1
        while choice<0 or choice>=len(possiblesList):
            choice = input("Which country would you like to attack? => ")
            if choice.isnumeric():
                choice=int(choice)
            else:
                choice=0
        return possiblesList[choice],countryD[possiblesList[choice]]["owner"]
    else: #AUTOMATIC
        return possiblesList[0],countryD[possiblesList[0]]["owner"]

def continueAttack(player,countryD,bookArmiesBonusList,playerDMe,manual=False):
    if manual: #MANUAL
        return(input("Attack again? (Enter to attack, RETREAT and enter to end attack) => "))
    else: #AUTOMATIC
        return ""
        
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
        print("I'm trying to take a book")
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
        # Get last fact (facts[list(facts.keys())] and indexes of book from choice {'book-choice': ['15.0', '4', '1', '0']}
        indexStringList = facts[list(facts.keys())[-1]]['book-choice'][1:]
        for idx in indexStringList:
            listOfCardIndicesToPlay.append(int(idx))
    return listOfCardIndicesToPlay

def tookCountryMoveArmiesHowMany(player,countryD,bookArmiesBonusList,playerDMe,attackFrom,manual=False):
    if manual: #MANUAL
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
        howManyToMove=countryD[attackFrom]["armies"]-1
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
