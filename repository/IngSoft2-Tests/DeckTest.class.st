Class {
	#name : #DeckTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #'exception tests' }
DeckTest >> testADeckCannotBeCreatedWithoutCards [
	self
		assert: [ Deck with: {} ]
		throws: Deck notValidSizeOfCardsErrorMessage
]

{ #category : #tests }
DeckTest >> testADeckCannotThrowCardWhenItHasNoCards [
	| aDeck |
	aDeck := Deck
		with:
			{OverloadCard new.
			SpeedCard new.
			CancellationCard}.
	aDeck
		pick;
		pick;
		pick.
	self
		assert: [ aDeck pick ]
		throws: Deck noMoreCardsToPickErrorMessage
]
