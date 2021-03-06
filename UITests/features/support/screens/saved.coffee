class SavedScreen extends Screen
  anchor: -> $('navigationBar[name=FlyrView]')
  anchor: -> $('tableview[name=Empty list]')
  
  constructor: ->
    super 'saved'

    extend @elements,
    'Home' : -> view.navigationBars()[0].buttons()[0],
    'Help' : -> view.navigationBars()[0].buttons()[1],
    'Create' : -> view.navigationBars()[0].buttons()[2],
    'Search Box' : -> $('#Search'),
    'Cell' : -> view.tableViews()[0].cells()[0],