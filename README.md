Meteor Account OAuth Forget Password
=========================

# Usecase
 - you added the `account-password` package
 - you added the `account-google` package or any other OAuth package
 - a user signed in your app with an OAuth service

Your user come back later to your app and has forgotten how he/she signed in. He
then click the *I forgot my passwork* link and, by default, sees a message
indicating that no user has been found with this email address.

This package add a new method called `forgotPasswordWithOAuthCheck` which will
check whether a user exists with this email registered from a service.

This obviously only works for OAuth services which return the user address.
Twitter and Instagram do not and it won't work with them.

### Workaround for OAuth services which doesn't return email
For those cases, I added the possibility to specify an alternative field to
check for email. Let say you use Twitter OAuth but you do need to have an email
for every user and took care to ask them one after authentication.

If you saved the email into `profile.email` then you don't have anything to do,
this package will find the user and its services and you'll get the appropriate
error.

If you saved the email in another field, just specify it with a call to the
`AccountOAuthCheck.setEmailField` method *on the server*.

If you want another way to find the user, call the
`AccountOAuthCheck.setFindUserMethod` method *on the server*, supplying your
very own function. It will be called with a single parameter, the email supplied
by the user.

# Installation
```
meteor add gildaspk:meteor-account-oauth-forget-password
```

# Usage

On client side, add a link for your users to recover their passwords. Add this
event handler in your template:
```javascript
Template.mySignInTemplate.events({
  "click #recover-password-link-selector": function(event, template) {
    var email = "" // Get the email from your template
    Accounts.forgotPasswordWithOAuthCheck(email, function(error){
      if(error) {
        if(error.details && error.details.servicesFound) {
          alert("You have an account with one of these services: " + error.servicesFound.join(', '));
        } else {
          alert("No account found with this adress");
        }
      } else {
        alert("Email sent !")
      }
    });
  }  
});
```
