class SignInScreen extends Screen
  anchor: -> $('#CreateFlyer')

  constructor: ->
    super 'sign-in'

    extend @elements,
	'Saved' : -> $('#SavedFlyers'),
	'Create' : -> $('#CreateFlyer'),
	'Invite' : -> $('#Invite'),
	'Settings': -> $('#Settings'),
	'Twitter' : -> $('#Twitter'),
	'Facebook' :-> $('#Facebook'),
	'FacebookLike' :-> $('#FacebookLikeInPopup'),
	'FacebookClose' :-> $('#FacebookClose'),