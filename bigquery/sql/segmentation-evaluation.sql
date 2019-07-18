#standardSQL

SELECT * FROM
ML.EVALUATE(MODEL `__REPLACE_ME__.customer_segments`, (
  select
    repeat_buyer,
    visits,
    pageviews,
    time_on_site,
    age,
    gender
  from `__REPLACE_ME__.aggregate_purchases`
))
