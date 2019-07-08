#standardSQL

-- This view is used as the basis for model training
create or replace view `__REPLACE_ME__.segmentation_training_set` as
select
`__REPLACE_ME__.users`.User_ID,
`__REPLACE_ME__.accounts`.Account_Number,
`__REPLACE_ME__.accounts`.Annual_Revenue,
`__REPLACE_ME__.ga360`.timeOnScreen,
`__REPLACE_ME__.ga360`.UniqueScreenViews,
`__REPLACE_ME__.users`.Loyalty_Program,
`__REPLACE_ME__.users`.Lifetime_Value,
`__REPLACE_ME__.users`.Age
from
`__REPLACE_ME__.ga360`,
`__REPLACE_ME__.users`,
`__REPLACE_ME__.accounts`
where
`__REPLACE_ME__.ga360`.User_ID = `__REPLACE_ME__.users`.User_ID
and
`__REPLACE_ME__.accounts`.Account_Number = `__REPLACE_ME__.users`.Account_ID
order by
`__REPLACE_ME__.users`.User_ID ASC
