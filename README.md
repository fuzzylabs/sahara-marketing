# sahara-marketing

[Seth](https://medium.com/fuzzylabsai/deploying-ai-in-your-business-3adfd2b33d9e) is back and this time he wants to sell more stuff ... using Google's BigQuery to identify which customers are more likely to buy, Terraform to automate it all,

**BigQuery** is Google's serverless, scalable data warehouse that enables training custom Machine Learning models using SQL.

**Terraform** (by Hashicorp) is the definitive tool for provisioning Cloud resources. It enables 'everything' to be defined as code.

## How

*Customer Segmentation*: Identify groups of customers that have similar attributes relevant to marketing ie. age, gender, spending habits.

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
