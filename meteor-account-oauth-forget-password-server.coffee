# Method called by a user to request a password reset email. This is
# the start of the reset process.
forgotPasswordWithOAuthCheck = (options) ->
  check options, email: String
  user = Meteor.users.findOne 'emails.address': options.email
  servicesFound = []

  unless user
    servicesCursor = ServiceConfiguration.configurations.find {} ,
      fields: service: 1

    servicesCursor.forEach (serviceConfig) ->
      service = serviceConfig.service
      filters = {}
      filters["services.#{service}.email"] = options.email

      user = Meteor.users.findOne

      if user then servicesFound.push service
      user = undefined

  if servicesFound.length > 0
    error = new Meteor.Error 403, 'User not found', servicesFound: servicesFound
    throw error

  unless user
    unless typeof AccountOAuthCheck.findUserByEmail == 'function'
      throw new Error "You did not supplied a method to AccountOAuthCheck.setFindUserMethod"

    user = AccountOAuthCheck.findUserByEmail options.email

    if user
      services = _.keys user.services
      servicesFound = _.without services, 'password'

      if servicesFound.length > 0
        error = new Meteor.Error 403, 'User not found', servicesFound: servicesFound
        throw error
      else
        user = undefined

  unless user then throw new Meteor.Error 403, 'User not found'

  Accounts.sendResetPasswordEmail user._id, options.email
  return

Meteor.methods forgotPasswordWithOAuthCheck: forgotPasswordWithOAuthCheck

class AccountOAuthCheckClass
  constructor: ->
    @emailField = 'profile.email'

    @_defaultFindUserByEmail = (email) ->
      filters = {}
      filters[AccountOAuthCheck.emailField] = email
      return Meteor.users.findOne filters

    @findUserByEmail = @_defaultFindUserByEmail

  setEmailField: (field) ->
    @emailField = field
    return

  setFindUserMethod: (func) ->
    @findUserByEmail = func
    return

AccountOAuthCheck = new AccountOAuthCheckClass()
