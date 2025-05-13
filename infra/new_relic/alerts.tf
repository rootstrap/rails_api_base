variable "newrelic_account_id" {
  type = string
  default = ""
}

variable "newrelic_api_key" {
  type = string
  default = ""
}

variable "newrelic_region" {
  type = string
  default = "US"
}

variable "app_name" {
  type = string
  default = "rails_api_base - development"
}

# TODO:
# Add names for different environments

terraform {
  # Require Terraform version 1.0 (recommended)
  required_version = "~> 1.0"

  # Require the latest 2.x version of the New Relic provider
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
    }
  }
}

# https://registry.terraform.io/providers/Newrelic/Newrelic/latest/docs/guides/migration_guide_alert_conditions
provider "newrelic" {
  account_id = var.newrelic_account_id
  api_key    = var.newrelic_api_key
  region     = var.newrelic_region
}

data "newrelic_entity" "app" {
  name = var.app_name # Must be an exact match to your application name in New Relic
  domain = "APM" # or BROWSER, INFRA, MOBILE, SYNTH, depending on your entity's domain
  type = "APPLICATION"
}

resource "newrelic_alert_policy" "golden_metrics_policy" {
  name = "Golden Signals - ${data.newrelic_entity.app.name}"
}

# Response time - Create Alert Condition
resource "newrelic_nrql_alert_condition" "response_time_alert" {
  policy_id = newrelic_alert_policy.golden_metrics_policy.id
  type = "static"
  name = "Response Time - ${data.newrelic_entity.app.name}"
  description = "High Transaction Response Time"
  # runbook_url = "https://www.example.com"
  enabled = true
  violation_time_limit_seconds = 3600

  nrql {
    query = "SELECT filter(average(newrelic.timeslice.value), WHERE metricTimesliceName = 'HttpDispatcher') OR 0 FROM Metric WHERE appId IN (${data.newrelic_entity.app.application_id}) AND metricTimesliceName IN ('HttpDispatcher', 'Agent/MetricsReported/count')"
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
  policy_id = newrelic_alert_policy.golden_metrics_policy.id
  name = "Low Throughput"
  type = "static"

  nrql {
    query = "FROM Transaction SELECT rate(count(*), 1 minute) WHERE appName = '${var.app_name}'"
  }

  critical {
    threshold = 1
    threshold_duration = 300
    threshold_occurrences = "ALL"
    operator = "below"
  }

  # signal {
  #   aggregation_window = 60
  #   aggregation_method = "event_flow"
  # }

  enabled = true
}

# Error percentage
# Error rate condition
resource "newrelic_nrql_alert_condition" "error_rate" {
  policy_id = newrelic_alert_policy.golden_metrics_policy.id
  name      = "High Error Rate"
  type      = "static"

  nrql {
    query = "FROM Transaction SELECT percentage(count(*), WHERE error IS true) AS 'error_rate' WHERE appName = '${var.app_name}'"
  }

  critical {
    threshold = 5
    threshold_duration = 300
    threshold_occurrences = "ALL"
    operator = "above"
  }

  # signal {
  #   aggregation_window = 60
  #   aggregation_method = "event_flow"
  # }

  enabled = true
}

#######################################
#          NOTIFICATIONS              #
#######################################

resource "newrelic_notification_destination" "team_email_destination" {
  name = "email-notification"
  type = "EMAIL"

  property {
    key = "email"
    value = "julian.pasquale@rootstrap.com,ignacio.perez@rootstrap.com"
  }
}

resource "newrelic_notification_channel" "team_email_channel" {
  name = "email-example"
  type = "EMAIL"
  destination_id = newrelic_notification_destination.team_email_destination.id
  product = "IINT"

  property {
    key = "subject"
    value = "New Alert"
  }
}

resource "newrelic_workflow" "team_workflow" {
  name = "workflow-example"
  # enrichments_enabled = true
  # destinations_enabled = true
  enabled = true
  muting_rules_handling = "NOTIFY_ALL_ISSUES"

  #enrichments {
  #  nrql {
   #   name = "Log"
    #  configuration {
  #     query = "SELECT count(*) FROM Metric"
   #   }
 #   }
 # }

  issues_filter {
    name = "filter-example"
    type = "FILTER"

    predicate {
      attribute = "accumulations.policyName"
      operator = "EXACTLY_MATCHES"
      values = [ newrelic_alert_policy.golden_metrics_policy.name ]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.team_email_channel.id
  }
}


# # Response time condition
# resource "newrelic_nrql_alert_condition" "response_time" {
#   policy_id = newrelic_alert_policy.golden_metrics_policy.id
#   name      = "High Response Time"
#   type      = "static"

#   nrql {
#     query = "FROM Transaction SELECT average(duration) WHERE appName = '${var.app_name}'"
#   }

#   terms {
#     threshold      = 1.5
#     threshold_duration = 300
#     threshold_occurrences = "ALL"
#     operator       = "above"
#     priority       = "critical"
#   }

#   signal {
#     aggregation_window = 60
#     aggregation_method = "event_flow"
#   }

#   enabled = true
# }

# # Apdex condition
# resource "newrelic_nrql_alert_condition" "apdex" {
#   policy_id = newrelic_alert_policy.golden_metrics_policy.id
#   name      = "Low Apdex Score"
#   type      = "static"

#   nrql {
#     query = "FROM Transaction SELECT apdex(duration, t:0.5) WHERE appName = '${var.app_name}'"
#   }

#   terms {
#     threshold      = 0.85
#     threshold_duration = 300
#     threshold_occurrences = "ALL"
#     operator       = "below"
#     priority       = "critical"
#   }

#   signal {
#     aggregation_window = 60
#     aggregation_method = "event_flow"
#   }

#   enabled = true
# }
