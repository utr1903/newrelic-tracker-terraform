##################
### Dashboards ###
##################

# Host
resource "newrelic_one_dashboard" "host" {
  name = "Ugur - Hosts Overview"

  page {
    name = "Overview"

    # Page description
    widget_markdown {
      title  = "Page description"
      column = 1
      row    = 1
      width  = 3
      height = 3

      text = "## Host Monitoring\n\nThis dashboard is meant to provide detailed insights about all of the hosts within the account.\n\nFor each aspect of a host (CPU, MEM...), you can find a dedicated page and per the dashboard variable, you can filter out one or many hosts which you would like to investigate."
    }

    # Host info
    widget_table {
      title  = "Host info"
      column = 4
      row    = 1
      width  = 5
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT latest(operatingSystem) AS `os`, latest(linuxDistribution) AS `distro`, latest(uptime)/60/60/24 AS `upDays`, latest(agentVersion) AS `nrVersion` FACET hostname WHERE hostname IN ({{hostnames}})"
      }
    }

    # Host capacity
    widget_table {
      title  = "Host capacity"
      column = 9
      row    = 1
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT latest(processorCount) AS `cores (count)`, latest(memoryTotalBytes)/1e9 AS `memory (GB)`, latest(diskTotalBytes)/1e9 AS `disk (GB)` FACET hostname WHERE hostname IN ({{hostnames}})"
      }
    }

    # CPU utilization (%)
    widget_table {
      title  = "CPU utilization (%)"
      column = 1
      row    = 4
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(host.cpuPercent) AS `max`, average(host.cpuPercent) AS `avg` FACET host.hostname WHERE host.hostname IN ({{hostnames}})"
      }
    }

    # MEM utilization (%)
    widget_table {
      title  = "MEM utilization (%)"
      column = 5
      row    = 4
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(host.memoryUsedPercent) AS `max`, average(host.memoryUsedPercent) AS `avg` FACET host.hostname WHERE host.hostname IN ({{hostnames}})"
      }
    }

    # STO utilization (%)
    widget_table {
      title  = "STO utilization (%)"
      column = 9
      row    = 4
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(host.diskUtilizationPercent) AS `max`, average(host.diskUtilizationPercent) AS `avg` FACET host.hostname WHERE host.hostname IN ({{hostnames}})"
      }
    }
  }

  page {
    name = "CPU"

    # Max total CPU utilization (%)
    widget_bar {
      title  = "Max total CPU utilization (%)"
      column = 1
      row    = 1
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(host.cpuPercent) AS `max` FACET host.hostname WHERE host.hostname IN ({{hostnames}})"
      }
    }

    # Total CPU utilization (%)
    widget_line {
      title  = "Total CPU utilization (%)"
      column = 4
      row    = 1
      width  = 9
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.cpuPercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }

    # Max idle CPU utilization (%)
    widget_bar {
      title  = "Max idle CPU utilization (%)"
      column = 1
      row    = 4
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(host.cpuIdlePercent) AS `max` FACET host.hostname WHERE host.hostname IN ({{hostnames}})"
      }
    }

    # Idle CPU utilization (%)
    widget_line {
      title  = "Idle CPU utilization (%)"
      column = 4
      row    = 4
      width  = 9
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.cpuIdlePercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }

    # Max I/O wait CPU utilization (%)
    widget_bar {
      title  = "Max I/O wait CPU utilization (%)"
      column = 1
      row    = 4
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(host.cpuIoWaitPercent) AS `max` FACET host.hostname WHERE host.hostname IN ({{hostnames}})"
      }
    }

    # I/O wait CPU utilization (%)
    widget_line {
      title  = "I/O wait CPU utilization (%)"
      column = 4
      row    = 4
      width  = 9
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.cpuIoWaitPercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }

    # Max steal CPU utilization (%)
    widget_bar {
      title  = "Max steal CPU utilization (%)"
      column = 1
      row    = 7
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(host.cpuStealPercent) AS `max` FACET host.hostname WHERE host.hostname IN ({{hostnames}})"
      }
    }

    # Steal CPU utilization (%)
    widget_line {
      title  = "Steal CPU utilization (%)"
      column = 4
      row    = 7
      width  = 9
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.cpuStealPercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }

    # Max system CPU utilization (%)
    widget_bar {
      title  = "Max system CPU utilization (%)"
      column = 1
      row    = 10
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(host.cpuSystemPercent) AS `max` FACET host.hostname WHERE host.hostname IN ({{hostnames}})"
      }
    }

    # System CPU utilization (%)
    widget_line {
      title  = "System CPU utilization (%)"
      column = 4
      row    = 10
      width  = 9
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.cpuSystemPercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }

    # Max user CPU utilization (%)
    widget_bar {
      title  = "Max user CPU utilization (%)"
      column = 1
      row    = 13
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(host.cpuUserPercent) AS `max` FACET host.hostname WHERE host.hostname IN ({{hostnames}})"
      }
    }

    # System CPU utilization (%)
    widget_line {
      title  = "System CPU utilization (%)"
      column = 4
      row    = 13
      width  = 9
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.cpuUserPercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }
  }

  page {
    name = "Memory"

    # Max MEM utilization (%)
    widget_bar {
      title  = "Max MEM utilization (%)"
      column = 1
      row    = 7
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(host.memoryUsedPercent) AS `max` FACET host.hostname WHERE host.hostname IN ({{hostnames}})"
      }
    }

    # MEM utilization (%)
    widget_line {
      title  = "MEM utilization (%)"
      column = 4
      row    = 7
      width  = 9
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.memoryUsedPercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }
  }

  page {
    name = "Storage"

    # Max STO utilization (%)
    widget_bar {
      title  = "Max STO utilization (%)"
      column = 1
      row    = 7
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(host.memoryUsedPercent) AS `max` FACET host.hostname WHERE host.hostname IN ({{hostnames}})"
      }
    }

    # STO utilization (%)
    widget_line {
      title  = "STO utilization (%)"
      column = 4
      row    = 7
      width  = 9
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.memoryUsedPercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }
  }

  # page {
  #   name = "Network"
  # }

  # page {
  #   name = "Process"
  # }

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
