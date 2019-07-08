#!/bin/bash

# Requirements: Google Cloud SDK (provides 'bq', the BigQuery command-line tool)

LOCATION=$1
PROJECT=$2
DATASET=$3

SED_DATASET=s/__REPLACE_ME__/$PROJECT.$DATASET/g

echo "Segmentation: creating training set view"
sed -e $SED_DATASET ../bigquery/sql/segmentation-training-set.sql | bq --location=$LOCATION query

echo "Segmentation: training segmentation model"
sed -e $SED_DATASET ../bigquery/sql/segmentation-model.sql | bq --location=$LOCATION query

echo "Segmentation: model evaluation"
sed -e $SED_DATASET ../bigquery/sql/segmentation-evaluation.sql | bq --location=$LOCATION query

echo "Repeat Buyers: creating training set view"
sed -e $SED_DATASET ../bigquery/sql/repeat-buyer-training-set.sql | bq --location=$LOCATION query

echo "Repeat Buyers: training clustering model"
sed -e $SED_DATASET ../bigquery/sql/repeat-buyer-model.sql | bq --location=$LOCATION query

echo "Repeat Buyers: model evaluation"
sed -e $SED_DATASET ../bigquery/sql/repeat-buyer-evaluation.sql | bq --location=$LOCATION query
