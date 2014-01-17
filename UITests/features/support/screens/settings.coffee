class SettingsScreen extends Screen
  anchor: -> $('#SettingsScreen')

  constructor: ->
    super 'settings'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0],
	'Next' : -> view.navigationBars()[0].buttons()[1],
	'Facebook Button' : -> $('#Facebook'),
	'Twitter Button' : -> $('#Twitter'),
	'Instagram Button' : -> $('#Instagram'),
	'Tumblr Button': -> $('#Tumblr'),
	'Twitter Button' : -> $('#Twitter')