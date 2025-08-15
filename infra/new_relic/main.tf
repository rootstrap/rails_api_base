terraform {
  required_version = "~> 1.0"

  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.0"
    }
  }
}

locals {
  transactions_per_environment = {
    # Example:
    # "Admin Users Index" = {
    #   transaction_name      = "Controller/admin/admin_users/index"
    #   p90_latency_threshold = 0.2
    # }
  }
  # Must be an exact match to your application name in New Relic
  app_name             = "rails_api_base"
  app_environments     = ["development", "staging", "production"]
  slack_channel_id     = "your-slack-channel-id"
  slack_destination_id = "your-slack-destination-id"
  devs_emails          = ["devs@example.com"]

  app_names = [
    for env in local.app_environments : "${local.app_name} - ${env}"
  ]
  transactions = flatten([
    for app in local.app_names : [
      for t_k, t_v in local.transactions_per_environment : merge({
        app_name      = app,
        friendly_name = t_k
      }, t_v)
    ]
  ])
}

# We use env variables to configure the provider
provider "newrelic" {}

data "newrelic_entity" "app" {
  for_each = toset(local.app_names)
  name     = each.value
  domain   = "APM"
  type     = "APPLICATION"
}

data "newrelic_account" "account" {
  # This will use the current account based on the API key
}

resource "newrelic_alert_policy" "rails_app_policy" {
  for_each = toset(local.app_names)
  name     = "Rails app policy - ${each.value}"
}

# Error rate condition
resource "newrelic_nrql_alert_condition" "error_alert" {
  for_each                     = toset(local.app_names)
  policy_id                    = newrelic_alert_policy.rails_app_policy[each.value].id
  type                         = "static"
  name                         = "Error alert - ${each.value}"
  description                  = "Error Alert"
  enabled                      = true
  violation_time_limit_seconds = 259200 # 3 days

  nrql {
    query = "SELECT count(*) FROM Transaction WHERE error IS true AND appName = '${each.value}'"
  }

  critical {
    threshold             = 1
    threshold_duration    = 60
    threshold_occurrences = "ALL"
    operator              = "above_or_equals"
  }
}

#######################################
#          P90 and P95 Alerts        #
#######################################

# Global P90 Alert
resource "newrelic_nrql_alert_condition" "p90_latency_alert" {
  for_each                     = toset(local.app_names)
  policy_id                    = newrelic_alert_policy.rails_app_policy[each.value].id
  type                         = "static"
  name                         = "P90 Response Time - ${each.value}"
  description                  = "High P90 Response Time"
  enabled                      = true
  violation_time_limit_seconds = 259200 # 3 days

  nrql {
    query = "SELECT percentile(duration, 90) FROM Transaction WHERE appName = '${each.value}' AND transactionType = 'Web'"
  }

  critical {
    operator              = "above"
    threshold             = 1
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
}

# Global P95 Alert
resource "newrelic_nrql_alert_condition" "p95_alert" {
  for_each                     = toset(local.app_names)
  policy_id                    = newrelic_alert_policy.rails_app_policy[each.value].id
  type                         = "static"
  name                         = "P95 Response Time - ${each.value}"
  description                  = "High P95 Response Time"
  enabled                      = true
  violation_time_limit_seconds = 259200 # 3 days

  nrql {
    query = "SELECT percentile(duration, 95) FROM Transaction WHERE appName = '${each.value}' AND transactionType = 'Web'"
  }

  critical {
    threshold             = 1
    threshold_duration    = 300
    threshold_occurrences = "ALL"
    operator              = "above"
  }
}

# Generate a P90 alert for each transaction defined in locals.transactions
resource "newrelic_nrql_alert_condition" "transaction_p90_alert" {
  for_each                     = { for t in local.transactions : "${t.app_name}|${t.transaction_name}" => t }
  policy_id                    = newrelic_alert_policy.rails_app_policy[each.value.app_name].id
  type                         = "static"
  name                         = "P90 Alert on ${each.value.friendly_name} - ${each.value.app_name}"
  description                  = "P90 Alert on ${each.value.transaction_name} in ${each.value.app_name}"
  enabled                      = true
  violation_time_limit_seconds = 259200 # 3 days

  nrql {
    query = "SELECT percentile(duration, 90) FROM Transaction WHERE appName = '${each.value.app_name}' AND name = '${each.value.transaction_name}' AND transactionType = 'Web'"
  }

  critical {
    threshold             = each.value.p90_latency_threshold
    threshold_duration    = 300
    threshold_occurrences = "ALL"
    operator              = "above"
  }
}

#######################################
#             DASHBOARDS              #
#######################################

resource "newrelic_one_dashboard_json" "activerecord_dashboard" {
  for_each = toset(local.app_names)
  json = templatefile("${path.module}/dashboard.json.tftpl", {
    app_name   = each.value,
    account_id = data.newrelic_account.account.id
  })
}

#######################################
#          NOTIFICATIONS              #
#######################################

resource "newrelic_notification_destination" "email_destination" {
  for_each = toset(local.app_names)
  name     = "Email destination - ${each.value}"
  type     = "EMAIL"

  property {
    key   = "email"
    value = join(",", local.devs_emails)
  }
}

resource "newrelic_notification_channel" "email_channel" {
  for_each       = toset(local.app_names)
  name           = "Email channel - ${each.value}"
  type           = "EMAIL"
  destination_id = newrelic_notification_destination.email_destination[each.value].id
  product        = "IINT"

  property {
    key   = "subject"
    value = "New Alert"
  }
}

resource "newrelic_workflow" "workflow" {
  for_each              = toset(local.app_names)
  name                  = "Workflow - ${each.value}"
  enabled               = true
  muting_rules_handling = "NOTIFY_ALL_ISSUES"

  issues_filter {
    name = "Filter - ${each.value}"
    type = "FILTER"

    predicate {
      attribute = "accumulations.policyName"
      operator  = "EXACTLY_MATCHES"
      values = [
        for app in local.app_names : newrelic_alert_policy.rails_app_policy[app].name
      ]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.email_channel[each.value].id
  }
}
resource "newrelic_notification_channel" "slack_channel" {
  name           = "Slack channel"
  type           = "SLACK"
  destination_id = local.slack_destination_id
  product        = "IINT"

  property {
    key   = "channelId"
    value = local.slack_channel_id
  }
}

resource "newrelic_workflow" "slack_workflow" {
  name                  = "Slack workflow"
  enabled               = true
  muting_rules_handling = "NOTIFY_ALL_ISSUES"

  issues_filter {
    name = "Filter"
    type = "FILTER"

    predicate {
      attribute = "accumulations.policyName"
      operator  = "EXACTLY_MATCHES"
      values = [
        for app in local.app_names : newrelic_alert_policy.rails_app_policy[app].name
      ]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.slack_channel.id
  }
}
