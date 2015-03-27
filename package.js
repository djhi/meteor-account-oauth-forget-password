Package.describe({
  name: 'gildaspk:meteor-account-oauth-forget-password',
  version: '0.0.1',
  summary: 'Check for existing oauth account when user try to recover forgotten password',
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.5');
  api.use('coffeescript', ['client', 'server']);
  api.use('accounts-base', ['client', 'server']);
  api.use('service-configuration', ['client', 'server']);

  // Export Accounts (etc) to packages using this one.
  api.imply('accounts-base', ['client', 'server']);
  api.imply('service-configuration', ['client', 'server']);

  api.addFiles('meteor-account-oauth-forget-password-client.coffee', ['client']);
  api.addFiles('meteor-account-oauth-forget-password-server.coffee', ['server']);
  api.export('AccountOAuthCheck');
});

Package.onTest(function(api) {
  api.use('tinytest', ['client', 'server']);
  api.use('coffeescript', ['client', 'server']);

  api.use('gildaspk:meteor-account-oauth-forget-password');
  api.addFiles('meteor-account-oauth-forget-password-tests.coffee', 'server');
});
