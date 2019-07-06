#!/bin/bash

# This trains a number of k-means clustering models with different values of k (the number of clusters)
# We use that to find the optimal value of k by looking for the 'elbow point': https://en.wikipedia.org/wiki/Elbow_method_(clustering)
#
# Requirements: Google Cloud SDK (provides 'bq', the BigQuery command-line tool)

LOCATION=europe-west2
PROJECT=fuzzylabs
DATASET=sahara_marketing

SED_DATASET=s/__REPLACE_ME__/$PROJECT.$DATASET/g

echo "Creating training set view"
sed -e $SED_DATASET ../sql/training_view.sql | bq --location=$LOCATION query

echo "Training clustering models"
for k in {2..11}
do
  SED_K=s/__K__/$k/g
  sed -e $SED_DATASET -e $SED_K ../sql/model.sql | bq --location=$LOCATION query
done

# This view is used for analysing the Elbow point. Generating SQL in Bash is kind of horrific so we'll need to replace with something better!
echo "Evaluating models"
EVALUATION_QUERY=""
N=11
for k in {2..11}
do
  SED_K=s/__K__/$k/g
  SED_RESULT=`sed -e $SED_DATASET -e $SED_K ../sql/evaluate.sql`
  EVALUATION_QUERY="$EVALUATION_QUERY $SED_RESULT"
  if (("$k" < "$N"))
  then
    EVALUATION_QUERY="$EVALUATION_QUERY union all"
  fi
done

bq --location=$LOCATION query --use_legacy_sql=false "create view $PROJECT.$DATASET.elbow_point as $EVALUATION_QUERY order by Size asc;"
