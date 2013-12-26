class WelcomeScreen extends Screen
  anchor: -> view.buttons()[0]

  constructor: ->
    super 'welcome'

    extend @elements,
    'Register' : -> view.buttons()[0],
    'SignIn' : -> view.buttons()[1]