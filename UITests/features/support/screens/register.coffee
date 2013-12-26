class RegisterScreen extends Screen
  anchor: -> $("navigationBar[name=REGISTER]")

  constructor: ->
    super 'register'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0]