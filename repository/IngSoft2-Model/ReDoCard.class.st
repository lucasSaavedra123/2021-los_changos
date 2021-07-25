Class {
	#name : #ReDoCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model-Core'
}

{ #category : #action }
ReDoCard >> applyTo: aTarget in: aGame from: aPlayer [
	| newCard |
	newCard := aGame lastCardPlayed.
	aGame validate: aPlayer has: self.
	aGame addInHand: newCard to: aPlayer.
	aGame affect: aTarget using: newCard by: aPlayer
]
