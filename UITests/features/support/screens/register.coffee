class RegisterScreen extends Screen
  anchor: -> $('#SignUp')

  constructor: ->
    super 'register'

    extend @elements,
    'Back' : -> view.navigationBars()[0].buttons()[0],
    'Next' : -> view.navigationBars()[0].buttons()[1],
    'Username' : -> $( '#Username' ),
    'Password' : -> $( '#Password' ),
    'Confirm Password' : -> $( '#ConfirmPassword' ),
    'Email' : -> $( '#Email' ),
    'Name' : -> $( '#Name' ),
    'Phone Number' : -> $( '#PhoneNumber' ),
    'Sign Up' : -> $( '#SignUp' ),
    'Facebook' : -> $( '#Facebook' ),
    'Twitter' : -> $( '#Twitter' )