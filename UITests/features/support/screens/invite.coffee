class InviteScreen extends Screen
  anchor: -> $('navigationBar[name=InviteFriends]')

  constructor: ->
    super 'invite'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0],
    'Help' : -> view.navigationBars()[0].buttons()[1]