class CropScreen extends Screen
  anchor: -> $('navigationBar[name=CropView]')

  constructor: ->
    super 'crop'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0],
    'Done' : -> view.navigationBars()[0].buttons()[1]
