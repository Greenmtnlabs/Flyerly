class SettingsScreen extends Screen
  anchor: -> $('navigationBar[name=MainSettingView]')

  constructor: ->
    super 'settings'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0],
    'Help' : -> view.navigationBars()[0].buttons()[1],
    'Email' : -> $('#SettingsEmail'),
    'App Review' : -> $('#AppReview'),
    'Twitter' : -> $('#Twitter'),
    'Help' : -> $('#Help'),
    'Sign Out' : -> $('#Sign Out')
