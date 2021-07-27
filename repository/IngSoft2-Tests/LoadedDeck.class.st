Class {
	#name : #LoadedDeck,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #'error message' }
LoadedDeck class >> noMoreCardsToPickErrorMessage [
	^ 'No cards to pick'
]

{ #category : #'instance creation' }
LoadedDeck class >> notValidSizeOfCardsErrorMessage [
	^ 'It needs one or more cards'
]

{ #category : #'instance creation' }
LoadedDeck class >> with: cards [
	
	cards isEmpty ifTrue: [ self error: self notValidSizeOfCardsErrorMessage  ].

	^ self new initializeWith: cards.
]

{ #category : #actions }
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

{ #category : #actions }
LoadedDeck >> pick [
	| cardToPick |
	cardToPick := cards
		at: 1
		ifAbsent: [ self error: self class noMoreCardsToPickErrorMessage ].
	cards remove: cardToPick.
	^ cardToPick
]

{ #category : #accesing }
LoadedDeck >> size [
	^ cards size
]
