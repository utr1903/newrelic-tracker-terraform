##################
### Dashboards ###
##################

# Host
resource "newrelic_one_dashboard" "host" {
  name = "Ugur - Hosts Overview"

  page {
    name = "System Sample"

    # Page description
    widget_markdown {
      title  = "Page description"
      column = 1
      row    = 1
      width  = 3
      height = 4

      text = "## System Sample\n."
    }

    # Host info
    widget_table {
      title  = "Host info"
      column = 4
      row    = 1
      width  = 5
      height = 2

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT latest(hostname) AS `host`, latest(linuxDistribution) AS `linuxDistro`, latest(agentName) AS `agentName`, latest(agentVersion) AS `agentVersion` FACET hostname WHERE hostname IN ({{hostnames}})"
      }
    }

    # Host capacity
    widget_table {
      title  = "Host capacity"
      column = 4
      row    = 3
      width  = 5
      height = 2

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT latest(hostname), latest(processorCount) AS `cores (count)`, latest(memoryTotalBytes)/1e9 AS `memory (GB)`, latest(diskTotalBytes)/1e9 AS `disk (GB)` FACET hostname WHERE hostname IN ({{hostnames}})"
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

  variable {
    title                = "Host Names"
    name                 = "hostnames"
    replacement_strategy = "default"
    type                 = "nrql"
    default_values       = ["*"]
    is_multi_selection   = true

    nrql_query {
      account_ids = [var.NEW_RELIC_ACCOUNT_ID]
      query       = "FROM SystemSample SELECT uniques(hostname) LIMIT MAX"
    }
  }
}
