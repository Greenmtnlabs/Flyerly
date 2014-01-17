class RegisterScreen extends Screen
  anchor: -> $('#SignUp')

  constructor: ->
    super 'register'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0]