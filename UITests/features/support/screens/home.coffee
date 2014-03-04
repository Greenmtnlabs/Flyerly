class HomeScreen extends Screen
  anchor: -> $('navigationBar[name=FlyerlyMainScreen]')

  constructor: ->
    super 'home'

    extend @elements,
    'Saved' : -> $('#SavedFlyers'),
    'Create' : -> $('#CreateFlyer'),
    'Invite' : -> $('#Invite'),
    'Settings': -> $('#Settings'),
    'Twitter' : -> $('#Twitter'),
    'Facebook' :-> $('#Facebook'),
    'FacebookLike' :-> $('#FacebookLikeInPopup'),
    'FacebookClose' :-> $('#FacebookClose'),
    'First Flyer' :-> $('#FirstFlyer'),
    'Second Flyer' :-> $('#SecondFlyer'),
    'Third Flyer' :-> $('#ThirdFlyer'),
    'Fourth Flyer' :-> $('#FourthFlyer')