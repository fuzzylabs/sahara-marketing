#standardSQL

SELECT * FROM
ML.EVALUATE(MODEL `__REPLACE_ME__.repeat_purchase_model`, (
  select
    repeat_buyer AS label,
    visits,
    pageviews,
    time_on_site,
    age,
    gender
  from `__REPLACE_ME__.aggregate_purchases`
))

