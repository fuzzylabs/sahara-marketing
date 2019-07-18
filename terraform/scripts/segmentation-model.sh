#!/bin/bash

# This trains a number of k-means clustering models with different values of k (the number of clusters)
# We use that to find the optimal value of k by looking for the 'elbow point': https://en.wikipedia.org/wiki/Elbow_method_(clustering)
#
# Requirements: Google Cloud SDK (provides 'bq', the BigQuery command-line tool)

LOCATION=europe-west2
PROJECT=fuzzylabs
DATASET=sahara_marketing

SED_DATASET=s/__REPLACE_ME__/$PROJECT.$DATASET/g

echo "Creating aggregate purchases view"
sed -e $SED_DATASET ../bigquery/sql/aggregate-purchases-view.sql | bq --location=$LOCATION query

echo "Creating repeat buyer purchases view"
sed -e $SED_DATASET ../bigquery/sql/repeat-buyer-purchases-view.sql | bq --location=$LOCATION query

echo "Segmentation: training segmentation model"
sed -e $SED_DATASET ../bigquery/sql/segmentation-model.sql | bq --location=$LOCATION query

echo "Segmentation: model evaluation"
sed -e $SED_DATASET ../bigquery/sql/segmentation-evaluation.sql | bq --location=$LOCATION query

echo "Repeat Buyers: training predictive model"
sed -e $SED_DATASET ../bigquery/sql/repeat-buyer-model.sql | bq --location=$LOCATION query

echo "Repeat Buyers: model evaluation"
sed -e $SED_DATASET ../bigquery/sql/repeat-buyer-evaluation.sql | bq --location=$LOCATION query
