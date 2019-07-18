CREATE OR replace VIEW `__REPLACE_ME__.aggregate_purchases` AS
SELECT
      fullVisitorId,
      sum(totals.visits) as visits,
      avg(totals.hits) as hits,
      avg(totals.pageviews) as pageviews,
      avg(totals.timeOnSite) as time_on_site,
      sum(totals.transactions) as total_transactions,
      sum(totals.totalTransactionRevenue/1e6) as total_revenue,
      sum(product.productQuantity) AS product_quantity,
      sum(product.productRevenue/1e6) AS product_revenue,
      sum(totals.transactions) > 1 AS repeat_buyer,
      max(geoNetwork.country) as country,
      -- mocked ages: we suppose repeat customers are aged between 20-35 in uniform random distribution
      -- non-repeat buyers overlap slightly, falling in the 32-52 range
      case when sum(totals.transactions) > 1 then
        round(20 + rand() * 15, 0)
      else
        round(32 + rand() * 20, 0)
      end as age,
      case when rand() < 0.5 then
        "Male"
      else
        "Female"
      end as gender
  FROM
      `bigquery-public-data.google_analytics_sample.ga_sessions_*`
      , UNNEST(hits) AS hits
      , UNNEST(hits.product) AS product
  WHERE
      _TABLE_SUFFIX BETWEEN '20170101' AND '20181231'
      AND geoNetwork.country = 'United States'
      AND totals.totalTransactionRevenue IS NOT NULL
      AND productRevenue IS NOT NULL
 GROUP BY fullVisitorId
 ORDER BY total_revenue DESC
