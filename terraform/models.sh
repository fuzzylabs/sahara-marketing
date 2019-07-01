#!/bin/bash

LOCATION=europe-west2
PROJECT=fuzzylabs
DATASET=sahara_marketing

SED_PLACEHOLDER=__REPLACE_ME__
SED_TARGET=$PROJECT.$DATASET
SED_EXPR=s/$SED_PLACEHOLDER/$SED_TARGET/g

sed -e $SED_EXPR sql/training_view.sql | bq --location=$LOCATION query
