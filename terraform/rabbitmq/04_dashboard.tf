##################
### Dashboards ###
##################

# RabbitMQ
resource "newrelic_one_dashboard" "rabbitmq" {
  name = "Ugur - RabbitMQ Overview"

  page {
    name = "Host Overview"

    # Page description
    widget_markdown {
      title  = "Page description"
      column = 1
      row    = 1
      width  = 3
      height = 3

      text = "## RabbitMQ Monitoring\n\n"
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
        query      = "FROM SystemSample SELECT latest(operatingSystem) AS `os`, latest(linuxDistribution) AS `distro`, latest(uptime)/60/60/24 AS `upDays`, latest(agentVersion) AS `nrVersion` FACET hostname WHERE hostname IN ({{rabbitmqnames}})"
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
        query      = "FROM SystemSample SELECT latest(processorCount) AS `cores (count)`, latest(memoryTotalBytes)/1e9 AS `memory (GB)`, latest(diskTotalBytes)/1e9 AS `disk (GB)` FACET hostname WHERE hostname IN ({{rabbitmqnames}})"
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
        query      = "FROM Metric SELECT max(host.cpuPercent) AS `max`, average(host.cpuPercent) AS `avg` FACET host.hostname WHERE host.hostname IN ({{rabbitmqnames}})"
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
        query      = "FROM Metric SELECT max(host.memoryUsedPercent) AS `max`, average(host.memoryUsedPercent) AS `avg` FACET host.hostname WHERE host.hostname IN ({{rabbitmqnames}})"
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
        query      = "FROM Metric SELECT max(host.diskUtilizationPercent) AS `max`, average(host.diskUtilizationPercent) AS `avg` FACET host.hostname WHERE host.hostname IN ({{rabbitmqnames}})"
      }
    }

    # Connections total
    widget_billboard {
      title  = "Connections total"
      column = 1
      row    = 7
      width  = 2
      height = 2

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT latest(rabbitmq.vhost.connectionsTotal) WHERE host.hostname IN ({{rabbitmqnames}}) FACET host.hostname TIMESERIES"
      }
    }
    
    # Connections running
    widget_billboard {
      title  = "Connections running"
      column = 3
      row    = 7
      width  = 2
      height = 2

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT latest(rabbitmq.vhost.connectionsRunning) WHERE host.hostname IN ({{rabbitmqnames}}) FACET host.hostname TIMESERIES"
      }
    }

    # Connections closed
    widget_billboard {
      title  = "Connections closed"
      column = 5
      row    = 7
      width  = 2
      height = 2

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT latest(rabbitmq.vhost.connectionsClosed) WHERE host.hostname IN ({{rabbitmqnames}}) FACET host.hostname TIMESERIES"
      }
    }

    # Connections closing
    widget_billboard {
      title  = "Connections closing"
      column = 7
      row    = 7
      width  = 2
      height = 2

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT latest(rabbitmq.vhost.connectionsClosing) WHERE host.hostname IN ({{rabbitmqnames}}) FACET host.hostname TIMESERIES"
      }
    }

    # Connections blocked
    widget_billboard {
      title  = "Connections blocked"
      column = 9
      row    = 7
      width  = 2
      height = 2

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT latest(rabbitmq.vhost.connectionsBlocked) WHERE host.hostname IN ({{rabbitmqnames}}) FACET host.hostname TIMESERIES"
      }
    }

    # Connections blocking
    widget_billboard {
      title  = "Connections blocking"
      column = 11
      row    = 7
      width  = 2
      height = 2

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT latest(rabbitmq.vhost.connectionsBlocking) WHERE host.hostname IN ({{rabbitmqnames}}) FACET host.hostname TIMESERIES"
      }
    }

    # Connections blocking
    widget_line {
      title  = "Connections blocking"
      column = 1
      row    = 9
      width  = 12
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT latest(rabbitmq.vhost.connectionsTotal), latest(rabbitmq.vhost.connectionsRunning), latest(rabbitmq.vhost.connectionsClosed), latest(rabbitmq.vhost.connectionsClosing), latest(rabbitmq.vhost.connectionsBlocked), latest(rabbitmq.vhost.connectionsBlocking) WHERE host.hostname IN ({{rabbitmqnames}}) FACET host.hostname TIMESERIES"
      }
    }
  }

  variable {
    title                = "RabbitMQ Names"
    name                 = "rabbitmqnames"
    replacement_strategy = "default"
    type                 = "nrql"
    default_values       = ["*"]
    is_multi_selection   = true

    nrql_query {
      account_ids = [var.NEW_RELIC_ACCOUNT_ID]
      query       = "FROM RabbitmqVhostSample SELECT uniques(hostname) LIMIT MAX"
    }
  }
}
