Class {
	#name : #LoadedDeck,
	#superclass : #Object,
	#instVars : [
		'cards',
		'nextCard'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #'as yet unclassified' }
LoadedDeck class >> noMoreCardsToPickErrorMessage [
	^ 'No cards to pick'
]

{ #category : #'as yet unclassified' }
LoadedDeck class >> notValidSizeOfCardsErrorMessage [
	^ 'It needs one or more cards'
]

{ #category : #'as yet unclassified' }
LoadedDeck class >> with: cards [
	^self new initializeWith: cards.
]

{ #category : #'as yet unclassified' }
LoadedDeck >> initializeWith: aGroupOfCards [ 
	cards := aGroupOfCards asOrderedCollection 
]

{ #category : #'as yet unclassified' }
LoadedDeck >> isEmpty [
	^ cards isEmpty 
]

{ #category : #'as yet unclassified' }
LoadedDeck >> pick [
	| cardToPick |
	
	cardToPick := cards at: 1 ifAbsent: [ self error: self class noMoreCardsToPickErrorMessage ].
	cards remove: cardToPick.
	^ cardToPick
]

{ #category : #'as yet unclassified' }
LoadedDeck >> size [
	^ cards size
]
