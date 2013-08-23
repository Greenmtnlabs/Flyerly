class SignInScreen extends Screen
  anchor: -> $("navigationBar[name=SIGN IN]")

  constructor: ->
    super 'sign-in'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0]