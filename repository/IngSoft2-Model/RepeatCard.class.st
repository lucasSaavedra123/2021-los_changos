Class {
	#name : #RepeatCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model-Core'
}

{ #category : #action }
RepeatCard >> applyTo: aTarget in: aGame [
	aGame applyEffectOfTheLastPlayedSquareTo: aTarget from: self
]

{ #category : #action }
RepeatCard >> applyTo: aTarget in: aGame from: aPlayer [
	aGame validateThrowOfAnInstantaneous: self from: aPlayer.
	self applyTo: aTarget in: aGame
]
