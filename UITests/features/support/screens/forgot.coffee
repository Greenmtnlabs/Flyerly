class ForgotScreen extends Screen
  anchor: -> $('navigationBar[name=ResetPWView]')

  constructor: ->
    super 'forgot'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0],
    'Username' : -> $('#Username'),
    'Reset Password' : -> $('#Reset Password')