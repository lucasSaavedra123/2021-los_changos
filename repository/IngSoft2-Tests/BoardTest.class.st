Class {
	#name : #BoardTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #'exception tests' }
BoardTest >> testABoardCannotBeCreatedWithDeckOfOneCardIfThereAreTwoPlayers [
	self
		assert: [ Board
				playedBy: {'jorge' . 'julian'}
				with:
					{EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new}
				andCardsFrom: (Deck with: {Card new})
				finishingAfter: 1 ]
		throws: (Board notValidDeckSizeErrorMessageWith: 2)
]

{ #category : #'exception tests' }
BoardTest >> testABoardCannotBeCreatedWithDeckOfTenCardsIfThereAreSixPlayers [
	self
		assert: [ Board
				playedBy: {'jorge' . 'julian' . 'ignacio' . 'gonzalo' . 'hernan' . 'lucas'}
				with:
					{EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new}
				andCardsFrom:
					(Deck
						with:
							{Card new.
							Card new.
							Card new.
							Card new.
							Card new.
							Card new.
							Card new.
							Card new.
							Card new.
							Card new})
				finishingAfter: 1 ]
		throws: (Board notValidDeckSizeErrorMessageWith: 6)
]

{ #category : #'exception tests' }
BoardTest >> testABoardCannotBeCreatedWithDeckOfThreeCardsIfThereAreTwoPlayers [
	self
		assert: [ Board
				playedBy: {'jorge' . 'julian'}
				with:
					{EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new}
				andCardsFrom:
					(Deck
						with:
							{Card new.
							Card new.
							Card new})
				finishingAfter: 1 ]
		throws: (Board notValidDeckSizeErrorMessageWith: 2)
]

{ #category : #'exception tests' }
BoardTest >> testABoardCannotBeCreatedWithFourSquaresize [
	self
		assert: [ Board
				playedBy: {'jorge' . 'julian'}
				with:
					{EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new}
				andCardsFrom: (Deck with: {Card new . Card new . Card new . Card new . Card new})
				finishingAfter: 1 ]
		throws: Board notValidNumberOfSquaresErrorMessage
]

{ #category : #'exception tests' }
BoardTest >> testABoardCannotBeCreatedWithNumberOfLapsNegative [
	self
		assert: [ Board
				playedBy: {'julian' . 'jorge'}
				with:
					{EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new}
				andCardsFrom: (Deck with: {Card new . Card new . Card new . Card new})
				finishingAfter: -3 ]
		throws: Board notValidNumberOfLapsErrorMessage
]

{ #category : #'exception tests' }
BoardTest >> testABoardCannotBeCreatedWithNumberOfLapsZero [
	self
		assert: [ Board
				playedBy: {'jorge' . 'julian'}
				with:
					{EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new}
				andCardsFrom: (Deck with: {Card new})
				finishingAfter: 0 ]
		throws: Board notValidNumberOfLapsErrorMessage
]

{ #category : #'exception tests' }
BoardTest >> testABoardCannotBeCreatedWithOnePlayer [
	self
		assert: [ Board
				playedBy: {'hernan'}
				with:
					{EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new}
				andCardsFrom:
					(Deck
						with:
							{Card new.
							Card new.
							Card new.
							Card new.
							Card new.
							Card new.
							Card new})
				finishingAfter: 1 ]
		throws: Board notValidNumberOfPlayersErrorMessage
]

{ #category : #'exception tests' }
BoardTest >> testABoardCannotBeCreatedWithTwoSquares [
	self
		assert: [ Board
				playedBy: {'jorge' . 'julian'}
				with:
					{EffectlessSquare new.
					EffectlessSquare new}
				andCardsFrom:
					(Deck
						with:
							{Card new.
							Card new.
							Card new.
							Card new.
							Card new})
				finishingAfter: 1 ]
		throws: Board notValidNumberOfSquaresErrorMessage
]

{ #category : #'exception tests' }
BoardTest >> testABoardCannotBeCreatedWithZeroPlayers [
	self
		assert: [ Board
				playedBy: {}
				with:
					{EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new}
				andCardsFrom:
					(Deck
						with:
							{Card new.
							Card new.
							Card new.
							Card new})
				finishingAfter: 10 ]
		throws: Board notValidNumberOfPlayersErrorMessage
]

{ #category : #'exception tests' }
BoardTest >> testABoardCannotBeCreatedWithoutSquares [
	self
		assert: [ Board
				playedBy: {'jorge' . 'julian'}
				with: {}
				andCardsFrom: (Deck with: {Card new . Card new . Card new . Card new . Card new . Card new})
				finishingAfter: 1 ] throws: Board notValidNumberOfSquaresErrorMessage
]

{ #category : #'exception tests' }
BoardTest >> testABoardCouldHaveOneLap [
	self
		shouldnt: [ Board
				playedBy: {'julian' . 'jorge'}
				with:
					{EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new.
					EffectlessSquare new}
				andCardsFrom: (Deck with: {Card new . Card new . Card new . Card new . Card new})
				finishingAfter: 1 ]
		raise: Error
]
