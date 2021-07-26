Class {
	#name : #LoadedDeck,
	#superclass : #Object,
	#instVars : [
		'cards'
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
LoadedDeck >> ifEmpty: aBlock [
	cards ifEmpty: aBlock
]

{ #category : #initialization }
LoadedDeck >> initializeWith: aGroupOfCards [ 
	cards := aGroupOfCards asOrderedCollection 
]

{ #category : #boolean }
LoadedDeck >> isEmpty [
	^ cards isEmpty 
]

{ #category : #action }
LoadedDeck >> pick [
	| cardToPick |
	
	cardToPick := cards at: 1 ifAbsent: [ self error: self class noMoreCardsToPickErrorMessage ].
	cards remove: cardToPick.
	^ cardToPick
]

{ #category : #accessing }
LoadedDeck >> size [
	^ cards size
]
