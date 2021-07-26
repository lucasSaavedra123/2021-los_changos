Class {
	#name : #OverloadCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model-Core'
}

{ #category : #action }
OverloadCard >> applyTo: aTarget in: aGame [
	aGame addEffectOf: self to:aTarget. 
]

{ #category : #action }
OverloadCard >> applyTo: aTarget in: aGame from: aPlayer [
	aGame validateThrowOfAPermanent: self  from: aPlayer.
	self applyTo: aTarget in: aGame
]

{ #category : #accesing }
OverloadCard >> effect [
	^-2.
]
