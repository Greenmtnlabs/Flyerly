class Invite123Screen extends Screen
  anchor: -> $('navigationBar[name=InviteFriends]')
  anchor: -> $('tableview[name=Empty list]')

  constructor: ->
    super 'invite'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0]
    'Help' : -> view.navigationBars()[0].buttons()[1]
    'Next' : -> view.navigationBars()[0].buttons()[2]
    'First Contact' : -> view.tableViews()[0].cells()[0]