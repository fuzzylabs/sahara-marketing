#standardSQL

-- What do repeat buyers buy?
CREATE OR REPLACE VIEW `__REPLACE_ME__.repeat_buyer_purchases` AS
SELECT
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
    `__REPLACE_ME__.aggregate_purchases` aggregate_purchases,
    `__REPLACE_ME__.purchases` purchases
    WHERE
    repeat_buyer = true and
    purchases.fullVisitorId = aggregate_purchases.fullVisitorId;
