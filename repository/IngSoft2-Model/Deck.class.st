Class {
	#name : #Deck,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'IngSoft2-Model-Core'
}

{ #category : #'as yet unclassified' }
Deck class >> noMoreCardsToPickErrorMessage [
	^ 'No cards to pick'
]

{ #category : #'instance creation' }
Deck class >> notValidSizeOfCardsErrorMessage [
	^ 'It needs one or more cards'
]

{ #category : #'instance creation' }
Deck class >> with: cards [
	
	cards isEmpty ifTrue: [ self error: self notValidSizeOfCardsErrorMessage  ].

	^ self new initializeWith: cards.
]

{ #category : #initialization }
Deck >> initializeWith: aGroupOfCards [
	cards := aGroupOfCards asOrderedCollection shuffled.
]

{ #category : #accesing }
Deck >> isEmpty [
	^ cards isEmpty 
]

{ #category : #actions }
Deck >> pick [
	| cardToPick |
	
	cardToPick := cards at: 1 ifAbsent: [ self error: self class noMoreCardsToPickErrorMessage ].
	cards remove: cardToPick.
	^ cardToPick
]

{ #category : #actions }
Deck >> size [
	^ cards size
]
