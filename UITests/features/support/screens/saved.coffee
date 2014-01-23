class SavedScreen extends Screen
  anchor: -> $('navigationBar[name=FlyrView]')

  constructor: ->
    super 'saved'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0],
    'Help' : -> view.navigationBars()[0].buttons()[1],
    'Create' : -> view.navigationBars()[0].buttons()[2],
    'Search Box' : -> $('#Search')