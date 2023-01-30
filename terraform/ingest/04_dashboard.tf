##################
### Dashboards ###
##################

# Data ingest
resource "newrelic_one_dashboard" "ingest" {
  name = "Data Ingest Breakdown"

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

    # Ingest by source
    widget_area {
      title  = "Ingest by source"
      row    = 1
      column = 4
      width  = 9
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NrConsumption SELECT rate(sum(GigabytesIngested), 1 day) AS avgGbIngestTimeseries WHERE productLine = 'DataPlatform' FACET usageMetric LIMIT MAX SINCE 30 days ago TIMESERIES AUTO"
      }
    }

    # Tracing by apps
    widget_pie {
      title  = "Tracing by apps"
      row    = 5
      column = 1
      width  = 4
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Span SELECT bytecountestimate()/10e8 WHERE instrumentation.provider != 'pixie' FACET entity.name LIMIT 15 SINCE 30 days ago"
      }
    }

    # Tracing by apps timeseries
    widget_line {
      title  = "Tracing by apps timeseries"
      row    = 5
      column = 5
      width  = 8
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Span SELECT bytecountestimate()/10e8 WHERE instrumentation.provider != 'pixie' FACET entity.name LIMIT 15 SINCE 30 days ago TIMESERIES AUTO"
      }
    }
  }
}
