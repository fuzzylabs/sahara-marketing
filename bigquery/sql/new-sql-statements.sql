--------------------------------------------------------------------------------------------------------------------------------
CREATE OR replace VIEW `fuzzylabs.google_merchandise_store.purchases` AS
  SELECT
      userId,
      fullVisitorId,
      visitId,
      visitNumber,
      "date" as visit_date,
      totals.visits as visits,
      totals.hits as hits,
      totals.pageviews as pageviews,
      totals.timeOnSite as time_on_site,
      totals.transactions as total_transactions,
      totals.totalTransactionRevenue/1e6 as total_revenue,
      product.v2ProductCategory AS product_category,
      product.v2ProductName AS product_name,
      product.productSKU AS product_sku,
      (product.productRevenue/1e6)/product.productQuantity AS product_price_valid,
      product.productQuantity AS product_quantity,
      product.productRevenue/1e6 AS product_revenue,
      socialEngagementType
  FROM
      `bigquery-public-data.google_analytics_sample.ga_sessions_*`
      , UNNEST(hits) AS hits
      , UNNEST(hits.product) AS product
  WHERE
      _TABLE_SUFFIX BETWEEN '20170101' AND '20181231'
      AND geoNetwork.country = 'United States'
      AND totals.totalTransactionRevenue IS NOT NULL
      AND productRevenue IS NOT NULL

--------------------------------------------------------------------------------------------------------------------------------
CREATE OR replace VIEW `fuzzylabs.google_merchandise_store.aggregate_purchases` AS
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
      sum(totals.transactions) > 1 AS repeat_buyer
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

-- create model
--------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE MODEL `fuzzylabs.google_merchandise_store.repeat_purchase_model`
OPTIONS(model_type='logistic_reg') AS
SELECT
    repeat_buyer AS label,
    visits,
    pageviews,
    time_on_site
FROM
 `fuzzylabs.google_merchandise_store.aggregate_purchases`

-- evaluate
--------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM
ML.EVALUATE(MODEL `fuzzylabs.google_merchandise_store.repeat_purchase_model`, (
  select
    repeat_buyer AS label,
    visits,
    pageviews,
    time_on_site
  from `fuzzylabs.google_merchandise_store.aggregate_purchases`
))

-- query
--------------------------------------------------------------------------------------------------------------------------------
SELECT 
*
FROM 
 ML.PREDICT(
  MODEL `fuzzylabs.google_merchandise_store.repeat_purchase_model`,
  TABLE `fuzzylabs.google_merchandise_store.aggregate_purchases`
)


--------------------------------------------------------------------------------------------------------------------------------
