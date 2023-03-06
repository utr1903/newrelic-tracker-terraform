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

  page {
    name = "Node Overview"

    # Page description
    widget_markdown {
      title  = "Page description"
      column = 1
      row    = 1
      width  = 3
      height = 3

      text = "## RabbitMQ Monitoring\n\n"
    }

    # Nodes
    widget_table {
      title  = "Nodes"
      column = 4
      row    = 1
      width  = 3
      height = 3

      filter_current_dashboard = true

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT uniqueCount(entity.name) as 'Total', filter(uniqueCount(entity.name), where rabbitmq.node.running[latest] > 0) as 'Running', filter(uniqueCount(entity.name), where rabbitmq.node.hostMemoryAlarm[latest] > 0) as 'Memory Alarms', filter(uniqueCount(entity.name), where rabbitmq.node.diskAlarm[latest] > 0) as 'Disk Alarms' WHERE metricName = 'rabbitmq.node.running' AND host.hostname IN ({{rabbitmqnames}}) FACET entity.name"
      }
    }

    # Total memory usage (MB)
    widget_line {
      title  = "Total memory usage (MB)"
      column = 7
      row    = 1
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(rabbitmq.node.totalMemoryUsedInBytes)/1e6 WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
      }
    }

    # File descriptors
    widget_line {
      title  = "File descriptors"
      column = 1
      row    = 4
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(rabbitmq.node.fileDescriptorsTotalUsed) AS `used`, average(rabbitmq.node.fileDescriptorsTotal) AS `total` WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
      }

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(rabbitmq.node.fileDescriptorsTotalUsed)/average(rabbitmq.node.fileDescriptorsTotal)*100 AS `util` WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
      }
    }

    # Processes
    widget_line {
      title  = "Processes"
      column = 7
      row    = 4
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(rabbitmq.node.processesUsed) AS `used`, average(rabbitmq.node.processesTotal) AS `total` WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
      }

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(rabbitmq.node.processesUsed)/average(rabbitmq.node.processesTotal)*100 AS `util` WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
      }
    }
  }

  page {
    name = "Exchange Overview"

    # Page description
    widget_markdown {
      title  = "Page description"
      column = 1
      row    = 1
      width  = 3
      height = 3

      text = "## RabbitMQ Monitoring\n\n"
    }

    # Bindings per exchange
    widget_table {
      title  = "Bindings per exchange"
      column = 4
      row    = 1
      width  = 3
      height = 3

      filter_current_dashboard = true

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT count(rabbitmq.exchange.bindings) FACET entity.name TIMESERIES"
      }
    }

    # Bindings per exchange
    widget_line {
      title  = "Bindings per exchange"
      column = 7
      row    = 1
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT count(rabbitmq.exchange.bindings) WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
      }
    }

    # Messages published per channel
    widget_line {
      title  = "Messages published per channel"
      column = 1
      row    = 4
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT uniqueCount(rabbitmq.exchange.messagesPublishedPerChannel) WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
      }
    }

    # Rate of messages published per channel (1/s)
    widget_line {
      title  = "Rate of messages published per channel (1/s)"
      column = 7
      row    = 4
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT uniqueCount(rabbitmq.exchange.messagesPublishedPerChannelPerSecond) WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
      }
    }

    # Messages published from exchange to queue
    widget_line {
      title  = "Messages published from exchange to queue"
      column = 1
      row    = 7
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT uniqueCount(rabbitmq.exchange.messagesPublishedQueue) WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
      }
    }

    # Rate of messages published from exchange to queue (1/s)
    widget_line {
      title  = "Rate of messages published from exchange to queue (1/s)"
      column = 7
      row    = 7
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT uniqueCount(rabbitmq.exchange.messagesPublishedQueuePerSecond) WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
      }
    }
  }

  page {
    name = "Queue Overview"

    # Page description
    widget_markdown {
      title  = "Page description"
      column = 1
      row    = 1
      width  = 3
      height = 3

      text = "## RabbitMQ Monitoring\n\n"
    }

    # Bindings per queue
    widget_table {
      title  = "Bindings per queue"
      column = 4
      row    = 1
      width  = 3
      height = 3

      filter_current_dashboard = true

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT latest(rabbitmq.queue.bindings) WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name"
      }
    }

    # Consumers per queue
    widget_line {
      title  = "Consumers per queue"
      column = 7
      row    = 1
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT latest(rabbitmq.queue.consumers) WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
      }
    }

    # Memory used per queue
    widget_line {
      title  = "Memory used per queue"
      column = 1
      row    = 4
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(rabbitmq.queue.erlangBytesConsumedInBytes) WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
      }
    }

    # Active consumers per queue
    widget_line {
      title  = "Active consumers per queue"
      column = 7
      row    = 4
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT latest(rabbitmq.queue.consumerMessageUtilizationPerSecond) WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
      }
    }

    # Messages published
    widget_line {
      title  = "Messages published"
      column = 1
      row    = 7
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(rabbitmq.queue.messagesPublished) WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
      }
    }

    # Messages acknowledged
    widget_line {
      title  = "Messages acknowledged"
      column = 7
      row    = 7
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(rabbitmq.queue.messagesAcknowledged) WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
      }
    }

    # Messages total
    widget_line {
      title  = "Messages total"
      column = 1
      row    = 10
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(rabbitmq.queue.totalMessages) WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
      }
    }

    # Messages ready to be delivered
    widget_area {
      title  = "Messages ready to be delivered"
      column = 7
      row    = 10
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(rabbitmq.queue.messagesReadyDeliveryClients), average(rabbitmq.queue.messagesReadyUnacknowledged) WHERE host.hostname IN ({{rabbitmqnames}}) FACET entity.name TIMESERIES"
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
