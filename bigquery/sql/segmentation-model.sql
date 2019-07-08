#standardSQL

-- Creates a k-means clustering model which we use for customer segmentation
create or replace model `__REPLACE_ME__.segmentation_model`
options(model_type='kmeans', num_clusters=9, distance_type='euclidean')
as select
Annual_Revenue,
timeOnScreen,
UniqueScreenViews,
Loyalty_Program,
Lifetime_Value,
Age
from
`__REPLACE_ME__.segmentation_training_set`;
