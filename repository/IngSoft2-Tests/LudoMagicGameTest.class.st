Class {
	#name : #LudoMagicGameTest,
	#superclass : #TestCase,
	#instVars : [
		'jorge',
		'julian',
		'players',
		'dices',
		'anOneLapGame',
		'aThreeLapGame',
		'twentySquares',
		'sixSquares',
		'aDeck'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #running }
LudoMagicGameTest >> setUp [
	| kindsOfCards |
	super setUp.
	jorge := 'jorge'.
	julian := 'julian'.
	
	players := OrderedCollection with: jorge with: julian.
	
	dices:= OrderedCollection with: (LoadedDice withValues: #(1 2 3 4 5)) with: (LoadedDice withValues: #(4 5 6 7)).
	
	kindsOfCards := (Card subclasses collect: [:kindOfCard | kindOfCard new ]).
	aDeck := Deck with: ((ProbabilisticDistributor withEqualProbability: kindsOfCards) generate: 50).
	
	sixSquares :=  (ProbabilisticDistributor with: { ProbabilisticEvent with: 1 for: EffectlessSquare new }) generate: 6.
	twentySquares := (ProbabilisticDistributor with: { ProbabilisticEvent with: 1 for: EffectlessSquare new }) generate: 20. 
	anOneLapGame := LudoMagicGame playedBy: players withNumberOfLaps: 1 throwing:dices andWithBoardOf:twentySquares and: aDeck copy.
	aThreeLapGame:= LudoMagicGame  playedBy: players withNumberOfLaps: 3 throwing:dices andWithBoardOf:sixSquares and: aDeck copy.

]

{ #category : #'exception tests' }
LudoMagicGameTest >> testAGameCannotHaveAWinnerIfItIsNotFinished [
	self do: 2 theGame: anOneLapGame.
	self
		assert: [ anOneLapGame winner ]
		throws: LudoMagicGame noWinnerErrorMessage
]

{ #category : #'exception tests' }
LudoMagicGameTest >> testAGameCannotHaveAWinnerWhenItIsNew [
	self assert: [anOneLapGame winner] throws: LudoMagicGame noWinnerErrorMessage
			
		
]

{ #category : #'exception tests' }
LudoMagicGameTest >> testAGameCannotHaveNoDices [
	self assert: [ LudoMagicGame playedBy: players withNumberOfLaps:3  throwing: {}  withBoardOf: 6 and: aDeck ] throws: LudoMagicGame noDicesErrorMessage
]

{ #category : #'exception tests' }
LudoMagicGameTest >> testAGameCannotMakeARoundWhenItIsFinished [
	self do: 5 theGame: anOneLapGame .
	self assert: [ anOneLapGame turn ] throws: LudoMagicGame noMoreRollsAllowedErrorMessage
]

{ #category : #'main tests' }
LudoMagicGameTest >> testAGameHasAWinner [
	self do: 5 theGame: anOneLapGame .
	
	self assert: anOneLapGame winner equals: jorge.
]

{ #category : #'main tests' }
LudoMagicGameTest >> testAGameHasTheRightSize [
	| aGame |
	aGame := LudoMagicGame playedBy: players withNumberOfLaps: 3 throwing: dices withBoardOf: 100 and: aDeck.
	self assert: aGame size equals: 100.
]

{ #category : #'main tests' }
LudoMagicGameTest >> testAGameRollsTheDiceForThePlayers [
	self do: 2 theGame: anOneLapGame .
	
	self assert: (anOneLapGame numberOfSquareOf:jorge) equals: 6.
	self assert: (anOneLapGame numberOfSquareOf:julian) equals: 8.
]

{ #category : #'main tests' }
LudoMagicGameTest >> testAGameRollsTheDiceForThePlayersTwiceAndIsFinishedWithEnoughPoints [
	
	| someDices |
	
	someDices := OrderedCollection
		with: (LoadedDice withValues: #(1 2 4 1 5))
		with: (LoadedDice withValues: #(4 5 1 1)).
	

	anOneLapGame := LudoMagicGame playedBy:players  withNumberOfLaps:1  throwing:someDices   andWithBoardOf:(OrderedCollection new:10 withAll: EffectlessSquare new) and: aDeck. 
	
	self do: 3 theGame: anOneLapGame .
	

	self assert: anOneLapGame finished
]

{ #category : #'main tests' }
LudoMagicGameTest >> testAGameRollsTheDiceForThePlayersTwiceAndIsFinishedWithMoreThanEnoughPoints [
	self do: 5 theGame: anOneLapGame .
	
	self assert: anOneLapGame finished
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testAGameThatGiveToPlayersTwoCards [
	| aGame |
	aGame := LudoMagicGame playedBy: players withNumberOfLaps: 3 throwing: dices withBoardOf: 100 and: aDeck.
	self assert: (aGame quantityOfCardsInHandOf: julian) equals: 2.
	self assert: (aGame quantityOfCardsInHandOf: jorge) equals: 2.
]

{ #category : #'main tests' }
LudoMagicGameTest >> testANewGameIsNotFinished [
	self deny: anOneLapGame finished
]

{ #category : #'exception tests' }
LudoMagicGameTest >> testAThreeLapGameCannotMakeAnotherRoundWhenItIsFinished [
	self do: 4 theGame: aThreeLapGame .
	self assert: [aThreeLapGame turn] throws: LudoMagicGame noMoreRollsAllowedErrorMessage
]

{ #category : #'decks behavior' }
LudoMagicGameTest >> testAllCardsAreGivenAndDeckIsEmpty [
	| aGame squares anOverloadCard |
	anOverloadCard := OverloadCard new.
	squares := {EffectlessSquare new. EffectlessSquare new. EffectlessSquare new. DeliveryCardSquare new. DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 3
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard }).
		self assert: aGame mainDeckSize equals: 0
]

{ #category : #'decks behavior' }
LudoMagicGameTest >> testAllCardsAreGivenAndJorgePlaysACardAndDeckHasOneCard [
	| aGame squares anOverloadCard |
	anOverloadCard := OverloadCard new.
	squares := {EffectlessSquare new. EffectlessSquare new. EffectlessSquare new. DeliveryCardSquare new. DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 3
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard }).
		aGame affect: julian using: anOverloadCard by: jorge. 
		self assert: aGame mainDeckSize equals: 1
]

{ #category : #'decks behavior' }
LudoMagicGameTest >> testAllCardsWereGivenToEachPlayerAndDeckIsOne [
	| aGame squares anOverloadCard |
	anOverloadCard := OverloadCard new.
	squares := {
		DeliveryCardSquare new.
		DeliveryCardSquare new.
		DeliveryCardSquare new.
		DeliveryCardSquare new.
		DeliveryCardSquare new.
		}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 20
		throwing:
			{(LoadedDice withValues: #(1)).
			(LoadedDice withValues: #(1))}
		andWithBoardOf: squares
		and: (Deck with: {
			anOverloadCard.
			anOverloadCard.
			anOverloadCard.
			anOverloadCard.
			anOverloadCard.
			anOverloadCard.
			anOverloadCard.
			anOverloadCard.
		}).
	aGame affect: julian using: anOverloadCard by: jorge.
	self do: 20 theGame: aGame.
	self assert: (aGame mainDeckSize) equals: 1.
]

{ #category : #'decks behavior' }
LudoMagicGameTest >> testAllCardsWereGivenToEachPlayerAndNoMoreAreGivenUntilSomePlayerPlayAgainTheFirstCard [
	| aGame squares anOverloadCard |
	anOverloadCard := OverloadCard new.
	squares := {
		DeliveryCardSquare new.
		DeliveryCardSquare new.
		DeliveryCardSquare new.
		DeliveryCardSquare new.
		DeliveryCardSquare new.
		}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 20
		throwing:
			{(LoadedDice withValues: #(1)).
			(LoadedDice withValues: #(1))}
		andWithBoardOf: squares
		and: (Deck with: {
			anOverloadCard.
			anOverloadCard.
			anOverloadCard.
			anOverloadCard.
			anOverloadCard.
			anOverloadCard.
			anOverloadCard.
			anOverloadCard.
		}).
	aGame affect: julian using: anOverloadCard by: jorge.
	self do: 20 theGame: aGame.
	self assert: (aGame quantityOfCardsInHandOf: jorge) equals: 3.
	self assert: (aGame quantityOfCardsInHandOf: julian) equals: 4.
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJorgeAndJulianGotDifferentsCards [
	| aGame squares aCard anotherCard |
	
	aCard := Card new.
	anotherCard := Card new.
	
	squares:= { EffectlessSquare new. EffectlessSquare new. DeliveryCardSquare new. EffectlessSquare new. DeliveryCardSquare new. }.
		aGame:= LudoMagicGame playedBy: players withNumberOfLaps:2  throwing: {(LoadedDice withValues: #(1 2)). (LoadedDice withValues: #(1 2))} andWithBoardOf: squares and: (LoadedDeck with: { aCard . anotherCard . aCard . anotherCard . aCard . anotherCard }).
	
	self do: 2 theGame: aGame.
	
	self assert: (aGame has: jorge the: aCard).
	self assert: (aGame has: julian the: anotherCard)
]

{ #category : #'decks behavior' }
LudoMagicGameTest >> testJorgeArriveBAndCardDeliveryIsDoneOnceHePlayACard [
	| aGame squares anOverloadCard |
	anOverloadCard := OverloadCard new.
	squares := {EffectlessSquare new. EffectlessSquare new. EffectlessSquare new. DeliveryCardSquare new. DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 3
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard}).
	self do: 2 theGame: aGame.
	aGame affect: julian using: anOverloadCard by: jorge.
	self do: 1 theGame: aGame.
	self assert: (aGame quantityOfCardsInHandOf: jorge) equals: 2.
	self assert: (aGame quantityOfCardsInHandOf: julian) equals: 2.
]

{ #category : #'exception tests' }
LudoMagicGameTest >> testJorgeCannotThrowAnOverloadCardThatHeDoesNotHave [
	| aGame squares anOverloadCard |
	anOverloadCard := OverloadCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	EffectlessSquare new.
	EffectlessSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard}).
	self do: 2 theGame: aGame.
	self assert: [ aGame affect: julian using: SpeedCard new by: jorge ] throws: LudoMagicGame cardNotInHandErrorMessage
]

{ #category : #'exception tests' }
LudoMagicGameTest >> testJorgeCannotThrowAnOverloadCardWhenItIsNotHisTurn [
	| aGame squares anOverloadCard |
	anOverloadCard := OverloadCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	EffectlessSquare new.
	EffectlessSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard}).
	aGame turn.
	self assert: [ aGame affect: julian using: anOverloadCard by: jorge ] throws: LudoMagicGame notCurrentTurnErrorMessage
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJorgeGetsARepeatCardAndPlaysItWithAtomicBombSquare [
	| aGame squares aRepeatCard |
	aRepeatCard := RepeatCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	EffectlessSquare new.
	AtomicBombSquare new.
	EffectlessSquare new.
	EffectlessSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {aRepeatCard . aRepeatCard . aRepeatCard . aRepeatCard . aRepeatCard . aRepeatCard}).
	self do: 2 theGame: aGame.
	aGame affect: jorge using: aRepeatCard by: jorge.
	self assert: (aGame numberOfSquareOf: julian) equals: 1.
	self assert: (aGame numberOfSquareOf: jorge) equals: 1
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJorgeGetsARepeatCardAndPlaysItWithDeliveryCardSquare [
	| aGame squares aRepeatCard |
	aRepeatCard := RepeatCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	EffectlessSquare new.
	EffectlessSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {aRepeatCard . aRepeatCard . aRepeatCard . aRepeatCard . aRepeatCard}).
	self do: 2 theGame: aGame.
	aGame affect: jorge using: aRepeatCard by: jorge.
	self assert: (aGame has: jorge the: aRepeatCard )
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJorgeGetsARepeatCardAndPlaysItWithMoonWalkSquare [
	| aGame squares aRepeatCard |
	aRepeatCard := RepeatCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	EffectlessSquare new.
	MoonWalkSquare with: 1.
	EffectlessSquare new.
	EffectlessSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {aRepeatCard . aRepeatCard . aRepeatCard . aRepeatCard . aRepeatCard . aRepeatCard}).
	self do: 2 theGame: aGame.
	aGame affect: jorge using: aRepeatCard by: jorge.
	self assert: (aGame numberOfSquareOf: julian) equals: 4.
	self assert: (aGame numberOfSquareOf: jorge) equals: 2
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJorgeGetsARepeatCardAndPlaysItWithSpeedUpSquare [
	| aGame squares aRepeatCard |
	aRepeatCard := RepeatCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	EffectlessSquare new.
	SpeedUpSquare new.
	EffectlessSquare new.
	EffectlessSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {aRepeatCard.aRepeatCard.aRepeatCard.aRepeatCard.aRepeatCard}).
	self do: 2 theGame: aGame.
	aGame affect: jorge using: aRepeatCard by: jorge.
	self assert: (aGame numberOfSquareOf: jorge) equals: 7
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJorgeGetsARepeatCardAndPlaysItWithWormHoleSquare [
	| aGame squares aRepeatCard |
	aRepeatCard := RepeatCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	EffectlessSquare new.
	WormHoleSquare new.
	EffectlessSquare new.
	EffectlessSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {aRepeatCard . aRepeatCard . aRepeatCard . aRepeatCard . aRepeatCard . aRepeatCard}).
	self do: 2 theGame: aGame.
	aGame affect: jorge using: aRepeatCard by: jorge.
	self assert: (aGame numberOfSquareOf: jorge) equals: 1
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJorgeGetsASpeedCardAndThrowItToJulian [
	| aGame squares aSpeedCard |
	aSpeedCard := SpeedCard new.
	squares := {EffectlessSquare new. EffectlessSquare new. DeliveryCardSquare new. EffectlessSquare new. EffectlessSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {aSpeedCard . aSpeedCard . aSpeedCard . aSpeedCard . aSpeedCard . aSpeedCard}).
	self do: 2 theGame: aGame.
	aGame affect: julian using: aSpeedCard by: jorge.
	self do: 2 theGame: aGame.
	self assert: (aGame numberOfSquareOf: julian) equals: 5
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJorgeGetsAnAccelerationAndAffectsAllPlayers [
	| aGame squares anAccelerationCard |
	anAccelerationCard := AccelerationCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	EffectlessSquare new.
	EffectlessSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {anAccelerationCard . anAccelerationCard . anAccelerationCard . anAccelerationCard . anAccelerationCard}).
	self do: 2 theGame: aGame.
	aGame affect: players using: anAccelerationCard by: jorge.
	self do: 2 theGame: aGame.
	self assert: (aGame numberOfSquareOf: julian) equals: 5.
	self assert: (aGame numberOfSquareOf: jorge) equals: 1
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJorgeGetsAnOverloadCardAndThrowItToJulian [
	| aGame squares anOverloadCard |
	anOverloadCard := OverloadCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	EffectlessSquare new.
	EffectlessSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard}).
	self do: 2 theGame: aGame.
	aGame affect: julian using: anOverloadCard by: jorge.
	self do: 2 theGame: aGame.
	self assert: (aGame numberOfSquareOf: julian) equals: 2
]

{ #category : #'squares usage tests' }
LudoMagicGameTest >> testJorgeGetsToAMoonWalkAndGoesToTheFirstSquare [

	| squares  aGame |
	squares:= { EffectlessSquare new. EffectlessSquare new. MoonWalkSquare with: 5. EffectlessSquare new. EffectlessSquare new.}.
	
	aGame:= LudoMagicGame playedBy: players withNumberOfLaps:2  throwing: {(LoadedDice withValues: #(9 2 4 5))}  andWithBoardOf: squares and: aDeck. 
	
	aGame turn.
	aGame turn.
	self assert: (aGame lapOf:jorge) equals: 0.
	self assert: (aGame numberOfSquareOf: jorge) equals: 5.
]

{ #category : #'squares usage tests' }
LudoMagicGameTest >> testJorgeGetsToAtomicBombSquare [

	| squares  aGame |
	squares:= { EffectlessSquare new. EffectlessSquare new. WormHoleSquare new. SpeedUpSquare new. AtomicBombSquare new. AtomicBombSquare new. EffectlessSquare new. WormHoleSquare new. SpeedUpSquare new. MoonWalkSquare with: 5. EffectlessSquare new. AtomicBombSquare new. MoonWalkSquare with:3.}.
	dices:= OrderedCollection with: (LoadedDice withValues: #(1 2 3 4 5)) with: (LoadedDice withValues: #(4 5 6 7)).
	
	aGame:= LudoMagicGame playedBy: players withNumberOfLaps:2  throwing:dices  andWithBoardOf: squares and: aDeck.
	
	aGame turn.
	
	self assert: (aGame numberOfSquareOf:jorge) equals: 1.
	
	
	
]

{ #category : #'squares usage tests' }
LudoMagicGameTest >> testJorgeGetsToLoadedSquareAndGetACard [
	| aGame squares aCard |
	
	aCard := Card new.
	
	squares:= { EffectlessSquare new. EffectlessSquare new. DeliveryCardSquare new. EffectlessSquare new. EffectlessSquare new.}.
		aGame:= LudoMagicGame playedBy: players withNumberOfLaps:2  throwing: {(LoadedDice withValues: #(1 2)). (LoadedDice withValues: #(1 2))} andWithBoardOf: squares and: (LoadedDeck with: {aCard . aCard . aCard . aCard . aCard}).
	
	self do: 2 theGame: aGame .
	
	self assert: (aGame has: jorge the: aCard).
]

{ #category : #'squares usage tests' }
LudoMagicGameTest >> testJorgeGetsToMoonWalkSquare [

	| squares  aGame |
	squares := { EffectlessSquare new. EffectlessSquare new. WormHoleSquare new. SpeedUpSquare new. AtomicBombSquare new. AtomicBombSquare new. EffectlessSquare new. WormHoleSquare new. AtomicBombSquare new. MoonWalkSquare with: 5. EffectlessSquare new. SpeedUpSquare new. MoonWalkSquare with:3. }.
	
	aGame:= LudoMagicGame playedBy: players withNumberOfLaps:2  throwing:dices andWithBoardOf:squares and: aDeck.
	
	self do: 3 theGame: aGame .
		
	self assert: (aGame numberOfSquareOf:jorge) equals: 10.

	
	
	
]

{ #category : #'main tests' }
LudoMagicGameTest >> testJorgeIsAtTheLapOneAndJulianIsAtTheLapZero [

	self do: 2 theGame: aThreeLapGame  .

	self assert: (aThreeLapGame lapOf: jorge) equals: 0.
	self assert: (aThreeLapGame lapOf: julian) equals: 1.
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJorgeThrowsAnOverloadCardAndDoesntHaveItAnymore [
	| aGame squares anOverloadCard |
	anOverloadCard := OverloadCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	EffectlessSquare new.
	EffectlessSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard}).
	self do: 2 theGame: aGame.
	aGame affect: julian using: anOverloadCard by: jorge.
	self assert: (aGame quantityOfCardsInHandOf: jorge) equals: 1
]

{ #category : #'main tests' }
LudoMagicGameTest >> testJorgeWinsAThreeLapGame [

	self do: 4 theGame: aThreeLapGame .
	self assert: aThreeLapGame winner equals: julian.
	self assert: (aThreeLapGame lapOf: julian) equals: 3.
]

{ #category : #'decks behavior' }
LudoMagicGameTest >> testJulianArriveToDeliverySquareButNotGetCardWithoutCardsPlayed [
	| aGame squares anOverloadCard |
	anOverloadCard := OverloadCard new.
	squares := {EffectlessSquare new. EffectlessSquare new. EffectlessSquare new. DeliveryCardSquare new. DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 3
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard}).
	self do: 2 theGame: aGame.
	self assert: (aGame quantityOfCardsInHandOf: jorge) equals: 2.
	self assert: (aGame quantityOfCardsInHandOf: julian) equals: 2.
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJulianCancelsAnOverloadCardWhenIsNotHisTurn [
	| aGame squares aCancellationCard anOverloadCard |
	aCancellationCard := CancellationCard new.
	anOverloadCard := OverloadCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and:
			(LoadedDeck
				with:
					{anOverloadCard.
					aCancellationCard.anOverloadCard.
					aCancellationCard.anOverloadCard.
					aCancellationCard.anOverloadCard.
					aCancellationCard}).
	self do: 2 theGame: aGame.
	aGame affect: julian using: anOverloadCard by: jorge.
	aGame affect: anOverloadCard using: aCancellationCard by: julian.
	self do: 2 theGame: aGame.
	self assert: (aGame numberOfSquareOf: julian) equals: 4
]

{ #category : #'exception tests' }
LudoMagicGameTest >> testJulianCannotCancelACardThatIsNotInTheGame [
	| aGame squares aCancellationCard anOverloadCard |
	aCancellationCard := CancellationCard new.
	anOverloadCard := OverloadCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {aCancellationCard . aCancellationCard . aCancellationCard . aCancellationCard . aCancellationCard}).
	self do: 3 theGame: aGame.
	self assert: [ aGame affect: anOverloadCard using: aCancellationCard by: julian ] throws: CardHandler noCardMatchErrorMessage
]

{ #category : #'exception tests' }
LudoMagicGameTest >> testJulianCannotThrowAReDoCardBecauseThereWasNoCardPlayedBefore [
	| aGame squares aReDoCard |
	aReDoCard := ReDoCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	SpeedUpSquare new.
	DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 4
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {aReDoCard . aReDoCard . aReDoCard . aReDoCard}).
	self assert: [ aGame affect: jorge using: aReDoCard by: jorge ] throws: Board noActiveCardsErrorMessage
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJulianGetsACancellationCardAndGetsRidOfAccelerationCard [
	| aGame squares aCancellationCard anAccelerationCard |
	aCancellationCard := CancellationCard new.
	anAccelerationCard := AccelerationCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and:
			(LoadedDeck
				with:
					{anAccelerationCard.
					aCancellationCard . anAccelerationCard.
					aCancellationCard . anAccelerationCard.
					aCancellationCard . anAccelerationCard.
					aCancellationCard . anAccelerationCard.
					aCancellationCard}).
	self do: 2 theGame: aGame.
	aGame affect: julian using: anAccelerationCard by: jorge.
	aGame turn.
	aGame affect: anAccelerationCard using: aCancellationCard by: julian.
	aGame turn.
	self assert: (aGame numberOfSquareOf: jorge) equals: 1.
	self assert: (aGame numberOfSquareOf: julian) equals: 4
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJulianGetsACancellationCardAndGetsRidOfOverloadCard [
	| aGame squares aCancellationCard anOverloadCard |
	aCancellationCard := CancellationCard new.
	anOverloadCard := OverloadCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and:
			(LoadedDeck
				with:
					{anOverloadCard.
					aCancellationCard . anOverloadCard.
					aCancellationCard . anOverloadCard.
					aCancellationCard}).
	self do: 2 theGame: aGame.
	aGame affect: julian using: anOverloadCard by: jorge.
	aGame turn.
	aGame affect: anOverloadCard using: aCancellationCard by: julian.
	aGame turn.
	self assert: (aGame numberOfSquareOf: julian) equals: 4
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJulianGetsACancellationCardAndGetsRidOfSpeedCard [
	| aGame squares aCancellationCard aSpeedCard |
	aCancellationCard := CancellationCard new.
	aSpeedCard := SpeedCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and:
			(LoadedDeck
				with:
					{aSpeedCard.
					aCancellationCard . aSpeedCard.
					aCancellationCard . aSpeedCard.
					aCancellationCard}).
	self do: 2 theGame: aGame.
	aGame affect: julian using: aSpeedCard by: jorge.
	aGame turn.
	aGame affect: aSpeedCard using: aCancellationCard by: julian.
	aGame turn.
	self assert: (aGame numberOfSquareOf: julian) equals: 4.
	self assert: (aGame numberOfSquareOf: jorge) equals: 5
]

{ #category : #'decks behavior' }
LudoMagicGameTest >> testJulianGetsACancellationCardAndGetsRidOfSpeedCardAndDeckSizeIncrease [
	| aGame squares aCancellationCard aSpeedCard |
	aCancellationCard := CancellationCard new.
	aSpeedCard := SpeedCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	EffectlessSquare new.
	EffectlessSquare new.
	EffectlessSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and:
			(LoadedDeck
				with:
					{aSpeedCard.
					aCancellationCard . aSpeedCard.
					aCancellationCard . aSpeedCard.
					aCancellationCard}).
	self do: 2 theGame: aGame.
	aGame affect: julian using: aSpeedCard by: jorge.
	aGame turn.
	aGame affect: aSpeedCard using: aCancellationCard by: julian.
	self assert: aGame discardDeckSize equals: 2.
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJulianGetsAReDoCardAfterJorgeThrewAnAccelerationCardAndPlaysIt [
	| aGame squares aReDoCard anAccelerationCard |
	aReDoCard := ReDoCard new.
	anAccelerationCard := AccelerationCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	EffectlessSquare new.
	EffectlessSquare new.
	EffectlessSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 4
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and:
			(LoadedDeck
				with:
					{anAccelerationCard.
					aReDoCard . anAccelerationCard.
					aReDoCard . anAccelerationCard.
					aReDoCard}).
	aGame affect: jorge using: anAccelerationCard by: jorge.
	self do: 1 theGame: aGame.
	aGame affect: julian using: aReDoCard by: julian.
	self do: 1 theGame: aGame.

	self assert: (aGame numberOfSquareOf: julian) equals: 2.
	self assert: (aGame numberOfSquareOf: jorge) equals: 4
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJulianGetsAReDoCardAfterJorgeThrewAnCancellationCardAndPlaysIt [
	| aGame squares aReDoCard aCancellationCard anOverloadCard aSpeedCard |
	aReDoCard := ReDoCard new.
	aCancellationCard := CancellationCard new.
	anOverloadCard := OverloadCard new.
	aSpeedCard:= SpeedCard new.
	squares := {
		EffectlessSquare new.
		EffectlessSquare new.
		DeliveryCardSquare new.
		DeliveryCardSquare new.
		DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 4
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and:
			(LoadedDeck
				with:
					{anOverloadCard . aCancellationCard.
					aReDoCard. aSpeedCard . anOverloadCard . 
					aCancellationCard.
					aReDoCard. aSpeedCard}).
	aGame affect:julian  using:anOverloadCard   by:jorge.
	aGame turn.
	aGame affect:jorge  using:aSpeedCard  by:julian.
	aGame turn.
	aGame affect:aSpeedCard   using:aCancellationCard   by:jorge.
	aGame turn.
	aGame affect:anOverloadCard  using:aReDoCard  by: julian.  
	aGame turn. 
	 
	self assert: (aGame numberOfSquareOf: julian) equals: 2.
	self assert: (aGame numberOfSquareOf: jorge) equals: 5.
]

{ #category : #'decks behavior' }
LudoMagicGameTest >> testJulianGetsAReDoCardAfterJorgeThrewAnCancellationCardAndPlaysIt2 [
	| aGame squares aReDoCard aCancellationCard anOverloadCard aSpeedCard |
	aReDoCard := ReDoCard new.
	aCancellationCard := CancellationCard new.
	anOverloadCard := OverloadCard new.
	aSpeedCard:= SpeedCard new.
	squares := {
		DeliveryCardSquare new.
		DeliveryCardSquare new.
		DeliveryCardSquare new.
		DeliveryCardSquare new.
		DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 20
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and:
			(LoadedDeck
				with:
					{anOverloadCard . aCancellationCard.
					aReDoCard. aSpeedCard . anOverloadCard . aCancellationCard.
					aReDoCard. aSpeedCard}).
	aGame affect:julian  using:anOverloadCard   by:jorge.
	aGame turn.
	aGame affect:jorge  using:aSpeedCard  by:julian.
	aGame turn.
	aGame affect:aSpeedCard   using:aCancellationCard   by:jorge.
	aGame turn.
	aGame affect:anOverloadCard  using:aReDoCard  by: julian.  
	self do: 10 theGame: aGame.
	self assert: (aGame mainDeckSize) equals: 4.
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJulianGetsAReDoCardAfterJorgeThrewAnOverloadCardAndPlaysIt [
	| aGame squares aReDoCard anOverloadCard |
	aReDoCard := ReDoCard new.
	anOverloadCard := OverloadCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 4
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and:
			(LoadedDeck
				with:
					{anOverloadCard.
					aReDoCard . anOverloadCard.
					aReDoCard . anOverloadCard.
					aReDoCard}).
	self do: 2 theGame: aGame.
	aGame affect: julian using: anOverloadCard by: jorge.
	self do: 1 theGame: aGame.
	aGame affect: jorge using: aReDoCard by: julian.
	self do: 2 theGame: aGame.
	self assert: (aGame numberOfSquareOf: julian) equals: 2.
	self assert: (aGame numberOfSquareOf: jorge) equals: 5
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJulianGetsAReDoCardAfterJorgeThrewAnRepeatCardAndPlaysIt [
	| aGame squares aReDoCard aRepeatCard |
	aReDoCard := ReDoCard new.
	aRepeatCard := RepeatCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	DeliveryCardSquare new.
	SpeedUpSquare new.
	DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 4
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and:
			(LoadedDeck
				with:
					{aRepeatCard.
					aReDoCard . aRepeatCard.
					aReDoCard . aRepeatCard.
					aReDoCard . aRepeatCard.
					aReDoCard}).
	self do: 4 theGame: aGame.
	aGame affect: jorge using: aRepeatCard by: jorge.
	aGame affect: julian using: aReDoCard by: julian.
	self assert: (aGame numberOfSquareOf: julian) equals: 2
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJulianGetsAReDoCardAfterJorgeThrewAnSpeedCardAndPlaysIt [
	| aGame squares aReDoCard aSpeedCard |
	aReDoCard := ReDoCard new.
	aSpeedCard := SpeedCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	EffectlessSquare new.
	EffectlessSquare new.
	EffectlessSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 4
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and:
			(LoadedDeck
				with:
					{aSpeedCard.
					aReDoCard . aSpeedCard.
					aReDoCard . aSpeedCard.
					aReDoCard . aSpeedCard.
					aReDoCard }).
	aGame affect: jorge using: aSpeedCard by: jorge.
	self do: 1 theGame: aGame.
	aGame affect: julian using: aReDoCard by: julian.
	self do: 1 theGame: aGame.

	self assert: (aGame numberOfSquareOf: julian) equals: 1.
	self assert: (aGame numberOfSquareOf: jorge) equals: 4.
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJulianGetsAReDoCardAfterJorgeThrewAnotherReDoCardAndPlaysIt [
	| aGame squares aReDoCard anAccelerationCard |
	aReDoCard := ReDoCard new.
	anAccelerationCard := AccelerationCard new.
	squares := {
		EffectlessSquare new.
		EffectlessSquare new.
		EffectlessSquare new.
		EffectlessSquare new.
		EffectlessSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 4
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and:
			(LoadedDeck
				with:
					{anAccelerationCard.
					aReDoCard . anAccelerationCard.
					aReDoCard . anAccelerationCard.
					aReDoCard}).
	aGame affect: jorge using: anAccelerationCard by: jorge.
	self do: 1 theGame: aGame.
	aGame affect: julian using: aReDoCard by: julian.
	self do: 1 theGame: aGame.
	aGame affect: jorge using: aReDoCard by: jorge.
	self do: 1 theGame: aGame.

	self assert: (aGame numberOfSquareOf: julian) equals: 2.
	self assert: (aGame numberOfSquareOf: jorge) equals: 4
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJulianGetsAReDoCardAfterTheDeckIsShuffled [ 
	| aGame squares aReDoCard anOverloadCard aSpeedCard |
	aReDoCard := ReDoCard new.
	anOverloadCard := OverloadCard new.
	aSpeedCard:= SpeedCard new.
	squares := {
		DeliveryCardSquare new.
		DeliveryCardSquare new.
		DeliveryCardSquare new.
		DeliveryCardSquare new.
		DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 4
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and:
			(LoadedDeck
				with:
					{anOverloadCard . aSpeedCard.
					anOverloadCard . aReDoCard . 
					anOverloadCard}).
					
	aGame affect: jorge using: aSpeedCard by:jorge.
	self do: 5 theGame: aGame.
	aGame affect: julian using: aReDoCard by: julian. 
	aGame turn.
	
	self assert: (aGame numberOfSquareOf: julian) equals: 4.
	self assert: (aGame numberOfSquareOf: jorge) equals: 5.
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJulianGetsAnOverloadCardAndThrowItToJorge [
	| aGame squares anOverloadCard |
	anOverloadCard := OverloadCard new.
	squares := {EffectlessSquare new. EffectlessSquare new. EffectlessSquare new. EffectlessSquare new. DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 2
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard }).
	self do: 3 theGame: aGame.
	aGame affect: jorge using: anOverloadCard by: julian.
	self do: 2 theGame: aGame.
	self assert: (aGame numberOfSquareOf: jorge) equals: 5
]

{ #category : #'squares usage tests' }
LudoMagicGameTest >> testJulianGetsToAtomicBombSquareWhenAPlayerIsAtSecondLap [

	| squares  aGame |
	squares:= { EffectlessSquare new. EffectlessSquare new. EffectlessSquare new. EffectlessSquare new. EffectlessSquare new. AtomicBombSquare new. EffectlessSquare new.  EffectlessSquare new. EffectlessSquare new. EffectlessSquare new. EffectlessSquare new. }.
	
	aGame:= LudoMagicGame playedBy: players withNumberOfLaps:2  throwing: {(LoadedDice withValues: #(10 1 3 4 5)). (LoadedDice withValues: #(5 4 6 7))}  andWithBoardOf: squares and: aDeck. 
	
	self do: 2 theGame: aGame.
	
	self assert: (aGame lapOf:jorge) equals: 1.
	self assert: (aGame lapOf:julian) equals: 0.
	
	
]

{ #category : #'squares usage tests' }
LudoMagicGameTest >> testJulianGetsToEffectlessSquareAndDoesntGetTheCard [
	| aGame squares aCard |
	
	aCard := Card new.
	
	squares:= { EffectlessSquare new. EffectlessSquare new. DeliveryCardSquare new. EffectlessSquare new. EffectlessSquare new. }.
	
		aGame:= LudoMagicGame playedBy: players withNumberOfLaps:2  throwing: {(LoadedDice withValues: #(1 2)). (LoadedDice withValues: #(1 2))} andWithBoardOf: squares and: (LoadedDeck with:{ aCard . aCard . aCard . aCard . aCard . aCard}).
	self do: 2 theGame: aGame.
	
	self assert: (aGame quantityOfCardsInHandOf: julian) equals: 2.
]

{ #category : #'squares usage tests' }
LudoMagicGameTest >> testJulianGetsToSpeedUpSquare [

	| squares  aGame |
	squares:= { EffectlessSquare new. EffectlessSquare new. WormHoleSquare new. SpeedUpSquare new. AtomicBombSquare new. AtomicBombSquare new. EffectlessSquare new. WormHoleSquare new. AtomicBombSquare new. MoonWalkSquare with: 5. EffectlessSquare new. SpeedUpSquare new. MoonWalkSquare with:3.}.
	
	aGame:= LudoMagicGame playedBy: players withNumberOfLaps:2  throwing:dices  andWithBoardOf:squares and: aDeck. 
	
	self do: 4 theGame: aGame.
	
	
	self assert: (aGame numberOfSquareOf: julian) equals: 3.

	
	
	
]

{ #category : #'squares usage tests' }
LudoMagicGameTest >> testJulianGetsToWormHoleSquare [

	| squares aGame |
	squares:= { EffectlessSquare new. EffectlessSquare new. WormHoleSquare new. SpeedUpSquare new. AtomicBombSquare new. AtomicBombSquare new. EffectlessSquare new. WormHoleSquare new. SpeedUpSquare new. MoonWalkSquare with: 5. EffectlessSquare new. AtomicBombSquare new. MoonWalkSquare with:3.}.
	
	aGame:= LudoMagicGame playedBy: players withNumberOfLaps:2  throwing:dices  andWithBoardOf: squares and: aDeck. 
	
	self do: 2 theGame: aGame.
	

	self assert: (aGame numberOfSquareOf: julian) equals: 4.
	
	
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJulianGetsTwoOverloadsCardAndThrowsThemToJorge [
	| aGame squares anOverloadCard |
	anOverloadCard := OverloadCard new.
	squares := {EffectlessSquare new. EffectlessSquare new. EffectlessSquare new. DeliveryCardSquare new. DeliveryCardSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 3
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and: (LoadedDeck with: {anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard . anOverloadCard}).
	self do: 3 theGame: aGame.
	aGame affect: jorge using: anOverloadCard by: julian.
	self do: 2 theGame: aGame.
	aGame affect: jorge using: anOverloadCard by: julian.
	self do: 2 theGame: aGame.
	self assert: (aGame numberOfSquareOf: jorge) equals: 3
]

{ #category : #'card usage tests' }
LudoMagicGameTest >> testJulianThrowsAReDoCardAndNoLongerHasItInHisHand [
	| aGame squares aReDoCard aSpeedCard |
	aReDoCard := ReDoCard new.
	aSpeedCard := SpeedCard new.
	squares := {EffectlessSquare new.
	EffectlessSquare new.
	EffectlessSquare new.
	EffectlessSquare new.
	EffectlessSquare new}.
	aGame := LudoMagicGame
		playedBy: players
		withNumberOfLaps: 4
		throwing:
			{(LoadedDice withValues: #(1 2)).
			(LoadedDice withValues: #(1 2))}
		andWithBoardOf: squares
		and:
			(LoadedDeck
				with:
					{aSpeedCard.
					aReDoCard . aSpeedCard.
					aReDoCard . aSpeedCard.
					aReDoCard . aSpeedCard.
					aReDoCard . aSpeedCard.
					aReDoCard}).
	aGame affect: jorge using: aSpeedCard by: jorge.
	aGame affect: jorge using: aReDoCard by: jorge.
	self deny: (aGame has: jorge the: aSpeedCard).
	self deny: (aGame has: jorge the: aReDoCard)
]

{ #category : #'main tests' }
LudoMagicGameTest >> testJulianWinsAThreeLapGame [

	self do: 4 theGame: aThreeLapGame .
	
	self assert: aThreeLapGame winner equals: julian.
	self assert: (aThreeLapGame lapOf: julian) equals: 3.
]

{ #category : #'main tests' }
LudoMagicGameTest >> testWhenAPlayerWinsTheOtherPlayersDoesNotRollTheDice [
	self do: 5 theGame: anOneLapGame.
	
	self assert: (anOneLapGame numberOfSquareOf: jorge) equals: 1.
	self assert: (anOneLapGame numberOfSquareOf: julian) equals: 19.

]
