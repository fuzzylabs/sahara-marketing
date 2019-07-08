#standardSQL

select * from
ML.EVALUATE(MODEL `fuzzylabs.sahara_marketing.regression_model`, (
  select repeat_buyer as label, * from `fuzzylabs.sahara_marketing.regression_training_set`
))
