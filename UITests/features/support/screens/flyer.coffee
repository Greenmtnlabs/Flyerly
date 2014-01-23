class FlyerScreen extends Screen
  anchor: -> $('navigationBar[name=CreateFlyer]')

  constructor: ->
    super 'flyer'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0],
    'Help' : -> view.navigationBars()[0].buttons()[1],
    'Undo' : -> view.navigationBars()[0].buttons()[2],
    'Share' : -> view.navigationBars()[0].buttons()[3]