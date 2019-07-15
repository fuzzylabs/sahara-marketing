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

-- create model
--------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE MODEL `fuzzylabs.google_merchandise_store.repeat_purchase_model`
OPTIONS(model_type='logistic_reg') AS
SELECT
    repeat_buyer AS label,
    visits,
    pageviews,
    time_on_site,
    age,
    gender
FROM
 `fuzzylabs.google_merchandise_store.aggregate_purchases`

-- evaluate repeat buyer model
--------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM
ML.EVALUATE(MODEL `fuzzylabs.google_merchandise_store.repeat_purchase_model`, (
  select
    repeat_buyer AS label,
    visits,
    pageviews,
    time_on_site,
    age,
    gender
  from `fuzzylabs.google_merchandise_store.aggregate_purchases`
))

-- query repeat buyer model
--------------------------------------------------------------------------------------------------------------------------------
SELECT
*
FROM
 ML.PREDICT(
  MODEL `fuzzylabs.google_merchandise_store.repeat_purchase_model`,
  TABLE `fuzzylabs.google_merchandise_store.aggregate_purchases`
)

-- What do repeat buyers buy?
--------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW `fuzzylabs.google_merchandise_store.repeat_buyer_purchases` AS SELECT
repeat_buyer,
aggregate_purchases.fullVisitorId,
aggregate_purchases.visits,
aggregate_purchases.pageviews,
aggregate_purchases.time_on_site,
aggregate_purchases.total_transactions,
purchases.visitId,
purchases.product_name,
purchases.product_category
FROM
`fuzzylabs.google_merchandise_store.aggregate_purchases` aggregate_purchases,
`fuzzylabs.google_merchandise_store.purchases` purchases
WHERE
repeat_buyer = true and
purchases.fullVisitorId = aggregate_purchases.fullVisitorId;

-- segmentation model
--------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE MODEL `fuzzylabs.google_merchandise_store.customer_segments`
OPTIONS(model_type='kmeans', num_clusters=2, distance_type='euclidean') AS
SELECT
    repeat_buyer,
    visits,
    pageviews,
    time_on_site,
    age,
    gender
FROM
 `fuzzylabs.google_merchandise_store.aggregate_purchases`

-- evaluate segmentation
--------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM
ML.EVALUATE(MODEL `fuzzylabs.google_merchandise_store.customer_segments`, (
  select
    repeat_buyer,
    visits,
    pageviews,
    time_on_site,
    age,
    gender
  from `fuzzylabs.google_merchandise_store.aggregate_purchases`
))

-- query segments
--------------------------------------------------------------------------------------------------------------------------------

SELECT
*
FROM
 ML.PREDICT(
  MODEL `fuzzylabs.google_merchandise_store.customer_segments`,
  TABLE `fuzzylabs.google_merchandise_store.aggregate_purchases`
)
