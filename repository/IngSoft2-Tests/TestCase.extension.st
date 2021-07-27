Extension { #name : #TestCase }

{ #category : #'*IngSoft2-Tests' }
TestCase >> assert: aBlockClosure throws: aMessage [
	self
		should: aBlockClosure
		raise: Error
		withExceptionDo:
			[ :error | self assert: error messageText equals: aMessage ]
]
