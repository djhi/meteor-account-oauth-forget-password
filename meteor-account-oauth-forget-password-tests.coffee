sendResetPasswordEmailCalled = false
Accounts.sendResetPasswordEmail = ->
  sendResetPasswordEmailCalled = true
  return

Tinytest.addAsync 'Throws meteor error with services when it find some', (test, onComplete) ->
  sendResetPasswordEmailCalled = false
  ServiceConfiguration.configurations.find = ->
    [service: 'test']

  Meteor.users.findOne = (filters) ->
    if _.has filters, 'services.test.email'
      result =
        _id: 'test'
        services:
          test: true
      result
    else
      undefined

  Meteor.call 'forgotPasswordWithOAuthCheck', email: 'test@test.com', (error, result) ->
    test.isTrue !!error
    test.equal error.error, 403
    test.equal error.reason, 'User not found'
    test.equal error.details.servicesFound, ['test']
    test.isFalse sendResetPasswordEmailCalled
    onComplete()

Tinytest.addAsync 'Throws meteor error with services when it find user by its profile.email field', (test, onComplete) ->
  sendResetPasswordEmailCalled = false
  ServiceConfiguration.configurations.find = ->
    []

  Meteor.users.findOne = (filters) ->
    if filters['profile.email']?
      result =
        _id: 'test'
        services:
          test: true
          test2: true
      result
    else
      undefined

  Meteor.call 'forgotPasswordWithOAuthCheck', email: 'test@test.com', (error, result) ->
    test.isTrue !!error
    test.equal error.error, 403
    test.equal error.reason, 'User not found'
    test.equal error.details.servicesFound, ['test', 'test2']
    test.isFalse sendResetPasswordEmailCalled
    onComplete()

Tinytest.addAsync 'Throws meteor error with services when it find user by a custom email field', (test, onComplete) ->
  sendResetPasswordEmailCalled = false
  ServiceConfiguration.configurations.find = ->
    []

  AccountOAuthCheck.setEmailField "customEmailField"
  Meteor.users.findOne = (filters) ->
    if filters['customEmailField']?
      result =
        _id: 'test'
        services:
          test: true
          test2: true
      result
    else
      undefined

  Meteor.call 'forgotPasswordWithOAuthCheck', email: 'test@test.com', (error, result) ->
    test.isTrue !!error
    test.equal error.error, 403
    test.equal error.reason, 'User not found'
    test.equal error.details.servicesFound, ['test', 'test2']
    test.isFalse sendResetPasswordEmailCalled
    onComplete()

Tinytest.addAsync 'Throws meteor error with services when it find user by a custom method', (test, onComplete) ->
  sendResetPasswordEmailCalled = false
  ServiceConfiguration.configurations.find = ->
    []

  AccountOAuthCheck.setFindUserMethod (email) ->
    result =
      _id: 'test'
      services:
        test: true
        test2: true
    result

  Meteor.users.findOne = (filters) ->
    undefined

  Meteor.call 'forgotPasswordWithOAuthCheck', email: 'test@test.com', (error, result) ->
    test.isTrue !!error
    test.equal error.error, 403
    test.equal error.reason, 'User not found'
    test.equal error.details.servicesFound, ['test', 'test2']
    test.isFalse sendResetPasswordEmailCalled
    onComplete()

Tinytest.addAsync 'Throws meteor error without services when it find none', (test, onComplete) ->
  sendResetPasswordEmailCalled = false
  ServiceConfiguration.configurations.find = ->
    []

  Meteor.users.findOne = (filters) ->
    undefined

  AccountOAuthCheck.setFindUserMethod AccountOAuthCheck._defaultFindUserByEmail

  Meteor.call 'forgotPasswordWithOAuthCheck', email: 'test@test.com', (error, result) ->
    test.isTrue !!error
    test.equal error.error, 403
    test.equal error.reason, 'User not found'
    test.equal error.details, undefined
    test.isFalse sendResetPasswordEmailCalled
    onComplete()

Tinytest.addAsync 'Calls Accounts.sendResetPasswordEmail when it find the user', (test, onComplete) ->
  ServiceConfiguration.configurations.find = ->
    []

  Meteor.users.findOne = (filters) ->
    _id: 'test'

  Meteor.call 'forgotPasswordWithOAuthCheck', email: 'test@test.com', (error, result) ->
    test.isUndefined error
    test.isTrue sendResetPasswordEmailCalled
    onComplete()
