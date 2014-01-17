class WelcomeScreen extends Screen
  anchor: -> $('#Register');

  constructor: ->
    super 'welcome'

    extend @elements,
    'Register' : -> $('#Register'),
    'SignIn' : -> $('#SignIn')