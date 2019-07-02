# sahara-marketing

[Seth](https://medium.com/fuzzylabsai/deploying-ai-in-your-business-3adfd2b33d9e) is back and this time he wants to sell more stuff ... using Google's BigQuery to identify which customers are more likely to buy, Terraform to automate it all,

**BigQuery** is Google's serverless, scalable data warehouse that enables training custom Machine Learning models using SQL.

**Terraform** (by Hashicorp) is the definitive tool for provisioning Cloud resources. It enables 'everything' to be defined as code.

## How

*Customer Segmentation*: Identify groups of customers that have similar attributes relevant to marketing e.g. age, gender, spending habits.

## Data

Using synthetic (made up) data sources from Sahara's CRM system and their Google Analytics data. See [data](data)

## Load the data into BigQuery

First of all we need to create the BigQuery [dataset](https://cloud.google.com/bigquery/docs/datasets) and [tables](https://cloud.google.com/bigquery/docs/tables) with an appropriate schema. Once they are created we will [load the data](https://cloud.google.com/bigquery/docs/loading-data-local) into the tables from our local CSV files.

We'll do all this using [Terraform](https://www.terraform.io/) which is the definitive tool for defining Cloud resources as code.

Install Terraform [here](https://www.terraform.io/downloads.html), [initialise remote state](TERRAFORM_REMOTE_STATE.md) then run:

```
cd terraform
terraform init
terraform plan
terraform apply
```

## Training a model

Once the data is loaded we can train a BigQuery model to break the customers into segments which helps us identify groups of customers by their age and other attributes. These groups are linked to lifetime value and annual revenue.

We use a k-means clustering model to do this. This model takes `n` data points and clusters them into `k` clusters, so `k` must be greater than 0 and no larger than `n`. If we only have one cluster, then every customer belongs to the same marketing segment, so that doesn't tell us very much. Similarly, if we have `n` clusters then every customer will have their very own marketing segment, which isn't particularly helpful either.

We want a sensible value for `k` that lies somewhere in-between. One approach to this is [Elbow Analysis](https://en.wikipedia.org/wiki/Elbow_method_(clustering)). In Elbow Analysis we train a number of alternative clustering models for various values of `k` and we pick the one that has the best trade-off between how spread out the data within clusters is and the number of clusters.

To generate a series of alternative models:

```
cd terraform
./scripts/segmentation-model.sh
```

You'll need the Google Cloud SDK installed and to be authenticated with your Google Cloud account to do this.
