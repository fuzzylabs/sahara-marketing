# Sahara AI-driven marketing example

[Seth](https://medium.com/fuzzylabsai/deploying-ai-in-your-business-3adfd2b33d9e) is back and this time he wants to sell more stuff, using Google's BigQuery to identify which customers are more likely to buy, Terraform to automate it all.

**BigQuery** is Google's serverless, scalable data warehouse that enables training custom Machine Learning models using SQL.

**Terraform** (by Hashicorp) is the definitive tool for provisioning Cloud resources. It enables 'everything' to be defined as code.

## How this repository is organised

* `data` - the CRM data that is used as a basis for these examples
* `analysis` - data analysis experiments in the form of Jupyter notebooks
* `bigquery` - production-ready models for deployment into Google BigQuery
* `terraform` - Terraform configuration for automated provisioning of data and models to the cloud

## The data

The faked data for Sahara's CRM system along with their Google Analytics data. Based on data we found on [Google's BigQuery machine-learning templates](https://github.com/GoogleCloudPlatform/bigquery-ml-templates]).

See [data](data).

## The problems we're trying to solve

### Customer segmentation

Identify groups of customers that have similar attributes relevant for marketing e.g. age, gender, spending habits. These groups are linked to lifetime value and annual revenue.

We use a k-means clustering model to do this. This model takes `n` data points and clusters them into `k` clusters, so `k` must be greater than 0 and no larger than `n`. If we only have one cluster, then every customer belongs to the same marketing segment, so that doesn't tell us very much. Similarly, if we have `n` clusters then every customer will have their very own marketing segment, which isn't particularly helpful either.

We want a sensible value for `k` that lies somewhere in-between. See the [customer segmentation jupyter notebook](analysis/customer-segmentation.ipynb) for more details.

### Repeat-buyer prediction

Given historical purchases and related activity, can we predict which customers will make more than one purchase?

See the [repeat buyers jupyter notebook](analysis/repeat-buyers.ipynb) for more details.

## The analysis

See [data analysis README](analysis/README.md).

## Provisioning BigQuery

### Loading data into BigQuery and training models

First of all we need to create the BigQuery [dataset](https://cloud.google.com/bigquery/docs/datasets) and [tables](https://cloud.google.com/bigquery/docs/tables) with an appropriate schema. Once they are created we will [load the data](https://cloud.google.com/bigquery/docs/loading-data-local) into the tables from our local CSV files.

We'll do all this using [Terraform](https://www.terraform.io/) which is the definitive tool for defining Cloud resources as code.

Install Terraform [here](https://www.terraform.io/downloads.html), [initialise remote state](TERRAFORM_REMOTE_STATE.md) then run:

```
cd terraform
terraform init
terraform plan
terraform apply
```

This will do the following:
  - Create the BigQuery DataSet
  - Create tables within that DataSet
  - Load the csv data into the tables, using 'autodetect' for the schema
  - Create training views and models for both 'Customer Segmentation' and 'Repeat Buyers'

You'll need the Google Cloud SDK installed and to be authenticated with your Google Cloud account to do this.
