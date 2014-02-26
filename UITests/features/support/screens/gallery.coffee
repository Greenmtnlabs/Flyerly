class GalleryScreen extends Screen
  anchor: -> $('navigationBar[name=9 albums]')

  constructor: ->
    super 'gallery'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0]
