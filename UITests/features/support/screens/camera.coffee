class CameraScreen extends Screen
  anchor: -> $('navigationBar[name=CameraView]')

  constructor: ->
    super 'camera'

    extend @elements,
    'Cancel' : -> view.navigationBars()[0].buttons()[0],
    'Take a photo' : -> $('#TakePhoto'),
    'Gallery' : -> $('#Gallery'),
    'Rotate Camera' : -> $('#RotateCamera'),
    'Grid' : -> $('#Grid')
