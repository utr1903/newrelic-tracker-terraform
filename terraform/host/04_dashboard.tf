##################
### Dashboards ###
##################

# Host
resource "newrelic_one_dashboard" "host" {
  name = "Host ${var.host_name}"

  page {
    name = "Overview"

    # Page description
    widget_markdown {
      title  = "Page description"
      row    = 1
      column = 1
      width  = 3
      height = 4

      text = "## Overview\n."
    }

    # Host capacity
    widget_billboard {
      title  = "Host capacity"
      row    = 1
      column = 4
      width  = 9
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT latest(processorCount) WHERE hostname = '${var.host_name}'"
      }
    }

    # # CPU utilization (%)
    # widget_area {
    #   title  = "CPU utilization (%)"
    #   row    = 1
    #   column = 4
    #   width  = 9
    #   height = 4

    #   nrql_query {
    #     account_id = var.NEW_RELIC_ACCOUNT_ID
    #     query      = "FROM SystemSample SELECT average(cpuPercent) WHERE hostname = '${var.host_name}' TIMESERIES"
    #   }
    # }

    # # Tracing by apps timeseries
    # widget_line {
    #   title  = "Tracing by apps timeseries"
    #   row    = 5
    #   column = 5
    #   width  = 8
    #   height = 4

    #   nrql_query {
    #     account_id = var.NEW_RELIC_ACCOUNT_ID
    #     query      = "FROM Span SELECT bytecountestimate()/10e8 WHERE instrumentation.provider != 'pixie' FACET entity.name LIMIT 15 SINCE 30 days ago TIMESERIES AUTO"
    #   }
    # }
  }
}
