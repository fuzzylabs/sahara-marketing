#standardSQL

-- Creates a k-means clustering model which we use for customer segmentation
create model `__REPLACE_ME__.segmentation_model__K__`
options(model_type='kmeans', num_clusters=__K__, distance_type='euclidean')
as select
Annual_Revenue,
timeOnScreen,
UniqueScreenViews,
Loyalty_Program,
Lifetime_Value,
Age
from
`__REPLACE_ME__.training_set`;
