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

    # Total CPU utilization (%)
    widget_markdown {
      title  = "Total CPU utilization (%)"
      column = 1
      row    = 1
      width  = 3
      height = 3

      text = "Total CPU utilization as a percentage. This is not an actual recorded value; it is an alias that combines percentage data from `cpuSystemPercent`, `cpuUserPercent`, `cpuIoWaitPercent` and `cpuStealPercent`.\n\nThis is calculated as:\n\n`(cpuUserPercent + cpuSystemPercent + cpuIOWaitPercent + cpuStealPercent)`"
    }

    # Max total CPU utilization (%)
    widget_bar {
      title  = "Max total CPU utilization (%)"
      column = 4
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
      column = 7
      row    = 1
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.cpuPercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }

    # Idle CPU utilization (%)
    widget_markdown {
      title  = "Idle CPU utilization (%)"
      column = 1
      row    = 4
      width  = 3
      height = 3

      text = "The portion of the current CPU utilization capacity that is idle.\n\nThis is calculated as:\n\n`(100.00 - cpuUserPercent - cpuSystemPercent - cpuIOWaitPercent) / elapsed_time`"
    }

    # Max idle CPU utilization (%)
    widget_bar {
      title  = "Max idle CPU utilization (%)"
      column = 4
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
      column = 7
      row    = 4
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.cpuIdlePercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }

    # I/O wait CPU utilization (%)
    widget_markdown {
      title  = "I/O wait CPU utilization (%)"
      column = 1
      row    = 7
      width  = 3
      height = 3

      text = "The portion of the current CPU utilization composed only of I/O wait time usage.\n\nThis is calculated as:\n\n`current_sample_io_time - previous_sample_io_time) / elapsed_time`"
    }

    # Max I/O wait CPU utilization (%)
    widget_bar {
      title  = "Max I/O wait CPU utilization (%)"
      column = 4
      row    = 7
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
      column = 7
      row    = 7
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.cpuIoWaitPercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }

    # Steal CPU utilization (%)
    widget_markdown {
      title  = "Steal CPU utilization (%)"
      column = 1
      row    = 10
      width  = 3
      height = 3

      text = "The portion of time when a virtualized CPU is waiting for the hypervisor to make real CPU time available to it."
    }

    # Max steal CPU utilization (%)
    widget_bar {
      title  = "Max steal CPU utilization (%)"
      column = 4
      row    = 10
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
      column = 7
      row    = 10
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.cpuStealPercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }

    # System CPU utilization (%)
    widget_markdown {
      title  = "System CPU utilization (%)"
      column = 1
      row    = 13
      width  = 3
      height = 3

      text = "The portion of the current CPU utilization composed only of system time usage.\n\nThis is calculated as:\n\n`(current_sample_sys_time - previous_sample_sys_time) / elapsed_time`"
    }

    # Max system CPU utilization (%)
    widget_bar {
      title  = "Max system CPU utilization (%)"
      column = 4
      row    = 13
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
      column = 7
      row    = 13
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.cpuSystemPercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }

    # User CPU utilization (%)
    widget_markdown {
      title  = "User CPU utilization (%)"
      column = 1
      row    = 16
      width  = 3
      height = 3

      text = "The portion of the current CPU utilization composed only of user time usage.\nThis is calculated as:\n\n`current_sample_user_time - previous_sample_user_time) / elapsed_time`"
    }

    # Max user CPU utilization (%)
    widget_bar {
      title  = "Max user CPU utilization (%)"
      column = 4
      row    = 16
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
      column = 7
      row    = 16
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.cpuUserPercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }
  }

  page {
    name = "Memory"

    # MEM utilization (%)
    widget_markdown {
      title  = "MEM utilization (%)"
      column = 1
      row    = 1
      width  = 3
      height = 3

      text = "The portion of available memory that is in use on this server, in percentage.\n\nThe higher the used space is,\n- the more you are benefiting from the host\n- the less free space you have in case of higher memory allocation (you can consider scaling up)"
    }

    # Max MEM utilization (%)
    widget_bar {
      title  = "Max MEM utilization (%)"
      column = 4
      row    = 1
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
      column = 7
      row    = 1
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.memoryUsedPercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }

    # MEM free (%)
    widget_markdown {
      title  = "MEM free (%)"
      column = 1
      row    = 4
      width  = 3
      height = 3

      text = "The portion of free memory available to this server, in percentage.\n\nThe higher the free space is,\n- the more applications you can allocate on the host\n- the less you are benefiting from the host (you can consider shutting it down)"
    }

    # Max MEM free (%)
    widget_bar {
      title  = "Max MEM free (%)"
      column = 4
      row    = 4
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(host.memoryFreePercent) AS `max` FACET host.hostname WHERE host.hostname IN ({{hostnames}})"
      }
    }

    # MEM free (%)
    widget_line {
      title  = "MEM free (%)"
      column = 7
      row    = 4
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.memoryFreePercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }
  }

  page {
    name = "Storage"

    # STO utilization (%)
    widget_markdown {
      title  = "STO utilization (%)"
      column = 1
      row    = 1
      width  = 3
      height = 3

      text = "The cumulative disk fullness percentage across all supported devices.\n\nThe higher the used space is,\n- the more you are benefiting from your storage\n- the less free space you have for storing critical data (you can consider adding more storage devices)"
    }

    # Max STO utilization (%)
    widget_bar {
      title  = "Max STO utilization (%)"
      column = 4
      row    = 1
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(host.disk.usedPercent) AS `max` FACET host.hostname WHERE host.hostname IN ({{hostnames}})"
      }
    }

    # STO utilization (%)
    widget_line {
      title  = "STO utilization (%)"
      column = 7
      row    = 1
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.disk.usedPercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }

    # STO free (%)
    widget_markdown {
      title  = "STO free (%)"
      column = 1
      row    = 4
      width  = 3
      height = 3

      text = "The cumulative disk emptiness percentage across all supported devices.\n\nThe higher the free space is,\n- the more space you have to be able to store your data\n- the less you are benefiting from the storage (you can consider removing some storage devices)"
    }

    # Max STO free (%)
    widget_bar {
      title  = "Max STO free (%)"
      column = 4
      row    = 4
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(host.disk.freePercent) AS `max` FACET host.hostname WHERE host.hostname IN ({{hostnames}})"
      }
    }

    # STO free (%)
    widget_line {
      title  = "STO free (%)"
      column = 7
      row    = 4
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.disk.freePercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }

    # STO read utilization (%)
    widget_markdown {
      title  = "STO read utilization (%)"
      column = 1
      row    = 7
      width  = 3
      height = 3

      text = "The portion of disk I/O utilization for read operations..\n\nThe higher the utilization is,\n- the more you are benefiting from the host & disk read capacity\n- the less read throughput you have left for critical high read operations (you can consider increasing read IOPS capacity)"
    }

    # Max STO read utilization (%)
    widget_bar {
      title  = "Max STO read utilization (%)"
      column = 4
      row    = 7
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(host.disk.readUtilizationPercent) AS `max` FACET host.hostname WHERE host.hostname IN ({{hostnames}})"
      }
    }

    # STO read utilization (%)
    widget_line {
      title  = "STO read utilization (%)"
      column = 7
      row    = 7
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.disk.readUtilizationPercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
      }
    }

    # STO write utilization (%)
    widget_markdown {
      title  = "STO write utilization (%)"
      column = 1
      row    = 10
      width  = 3
      height = 3

      text = "The portion of disk I/O utilization for write operations..\n\nThe higher the utilization is,\n- the more you are benefiting from the host & disk write capacity\n- the less write throughput you have left for critical high write operations (you can consider increasing write IOPS capacity)"
    }

    # Max STO write utilization (%)
    widget_bar {
      title  = "Max STO write utilization (%)"
      column = 4
      row    = 10
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(host.disk.writeUtilizationPercent) AS `max` FACET host.hostname WHERE host.hostname IN ({{hostnames}})"
      }
    }

    # STO write utilization (%)
    widget_line {
      title  = "STO write utilization (%)"
      column = 7
      row    = 10
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(host.disk.writeUtilizationPercent) FACET host.hostname WHERE host.hostname IN ({{hostnames}}) TIMESERIES"
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
