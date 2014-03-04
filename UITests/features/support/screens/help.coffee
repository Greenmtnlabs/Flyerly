class Help1Screen extends Screen
  anchor: -> $('navigationBar[name=Help]')

  constructor: ->
    super 'help'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0]