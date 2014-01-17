class SignInScreen extends Screen
  anchor: -> $('#Login')

  constructor: ->
    super 'sign-in'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0],
	'Next' : -> view.navigationBars()[0].buttons()[1],
	'Username' : -> $('#Username'),
	'Password' : -> $('#Password')