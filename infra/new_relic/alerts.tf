variable "newrelic_account_id" {
  type = string
}

variable "newrelic_api_key" {
  type = string
}

variable "newrelic_region" {
  type = string
  default = "US"
}

variable "app_name" {
  type = string
}

# TODO:
# Add names for different environments

provider "newrelic" {
  account_id = var.newrelic_account_id
  api_key    = var.newrelic_api_key
  region     = var.newrelic_region
}

# Define your alert policy
resource "newrelic_alert_policy" "golden_metrics_policy" {
  name = "Golden Metrics Alert Policy"
}

# Error rate condition
resource "newrelic_nrql_alert_condition" "error_rate" {
  policy_id = newrelic_alert_policy.golden_metrics_policy.id
  name      = "High Error Rate"
  type      = "static"

  nrql {
    query = "FROM Transaction SELECT percentage(count(*), WHERE error IS true) AS 'error_rate' WHERE appName = '${var.app_name}'"
  }

  terms {
    threshold      = 5
    threshold_duration = 300
    threshold_occurrences = "ALL"
    operator       = "above"
    priority       = "critical"
  }

  signal {
    aggregation_window = 60
    aggregation_method = "event_flow"
  }

  enabled = true
}

# Response time condition
resource "newrelic_nrql_alert_condition" "response_time" {
  policy_id = newrelic_alert_policy.golden_metrics_policy.id
  name      = "High Response Time"
  type      = "static"

  nrql {
    query = "FROM Transaction SELECT average(duration) WHERE appName = '${var.app_name}'"
  }

  terms {
    threshold      = 1.5
    threshold_duration = 300
    threshold_occurrences = "ALL"
    operator       = "above"
    priority       = "critical"
  }

  signal {
    aggregation_window = 60
    aggregation_method = "event_flow"
  }

  enabled = true
}

# Throughput condition
resource "newrelic_nrql_alert_condition" "low_throughput" {
  policy_id = newrelic_alert_policy.golden_metrics_policy.id
  name      = "Low Throughput"
  type      = "static"

  nrql {
    query = "FROM Transaction SELECT rate(count(*), 1 minute) WHERE appName = '${var.app_name}'"
  }

  terms {
    threshold      = 1
    threshold_duration = 300
    threshold_occurrences = "ALL"
    operator       = "below"
    priority       = "warning"
  }

  signal {
    aggregation_window = 60
    aggregation_method = "event_flow"
  }

  enabled = true
}

# Apdex condition
resource "newrelic_nrql_alert_condition" "apdex" {
  policy_id = newrelic_alert_policy.golden_metrics_policy.id
  name      = "Low Apdex Score"
  type      = "static"

  nrql {
    query = "FROM Transaction SELECT apdex(duration, t:0.5) WHERE appName = '${var.app_name}'"
  }

  terms {
    threshold      = 0.85
    threshold_duration = 300
    threshold_occurrences = "ALL"
    operator       = "below"
    priority       = "critical"
  }

  signal {
    aggregation_window = 60
    aggregation_method = "event_flow"
  }

  enabled = true
}
