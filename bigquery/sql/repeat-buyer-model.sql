#standardSQL

-- This model predicts repeat-buyers based on a logistic regression

create or replace model `__REPLACE_ME__.repeat_buyer_model`
options(model_type='logistic_reg') as
select
  repeat_buyer as label,
  ifnull(State_Code, "") as State_Code,
  ifnull(Industry, "") as Industry,
  size
 from
  `__REPLACE_ME__.repeat_buyer_training_set`
