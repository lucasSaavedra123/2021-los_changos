Class {
	#name : #ProbabilisticDistributor,
	#superclass : #Object,
	#instVars : [
		'events',
		'intervalsByEvent'
	],
	#category : #'IngSoft2-Model-Utilities'
}

{ #category : #validating }
ProbabilisticDistributor class >> areValidEvents: events [
	| sumOfProbabilities |
	events ifEmpty: [ ^ false ].
	sumOfProbabilities := (events detectSum: [ :event | event probability ]).
	^ (sumOfProbabilities closeTo: 1)
]

{ #category : #'error message' }
ProbabilisticDistributor class >> notValidGroupOfEventsMessage [
	^ 'The sum of events probabilities must be 1'
]

{ #category : #validation }
ProbabilisticDistributor class >> validate: events [
	(self areValidEvents: events) ifFalse: [ self error: self notValidGroupOfEventsMessage ].
]

{ #category : #'instance creation' }
ProbabilisticDistributor class >> with: events [
	self validate: events.
	^ self new initializeWith: events
]

{ #category : #'instance creation' }
ProbabilisticDistributor class >> withEqualProbability: groupOfItems [
	| probability events |
	probability := 1/(groupOfItems size). 
	events := groupOfItems collect: [ :item | ProbabilisticEvent with: probability for: item ].
	^ self new initializeWith: events.
]

{ #category : #accessing }
ProbabilisticDistributor >> events [
	^ events copy
]

{ #category : #action }
ProbabilisticDistributor >> generate: numberOfTimesToPick [
	^ (1 to: numberOfTimesToPick) collect: [ :number | self pick ]
]

{ #category : #initialization }
ProbabilisticDistributor >> initializeWith: aGroupOfEvents [
	| indexOne indexTwo |
	events := aGroupOfEvents.
	intervalsByEvent := Dictionary new.
	indexOne := 0.
	indexTwo := 0.
	aGroupOfEvents
		do: [ :event | 
			indexOne := indexTwo.
			indexTwo := indexTwo + event probability.
			intervalsByEvent
				at: event
				put: (RealInterval from: indexOne to: indexTwo) ]
]

{ #category : #action }
ProbabilisticDistributor >> pick [
	| numberGenerated event |
	numberGenerated := Random new next.
	event := events
		detect:
			[ :aEvent | (intervalsByEvent at: aEvent) includes: numberGenerated ].
	^ event object
]
