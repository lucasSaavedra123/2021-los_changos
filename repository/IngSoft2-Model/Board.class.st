Class {
	#name : #Board,
	#superclass : #Object,
	#instVars : [
		'laps',
		'players',
		'positions',
		'squares',
		'cardHandlers',
		'lastSquarePlayed',
		'discardDeck',
		'history',
		'mainDeck'
	],
	#category : #'IngSoft2-Model-Core'
}

{ #category : #'error message' }
Board class >> noActiveCardsErrorMessage [
	^ 'This card cannot be played because there was no card played before'
]

{ #category : #'error message' }
Board class >> notValidDeckSizeErrorMessage: numberOfPlayers [
	^ 'Deck should be of size ', (numberOfPlayers * 2) asString,' or more'
]

{ #category : #'error message' }
Board class >> notValidNumberOfLapsErrorMessage [
	^ 'Number of laps must be greater than 0'
]

{ #category : #'error message' }
Board class >> notValidNumberOfPlayersErrorMessage [
	^ 'There must be 2 or more players'
]

{ #category : #'error message' }
Board class >> notValidNumberOfSquaresErrorMessage [
	^ 'Size must be greater than 4'
]

{ #category : #'instance creation' }
Board class >> playedBy: players with: squares andCardsFrom: deck finishingAfter: laps [
	self validate: players withNumberOf: laps  on: squares with: deck.
	^self new initializePlayedBy: players withNumberOf: laps with: squares andCardsFrom: deck.
]

{ #category : #validation }
Board class >> validate: players withNumberOf: laps on: squares with: deck [.
	self validatePlayers: players.
	self validateLaps: laps.
	self validateSquares: squares.
	self validateDeck: deck for: players.
]

{ #category : #validation }
Board class >> validateDeck: aDeck for: players [
	aDeck size < (players size * 2) ifTrue: [ self error: (self notValidDeckSizeErrorMessage: players size)]
]

{ #category : #validation }
Board class >> validateLaps: laps [
	laps < 1
		ifTrue: [ self error: self notValidNumberOfLapsErrorMessage ]
]

{ #category : #validation }
Board class >> validatePlayers: players [
	players size <= 1
		ifTrue: [ self error: self notValidNumberOfPlayersErrorMessage ]
]

{ #category : #validation }
Board class >> validateSquares: squares [
	squares size <= 4
		ifTrue: [ self error: self notValidNumberOfSquaresErrorMessage ]
]

{ #category : #action }
Board >> addEffectOf: aCard to: aPlayer [
	(self cardHandlerOf: aPlayer) addEffectOf: aCard.
]

{ #category : #action }
Board >> addToAllEffectOf: aCard [ 
	players do:[:player | self addEffectOf: aCard to:player].
	
]

{ #category : #action }
Board >> applyEffectOfTheLastPlayedSquareTo: aPlayer from: aCard [
	lastSquarePlayed makeEffectOn: aPlayer thatHasItsPositionIn: self.

]

{ #category : #accessing }
Board >> cardHandlerOf: aPlayer [
	| playerCardHandler |
	playerCardHandler := cardHandlers
		detect: [ :handler | handler player = aPlayer ].
	^ playerCardHandler
]

{ #category : #accessing }
Board >> discardDeckSize [
	^ discardDeck size
]

{ #category : #initialization }
Board >> distributeCardsFrom: aDeck [
	cardHandlers
		do: [ :cardHandler | 
			cardHandler addToHand: aDeck pick.
			cardHandler addToHand: aDeck pick ]
]

{ #category : #boolean }
Board >> finished: aPlayer [
	| playerPosition squaresAdvanced |
	playerPosition := self positionOf: aPlayer.
	squaresAdvanced := self numberOfSquaresAdvancedOf: playerPosition.
	^ squaresAdvanced = self limit
]

{ #category : #action }
Board >> giveCardFromDeckTo: aPlayer [
	discardDeck ifNotEmpty: [ (self cardHandlerOf: aPlayer) addToHand: (mainDeck pick) ].
	mainDeck ifEmpty: [ self refillDeck ]
]

{ #category : #boolean }
Board >> has: aPlayer the: aCard [
	| playerCardHandler |
	playerCardHandler := self cardHandlerOf: aPlayer.
	^ playerCardHandler hasInHand: aCard
]

{ #category : #initialization }
Board >> initializePlayedBy: aGroupOfPlayers withNumberOf: numberOfLaps with: aGroupOfSquares andCardsFrom: aDeck [
	positions := aGroupOfPlayers
		collect: [ :player | Position of: player at: 1 after: 0 ].
	cardHandlers := aGroupOfPlayers
		collect: [ :player | CardHandler with: player ].
	self distributeCardsFrom: aDeck.
	squares := aGroupOfSquares.
	laps := numberOfLaps.
	discardDeck := OrderedCollection new.
	history := OrderedCollection new.
	players := aGroupOfPlayers.
	mainDeck := aDeck.
	lastSquarePlayed := EffectlessSquare new.
]

{ #category : #accessing }
Board >> lapOf: aPlayer [ 
	^ (self positionOf: aPlayer) lap.
]

{ #category : #accessing }
Board >> lastPlayableCardPlayed [
	| notRedoCards |
	notRedoCards := history select: [ :aCard | aCard isNotReDo ].
	^ notRedoCards at: notRedoCards size ifAbsent: [self error: self class noActiveCardsErrorMessage]
]

{ #category : #accessing }
Board >> limit [
	^(laps * (squares size)) + 1
]

{ #category : #accessing }
Board >> mainDeckSize [
	^ mainDeck size
]

{ #category : #action }
Board >> move: aPlayer backwards: numberOfSquares [

	| aPosition newPosition |
	aPosition := self positionOf: aPlayer.
	newPosition := self newPosition: (numberOfSquares negated) from: aPosition. 
	positions remove: aPosition.
	positions add: newPosition.
]

{ #category : #action }
Board >> move: aPlayer forward: squaresToMove [
	| currentSquare newPosition |
	newPosition := self move: aPlayer withoutEffectTo: squaresToMove.
	currentSquare := squares at: newPosition numberOfSquare.
	lastSquarePlayed := currentSquare.
	currentSquare makeEffectOn: aPlayer thatHasItsPositionIn: self
]

{ #category : #action }
Board >> move: aPlayer withoutEffectTo: squaresToMove [
	| oldPosition newPosition |
	oldPosition := self positionOf: aPlayer.
	positions remove: oldPosition.
	newPosition := self newPosition: squaresToMove from: oldPosition.
	positions add: newPosition.
	^ newPosition
]

{ #category : #accessing }
Board >> moveAllPlayersBackards: numberOfSquaresToMoveBackwards except: aPlayer [ 
	| playersToMove |
	playersToMove:= self players.
	playersToMove remove: aPlayer.
	playersToMove do:[:player| self move: player backwards: numberOfSquaresToMoveBackwards ].
]

{ #category : #accessing }
Board >> newPosition: numberOfSquaresToAdvance from: aPosition [
	| newLap newNumberOfSquare quantityOfSquaresAdvanced |
	quantityOfSquaresAdvanced := (self
		numberOfSquaresAdvancedOf: aPosition) + numberOfSquaresToAdvance
		min: self limit
		max: 1.
	newLap := (quantityOfSquaresAdvanced - 1) // self size.
	newNumberOfSquare := quantityOfSquaresAdvanced % self size.
	newNumberOfSquare = 0
		ifTrue: [ newNumberOfSquare := self size ].
	^ Position of: aPosition player at: newNumberOfSquare after: newLap
]

{ #category : #accessing }
Board >> numberOfSquaresAdvancedOf: aPosition [
	^ aPosition lap * squares size + aPosition numberOfSquare
]

{ #category : #accessing }
Board >> players [
	^ players copy.
]

{ #category : #accessing }
Board >> positionOf: aPlayer [ 
	^ positions detect: [ :aPosition | aPosition player = aPlayer  ]
]

{ #category : #action }
Board >> refillDeck [
	mainDeck := Deck with: discardDeck.
	discardDeck := OrderedCollection new.
]

{ #category : #action }
Board >> removeFromHand: aCard to: aPlayer [
	(self cardHandlerOf: aPlayer) removeFromHand: aCard.
	discardDeck add: aCard.
	history add: aCard.
]

{ #category : #action }
Board >> removeToAllPlayersPermanent: card [
	| handlersWithCardToBeRemoved |
	handlersWithCardToBeRemoved := cardHandlers
		select: [ :cardHandler | cardHandler affectsPlayer: card ].
	self
	validateIsNotEmpty: handlersWithCardToBeRemoved.
	handlersWithCardToBeRemoved
		do: [ :cardHandler | cardHandler removeEffectOf: card ].


]

{ #category : #action }
Board >> restartPositionOfAllPlayers [
	positions := players
		collect:
			[ :player | Position of: player at: 1 after: (self lapOf: player) ]
]

{ #category : #accessing }
Board >> size [
	^ squares size
]

{ #category : #accessing }
Board >> sortedPositions [
	^ positions asSortedCollection: [ :playerA :playerB | playerA >= playerB ]
]

{ #category : #action }
Board >> validateIsNotEmpty: handlersWithCardToBeRemoved [
	handlersWithCardToBeRemoved isEmpty
		ifTrue: [ self error: CardHandler noCardMatchErrorMessage ]
]
