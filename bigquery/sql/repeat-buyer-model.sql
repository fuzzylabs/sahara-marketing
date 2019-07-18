#standardSQL

-- This model predicts repeat-buyers based on a logistic regression
CREATE OR REPLACE MODEL `__REPLACE_ME__.repeat_purchase_model`
OPTIONS(model_type='logistic_reg') AS
SELECT
    repeat_buyer AS label,
    visits,
    pageviews,
    time_on_site,
    age,
    gender
FROM
 `__REPLACE_ME__.aggregate_purchases`
