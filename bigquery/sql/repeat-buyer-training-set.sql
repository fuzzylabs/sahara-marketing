#standardSQL

-- This view is used as a basis for the repeat-buyer model

create view `__REPLACE_ME__.repeat_buyer_training_set` as
select
State_Code,
Industry,
Number_of_employees as size,
case when(Num_Opportunities_Won > 1) then 1 else 0 end as repeat_buyer
from `__REPLACE_ME__.accounts`
