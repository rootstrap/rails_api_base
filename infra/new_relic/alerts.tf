terraform {
  required_version = "~> 1.0"

  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.0"
    }
  }
}

# We use env variables to configure the provider
provider "newrelic" {}

# Must be an exact match to your application name in New Relic
variable "app_name" {
  type = list(string)
  description = "List of New Relic application names."
  default = [
    "rails_api_base - development"
  ]
}

variable "account_id" {
  type = number
  description = "New Relic account ID."
}

# List of endpoints to monitor for latency
variable "endpoints" {
  type = list(string)
  description = "List of endpoint URIs to create P95 alert conditions for."
  default = []
}

# Map of endpoint-specific thresholds (in seconds)
variable "endpoint_thresholds" {
  type = map(object({
    p90 = optional(number)
    p95 = optional(number)
  }))
  description = "Map of endpoint URIs to custom P90/P95 thresholds. If not set, uses default threshold."
  default = {
    "/api/v1/orders" = { p90 = 2.0, p95 = 3.0 }
    "/api/v1/users"  = { p90 = 1.5 } # Only override P90, use default for P95
  }
}

data "newrelic_entity" "app" {
  for_each = toset(var.app_name)
  name   = each.value
  domain = "APM"
  type   = "APPLICATION"
}

resource "newrelic_alert_policy" "golden_metrics_policy" {
  for_each = toset(var.app_name)
  name = "Golden Signals - ${each.value}"
}

resource "newrelic_alert_policy" "percentiles_policy" {
  for_each = toset(var.app_name)
  name = "Percentiles - ${each.value}"
}

# Response time - Create Alert Condition
resource "newrelic_nrql_alert_condition" "response_time_alert" {
  for_each = toset(var.app_name)
  policy_id = newrelic_alert_policy.golden_metrics_policy[each.value].id
  type = "static"
  name = "Response Time - ${each.value}"
  description = "High Transaction Response Time"
  enabled = true
  violation_time_limit_seconds = 259200 # 3 days

  nrql {
    query = "SELECT average(duration) FROM Transaction WHERE appName = '${each.value}'"
  }

  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
}

# Throughput condition
resource "newrelic_nrql_alert_condition" "low_throughput" {
  for_each = toset(var.app_name)
  policy_id = newrelic_alert_policy.golden_metrics_policy[each.value].id
  type = "static"
  name = "Low Throughput - ${each.value}"
  description = "Low Throughput"
  enabled = true
  violation_time_limit_seconds = 259200 # 3 days

  nrql {
    query = "FROM Transaction SELECT rate(count(*), 1 minute) WHERE appName = '${each.value}'"
  }

  critical {
    threshold = 5
    threshold_duration = 300
    threshold_occurrences = "ALL"
    operator = "below"
  }
}

# Error rate condition
resource "newrelic_nrql_alert_condition" "error_rate" {
  for_each = toset(var.app_name)
  policy_id = newrelic_alert_policy.golden_metrics_policy[each.value].id
  type = "static"
  name = "High Error Rate - ${each.value}"
  description = "High Error Rate"
  enabled = true
  violation_time_limit_seconds = 259200 # 3 days

  nrql {
    query = "SELECT (filter(count(*), WHERE error IS true) / count(*)) * 100 AS 'error_rate' FROM Transaction WHERE appName = '${each.value}'"
  }

  critical {
    threshold = 5
    threshold_duration = 60
    threshold_occurrences = "ALL"
    operator = "above"
  }
}

#######################################
#          P90 and P95 Alerts        #
#######################################

# Global P90 Alert
resource "newrelic_nrql_alert_condition" "p90_alert" {
  for_each = toset(var.app_name)
  policy_id = newrelic_alert_policy.percentiles_policy[each.value].id
  type = "static"
  name = "P90 Alert - ${each.value}"
  description = "P90 Alert"
  enabled = true
  violation_time_limit_seconds = 259200 # 3 days

  nrql {
    query = "SELECT percentile(duration, 90) FROM Transaction WHERE appName = '${each.value}'"
  }

  critical {
    threshold = 1.5 # Recommended starting value, see below
    threshold_duration = 60
    threshold_occurrences = "ALL"
    operator = "above"
  }
}

# Global P95 Alert
resource "newrelic_nrql_alert_condition" "p95_alert" {
  for_each = toset(var.app_name)
  policy_id = newrelic_alert_policy.percentiles_policy[each.value].id
  type = "static"
  name = "P95 Alert - ${each.value}"
  description = "P95 Alert"
  enabled = true
  violation_time_limit_seconds = 259200 # 3 days

  nrql {
    query = "SELECT percentile(duration, 95) FROM Transaction WHERE appName = '${each.value}'"
  }

  critical {
    threshold = 5
    threshold_duration = 60
    threshold_occurrences = "ALL"
    operator = "above"
  }
}

# Per-endpoint P90 Alert
resource "newrelic_nrql_alert_condition" "endpoint_p90" {
  for_each = { for pair in flatten([for app in var.app_name : [for endpoint in var.endpoints : { app = app, endpoint = endpoint }]]) : "${pair.app}|${pair.endpoint}" => pair }
  policy_id = newrelic_alert_policy.percentiles_policy[each.value.app].id
  type = "static"
  name = "P90 Alert - ${each.value.app} - ${each.value.endpoint}"
  description = "P90 Alert for endpoint ${each.value.endpoint}"
  enabled = true
  violation_time_limit_seconds = 259200 # 3 days

  nrql {
    query = "SELECT percentile(duration, 90) FROM Transaction WHERE appName = '${each.value.app}' AND request.uri = '${each.value.endpoint}'"
  }

  critical {
    threshold = lookup(try(var.endpoint_thresholds[each.value.endpoint].p90, null), each.value.endpoint, 1.5)
    threshold_duration = 60
    threshold_occurrences = "ALL"
    operator = "above"
  }
}

# Per-endpoint P95 Alert
resource "newrelic_nrql_alert_condition" "endpoint_p95" {
  for_each = { for pair in flatten([for app in var.app_name : [for endpoint in var.endpoints : { app = app, endpoint = endpoint }]]) : "${pair.app}|${pair.endpoint}" => pair }
  policy_id = newrelic_alert_policy.percentiles_policy[each.value.app].id
  type = "static"
  name = "P95 Alert - ${each.value.app} - ${each.value.endpoint}"
  description = "P95 Alert for endpoint ${each.value.endpoint}"
  enabled = true
  violation_time_limit_seconds = 259200 # 3 days

  nrql {
    query = "SELECT percentile(duration, 95) FROM Transaction WHERE appName = '${each.value.app}' AND request.uri = '${each.value.endpoint}'"
  }

  critical {
    threshold = lookup(try(var.endpoint_thresholds[each.value.endpoint].p95, null), each.value.endpoint, 2.5)
    threshold_duration = 60
    threshold_occurrences = "ALL"
    operator = "above"
  }
}

#######################################
#             DASHBOARDS              #
#######################################
resource "newrelic_one_dashboard" "exampledash" {
  name        = "New Relic Terraform Example"
  permissions = "private"

  page {
    name = "New Relic Terraform Example"

    widget_billboard {
      title  = "Requests per minute"
      row    = 1
      column = 1
      width  = 6
      height = 3

      refresh_rate = 60000 // 60 seconds

      data_format {
        name = "rate"
        type = "recent-relative"
      }

      nrql_query {
        query = "FROM Transaction SELECT rate(count(*), 1 minute)"
      }
    }

     widget_bar {
       title  = "Average transaction duration, by application"
       row    = 1
       column = 7
       width  = 6
       height = 3

       nrql_query {
         query      = "FROM Transaction SELECT average(duration) FACET appName"
       }
     }

    # widget_bar {
    #   title  = "Average transaction duration, by application"
    #   row    = 4
    #   column = 1
    #   width  = 6
    #   height = 3

    #   refresh_rate = 300000 // 5 minutes

    #   nrql_query {
    #     query      = "FROM Transaction SELECT average(duration) FACET appName"
    #   }

    #   # Must be another dashboard GUID
    #   filter_current_dashboard = true

    #   # color customization
    #   colors {
    #     color = "#722727"
    #     series_overrides {
    #       color = "#722322"
    #       series_name = "Node"
    #     }
    #     series_overrides {
    #       color = "#236f70"
    #       series_name = "Java"
    #     }
    #   }
    # }

    widget_line {
      title  = "Average transaction duration and the request per minute, by application"
      row    = 4
      column = 7
      width  = 6
      height = 3

      refresh_rate = 30000 // 30 seconds

      nrql_query {
        query      = "FROM Transaction select max(duration) as 'max duration' where httpResponseCode = '504' timeseries since 5 minutes ago"
      }

      nrql_query {
        query = "FROM Transaction SELECT rate(count(*), 1 minute)"
      }
      legend_enabled = true
      ignore_time_range = false
      y_axis_left_zero = true
      y_axis_left_min = 0
      y_axis_left_max = 1

      y_axis_right {
        y_axis_right_zero   = true
        y_axis_right_min    = 0
        y_axis_right_max    = 300
        y_axis_right_series = ["A", "B"]
      }

      is_label_visible = true

      threshold {
        name     = "Duration Threshold"
        from     = 1
        to       = 2
        severity = "critical"
      }

      threshold {
        name     = "Duration Threshold Two"
        from     = 2.1
        to       = 3.3
        severity = "warning"
      }

      units {
        unit = "ms"
        series_overrides {
          unit = "ms"
          series_name = "max duration"
        }
      }


    }

    # widget_markdown {
    #   title  = "Dashboard Note"
    #   row    = 7
    #   column = 1
    #   width  = 12
    #   height = 3

    #   text = "### Helpful Links\n\n* [New Relic One](https://one.newrelic.com)\n* [Developer Portal](https://developer.newrelic.com)"
    # }

#     widget_line {
#       title = "Overall CPU % Statistics"
#       row = 1
#       column = 5
#       height = 3
#       width = 4

#       nrql_query {
#         query = <<EOT
# SELECT average(cpuSystemPercent), average(cpuUserPercent), average(cpuIdlePercent), average(cpuIOWaitPercent) FROM SystemSample SINCE 1 hour ago TIMESERIES
# EOT
#       }
#       facet_show_other_series = false
#       legend_enabled = true
#       ignore_time_range = false
#       y_axis_left_zero = true
#       y_axis_left_min = 0
#       y_axis_left_max = 0
#       null_values {
#         null_value = "default"

#         series_overrides {
#           null_value = "remove"
#           series_name = "Avg Cpu User Percent"
#         }

#         series_overrides {
#           null_value = "zero"
#           series_name = "Avg Cpu Idle Percent"
#         }

#         series_overrides {
#           null_value = "default"
#           series_name = "Avg Cpu IO Wait Percent"
#         }

#         series_overrides {
#           null_value = "preserve"
#           series_name = "Avg Cpu System Percent"
#         }
#       }
#     }
  }

  variable {
      default_values     = ["value"]
      is_multi_selection = true
      item {
        title = "item"
        value = "ITEM"
      }
      name = "app_name"
      nrql_query {
        account_ids = [var.account_id]
        query       = "FROM Transaction SELECT distinct(appName)"
      }
      replacement_strategy = "default"
      title                = "app_name"
      type                 = "nrql"
  }
}


#######################################
#          NOTIFICATIONS              #
#######################################

resource "newrelic_notification_destination" "email_destination" {
  for_each = toset(var.app_name)
  name = "Email destination - ${each.value}"
  type = "EMAIL"

  property {
    key = "email"
    value = "julian.pasquale@rootstrap.com,ignacio.perez@rootstrap.com"
  }
}

resource "newrelic_notification_channel" "email_channel" {
  for_each = toset(var.app_name)
  name = "Email channel - ${each.value}"
  type = "EMAIL"
  destination_id = newrelic_notification_destination.email_destination[each.value].id
  product = "IINT"

  property {
    key = "subject"
    value = "New Alert"
  }
}

resource "newrelic_workflow" "workflow" {
  for_each = toset(var.app_name)
  name = "Workflow - ${each.value}"
  enabled = true
  muting_rules_handling = "NOTIFY_ALL_ISSUES"

  issues_filter {
    name = "Filter - ${each.value}"
    type = "FILTER"

    predicate {
      attribute = "accumulations.policyName"
      operator = "EXACTLY_MATCHES"
      values = [
        newrelic_alert_policy.golden_metrics_policy[each.value].name,
        newrelic_alert_policy.percentiles_policy[each.value].name
      ]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.email_channel[each.value].id
  }
}
