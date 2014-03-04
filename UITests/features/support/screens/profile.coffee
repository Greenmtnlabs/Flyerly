class ProfileScreen extends Screen
  anchor: -> $('navigationBar[name=ProfileView]')

  constructor: ->
    super 'profile'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0]
    'Email' : -> $('#Email')
    'Name' : -> $('#Name')
    'Phone' : -> $('#Phone')