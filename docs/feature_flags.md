# Feature Flags

## Intro

The Rootstrap Rails API Base allows developers to define feature flags, which are essentially boolean variables representing whether a particular feature or piece of code should be enabled or disabled. These flags can be easily controlled without requiring code changes or redeployment.
Feature flags can be set at different levels of granularity, such as for individual users, user groups, or percentage-based rollouts. This allows for controlled feature releases and gradual rollouts.
Our feature flag implementation is based on Flipper. To learn more about Flipper, please visit the following website: [Flipper Documentation](https://www.flippercloud.io/docs/introduction)

## Best practices and benefits of using feature flags

Feature flags are not intended to be user-editable. Instead, they are intended as a tool for Engineers and Site Reliability Engineers to use to de-risk their changes. Feature flags are the shim that gets us to Continuous Delivery with our monorepo and without having to deploy the entire codebase on every change. Feature flags are created to ensure that we can safely rollout our work on our terms. If we use Feature Flags as a configuration, we are doing it wrong and are indeed in violation of our principles. If something needs to be configured, we should intentionally make it configuration from the first moment.

To learn more about best practices and the benefits of using feature flags, please take a look at this [article](https://about.gitlab.com/handbook/product-development-flow/feature-flag-lifecycle/#the-benefits-of-feature-flags)

## Flipper Configuration

We have taken care of all aspects of the Flipper configuration, and the Feature Flags system is ready to use. However, we understand that some users might have different needs. Flipper configuration can be find in the following files:

- `config/routes.rb` => Mounts the Flipper UI and restricts access to admin_user.
- `config/initializers/active_admin.rb` => Adds a link in `active_admin` to the Flipper UI.
- `config/initializers/flipper.rb` => Enables the inclusion of a description for every feature flag.
- `config/feature-flags.yml` => List of all registered feature flags in the system.
- `spec/rails_helper.rb` => Configures the Memory adapter for use in the testing environment.


## Set Up Feature Flags

1. [DEV ENVIRONMENT] Register your feature flag in `config/feature-flags.yml`, adhering to the format specified in that file.
2. [DEV ENVIRONMENT] Restart your server.

## Monitoring and Managing Feature Flags

To monitor and manage feature flags, we recommend using the Flipper UI, which can be accessed through `active_admin` or at this path: `/admin/feature-flags/`

## Use Feature Flags in Your Application

```
    Flipper.enabled?(:feature_flag) Checks if the feature flag is globally enabled.
    Flipper.enabled?(:feature_flag, user) Checks if the feature is enabled at the user level.
```
For more examples, please visit [Flipper documentation](https://www.flippercloud.io/docs/features).

## Deploy

The Rootstrap Rails API base utilizes the `bin/release.sh` script to execute `lib/tasks/feature_flags.rake` on every release. This rake task registers non-existing feature flags based on the list in config/feature-flags.yml. This approach eliminates the need for developers to manually register feature flags in the production environment, as registering them in the local environment is sufficient.

## Testing

Testing new code behind a feature flag is straightforward; developers only need to enable the feature flag before running the test. 
Here's an example:

```
 context 'when test_feature_flag is on' do
    before { Flipper.enable(:test_feature_flag) }

    it do
      expect(feature).to match_behavior_behind_the_feature_flag
      expect(Flipper).to be_enabled(:test_feature_flag)
    end
 end
```

No need to reset the feature flag state; our system already resets the Flipper instance before each test. This ensures that all tests start in a fresh state.
