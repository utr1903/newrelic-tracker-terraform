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
      width  = 4
      height = 2

      text = "## Overview\n."
    }

    # Ingest by source
    widget_area {
      title  = "Ingest by source"
      row    = 1
      column = 9
      width  = 2
      height = 2

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NrConsumption SELECT rate(sum(GigabytesIngested), 1 day) AS avgGbIngestTimeseries WHERE productLine = 'DataPlatform' FACET usageMetric LIMIT MAX TIMESERIES AUTO"
      }
    }
  }
}
