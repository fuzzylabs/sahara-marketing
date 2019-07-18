#standardSQL

-- Creates a k-means clustering model which we use for customer segmentation
CREATE OR REPLACE MODEL `__REPLACE_ME__.customer_segments`
OPTIONS(model_type='kmeans', num_clusters=3, distance_type='euclidean') AS
SELECT
    repeat_buyer,
    visits,
    pageviews,
    time_on_site,
    age,
    gender
FROM
 `__REPLACE_ME__.aggregate_purchases`
