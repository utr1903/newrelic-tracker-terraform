#################
### Dashboard ###
#################

# Dashboard - APM
resource "newrelic_one_dashboard" "app" {
  name = "APM | ${var.app_name}"

  ##############################
  ### WEB & NON-WEB INSIGHTS ###
  ##############################
  page {
    name = "Web & Non-Web Insights"

    # Page description
    widget_markdown {
      title  = "Page description"
      row    = 1
      column = 1
      height = 4
      width  = 3

      text = "## Overview Insights\n\n### Web transactions\nRefers to synchronous calls\n- HTTP\n- gRPC\n\n### Non-web transactions\nRefers to asynchronous calls.\n- Kafka\n- SQS\n- Service Bus"
    }

    # Average web response time (ms)
    widget_billboard {
      title  = "Average web response time (ms)"
      row    = 1
      column = 4
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM (FROM Metric SELECT average(apm.service.overview.web*1000) AS `duration` WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET segmentName LIMIT MAX) SELECT sum(`duration`) AS `Average web response time (ms)`"
      }
    }

    # Average web throughput (rpm)
    widget_billboard {
      title  = "Average web throughput (rpm)"
      row    = 1
      column = 7
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.transaction.duration), 1 minute) as 'Average web throughput (rpm)' WHERE entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Web' LIMIT MAX"
      }
    }

    # Average web error rate (%)
    widget_billboard {
      title  = "Average web error rate (%)"
      row    = 1
      column = 10
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT count(apm.service.error.count)/count(apm.service.transaction.duration)*100 as 'Average web error rate (%)' WHERE entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Web' LIMIT MAX"
      }
    }

    # Average non-web response time (ms)
    widget_billboard {
      title  = "Average non-web response time (ms)"
      row    = 3
      column = 4
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM (FROM Metric SELECT average(apm.service.overview.other*1000) AS `duration` WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET segmentName LIMIT MAX) SELECT sum(`duration`) AS `Average non-web response time (ms)`"
      }
    }

    # Average non-web throughput (rpm)
    widget_billboard {
      title  = "Average non-web throughput (rpm)"
      row    = 3
      column = 7
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.transaction.duration), 1 minute) as 'Average non-web throughput (rpm)' WHERE entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Other' LIMIT MAX"
      }
    }

    # Average non-web error rate (%)
    widget_billboard {
      title  = "Average non-web error rate (%)"
      row    = 3
      column = 10
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT count(apm.service.error.count)/count(apm.service.transaction.duration)*100 as 'Average non-web error rate (%)' WHERE entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Other' LIMIT MAX"
      }
    }

    # Web response time by segment (ms)
    widget_area {
      title  = "Web response time by segment (ms)"
      row    = 5
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.overview.web*1000) WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET segmentName LIMIT MAX TIMESERIES"
      }
    }

    # Non-web response time by segment (ms)
    widget_area {
      title  = "Non-web response time by segment (ms)"
      row    = 5
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.overview.other*1000) WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET segmentName LIMIT MAX TIMESERIES"
      }
    }

    # Average web throughput (rpm)
    widget_line {
      title  = "Average web throughput (rpm)"
      row    = 8
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.transaction.duration), 1 minute) as 'Average web throughput (rpm)' WHERE entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Web' LIMIT MAX TIMESERIES"
      }
    }

    # Average non-web throughput (rpm)
    widget_line {
      title  = "Average non-web throughput (rpm)"
      row    = 8
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.transaction.duration), 1 minute) as 'Average non-web throughput (rpm)' WHERE entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Other' LIMIT MAX TIMESERIES"
      }
    }

    # Average web error rate (%)
    widget_line {
      title  = "Average web error rate (%)"
      row    = 11
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT count(apm.service.error.count)/count(apm.service.transaction.duration)*100 as 'Average web error rate (%)' WHERE entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Web' LIMIT MAX TIMESERIES"
      }
    }

    # Average non-web error rate (%)
    widget_line {
      title  = "Average non-web error rate (%)"
      row    = 11
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT count(apm.service.error.count)/count(apm.service.transaction.duration)*100 as 'Average non-web error rate (%)' WHERE entity.guid = '${data.newrelic_entity.app.guid}' AND transactionType = 'Other' LIMIT MAX TIMESERIES"
      }
    }
  }

  ####################
  ### TRANSACTIONS ###
  ####################
  page {
    name = "Transactions"

    # Page description
    widget_markdown {
      title  = "Page description"
      row    = 1
      column = 1
      height = 3
      width  = 3

      text = "## Transactions\n\nThis page is dedicated for the transactions which are tracked and sent to New Relic. In cases of high throughput, the agent starts dropping and not tracking all transactions.\n\nTherefore, this view is not exactly appropriate to make a judgement about the overall application performance but to investigate a portion of detailed traces."
    }

    # Overview
    widget_billboard {
      title  = "Overview"
      row    = 1
      column = 4
      height = 3
      width  = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction SELECT count(*) AS `Total transactions`, average(duration)*1000 AS `Average duration (ms)`, percentile(duration*1000, 90) as `Slowest duration (ms)` WHERE entity.guid = '${data.newrelic_entity.app.guid}' LIMIT MAX"
      }
    }

    # Transaction count by instance
    widget_line {
      title  = "Transaction count by instance"
      row    = 1
      column = 8
      height = 3
      width  = 5

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction SELECT rate(count(*), 1 minute) WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET host LIMIT MAX TIMESERIES"
        # query      = "FROM Transaction SELECT count(*) WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET host LIMIT 10 TIMESERIES"
      }
    }

    # Transaction count by type
    widget_pie {
      title  = "Transaction count by type"
      row    = 4
      column = 1
      height = 4
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction SELECT count(*) WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET transactionType LIMIT 10"
      }
    }

    # Transaction count by method
    widget_pie {
      title  = "Transaction count by method"
      row    = 4
      column = 4
      height = 4
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction SELECT count(*) WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET request.method LIMIT 10"
      }
    }

    # Transaction count by name
    widget_bar {
      title  = "Transaction count by name"
      row    = 4
      column = 7
      height = 4
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction SELECT count(*) WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET name LIMIT 20"
      }
    }

    # Transactions with errors
    widget_table {
      title  = "Transactions with errors"
      row    = 10
      column = 1
      height = 3
      width  = 8

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM TransactionError SELECT host, error.expected, error.class, error.message WHERE entity.guid = '${data.newrelic_entity.app.guid}' LIMIT 20"
      }
    }

    # Transaction count by URI
    widget_bar {
      title  = "Transaction count by URI"
      row    = 10
      column = 9
      height = 3
      width  = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction SELECT count(*) WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET request.uri LIMIT 20"
      }
    }
  }

  ############################
  ### RESOURCE CONSUMPTION ###
  ############################
  page {
    name = "Resource consumption"

    # Page description
    widget_markdown {
      title  = "Page description"
      row    = 1
      column = 1
      height = 2
      width  = 4

      text = "## Resource Consumption\nThis page is dedicated to give an overview of the resource (CPU/MEM) consumption of the application.\n\nFor better understanding, it is highly recommended to retrieve the consumption data per infrastructure agent or Prometheus etc."
    }

    # CPU utilization (%)
    widget_billboard {
      title  = "CPU utilization (%)"
      row    = 1
      column = 5
      height = 2
      width  = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.cpu.usertime.utilization) AS `avg`, max(apm.service.cpu.usertime.utilization) AS `max` WHERE entity.guid = '${data.newrelic_entity.app.guid}' TIMESERIES"
      }
    }

    # MEM utilization (MB)
    widget_billboard {
      title  = "MEM utilization (MB)"
      row    = 1
      column = 9
      height = 2
      width  = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.memory.physical) AS `avg`, max(apm.service.memory.physical) AS `max` WHERE entity.guid = '${data.newrelic_entity.app.guid}' TIMESERIES"
      }
    }

    # Average CPU utilization (%)
    widget_line {
      title  = "Average CPU utilization (%)"
      row    = 3
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.cpu.usertime.utilization) AS `cpu` WHERE entity.guid = '${data.newrelic_entity.app.guid}' TIMESERIES"
      }
    }

    # Average CPU utilization by instance (%)
    widget_line {
      title  = "Average CPU utilization by instance (%)"
      row    = 3
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.cpu.usertime.utilization) AS `cpu` WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET instanceName TIMESERIES LIMIT 10"
      }
    }

    # Maximum CPU utilization (%)
    widget_line {
      title  = "Maximum CPU utilization (%)"
      row    = 6
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(apm.service.cpu.usertime.utilization) AS `cpu` WHERE entity.guid = '${data.newrelic_entity.app.guid}' TIMESERIES"
      }
    }

    # Maximum CPU utilization by instance (%)
    widget_line {
      title  = "Maximum CPU utilization by instance (%)"
      row    = 6
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(apm.service.cpu.usertime.utilization) AS `cpu` WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET instanceName TIMESERIES LIMIT 10"
      }
    }

    # Average MEM usage (MB)
    widget_line {
      title  = "Average MEM usage (MB)"
      row    = 9
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.memory.physical) AS `mem` WHERE entity.guid = '${data.newrelic_entity.app.guid}' TIMESERIES"
      }
    }

    # Average MEM usage by instance (MB)
    widget_line {
      title  = "Average MEM usage by instance (MB)"
      row    = 9
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.memory.physical) AS `mem` WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET instanceName TIMESERIES LIMIT 10"
      }
    }

    # Maximum MEM usage (MB)
    widget_line {
      title  = "Maximum CPU usage (MB)"
      row    = 12
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(apm.service.memory.physical) AS `mem` WHERE entity.guid = '${data.newrelic_entity.app.guid}' TIMESERIES"
      }
    }

    # Maximum MEM usage by instance (MB)
    widget_line {
      title  = "Maximum MEM usage by instance (MB)"
      row    = 12
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(apm.service.memory.physical) AS `mem` WHERE entity.guid = '${data.newrelic_entity.app.guid}' FACET instanceName TIMESERIES LIMIT 10"
      }
    }
  }
}
