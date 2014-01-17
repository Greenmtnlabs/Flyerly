class SignInScreen extends Screen
  anchor: -> $('#Login')

  constructor: ->
    super 'sign-in'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0]