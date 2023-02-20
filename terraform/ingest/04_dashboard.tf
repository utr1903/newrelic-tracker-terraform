##################
### Dashboards ###
##################

# Data ingest
resource "newrelic_one_dashboard" "ingest" {
  name = "Data Ingest Breakdown"

  page {
    name = "Overview"

    # Ingest / Ordered ingest (GB)
    widget_billboard {
      title  = "Ingest / Ordered ingest (GB)"
      column = 1
      row    = 1
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NrConsumption SELECT sum(BytesIngested)/1e9 AS 'Ingested volume (In GB)' SINCE this year"
      }
    }

    # Ingest / Ordered ingest (GB)
    widget_line {
      title  = "Ingest / Ordered ingest (GB)"
      column = 4
      row    = 1
      width  = 9
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NrConsumption SELECT sum(GigabytesIngested) WHERE productLine = 'DataPlatform' FACET usageMetric TIMESERIES 1 day SINCE 30 days ago"
      }
    }

    # APM Ingest by App (GB, %)
    widget_pie {
      title  = "APM Ingest by App (GB, %)"
      column = 1
      row    = 4
      width  = 4
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction, TransactionError SELECT bytecountestimate()/1e9 FACET appName SINCE this year LIMIT MAX"
      }
    }

    # APM Ingest by App (GB)
    widget_area {
      title  = "APM Ingest by App (GB)"
      column = 5
      row    = 4
      width  = 8
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction, TransactionError SELECT bytecountestimate()/1e9 TIMESERIES FACET appName SINCE this year LIMIT MAX"
      }
    }

    # Ingest by Telemetry Datatype (GB)
    widget_pie {
      title  = "Ingest by Telemetry Datatype (GB)"
      column = 1
      row    = 8
      width  = 4
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NrConsumption SELECT sum(BytesIngested)/1e9 FACET usageMetric SINCE this year"
      }
    }

    # Ingest by Telemetry Datatype (GB)
    widget_area {
      title  = "Ingest by Telemetry Datatype (GB)"
      column = 5
      row    = 8
      width  = 8
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction, TransactionError SELECT bytecountestimate()/1e9 FACET appName TIMESERIES SINCE this year LIMIT MAX"
      }
    }

    # Event Type (count, %)
    widget_pie {
      title  = "Event Type (count, %)"
      column = 1
      row    = 12
      width  = 4
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction, TransactionError, TransactionTrace, ErrorTrace, Span SELECT count(*) FACET eventType() SINCE this year LIMIT MAX"
      }
    }

    # Event Type (count)
    widget_area {
      title  = "Event Type (count)"
      column = 5
      row    = 12
      width  = 8
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction, TransactionError, TransactionTrace, ErrorTrace, Span SELECT count(*) FACET eventType() TIMESERIES SINCE this year LIMIT MAX"
      }
    }
  }
}
