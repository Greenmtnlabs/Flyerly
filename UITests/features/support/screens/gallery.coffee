class GalleryScreen extends Screen
  anchor: -> $('navigationBar[name=GalleryView]')

  constructor: ->
    super 'gallery'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0]
