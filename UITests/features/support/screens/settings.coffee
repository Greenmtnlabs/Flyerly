class SettingsScreen extends Screen
  anchor: -> $('navigationBar[name=MainSettingView]')
  anchor: -> $('tableview[name=Empty list]')

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
    'Account Setting' : -> $('#Account Setting')
    'Save to Gallery' : -> $('#Save to Gallery')
    'Cell' : -> view.tableViews()[0].scrollToElementWithName('Save to Gallery')