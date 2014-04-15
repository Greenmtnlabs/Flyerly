class Invite123Screen extends Screen
  anchor: -> $('navigationBar[name=InviteFriends]')
  anchor: -> $('tableview[name=Empty list]')
  
  constructor: ->
    super 'invite_friend'

    extend @elements,
    'Home' : -> view.navigationBars()[0].buttons()[0],
    'Help' : -> view.navigationBars()[0].buttons()[1],
    'Create' : -> view.navigationBars()[0].buttons()[2],
    'Search Box' : -> $('#Search'),
    'Cell' : -> view.tableViews()[0].cells()[1],
    '1Cell' : -> view.tableViews()[0].cells()[11],