# Sends an email to a user with a link that can be used to reset
# their password
#
# @param options {Object}
#   - email: (email)
# @param callback (optional) {Function(error|undefined)}

###*
# @summary Request a forgot password email.
# @locus Client
# @param {Object} options
# @param {String} options.email The email address to send a password reset link.
# @param {Function} [callback] Optional callback. Called with no arguments on success, or with a single `Error` argument on failure.
###
Accounts.forgotPasswordWithOAuthCheck = (options, callback) ->
  if !options.email
    throw new Error('Must pass options.email')
  Accounts.connection.call 'forgotPasswordWithOAuthCheck', options, callback
  return
