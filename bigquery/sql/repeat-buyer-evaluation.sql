#standardSQL

select * from
ML.EVALUATE(MODEL `fuzzylabs.sahara_marketing.repeat_buyer_model`, (
  select repeat_buyer as label, * from `fuzzylabs.sahara_marketing.repeat_buyer_training_set`
))
